//
//  MovieOverviewCollectionViewCell.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 8/30/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import UIKit

class MovieOverviewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func setup(_ movie: Movie) {
        self.thumbnail.image = movie.artwork
        self.title.text = movie.title
    }
}
