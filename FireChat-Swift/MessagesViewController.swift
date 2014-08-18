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
        let outgoingDiameter = collectionView.collectionViewLayout.outgoingAvatarViewSize.width
        let incomingDiameter = collectionView.collectionViewLayout.incomingAvatarViewSize.width
        let sbImage = JSQMessagesAvatarFactory.avatarWithUserInitials("SB", backgroundColor: UIColor.blueColor(), textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(14)), diameter: UInt(incomingDiameter))
        let saImage = JSQMessagesAvatarFactory.avatarWithUserInitials("SA", backgroundColor: UIColor.greenColor(), textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(14)), diameter: UInt(outgoingDiameter))
        let scImage = JSQMessagesAvatarFactory.avatarWithUserInitials("SC", backgroundColor: UIColor.redColor(), textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(14)), diameter: UInt(outgoingDiameter))
        let anonImage = JSQMessagesAvatarFactory.avatarWithUserInitials("Anon", backgroundColor: UIColor.grayColor(), textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(14)), diameter: UInt(outgoingDiameter))
        
        avatars = ["Sender A":saImage, "Sender B":sbImage, "Sender C":scImage, "Anonymous": anonImage]
    }
    
    func setupUserAvatar() {
        if sender == "Anonymous" {
            return
        }
        
        let outgoingDiameter = collectionView.collectionViewLayout.outgoingAvatarViewSize.width
        let initials : String? = sender.substringToIndex(advance(sender.startIndex, 2))
        let userImage = JSQMessagesAvatarFactory.avatarWithUserInitials(initials, backgroundColor: UIColor.redColor(), textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(14)), diameter: UInt(outgoingDiameter))
        avatars[sender] = userImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sender = sender ? sender : "Anonymous"
        automaticallyScrollsToMostRecentMessage = true
        setupTestModel()
        
        ref = Firebase(url: "https://swift-chat.firebaseio.com/")
        messagesRef = ref.childByAppendingPath("messages")
        
        setupUserAvatar()
        
        // *** GOT A MESSAGE FROM FIREBASE
        messagesRef.observeEventType(FEventTypeChildAdded, withBlock: { (snapshot) in
            if let data = snapshot.value as? [String:AnyObject] {
                let messageText = data["text"]! as? String
                let messageSender = data["sender"]! as? String
                
                let message = JSQMessage(text: messageText, sender: messageSender)
                self.messages.append(message)
                self.finishReceivingMessage()
            }
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
