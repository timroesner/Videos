//
//  MoviesDetail.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 1/4/17.
//  Copyright © 2017 Tim Roesner. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import AmplitudeLite

class MoviesDetail: UIViewController {
    
    @IBOutlet var cover: UIImageView!
    @IBOutlet var subtitleLbl: UILabel!
    @IBOutlet var descLbl: UILabel!
    @IBOutlet var castLbl: UILabel!
    @IBOutlet var direcLbl: UILabel!
    @IBOutlet var screenwrLbl: UILabel!
    @IBOutlet var playButton: UIButton!
	@IBOutlet var trashButton: UIButton!
	
	var currentMovie: Movie!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        setLables()
		trashButton.isHidden = UIAccessibility.isGuidedAccessEnabled
		
        if #available(iOS 13.4, *) {
            playButton.pointerStyleProvider = { (button, _, _) in
                let targetPreview = UITargetedPreview(view: button)
				return UIPointerStyle(effect: .hover(targetPreview, preferredTintMode: .none, prefersShadow: false, prefersScaledContent: true))
            }
        }
        Analytics.shared.trackEvent(.screenView, properties: [.screenName: "movie-details"])
		
		NotificationCenter.default.addObserver(forName: UIAccessibility.guidedAccessStatusDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
			self?.trashButton.isHidden = UIAccessibility.isGuidedAccessEnabled
		}
    }
    
    func setLables() {
        self.title = currentMovie.title
        cover.image = currentMovie.artwork
		cover.addCornerRadius()
        subtitleLbl.text = "\(currentMovie.duration)m    \(currentMovie.year)    \(currentMovie.genres)"
        descLbl.text = currentMovie.description
        castLbl.attributedText = createParagraphs(array: currentMovie.cast, headline: "Cast")
        direcLbl.attributedText = createParagraphs(array: currentMovie.directors, headline: "Directors")
        screenwrLbl.attributedText = createParagraphs(array: currentMovie.screenwriters, headline: "Writers")
    }
    
    func createParagraphs(array:[String], headline:String) -> NSMutableAttributedString {
        let result = NSMutableAttributedString(string: "", attributes: nil)
        if(!array.isEmpty) {
            result.append(NSAttributedString(string: headline.uppercased()+"\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0), NSAttributedString.Key.foregroundColor: ColorCompatibility.label]))
            
            var itemsString = ""
            for item in array {
                itemsString += "\(item)\n"
            }
            result.append(NSAttributedString(string: itemsString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0), NSAttributedString.Key.foregroundColor: ColorCompatibility.secondaryLabel]))
        }
        return result
    }
    
    @IBAction func playBtn (_ Sender: UIButton) {
        Analytics.shared.trackEvent(.interaction, properties: [.type: "play-movie"])
        self.presentPlayer(with: currentMovie.url)
    }
    
    @IBAction func trashBtn() {
        let alertController = UIAlertController(title: "Delete \(currentMovie.title)", message: "Are you sure you want to delete this movie? To re-add it you will have to copy it from your computer again.", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive) { [weak self] _ in
			guard let self = self else { return }
            do {
                try FileManager().removeItem(at: self.currentMovie.url)
				UserDefaults.standard.removeTime(forKey: self.documentsPath(of: self.currentMovie.url))
                Analytics.shared.trackEvent(.interaction, properties: [.type: "delete-movie"])
                self.navigationController?.popViewController(animated: true)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
            (result : UIAlertAction) -> Void in
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
