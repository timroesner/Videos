//
//  TVShowOverviewCollectionLayout.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 9/3/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import UIKit

extension TVShowOverviewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var w: CGFloat = 0
        let screenWidth = UIScreen.main.bounds.width
        if UIApplication.shared.statusBarOrientation.isLandscape {
            w = (screenWidth-72)/5
        } else {
            w = (screenWidth-48)/3
        }
        let h = w*1.14
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12);
    }
}
