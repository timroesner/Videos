//
//  FirstViewController.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 12/28/16.
//  Copyright © 2016 Tim Roesner. All rights reserved.
//

import UIKit

class MovieOverviewController: UIViewController, UISearchResultsUpdating {
    @IBOutlet var collectionView: UICollectionView!
	
	private var _movies = [Movie]()
	
	var movies: [Movie] {
		get {
			if #available(iOS 11.0, *) {
				guard let searchController = navigationItem.searchController, let searchText = searchController.searchBar.text else { return _movies }
				return searchController.isActive && !searchText.isEmpty ? _movies.filter({ $0.title.contains(searchText) }) : _movies
			} else {
				return _movies
			}
		}
		set {
			_movies = newValue
		}
	}
	
    var finishedLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
			
			let searchController = UISearchController(searchResultsController: nil)
			searchController.searchResultsUpdater = self
			searchController.obscuresBackgroundDuringPresentation = false
			navigationItem.searchController = searchController
		}
		extendedLayoutIncludesOpaqueBars = true
		
		collectionView.register(MovieOverviewCollectionViewCell.self, forCellWithReuseIdentifier: MovieOverviewCollectionViewCell.reuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getFiles()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
	
	func updateSearchResults(for searchController: UISearchController) {
		if searchController.isActive {
			collectionView.reloadData()
		}
	}
    
    private func getFiles() {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        if let directoryContents = try? FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: []) {
            movies = Movie.mapURLs(collection: directoryContents.filter{ $0.pathExtension == "mp4" || $0.pathExtension == "m4v" || $0.pathExtension == "mov"})
        }
        finishedLoading = true
        collectionView.reloadData()
    }
	
    #if DEBUG
    private func createTestMovies() {
        for index in 1 ... 10 {
			let testURL = URL(string: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_1MB.mp4")!
            let testMovie = Movie(url: testURL, title: "Test \(index)", duration: 126, year: "2020", genres: "Comedy", description: "This is a test movie",
								  cast: [], directors: [], screenwriters: [])
            movies.append(testMovie)
        }
		collectionView.reloadData()
    }
    #endif
}

