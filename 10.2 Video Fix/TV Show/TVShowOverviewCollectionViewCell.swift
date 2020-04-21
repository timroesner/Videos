//
//  TVShowOverviewCollectionViewCell.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 9/3/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import UIKit

class TVShowOverviewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func setup(with show: TVShow) {
        thumbnail.image = show.artwork
        thumbnail.isUserInteractionEnabled = true
        title.text = show.title
        
        if #available(iOS 13.4, *) {
            let interaction = UIPointerInteraction(delegate: self)
            thumbnail.addInteraction(interaction)
        }
    }
}

@available(iOS 13.4, *)
extension TVShowOverviewCollectionViewCell: UIPointerInteractionDelegate {
    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        guard let view = interaction.view else { return nil }
        let targetedPreview = UITargetedPreview(view: view)
        return UIPointerStyle(effect: .lift(targetedPreview))
    }
}

