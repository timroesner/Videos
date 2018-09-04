//
//  TVShowDetail.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 12/30/16.
//  Copyright © 2016 Tim Roesner. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class TVShowDetail: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentShow.episodes.count
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
        let player = AVPlayer(url: currentShow.episodes[indexPath.row].url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
}

