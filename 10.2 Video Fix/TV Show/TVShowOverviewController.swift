//
//  SecondViewController.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 12/28/16.
//  Copyright © 2016 Tim Roesner. All rights reserved.
//

import UIKit

class TVShowOverviewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var shows = [TVShow]()
    var finishedLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getFiles()
    }
    
    func getFiles() {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        if let directoryContents = try? FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: []) {
            shows = TVShow().mapURLs(collection: directoryContents.filter{$0.hasDirectoryPath})
        }
        finishedLoading = true
        collectionView.reloadData()
    }
}

