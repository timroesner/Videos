//
//  TVShowDetail.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 12/30/16.
//  Copyright © 2016 Tim Roesner. All rights reserved.
//

import UIKit

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
    }
}

