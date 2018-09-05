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

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFiles()
    }
    
    func getFiles() {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            
            // Check for directories
            shows = TVShow().mapURLs(collection: directoryContents.filter{$0.hasDirectoryPath})
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        collectionView.reloadData()
    }
}

