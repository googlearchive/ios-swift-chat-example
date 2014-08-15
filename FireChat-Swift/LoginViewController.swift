//
//  LoginViewController.swift
//  FireChat-Swift
//
//  Created by David on 8/15/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

import Foundation

class LoginViewController : UIViewController {
    
    @IBOutlet var btLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
    }
    
    @IBAction func loginWithTwitter(sender: UIButton) {
    
        var myRef = Firebase(url:"https://swift-chat.firebaseio.com")
        var authClient = FirebaseSimpleLogin(ref:myRef)
        
        authClient.checkAuthStatusWithBlock({ error, user in
            if error {
                // an error occurred while attempting to login
                println(error)
            } else if user == nil {
                // No user is logged in
            } else {
                println(user)
            }
        })
        
        
        
    }
    
}