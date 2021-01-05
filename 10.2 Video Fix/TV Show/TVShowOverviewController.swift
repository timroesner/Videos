//
//  SecondViewController.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 12/28/16.
//  Copyright © 2016 Tim Roesner. All rights reserved.
//

import UIKit

class TVShowOverviewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var _shows = [TVShow]()
	var shows: [TVShow] {
		get {
			if #available(iOS 11.0, *) {
				guard let searchController = navigationItem.searchController, let searchText = searchController.searchBar.text else { return _shows }
				return searchController.isActive && !searchText.isEmpty ? _shows.filter({ $0.title.contains(searchText) }) : _shows
			} else {
				return _shows
			}
		}
		set {
			_shows = newValue
		}
	}
    var finishedLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
			
			let searchController = UISearchController(searchResultsController: nil)
			searchController.searchResultsUpdater = self
			searchController.obscuresBackgroundDuringPresentation = false
			navigationItem.searchController = searchController
        }
		extendedLayoutIncludesOpaqueBars = true
		
		collectionView.register(TVShowOverviewCollectionViewCell.self, forCellWithReuseIdentifier: TVShowOverviewCollectionViewCell.reuseIdentifier)
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
            shows = TVShow.mapURLs(collection: directoryContents.filter{$0.hasDirectoryPath})
        }
        finishedLoading = true
        collectionView.reloadData()
    }
	
	#if DEBUG
	private func createTestShows() {
		var shows = [TVShow]()
		for index in 1...10 {
			var episodes = [TVEpisode]()
			let testURL = URL(string: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_1MB.mp4")!
			for episodeIndex in 1...10 {
				let episode = TVEpisode(title: "Episode \(episodeIndex)", episodeNumber: episodeIndex, url: testURL, duration: 25 + ((-5...5).randomElement() ?? 0))
				episodes.append(episode)
			}
			let show = TVShow(title: "Test Show \(index)", url: testURL, description: "This is a TV show for testing", episodes: episodes)
			shows.append(show)
		}
		self.shows = shows
		collectionView.reloadData()
	}
	#endif
}

