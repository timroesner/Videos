//
//  FirstViewController.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 12/28/16.
//  Copyright © 2016 Tim Roesner. All rights reserved.
//

import UIKit

class MovieOverviewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    var movies = [Movie]()
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func getFiles() {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        if let directoryContents = try? FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: []) {
            movies = Movie().mapURLs(collection: directoryContents.filter{ $0.pathExtension == "mp4" || $0.pathExtension == "m4v" || $0.pathExtension == "mov"})
        }
        finishedLoading = true
        collectionView.reloadData()
    }
    
    #if DEBUG
    private func createTestMovies() {
        for _ in 0 ... 10 {
            let testMovie = Movie(url: nil, title: "Test", artwork: UIImage(named: "MissingArtworkMovies.png"), duration: 120, year: "2020", genres: "Comedy", description: "", cast: [], directors: [], screenwriters: [])
            movies.append(testMovie)
        }
    }
    #endif
}

