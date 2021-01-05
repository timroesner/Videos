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
        let availableWidth = collectionView.frame.width
        
        let width: CGFloat
        if traitCollection.horizontalSizeClass == .compact, traitCollection.verticalSizeClass == .regular {
            width = (availableWidth - 48) / 3
        } else {
            width = (availableWidth - 72) / 5
        }
		return TVShowOverviewCollectionViewCell.layoutSize(withRequiredWidth: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12);
    }
}
