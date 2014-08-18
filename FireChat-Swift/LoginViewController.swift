//
//  LoginViewController.swift
//  FireChat-Swift
//
//  Created by David on 8/15/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

import Foundation

class LoginViewController : UIViewController, UIActionSheetDelegate {
    
    @IBOutlet var btLogin: UIButton!
    
    var currentTwitterHandle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
    }
    
    @IBAction func login(sender: UIButton) {
        self.authWithTwitter()
    }

    func authWithTwitter() {
    
        var myRef = Firebase(url:"https://swift-chat.firebaseio.com")
        var authRef = FirebaseSimpleLogin(ref:myRef)
        
        if currentTwitterHandle != nil {
            
            authRef.loginToTwitterAppWithId("S40X72gZw8JSoDVjWtwidpk2r",
                multipleAccountsHandler: { usernames -> Int32 in
                    
                    if let usernamesArray = usernames as? [String] {
                        
                        if let usernameIndex = find(usernamesArray, self.currentTwitterHandle!) {
                            return Int32(usernameIndex)
                        }
                        
                    }
                    
                    return 1;
                }, withCompletionBlock: { error, user in
                    if error {
                        // There was an error authenticating
                    } else {
                        // We have an authenticated Twitter user
                        NSLog("%@", user)
                        
                        // segue to chat
                        self.performSegueWithIdentifier("TWITTER_LOGIN", sender: user)
                    }
            })
            
        } else {
            var accountStore = ACAccountStore();
            var accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter);
            

            accountStore.requestAccessToAccountsWithType(accountType, options: nil, completion: { granted, error -> Void in
                
                if granted {
                 
                    var accounts = accountStore.accountsWithAccountType(accountType)
                    self.handleMultipleTwitterAccounts(accounts)
                    
                } else {
                    // User has denied access to Twitter accounts
                }
                
            })
            
        }
    }


    func selectTwitterAccount(accounts: NSArray) {
 
        var selectUserActionSheet = UIActionSheet(title: "Select Twitter Account", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Destruct", otherButtonTitles: "Other")
        
        for account in accounts {
            selectUserActionSheet.addButtonWithTitle(account.username)
        }
        
        selectUserActionSheet.cancelButtonIndex = selectUserActionSheet.addButtonWithTitle("Cancel")
        selectUserActionSheet.showInView(self.view);
        
    }
    
    func handleMultipleTwitterAccounts(accounts: NSArray) {

        switch accounts.count {
        case 0:
            UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/signup"))
            break;
        case 1:
            self.currentTwitterHandle = accounts.firstObject.username
            self.authWithTwitter()
            break;
        default:
            self.selectTwitterAccount(accounts);
            break;
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        self.currentTwitterHandle = actionSheet.buttonTitleAtIndex(buttonIndex)
        self.authWithTwitter()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        var messagesVc = segue.destinationViewController as MessagesViewController
        messagesVc.user = sender as? FAUser
    }

    
}