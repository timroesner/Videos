//
//  TVShowOverviewCollectionViewCell.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 9/3/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import UIKit

class TVShowOverviewCollectionViewCell: UICollectionViewCell {
	static let reuseIdentifier = "TVShowOverviewCollectionViewCell"
	
    private let thumbnail = UIImageView()
    private let title = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		thumbnail.contentMode = .scaleAspectFill
		thumbnail.addCornerRadius()
		contentView.addAutoLayoutSubview(thumbnail)
		
		title.font = .preferredFont(forTextStyle: .subheadline)
		contentView.addAutoLayoutSubview(title)
		
		NSLayoutConstraint.activate([
			thumbnail.topAnchor.constraint(equalTo: contentView.topAnchor),
			thumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			thumbnail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			thumbnail.widthAnchor.constraint(equalTo: thumbnail.heightAnchor),
			
			title.topAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: 4),
			title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			contentView.bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: 8)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    func setup(with show: TVShow) {
        thumbnail.image = show.artwork
        thumbnail.isUserInteractionEnabled = true
        title.text = show.title
        
        if #available(iOS 13.4, *) {
            let interaction = UIPointerInteraction(delegate: self)
            thumbnail.addInteraction(interaction)
        }
    }
	
	private func setupForSizing() {
		title.text = "Test"
	}
	
	static func layoutSize(withRequiredWidth width: CGFloat) -> CGSize {
		let targetSize = CGSize(width: width, height: .greatestFiniteMagnitude)
		let cell = TVShowOverviewCollectionViewCell()
		cell.setupForSizing()
		return cell.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
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

extension UIView {
	func addAutoLayoutSubview(_ view: UIView) {
		view.translatesAutoresizingMaskIntoConstraints = false
		addSubview(view)
	}
	
	func addCornerRadius() {
		guard #available(iOS 13.0, *) else { return }
		layer.cornerRadius = 6
		clipsToBounds = true
		layer.cornerCurve = .continuous
	}
}
