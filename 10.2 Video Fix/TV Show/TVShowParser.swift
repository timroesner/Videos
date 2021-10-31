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
    static func mapURLs(collection:[URL]) -> [TVShow] {
        var result = [TVShow]()
        for var url in collection {
            let directoryContents = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            let currentShow = directoryContents?.filter{ $0.pathExtension.lowercased() == "mp4" || $0.pathExtension.lowercased() == "m4v" || $0.pathExtension.lowercased() == "mov"} ?? []
            
			guard !currentShow.isEmpty else { continue }
			
			var show = TVShow(url: url)
			show.title = url.lastPathComponent
			
			var resourceValues = URLResourceValues()
			resourceValues.isExcludedFromBackup = true
			try? url.setResourceValues(resourceValues)
			
			let asset = AVAsset(url: currentShow[0])
			let metadata = asset.metadata(forFormat: AVMetadataFormat.iTunesMetadata)
			
			// Artwork
			if let imageData = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: AVMetadataIdentifier.commonIdentifierArtwork).first?.dataValue {
				show.artwork = UIImage(data: imageData)
			}
			
			// Description
			if let description = AVMetadataItem.metadataItems(from: metadata, withKey: "sdes", keySpace: .iTunes).first?.stringValue {
				show.description = description
			}
			
			for url in currentShow {
				var episode = TVEpisode(url: url)
				
				let asset = AVAsset(url: url)
				let metadata = asset.metadata(forFormat: AVMetadataFormat.iTunesMetadata)
				
				episode.duration = Int(round(asset.duration.seconds / 60))
				
				// Episode Name
				if let episodeName = AVMetadataItem.metadataItems(from: metadata, withKey: "©nam", keySpace: .iTunes).first?.stringValue {
					episode.title = episodeName
				}
				
				// Episode number
				if let episodeNumber = AVMetadataItem.metadataItems(from: metadata, withKey: "tves", keySpace: .iTunes).first?.numberValue {
					episode.episodeNumber = episodeNumber.intValue
				}
				
				// Episode Description
				if let descriptionData = AVMetadataItem.metadataItems(from: metadata, withKey: "desc", keySpace: .iTunes).first?.stringValue {
					episode.description = descriptionData
				}
				
				// Season number
				if let season = AVMetadataItem.metadataItems(from: metadata, withKey: "tvsn", keySpace: .iTunes).first?.numberValue {
					episode.seasonNumber = season.intValue
				}
				
				show.episodes.append(episode)
			}
			result.append(show)
        }
        return result.sorted(by: { $0.title < $1.title })
    }
}
