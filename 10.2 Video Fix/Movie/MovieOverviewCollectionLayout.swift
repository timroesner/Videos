//
//  MovieOverviewCollectionLayout.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 8/31/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import UIKit

extension MovieOverviewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var w: CGFloat = 0
        let screenWidth = UIScreen.main.bounds.width
        if UIApplication.shared.statusBarOrientation.isLandscape {
            w = (screenWidth-72)/5
        } else {
            w = (screenWidth-48)/3
        }
        let h = w*1.69
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(12, 12, 12, 12);
    }
}
