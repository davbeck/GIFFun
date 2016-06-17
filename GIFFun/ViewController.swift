//
//  ViewController.swift
//  GIFFun
//
//  Created by David Beck on 6/16/16.
//  Copyright © 2016 ThinkUltimate LLC. All rights reserved.
//

import UIKit
import SlackTextViewController
import MobileCoreServices


class ViewController: SLKTextViewController {
	var messages = [
		Message(body: Message.randomBody()),
		Message(photo: UIImage(named: "image-1.gif")),
		Message(body: Message.randomBody()),
		Message(body: Message.randomBody()),
		Message(photo: UIImage(named: "image-2.gif")),
		Message(photo: UIImage(named: "image-3.gif")),
		Message(body: Message.randomBody()),
		Message(body: Message.randomBody()),
		Message(body: Message.randomBody()),
		Message(body: Message.randomBody()),
		Message(body: Message.randomBody()),
		Message(body: Message.randomBody()),
	]
	
	
	required init(coder decoder: NSCoder) {
		super.init(coder: decoder)
		
		commonInit()
	}
	
	init() {
		super.init(tableViewStyle: .Plain)
		
		commonInit()
	}
	
	private func commonInit() {
		self.registerClassForTextView(TextView.self)
		self.textInputbar.autoHideRightButton = false
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView?.estimatedRowHeight = 100
		
		self.tableView?.registerClass(MessageCell.self, forCellReuseIdentifier: String(MessageCell))
	}
	
	
	// MARK: - Table View
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(String(MessageCell)) as! MessageCell
		let message = messages[indexPath.row]
		
		cell.nameLabel.text = message.senderName
		cell.bodyLabel.text = message.body
		cell.photoView.image = message.photo
		
		cell.transform = self.tableView!.transform
		return cell
	}
	
	
	// MARK: - SLKTextViewController
	
	private func messagesWithAttributedString(attributedText: NSAttributedString) -> [Message] {
		var messages = [Message]()
		
		attributedText.enumerateAttributesInRange(NSRange(location: 0, length: self.textView.attributedText.length), options: []) { (attributes, range, stop) in
			if let attachment = attributes[NSAttachmentAttributeName] as? NSTextAttachment {
				guard let contents = attachment.contents ?? attachment.fileWrapper?.regularFileContents else { return } // block continue
				guard let image = UIImage(data: contents) else { return } // block continue
				
				let message = Message(senderName: "You", photo: image)
				messages.append(message)
			} else {
				// because we add in line breaks to put each photo on it's own line, we need to trim that out of the text
				let body = attributedText.attributedSubstringFromRange(range).string.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
				
				// text between images may just be whitespace, and can be ignored
				guard !body.isEmpty else { return } // block continue
				
				let message = Message(senderName: "You", body: body)
				messages.append(message)
			}
		}
		
		return messages
	}
	
	override func didPressRightButton(sender: AnyObject?) {
		self.textView.refreshFirstResponder()
		
		// reversing because we show the newest images at the bottom, but we are inversed, so they need to be at index 0
		let messages = messagesWithAttributedString(self.textView.attributedText).reverse()
		self.messages.insertContentsOf(messages, at: 0)
		
		let indexPaths = (0..<messages.count).map({ NSIndexPath(forRow: $0, inSection: 0) })
		self.tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
		
		super.didPressRightButton(sender)
	}
}

