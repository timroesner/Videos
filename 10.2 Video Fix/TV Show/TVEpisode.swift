//
//  TVEpisode.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 9/3/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import UIKit

struct TVEpisode: Hashable {
    var title = ""
	var description = ""
    var episodeNumber = 0
	var seasonNumber = 0
    var url: URL
    var duration = 0
}

struct Season: Hashable {
	var seasonNumber: Int
	var episodes: [TVEpisode]
}
