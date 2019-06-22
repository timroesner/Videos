//
//  TVShowDetailTableView.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 9/4/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import UIKit
import AVKit

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
            let alertController = UIAlertController(title: "Delete Episode", message: "Are you sure you want to delete this episode? To readd it you will have to copy it from iTunes again.", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive) {
                (result : UIAlertAction) -> Void in
                do {
                    try FileManager().removeItem(at: self.currentShow.episodes[indexPath.row].url)
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
        self.presentPlayer(withURL: currentShow.episodes[indexPath.row].url)
    }
}
