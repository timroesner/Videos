//
//  MovieOverviewCollectionView.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 8/31/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import UIKit

extension MovieOverviewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movies.isEmpty && finishedLoading {
            collectionView.backgroundView = EmptyView().setup(title: "No Movies", subtitle: "Connect to iTunes to add movies")
        } else {
            collectionView.backgroundView = nil
        }
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieOverviewCollectionViewCell
        cell.setup(with: movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "movieDetail") as! MoviesDetail
        vc.currentMovie = movies[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
		
		if #available(iOS 11.0, *) {
			navigationItem.searchController?.isActive = false
		}
    }
}
