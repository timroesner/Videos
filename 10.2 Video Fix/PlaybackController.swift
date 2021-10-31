//
//  Playback.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 9/4/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import AVKit

// MARK: - PlayerViewController

final class PlayerViewController: AVPlayerViewController {
    let autoplayURLs: [URL]?
    
    private var currentEpisodeIndex: Int = 0
    private var timeObserverToken: Any?
    
    private lazy var nextButtonBottomConstraint: NSLayoutConstraint = {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: nextEpisodeButton.bottomAnchor, constant: 12)
        } else {
            return view.bottomAnchor.constraint(equalTo: nextEpisodeButton.bottomAnchor, constant: 12)
        }
    }()
    
    private lazy var nextEpisodeButton: UIButton = {
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.title = NSLocalizedString("Next Episode", comment: "")
            config.buttonSize = .medium
            config.baseForegroundColor = .white
            var backgroundConfig = UIBackgroundConfiguration.clear()
            backgroundConfig.visualEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
            backgroundConfig.cornerRadius = 16
            config.background = backgroundConfig
            let button = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
                self?.playNextEpisode()
            })
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        } else {
            let button = UIButton()
            button.setTitle(NSLocalizedString("Next Episode", comment: ""), for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(.white.withAlphaComponent(0.65), for: .highlighted)
            button.backgroundColor = .darkGray.withAlphaComponent(0.75)
            button.layer.cornerRadius = 16
            button.addTarget(self, action: #selector(playNextEpisode), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
    }()
    
    override var player: AVPlayer? {
        didSet {
            addNextEpisodeObservers()
        }
    }
    
    init(autoplayURLs: [URL]?) {
        self.autoplayURLs = autoplayURLs
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        removeTimeObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.frame.height < view.frame.width {
            nextButtonBottomConstraint.constant = 12
        } else {
            nextButtonBottomConstraint.constant = 68
        }
    }
    
    private func addNextEpisodeObservers() {
        guard let player = player, let asset = player.currentItem?.asset,
              let autoplayURLs = autoplayURLs, currentEpisodeIndex < autoplayURLs.count else { return }
        
        NotificationCenter.default.addObserver(self, selector: #selector(timeJumped), name: AVPlayerItem.timeJumpedNotification, object: player.currentItem)
        
        let endCreditsLength = self.endCreditsLength(for: asset)
        let creditsTime = asset.duration - CMTime(seconds: endCreditsLength, preferredTimescale: asset.duration.timescale)
        timeObserverToken = player.addBoundaryTimeObserver(forTimes: [NSValue(time: creditsTime)], queue: .main) { [weak self] in
            self?.setupNextEpisodeButton()
        }
        
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self, selector: #selector(playNextEpisode), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    private func endCreditsLength(for asset: AVAsset) -> TimeInterval {
        switch asset.duration.seconds {
        case 0..<35 * .minute: return 30
        case 35 * .minute..<65 * .minute: return 75
        case 65 * .minute..<95 * .minute: return 120
        default: return 180
        }
    }
    
    private func setupNextEpisodeButton() {
        guard nextEpisodeButton.superview == nil else {
            nextEpisodeButton.isHidden = false
            return
        }
        
        view.addSubview(nextEpisodeButton)
        nextEpisodeButton.isHidden = false
        
        NSLayoutConstraint.activate([
            nextEpisodeButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            nextEpisodeButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 146),
            view.trailingAnchor.constraint(equalTo: nextEpisodeButton.trailingAnchor, constant: 24),
            nextButtonBottomConstraint,
        ])
    }
    
    private func removeTimeObserver() {
        guard let timeObserverToken = timeObserverToken else { return }
        player?.removeTimeObserver(timeObserverToken)
        self.timeObserverToken = nil
        nextEpisodeButton.isHidden = true
    }
    
    @objc private func timeJumped() {
        guard let currentPlaybackTime = player?.currentTime(), let asset = player?.currentItem?.asset else { return }
        
        let timeRemaining = asset.duration - currentPlaybackTime
        let endCreditsTime = CMTime(seconds: endCreditsLength(for: asset), preferredTimescale: asset.duration.timescale)
        guard timeRemaining < endCreditsTime else {
            nextEpisodeButton.isHidden = true
            return
        }
        // Current time is smaller than end credits time, so we display the next episode button
        setupNextEpisodeButton()
    }
    
    @objc private func playNextEpisode() {
        guard let autoplayURLs = autoplayURLs else { return }
        let newItem = AVPlayerItem(url: autoplayURLs[currentEpisodeIndex])
        player?.replaceCurrentItem(with: newItem)
        currentEpisodeIndex += 1
        
        nextEpisodeButton.isHidden = true
        removeTimeObserver()
        addNextEpisodeObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - AVPlayerViewControllerDelegate

extension UIViewController: AVPlayerViewControllerDelegate {
    func presentPlayer(with url: URL, autoplayURLs: [URL]? = nil) {
        let playerVC = PlayerViewController(autoplayURLs: autoplayURLs)
        playerVC.delegate = self
        if #available(iOS 14.2, *) {
            playerVC.canStartPictureInPictureAutomaticallyFromInline = true
        }
        
        let player = AVPlayer(url: url)
		timeRestoration(for: url, with: player)
		playerVC.player = player
		
        self.present(playerVC, animated: true) {
            playerVC.player?.play()
        }
    }
	
	private func timeRestoration(for url: URL, with player: AVPlayer) {
		if let time = UserDefaults.standard.time(forKey: documentsPath(of: url)) {
			player.seek(to: time)
		}
		player.addObserver(self, forKeyPath: #keyPath(AVPlayer.timeControlStatus), context: nil)
	}
	
	open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		guard let player = object as? AVPlayer, player.timeControlStatus == .paused else { return }
		guard let urlAsset = player.currentItem?.asset as? AVURLAsset else {
			assertionFailure("Not playing URL asset")
			return
		}
		UserDefaults.standard.set(player.currentTime(), forKey: documentsPath(of: urlAsset.url))
	}
    
    public func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        present(playerViewController, animated: true) {
            completionHandler(true)
        }
    }
	
	func documentsPath(of url: URL) -> String {
		let absolutePath = url.absoluteString
		guard let range = absolutePath.range(of: #"(?<=Documents/).*"#, options: .regularExpression) else { return url.absoluteString }
		return String(absolutePath[range])
	}
}

extension UserDefaults {
	func time(forKey key: String) -> CMTime? {
		if let timescale = object(forKey: key + ".timescale") as? NSNumber {
			let seconds = double(forKey: key + ".seconds")
			return CMTime(seconds: seconds, preferredTimescale: timescale.int32Value)
		} else {
			return nil
		}
	}
	
	func set(_ time: CMTime, forKey key: String) {
		let seconds = time.seconds
		let timescale = time.timescale
		
		set(seconds, forKey: key + ".seconds")
		set(NSNumber(value: timescale), forKey: key + ".timescale")
	}
	
	func removeTime(forKey key: String) {
		removeObject(forKey: key + ".seconds")
		removeObject(forKey: key + ".timescale")
	}
}

extension TimeInterval {
    static let minute: TimeInterval = 60
}
