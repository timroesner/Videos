//
//  TVShowParser.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 9/3/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import AVFoundation
import UIKit

extension TVShow {
    func mapURLs(collection:[URL]) -> [TVShow] {
        var result = [TVShow]()
        for url in collection {
            let directoryContents = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            let currentShow = directoryContents?.filter{ $0.pathExtension == "mp4" || $0.pathExtension == "m4v" || $0.pathExtension == "mov"} ?? []
            
            if(!currentShow.isEmpty) {
                var show = TVShow()
                show.title = url.lastPathComponent
                
                let asset = AVAsset(url: currentShow[0])
                let metadata = asset.metadata(forFormat: AVMetadataFormatiTunesMetadata)
                
                // Artwork
                let artworkItems = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: AVMetadataCommonIdentifierArtwork)
                if let artworkItem = artworkItems.first, let imageData = artworkItem.dataValue {
                        show.artwork = UIImage(data: imageData)
                }
                
                // Description
                let descriptionItems = AVMetadataItem.metadataItems(from: metadata, withKey: "ldes", keySpace: "itsk")
                if let descriptionItem = descriptionItems.first, let descriptionData = descriptionItem.stringValue {
                    show.description = descriptionData
                }
                
                for url in currentShow {
                    var episode = TVEpisode()
                    episode.url = url
                    
                    let asset = AVAsset(url: url)
                    let metadata = asset.metadata(forFormat: AVMetadataFormatiTunesMetadata)
                    
                    episode.duration = Int(round(CMTimeGetSeconds(asset.duration) / 60))
                    
                    // Episode Name
                    let titleItems = AVMetadataItem.metadataItems(from: metadata, withKey: "©nam", keySpace: "itsk")
                    if let data = titleItems.first, let name = data.stringValue {
                            episode.title = name
                    }
                    
                    // Episode number
                    let trackItems = AVMetadataItem.metadataItems(from: metadata, withKey: "tves", keySpace: "itsk")
                    if let data = trackItems.first, let track = data.numberValue {
                        episode.number = track.intValue
                    }
                    show.episodes.append(episode)
                }
                result.append(show)
            }
        }
        return result
    }
}
