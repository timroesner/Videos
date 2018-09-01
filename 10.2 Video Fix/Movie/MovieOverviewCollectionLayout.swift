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
        let w = (screenWidth-72)/5
        let h = w*1.67
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(12, 12, 12, 12);
    }
}
