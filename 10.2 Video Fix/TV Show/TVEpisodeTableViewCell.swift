//
//  TVEpisodeTableViewCell.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 12/31/20.
//  Copyright © 2020 Tim Roesner. All rights reserved.
//

import UIKit
import AVKit

class TVEpisodeTableViewCell: UITableViewCell {
	static let reuseIdentifier = "TVEpisodeTableViewCell"
	
	private let thumbnail = UIImageView()
	private let titleLabel = UILabel()
	private let durationLabel = UILabel()
	private let descriptionLabel = UILabel()
	
	private let imageCache = NSCache<NSURL, UIImage>()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		thumbnail.contentMode = .scaleAspectFill
		thumbnail.addCornerRadius()
		thumbnail.backgroundColor = ColorCompatibility.secondaryLabel
		contentView.addAutoLayoutSubview(thumbnail)
		
		titleLabel.font = .preferredFont(forTextStyle: .headline)
		titleLabel.textColor = ColorCompatibility.label
		
		descriptionLabel.font = .preferredFont(forTextStyle: .subheadline)
		descriptionLabel.textColor = ColorCompatibility.label
		descriptionLabel.numberOfLines = 2
		
		durationLabel.font = .preferredFont(forTextStyle: .subheadline)
		durationLabel.textColor = ColorCompatibility.secondaryLabel
		
		let detailsStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, durationLabel])
		detailsStack.spacing = 8
		detailsStack.axis = .vertical
		contentView.addAutoLayoutSubview(detailsStack)
		
		NSLayoutConstraint.activate([
			thumbnail.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			thumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			contentView.bottomAnchor.constraint(greaterThanOrEqualTo: thumbnail.bottomAnchor, constant: 8),
			thumbnail.widthAnchor.constraint(equalTo: thumbnail.heightAnchor, multiplier: 16/9),
			thumbnail.heightAnchor.constraint(equalToConstant: 75),
			
			detailsStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			detailsStack.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: 12),
			contentView.trailingAnchor.constraint(equalTo: detailsStack.trailingAnchor, constant: 8),
			contentView.bottomAnchor.constraint(greaterThanOrEqualTo: detailsStack.bottomAnchor, constant: 8),
		])
	}
	
	func setup(with episode: TVEpisode) {
		titleLabel.text = "\(episode.episodeNumber). \(episode.title)"
		descriptionLabel.text = episode.description
		durationLabel.text = "\(episode.duration) min"

		generateThumbnail(for: episode.url)
	}
	
	private func generateThumbnail(for url: URL) {
		if let thumbnailImage = imageCache.object(forKey: url as NSURL) {
			thumbnail.image = thumbnailImage
		}
		
		let asset = AVURLAsset(url: url, options: nil)
		let imgGenerator = AVAssetImageGenerator(asset: asset)
		let thumbnailTime = CMTime(seconds: asset.duration.seconds < 25.0 ? 5.0 : 25.0, preferredTimescale: 1)
		imgGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: thumbnailTime)]) { [weak self] _, cgImage, _, _, error in
			if let error = error {
				print(error.localizedDescription)
			}
			guard let cgImage = cgImage, let self = self else { return }
			let thumbnail = UIImage(cgImage: cgImage)
			self.imageCache.setObject(thumbnail, forKey: url as NSURL)
			DispatchQueue.main.async {
				self.thumbnail.image = thumbnail
			}
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
