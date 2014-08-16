//
//  ViewController.swift
//  FireChat-Swift
//
//  Created by Katherine Fang on 8/13/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

import UIKit

class MessagesViewController: JSQMessagesViewController {
    
    var user: FAUser?
    
    var messages = [JSQMessage]()
    var avatars = Dictionary<String, UIImage>()
    var outgoingBubbleImageView = JSQMessagesBubbleImageFactory.outgoingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    var incomingBubbleImageView = JSQMessagesBubbleImageFactory.incomingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleGreenColor())
    var ref: Firebase!
    var messagesRef: Firebase!
    var batchMessages = true
    
    func setupTestModel() {
        var outgoingDiameter = collectionView.collectionViewLayout.outgoingAvatarViewSize.width
        var sbImage = JSQMessagesAvatarFactory.avatarWithUserInitials("SB", backgroundColor: UIColor.blueColor(), textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(14)), diameter: UInt(outgoingDiameter))
        
        var incomingDiameter = collectionView.collectionViewLayout.incomingAvatarViewSize.width
        var saImage = JSQMessagesAvatarFactory.avatarWithUserInitials("SA", backgroundColor: UIColor.greenColor(), textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(14)), diameter: UInt(outgoingDiameter))
        var scImage = JSQMessagesAvatarFactory.avatarWithUserInitials("SC", backgroundColor: UIColor.redColor(), textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(14)), diameter: UInt(outgoingDiameter))
        
        avatars = ["Sender A":saImage, "Sender B":sbImage, "Sender C":scImage]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sender = "Sender A"
        automaticallyScrollsToMostRecentMessage = true
        setupTestModel()
        
        ref = Firebase(url: "https://swift-chat.firebaseio.com/")
        messagesRef = ref.childByAppendingPath("messages")
        
        // *** GOT A MESSAGE FROM FIREBASE
        messagesRef.observeEventType(FEventTypeChildAdded, withBlock: { (snapshot) in
            let message = JSQMessage(text: snapshot.value["text"] as? String, sender: snapshot.value["sender"] as? String)
            self.messages.append(message)
            if !self.batchMessages {
                self.finishReceivingMessage()
            }
        })
        
        messagesRef.observeSingleEventOfType(FEventTypeValue, withBlock: { (snapshot) in
            self.finishReceivingMessage()
            self.batchMessages = false
            println("Should be done")
        })
        // *** END GOT A MESSAGE FROM FIREBASE
    }
    
    override func viewDidAppear(animated: Bool) {
        collectionView.collectionViewLayout.springinessEnabled = true
    }
    
    // ACTIONS
    
    func receivedMessagePressed(sender: UIBarButtonItem) {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, sender: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        // *** ADD A MESSAGE TO FIREBASE
        messagesRef.childByAutoId().setValue(["text":text, "sender":sender])
        // *** END ADD A MESSAGE TO FIREBASE
        
        finishSendingMessage()
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
    
    
    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // Sent by me, skip
        if message.sender == sender {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 1 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.sender == message.sender {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.sender)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        // Sent by me, skip
        if message.sender == sender {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 1 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.sender == message.sender {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
}
