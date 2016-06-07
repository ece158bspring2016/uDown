//
//  ChatViewController.swift
//  uDown
//
//  Created by Oscar Pan on 5/29/16.
//  Copyright © 2016 Rachit Crew. All rights reserved.
//


import UIKit
import Firebase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    // MARK: Properties
    var receiverId: String!
    var match: String!
    var loaded = false
    
    let rootRef = FIRDatabase.database().reference()
    var messageRef: FIRDatabaseReference!
    var messages = [JSQMessage]()
    
    var userIsTypingRef: FIRDatabaseReference!
    var usersTypingQuery: FIRDatabaseQuery!
    private var localTyping = false
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    private var incomingAvatar: JSQMessagesAvatarImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBubbles()

        // get current user information for senderId
        for profile in (FIRAuth.auth()?.currentUser?.providerData)! {
            self.senderId = profile.uid;
            self.senderDisplayName = profile.displayName;
        }
        
        // get profile image for the matched user
        let imageUrl = "https://graph.facebook.com/\(receiverId)/picture?width=64&height=64"
        print(imageUrl)
        let url = NSURL(string: imageUrl)
        if let data = NSData(contentsOfURL: url!) {
            self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(data: data)!, diameter: 64)
        }

        // Remove Attachment icon
        self.inputToolbar?.contentView?.leftBarButtonItem = nil
        
        // No outgoing avatars
        //collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        observeMessages()
        observeTyping()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.whiteColor()
        } else {
            cell.textView!.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return incomingAvatar
    }
    
    private func observeMessages() {
        
        // ensure that messages are only added once
        if(loaded == false){
            
            let messagesQuery = messageRef.queryLimitedToLast(25)
            messagesQuery.observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot!) in
                let id = snapshot.value!["senderId"] as! String
                let text = snapshot.value!["text"] as! String
                
                self.addMessage(id, text: text)
                
                self.finishReceivingMessage()
            }
            
            loaded = true
        }
        
    }
    
    private func observeTyping() {
        let typingIndicatorRef = rootRef.child("typingIndicator").child(messageRef.key)
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.onDisconnectRemoveValue()
        usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqualToValue(true)
        
        usersTypingQuery.observeEventType(.Value) { (data: FIRDataSnapshot!) in
            
            // You're the only typing, don't show the indicator
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            
            // Are there others typing?
            self.showTypingIndicator = data.childrenCount > 0
            self.scrollToBottomAnimated(true)
        }
        
    }
    
    func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: "", text: text)
        messages.append(message)
    }
    
    override func textViewDidChange(textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        isTyping = textView.text != ""
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        // create the message on databases
        let itemRef = messageRef.childByAutoId()
        let messageItem = [ // 2
            "text": text,
            "senderId": senderId
        ]
        itemRef.setValue(messageItem)
        
        // play sound
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
        isTyping = false
    }
    
    private func setupBubbles() {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = bubbleImageFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = bubbleImageFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if(segue.identifier == "ChatToBeacon"){
            let beaconVc = segue.destinationViewController as! iBeaconViewController
            // setup segue to find view
            // minor1 = ranging minor value
            // minor2 = advertising minor value
            if(match == "my"){
                beaconVc.minor1 = 54627
                beaconVc.minor2 = 54628
            }
            else{
                beaconVc.minor1 = 54628
                beaconVc.minor2 = 54627
            }
            
        }
    }
    
    @IBAction func cancelToMyChatsViewController(segue:UIStoryboardSegue) {
    }
    
}