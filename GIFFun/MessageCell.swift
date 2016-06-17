//
//  MessageCell.swift
//  GIFFun
//
//  Created by David Beck on 6/16/16.
//  Copyright © 2016 ThinkUltimate LLC. All rights reserved.
//

import UIKit


class MessageCell: UITableViewCell {
	private let avatarWidth: CGFloat = 30
	
	
	let avatarView = UIImageView()
	let nameLabel = UILabel()
	let bodyLabel = UILabel()
	let photoView = AspectImageView()
	
	
	private func commonInit() {
		self.selectionStyle = .None
		
		
		for view in [avatarView, nameLabel, bodyLabel, photoView] {
			view.translatesAutoresizingMaskIntoConstraints = false
			self.contentView.addSubview(view)
		}
		
		avatarView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
		avatarView.layer.cornerRadius = avatarWidth / 2
		avatarView.clipsToBounds = true
		
		nameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
		
		bodyLabel.numberOfLines = 0
		bodyLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
		
		photoView.contentMode = .ScaleAspectFill
		photoView.layer.cornerRadius = 5
		photoView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
		photoView.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).CGColor
		photoView.clipsToBounds = true
		
		self.separatorInset.left = 15 + avatarWidth + 8
		
		NSLayoutConstraint.activateConstraints([
			avatarView.widthAnchor.constraintEqualToConstant(avatarWidth),
			avatarView.heightAnchor.constraintEqualToConstant(avatarWidth),
			avatarView.leadingAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.leadingAnchor),
			avatarView.topAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.topAnchor),
			avatarView.bottomAnchor.constraintLessThanOrEqualToAnchor(contentView.layoutMarginsGuide.bottomAnchor),
			
			nameLabel.leadingAnchor.constraintEqualToAnchor(avatarView.trailingAnchor, constant: 8),
			nameLabel.topAnchor.constraintEqualToAnchor(avatarView.topAnchor),
			nameLabel.trailingAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.trailingAnchor),
			
			bodyLabel.leadingAnchor.constraintEqualToAnchor(nameLabel.leadingAnchor),
			bodyLabel.trailingAnchor.constraintEqualToAnchor(nameLabel.trailingAnchor),
			bodyLabel.topAnchor.constraintEqualToAnchor(nameLabel.bottomAnchor),
			
			photoView.leadingAnchor.constraintEqualToAnchor(nameLabel.leadingAnchor),
			photoView.trailingAnchor.constraintEqualToAnchor(nameLabel.trailingAnchor),
			photoView.topAnchor.constraintEqualToAnchor(bodyLabel.bottomAnchor),
			photoView.bottomAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.bottomAnchor),
		])
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .Default, reuseIdentifier: reuseIdentifier)
		
		self.commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.commonInit()
	}
}
