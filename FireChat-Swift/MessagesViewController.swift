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
    
    var messages = [Message]()
    var avatars = Dictionary<String, UIImage>()
    var outgoingBubbleImageView = JSQMessagesBubbleImageFactory.outgoingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    var incomingBubbleImageView = JSQMessagesBubbleImageFactory.incomingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleGreenColor())
    var senderImageUrl: String!
    var batchMessages = true
    var authRef: FirebaseSimpleLogin!
    
    // *** STEP 1: STORE FIREBASE REFERENCES
    var ref: Firebase!
    var messagesRef: Firebase!
    // *** END STEP 1
    
    func setupTestModel() {
        let outgoingDiameter = collectionView.collectionViewLayout.outgoingAvatarViewSize.width
        let incomingDiameter = collectionView.collectionViewLayout.incomingAvatarViewSize.width
        let sbImage = JSQMessagesAvatarFactory.avatarWithUserInitials("SB", backgroundColor: UIColor.blueColor(), textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(14)), diameter: UInt(incomingDiameter))
        let saImage = JSQMessagesAvatarFactory.avatarWithUserInitials("SA", backgroundColor: UIColor.greenColor(), textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(14)), diameter: UInt(outgoingDiameter))
        let scImage = JSQMessagesAvatarFactory.avatarWithUserInitials("SC", backgroundColor: UIColor.redColor(), textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(14)), diameter: UInt(outgoingDiameter))
        let anonImage = JSQMessagesAvatarFactory.avatarWithUserInitials("Anon", backgroundColor: UIColor.grayColor(), textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(14)), diameter: UInt(outgoingDiameter))
        
        avatars["Sender A"] = saImage
        avatars["Sender B"] = sbImage
        avatars["Sender C"] = scImage
        avatars["Anonymous"] = anonImage
        
        messages = [
            Message(text: "I'm so fast, I got here first.", sender: "Flash", imageUrl: "http://images.fanpop.com/images/image_uploads/Flash-logo-dc-comics-251206_1024_768.jpg"),
            Message(text: "Well, I'm making sure all the data is stored.", sender:"Superman", imageUrl: "http://upload.wikimedia.org/wikipedia/en/7/73/Superman_shield.png"),
            Message(text: "I make sure everything is remembered.", sender: "Professor X", imageUrl: "http://movietime.pl/wp-content/uploads/2014/05/x-men_logo_1-1.png"),
            Message(text: "We'll keep everything simple and functioning.", sender: "Fantastic 4", imageUrl: "http://img1.wikia.nocookie.net/__cb20130719192836/p__/protagonist/images/e/e9/Fantastic_four_logo.jpg")
        ]
    }
    
    func setupAvatarImage(name: String, imageUrl: String?, incoming: Bool) {
        if imageUrl == nil ||  countElements(imageUrl!) == 0 {
            setupAvatarColor(name, incoming: incoming)
            return
        }
        
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let url = NSURL(string: imageUrl)
        let image = UIImage(data: NSData(contentsOfURL: url))
        let avatarImage = JSQMessagesAvatarFactory.avatarWithImage(image, diameter: diameter)
        
        avatars[name] = avatarImage
    }
    
    func setupAvatarColor(name: String, incoming: Bool) {
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let rgbValue = name.hash
        let r = CGFloat(Float((rgbValue & 0xFF0000) >> 16)/255.0)
        let g = CGFloat(Float((rgbValue & 0xFF00) >> 8)/255.0)
        let b = CGFloat(Float(rgbValue & 0xFF)/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
        
        let nameLength = countElements(name)
        let initials : String? = name.substringToIndex(advance(sender.startIndex, min(3, nameLength)))
        let userImage = JSQMessagesAvatarFactory.avatarWithUserInitials(initials, backgroundColor: color, textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(13)), diameter: diameter)
        
        avatars[name] = userImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputToolbar.contentView.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
        navigationController.navigationBar.topItem.title = "Logout"
        
        sender = sender ? sender : "Anonymous"
        if let urlString = user!.thirdPartyUserData["profile_image_url"]! as? String {
            setupAvatarImage(sender, imageUrl: urlString, incoming: false)
            senderImageUrl = urlString
        } else {
            setupAvatarColor(sender, incoming: false)
            senderImageUrl = ""
        }
        
        setupTestModel()
        
        // *** STEP 2: SETUP FIREBASES
        ref = Firebase(url: "https://swift-chat.firebaseio.com/")
        messagesRef = ref.childByAppendingPath("messages")
        // *** END STEP 2
        
        // *** STEP 3: RECEIVE MESSAGES FROM FIREBASE
        messagesRef.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
            let messageText = snapshot.value["text"] as? String
            let messageSender = snapshot.value["sender"] as? String
            let messageImageUrl = snapshot.value["imageUrl"] as? String
                
            let message = Message(text: messageText, sender: messageSender, imageUrl: messageImageUrl)
            self.messages.append(message)
            self.finishReceivingMessage()
        })
        // *** END STEP 3
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.collectionViewLayout.springinessEnabled = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if authRef != nil {
            authRef.logout()
        }
    }
    
    // ACTIONS
    
    func receivedMessagePressed(sender: UIBarButtonItem) {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, sender: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        // *** STEP 4: ADD A MESSAGE TO FIREBASE
        messagesRef.childByAutoId().setValue(["text":text, "sender":sender, "imageUrl":senderImageUrl])
        // *** END STEP 4
        
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
        
        if message.sender() == sender {
            return UIImageView(image: outgoingBubbleImageView.image, highlightedImage: outgoingBubbleImageView.highlightedImage)
        }
        
        return UIImageView(image: incomingBubbleImageView.image, highlightedImage: incomingBubbleImageView.highlightedImage)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        let message = messages[indexPath.item]
        if let avatar = avatars[message.sender()] {
            return UIImageView(image: avatar)
        } else {
            setupAvatarImage(message.sender(), imageUrl: message.imageUrl(), incoming: true)
            return UIImageView(image:avatars[message.sender()])
        }
    }
    
    override func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if message.sender() == sender {
            cell.textView.textColor = UIColor.blackColor()
        } else {
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        let attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor, NSUnderlineStyleAttributeName: 1]
        cell.textView.linkTextAttributes = attributes
        
        //        cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor,
        //            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle]
        return cell
    }
    
    
    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // Sent by me, skip
        if message.sender() == sender {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.sender() == message.sender() {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.sender())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        // Sent by me, skip
        if message.sender() == sender {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.sender() == message.sender() {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
}
