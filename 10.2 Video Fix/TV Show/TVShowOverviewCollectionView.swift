//
//  TVShowOverviewCollectionView.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 9/3/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import UIKit

extension TVShowOverviewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shows.isEmpty && finishedLoading {
            collectionView.backgroundView = EmptyView().setup(title: "No TV Shows", subtitle: "Connect to your computer to add TV shows")
        } else {
            collectionView.backgroundView = nil
        }
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showCell", for: indexPath) as! TVShowOverviewCollectionViewCell
        let currentShow = shows[indexPath.row]
        cell.setup(with: currentShow)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentShow = shows[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "showDetail") as! TVShowDetail
        vc.currentShow = currentShow
        self.navigationController?.pushViewController(vc, animated: true)
		
		if #available(iOS 11.0, *) {
			navigationItem.searchController?.isActive = false
		}
    }
}
