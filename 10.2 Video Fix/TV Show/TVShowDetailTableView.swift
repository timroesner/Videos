//
//  TVShowDetailTableView.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 9/4/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import UIKit
import AVKit
import AmplitudeLite

extension TVShowDetail: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentShow.episodes.isEmpty {
            tableView.backgroundView = EmptyView().setup(title: "No Episodes", subtitle: "")
        } else {
            tableView.backgroundView = nil
        }
        return currentShow.episodes.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
			let episode = self.currentShow.episodes[indexPath.row]
			
			let alertController = UIAlertController(title: "Delete \(episode.title)", message: "Are you sure you want to delete this episode? To re-add it you will have to copy it from your computer again.", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive) { [weak self] _ in
				guard let self = self else { return }
                do {
					try FileManager().removeItem(at: episode.url)
					UserDefaults.standard.removeTime(forKey: self.documentsPath(of: episode.url))
                    Analytics.shared.trackEvent(.interaction, properties: [.type: "delete-tv-show-episode"])
                    self.currentShow.episodes.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                    tableView.reloadData()
                    
                    if(self.currentShow.episodes.isEmpty) {
                        try FileManager().removeItem(at: self.currentShow.url)
                        self.navigationController?.popViewController(animated: true)
                    }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let episode = currentShow.episodes[indexPath.row]
        cell.textLabel?.text = "\(episode.number). \(episode.title)"
        cell.detailTextLabel?.text = "\(episode.duration) min"
        self.tableView.rowHeight = 50.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        Analytics.shared.trackEvent(.interaction, properties: [.type: "play-tv-show-episode"])
        self.presentPlayer(with: currentShow.episodes[indexPath.row].url)
    }
}
