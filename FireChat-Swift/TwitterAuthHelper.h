//
//  TwitterAuthHelper.h
//  FireChat-Swift
//
//  Created by Katherine Fang on 9/29/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#ifndef FireChat_Swift_TwitterAuthHelper_h
#define FireChat_Swift_TwitterAuthHelper_h

#import <Firebase/Firebase.h>

@interface TwitterAuthHelper : NSObject

@property (strong, nonatomic) ACAccountStore *store;
@property (strong, nonatomic) Firebase *ref;
@property (strong, nonatomic) NSString *appId;

- (id) initWithFirebaseRef:(Firebase *)ref twitterAppId:(NSString *)appId;

// Step 1a
- (void) selectTwitterAccountWithCallback:(void (^)(NSError *error, NSArray *accounts))callback;

// Step 1b through 3:
- (void) authenticateAccount:(ACAccount *)account withCallback:(void (^)(NSError *error, FAuthData *authData))callback;

@end

typedef NS_ENUM(NSInteger, AuthHelperError) {
    AuthHelperErrorAccountAccessDenied = -1
};

#endif