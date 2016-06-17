//
//  ViewController.swift
//  GIFFun
//
//  Created by David Beck on 6/16/16.
//  Copyright © 2016 ThinkUltimate LLC. All rights reserved.
//

import UIKit
import SlackTextViewController


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
	
	override func didPressRightButton(sender: AnyObject?) {
		self.textView.refreshFirstResponder()
		
		let message = Message(senderName: "You", body: self.textView.text)
		self.messages.insert(message, atIndex: 0)
		
		let indexPath = NSIndexPath(forRow: 0, inSection: 0)
		self.tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .None)
		
		super.didPressRightButton(sender)
	}
}

