//
//  TVShowDetail.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 12/30/16.
//  Copyright © 2016 Tim Roesner. All rights reserved.
//

import UIKit
import AmplitudeLite

class TVShowDetail: UIViewController {
    
    @IBOutlet var cover: UIImageView!
    @IBOutlet var descLbl: UILabel!
    @IBOutlet var tableView: UITableView!
    var currentShow = TVShow()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = currentShow.title
        cover.image = currentShow.artwork
        descLbl.text = currentShow.description
        
        currentShow.episodes.sort(by: {$0.number < $1.number})
        tableView.tableFooterView = UIView()
		
		let deleteButton = UIButton()
		deleteButton.setImage(#imageLiteral(resourceName: "Trash"), for: .normal)
		deleteButton.tintColor = .systemRed
		deleteButton.accessibilityLabel = NSLocalizedString("Delete", comment: "")
		deleteButton.addTarget(self, action: #selector(deleteShow), for: .touchUpInside)
		deleteButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			deleteButton.widthAnchor.constraint(equalToConstant: 24),
			deleteButton.heightAnchor.constraint(equalToConstant: 28)
		])
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteButton)
		deleteButton.isHidden = UIAccessibility.isGuidedAccessEnabled
        
        Analytics.shared.trackEvent(.screenView, properties: [.screenName: "tv-show-details"])
		
		NotificationCenter.default.addObserver(forName: UIAccessibility.guidedAccessStatusDidChangeNotification, object: nil, queue: .main) { [weak deleteButton] _ in
			deleteButton?.isHidden = UIAccessibility.isGuidedAccessEnabled
		}
    }
	
	@objc func deleteShow() {
		let alertController = UIAlertController(title: "Delete \(currentShow.title)", message: "Are you sure you want to delete this show? To re-add it you will have to copy it from your computer again.", preferredStyle: .alert)
		
		let deleteAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive) { [weak self] _ in
			guard let self = self else { return }
			do {
				try FileManager().removeItem(at: self.currentShow.url)
				UserDefaults.standard.removeTime(forKey: self.documentsPath(of: self.currentShow.url))
				Analytics.shared.trackEvent(.interaction, properties: [.type: "delete-tv-show"])
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

