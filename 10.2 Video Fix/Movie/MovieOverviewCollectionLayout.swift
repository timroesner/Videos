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
        let availableWidth = collectionViewLayout.collectionViewContentSize.width
        
        let width: CGFloat
        if UIApplication.shared.statusBarOrientation.isLandscape {
            width = (availableWidth - 72) / 5
        } else {
            width = (availableWidth - 48) / 3
        }
        let height = width*1.69
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12);
    }
}
