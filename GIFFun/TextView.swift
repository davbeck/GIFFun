//
//  TextView.swift
//  GIFFun
//
//  Created by David Beck on 6/17/16.
//  Copyright © 2016 ThinkUltimate LLC. All rights reserved.
//

import UIKit
import SlackTextViewController
import MobileCoreServices


class TextAttachment: NSTextAttachment {
	private var _imageSize: CGSize?
	
	/// A cached size for the image represented by the attachment.
	var imageSize: CGSize? {
		if let image = self.image {
			return image.size
		} else {
			if let size = _imageSize {
				return size
			}
			
			guard let data = self.contents ?? self.fileWrapper?.regularFileContents else { return nil }
			guard let image = UIImage(data: data) else { return nil }
			
			_imageSize = image.size
			
			return image.size
		}
	}
	
	override func attachmentBoundsForTextContainer(textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
		guard let imageSize = self.imageSize else { return lineFrag }
		
		let width = lineFrag.size.width - 14
		let adjustedSize = CGSize(width: width, height: floor(imageSize.height / imageSize.width * width))
		return CGRect(origin: .zero, size: adjustedSize)
	}
}


class TextView: SLKTextView {
	override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
		// if it's an action our superclasss can handle, let it
		if super.canPerformAction(action, withSender: sender) {
			return true
		}
		
		// if the pasteboard has images on it, make sure paste gets enabled
		return UIPasteboard.generalPasteboard().containsPasteboardTypes([ kUTTypeImage as String ]) && action == #selector(paste)
	}
	
	override func paste(sender: AnyObject?) {
		// we want to handle pasting images ourselves
		if UIPasteboard.generalPasteboard().containsPasteboardTypes([ kUTTypeImage as String ]) {
			// the pasteboard can contain any number of items, we want to handle them all
			for index in 0..<UIPasteboard.generalPasteboard().numberOfItems {
				let itemSet = NSIndexSet(index: index)
				
				// for GIFs, make sure we retain their type, for all other image types we can be generic
				let textAttachment: TextAttachment
				if let data = UIPasteboard.generalPasteboard().dataForPasteboardType(kUTTypeGIF as String, inItemSet: itemSet)?.first as? NSData {
					textAttachment = TextAttachment(data: data, ofType: kUTTypeGIF as String)
				} else if let data = UIPasteboard.generalPasteboard().dataForPasteboardType(kUTTypeImage as String, inItemSet: itemSet)?.first as? NSData {
					textAttachment = TextAttachment(data: data, ofType: kUTTypeImage as String)
				} else {
					continue
				}
				
				
				// this is how you add an attachment to an NSAttributedString
				// unfortunately, NSAttributedString(attachment:) isn't available for NSMutableAttributedString, so we need to copy it
				let attachmentString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: textAttachment))
				// for convenience, we are adding a line break after an image
				// we will trim this out of our text when we send it later
				attachmentString.appendAttributedString(NSAttributedString(string: "\n"))
				
				let startingSelectedRange = self.selectedRange
				
				// if there is something selected, paste should replace it
				self.textStorage.replaceCharactersInRange(
					startingSelectedRange,
					withAttributedString: attachmentString
				)
				
				// move selection to the end of what we just inserted
				let endingSelectedRange = NSRange(location: startingSelectedRange.location + attachmentString.length, length: 0)
				self.selectedRange = endingSelectedRange
				
				
				// adding the attachment to an empty text view can wipe out any formatting set on it
				// you'll need to reset the basic attributes you want here, such as font, text color and so on
				self.typingAttributes = [
					NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleBody),
				]
				self.textStorage.addAttributes(self.typingAttributes, range: NSRange(location: 0, length: self.textStorage.length))
			}
		} else {
			// all other pasted content can be handled by our superclass
			super.paste(sender)
		}
	}
}
