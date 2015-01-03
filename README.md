Swift Chat Example
==============

Chat implemented in Swift! Now works in Xcode 6.0.1. 

![animated screenshot of this app in use](ios-chat.gif)

## What's here

* You can log in with Twitter.
* You can post / receive messages
* Powered by [Firebase](https://www.firebase.com/)

If you have issues with XCTest, check out [this issue](https://github.com/firebase/ios-swift-chat-example/issues/5).

## Setup
This example still has some rough edges around authentication. They'll be fixed soon, so in the mean time follow these steps to run this example. Sorry for the mess!

0. Create a new [Firebase](https://www.firebase.com/).
0. Clone this repo.
0. Open `FireChat-Swift.xcodeproj` in Xcode.
0. Edit [`MessagesViewController.swift`](FireChat-Swift/MessagesViewController.swift) and change `swift-chat.firebaseio.com` to point to your Firebase.
0. Edit [`LoginViewController.swift`](FireChat-Swift/LoginViewController.swift) and change `swift-chat.firebaseio.com` to point to your Firebase.
0. On your emulator or iOS device, go to Settings, scroll down to the accounts section (which contains Twitter, Facebook, Flickr and Vimeo), select Twitter -> Add Account. Register one account. 
0. If the previous step didn't work, install the Twitter app and sign in to at least one account.

## License
[MIT](http://firebase.mit-license.org)
