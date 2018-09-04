//
//  MovieParser.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 9/3/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import UIKit
import AVFoundation

extension Movie {
    func mapURLs(collection:[URL]) -> [Movie] {
        var result = [Movie]()
        for url in collection {
            var movie = Movie()
            movie.url = url
            let asset = AVAsset(url: url)
            let metadata = asset.metadata(forFormat: AVMetadataFormatiTunesMetadata)
            
            // Title
            movie.title = url.lastPathComponent
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
            movie.duration = Int(round(CMTimeGetSeconds(asset.duration) / 60))
            
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
            
            let extendedInfo = AVMetadataItem.metadataItems(from: metadata, withKey: "com.apple.iTunes.iTunMOVI", keySpace: "itlk")
            if let first = extendedInfo.first {
                do {
                    let plistData = try PropertyListSerialization.propertyList(from: first.stringValue?.data(using: .utf8) ?? Data(), options: .mutableContainersAndLeaves, format: nil) as! [String:AnyObject]
                    
                    movie.cast = plistData["cast"].map({$0.value(forKey: "name")}) as? [String] ?? []
                    movie.directors = plistData["directors"].map({$0.value(forKey: "name")}) as? [String] ?? []
                    movie.screenwriters = plistData["screenwriters"].map({$0.value(forKey: "name")}) as? [String] ?? []
                    
                } catch {
                    print("Error reading plist: \(error.localizedDescription)")
                }
            }
            result.append(movie)
        }
        return result
    }
}
