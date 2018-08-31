//
//  Movie.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 8/30/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import AVFoundation
import AVKit
import UIKit

struct Movie {
    var title = ""
    var artwork = UIImage(named: "MissingArtworkMovies.png")
    var duration = 0
    var year = ""
    var genres = ""
    var description = ""
    
    func mapURLs(collection:[URL]) -> [Movie] {
        var result = [Movie]()
        for url in collection {
            var movie = Movie()
            let asset = AVAsset(url: url)
            let metadata = asset.metadata(forFormat: AVMetadataFormatiTunesMetadata)
            
            // Title
            movie.title = url.pathComponents.last ?? ""
            let titleItems = AVMetadataItem.metadataItems(from: metadata, withKey: "©nam", keySpace: "itsk")
            if let data = titleItems.first, let title = data.stringValue {
                movie.title = title
            }
            
            // Artwork
            let artworkItems = AVMetadataItem.metadataItems(from: metadata, withKey: "covr", keySpace: "itsk")
            if let artworkItem = artworkItems.first, let imageData = artworkItem.dataValue {
                movie.artwork = UIImage(data: imageData)
            }
            
            // Description
            let descItems = AVMetadataItem.metadataItems(from: metadata, withKey: "ldes", keySpace: "itsk")
            if let first = descItems.first, let desc = first.stringValue {
                movie.description = desc
            }
            
            // Duration
            let time: CMTime = asset.duration
            movie.duration = Int(round(CMTimeGetSeconds(time) / 60))
            
            // Year
            let yearItems = AVMetadataItem.metadataItems(from: metadata, withKey: "©day", keySpace: "itsk")
            if let first = yearItems.first, let data = first.stringValue {
                let range = data.index(data.startIndex, offsetBy: 4)
                movie.year = data.substring(to: range)
            }
            
            // Genres
            let genItems = AVMetadataItem.metadataItems(from: metadata, withKey: "©gen", keySpace: "itsk")
            if let first = genItems.first, let data = first.stringValue {
                movie.genres = data
            }
            
            result.append(movie)
        }
        return result
    }
}
