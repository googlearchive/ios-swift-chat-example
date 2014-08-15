//
//  ViewController.swift
//  FireChat-Swift
//
//  Created by Katherine Fang on 8/13/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

import UIKit

class MessagesViewController: JSQMessagesViewController {
    var messages = [JSQMessage]()
    var avatars = Dictionary<String, UIImage>()
    var outgoingBubbleImageView = JSQMessagesBubbleImageFactory.outgoingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    var incomingBubbleImageView = JSQMessagesBubbleImageFactory.incomingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleGreenColor())
    
    func setupTestModel() {
        messages = [
            JSQMessage(text: "A", sender: "SA"),
            JSQMessage(text: "A", sender: "SB"),
            JSQMessage(text: "A", sender: "SC")]
        
        var outgoingDiameter = collectionView.collectionViewLayout.outgoingAvatarViewSize.width
        var sbImage = JSQMessagesAvatarFactory.avatarWithUserInitials("SB", backgroundColor: UIColor.blueColor(), textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(14)), diameter: UInt(outgoingDiameter))
        
        var incomingDiameter = collectionView.collectionViewLayout.incomingAvatarViewSize.width
        var saImage = JSQMessagesAvatarFactory.avatarWithUserInitials("SA", backgroundColor: UIColor.greenColor(), textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(14)), diameter: UInt(outgoingDiameter))
        var scImage = JSQMessagesAvatarFactory.avatarWithUserInitials("SC", backgroundColor: UIColor.redColor(), textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(14)), diameter: UInt(outgoingDiameter))
        
        avatars = ["SA":saImage, "SB":sbImage, "SC":scImage]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sender = "SA"
        
        self.setupTestModel()
    }
    
    override func viewDidAppear(animated: Bool) {
        collectionView.collectionViewLayout.springinessEnabled = true
    }
    
    // ACTIONS
    
    func receivedMessagePressed(sender: UIBarButtonItem) {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
        
        // TODO message pressed?
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, sender: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        let message = JSQMessage(text: text, sender: sender, date: date)
        messages.append(message)
        
        finishSendingMessage()
        
        // TODO SENDING MESSAGE TO FIREBASE
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        println("Camera pressed!")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, bubbleImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        let message = messages[indexPath.item]
        
        if message.sender == sender {
            return UIImageView(image: outgoingBubbleImageView.image, highlightedImage: outgoingBubbleImageView.highlightedImage)
        }
        
        return UIImageView(image: incomingBubbleImageView.image, highlightedImage: incomingBubbleImageView.highlightedImage)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        let message = messages[indexPath.item]
        let avatar = avatars[message.sender]
        return UIImageView(image: avatar)
    }
    
    override func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if message.sender == sender {
            cell.textView.textColor = UIColor.blackColor()
        } else {
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        //        cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor,
        //            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle]
        return cell
    }
}