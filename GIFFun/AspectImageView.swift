//
//  AspectImageView.swift
//  GIFFun
//
//  Created by David Beck on 6/17/16.
//  Copyright © 2016 ThinkUltimate LLC. All rights reserved.
//

import UIKit
import FLAnimatedImage


/**
 An image view that maintains it's images aspect ratio using constraints.
 */
class AspectImageView: FLAnimatedImageView {
	private var aspectConstraint: NSLayoutConstraint? {
		didSet {
			oldValue?.active = false
			aspectConstraint?.active = true
		}
	}
	
	override var animatedImage: FLAnimatedImage! {
		didSet {
			if let image = animatedImage {
				guard image.size != oldValue?.size else { return }
				
				let constraint = self.widthAnchor.constraintEqualToAnchor(self.heightAnchor, multiplier: image.size.width / image.size.height)
				constraint.priority = 750
				
				self.aspectConstraint = constraint
			} else {
				self.aspectConstraint = nil
			}
		}
	}
	
	override var image: UIImage? {
		didSet {
			if let image = image {
				guard image.size != oldValue?.size else { return }
				
				let constraint = self.heightAnchor.constraintEqualToAnchor(self.widthAnchor, multiplier: image.size.height / image.size.width)
				constraint.priority = 900
				
				self.aspectConstraint = constraint
			} else {
				self.aspectConstraint = nil
			}
		}
	}
	
	
	private func commonInit() {
		
	}
	
	convenience init() {
		self.init(frame: CGRect.zero)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.commonInit()
	}
}
