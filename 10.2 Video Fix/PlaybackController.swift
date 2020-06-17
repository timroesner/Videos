//
//  Playback.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 9/4/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import AVKit

extension UIViewController: AVPlayerViewControllerDelegate {
	func presentPlayer(with url: URL) {
        let playerVC = AVPlayerViewController()
        playerVC.delegate = self
		
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
