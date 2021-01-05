//
//  Movie.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 8/30/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import UIKit

struct Movie {
    var url: URL
    var title = ""
    var artwork = UIImage(named: "MissingArtworkMovies.png")
    var duration = 0
    var year = ""
    var genres = ""
    var description = ""
    var cast = [String]()
    var directors = [String]()
    var screenwriters = [String]()
}
