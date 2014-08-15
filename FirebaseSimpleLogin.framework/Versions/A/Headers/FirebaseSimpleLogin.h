/*
 * Firebase iOS Simple Login Library
 *
 * Copyright © 2013 Firebase - All Rights Reserved
 * https://www.firebase.com
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binaryform must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY FIREBASE AS IS AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL FIREBASE BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

#import "FAUser.h"

/**
 * A FirebaseSimpleLogin client instance for authenticating Firebase references with email / password, Facebook, or Twitter.
 */
@interface FirebaseSimpleLogin : NSObject


/** @name Initializing a FirebaseSimpleLogin instance */


/**
 * You must initialize the Simple Login with a Firebase reference. The Simple Login client will use that reference to authenticate to the Firebase servers
 *
 * @param ref A valid Firebase reference
 * @return An initialized instance of FirebaseSimpleLogin
 */
- (id) initWithRef:(Firebase *)ref;


/**
 * You must initialize the Simple Login with a Firebase reference. The Simple Login client will use that reference to authenticate to the Firebase servers
 *
 * @param ref A valid Firebase reference
 @ @param options A dictionary of options to respect (i.e. @{ @"flag": @YES } )
 * @return An initialized instance of FirebaseSimpleLogin
 */
- (id) initWithRef:(Firebase *)aRef andOptions:(NSDictionary *)options;


/** @name Checking current authentication status */

/**
 * checkAuthStatusWithBlock: will determine if there is a logged in user. The provided block will be called asynchronously with the results of the check
 *
 * @param block The block to be called with result of the authentication check.
 */
- (void) checkAuthStatusWithBlock:(void (^)(NSError* error, FAUser* user))block;


/** @name Removing any existing authentication */

/**
 * Log the current user out, and clear any stored credentials
 */
- (void) logout;


/** @name Email/password authentication methods */


/**
 * Used to create a new user account with the given email and password combo. The results will be passed to the given block.
 * Note that this method will not log the new user in.
 *
 * @param email The email for the account to be created
 * @param password The password for the account to be created
 * @param block The block to be called with the results of the operation
 */
- (void) createUserWithEmail:(NSString *)email password:(NSString *)password andCompletionBlock:(void (^)(NSError* error, FAUser* user))block;


/**
 * Remove a user account with the given email and password.
 *
 * @param email The email of the account to be removed
 * @param password The password for the account to be removed
 * @param block A block to receive the results of the operation
 */
- (void) removeUserWithEmail:(NSString *)email password:(NSString *)password andCompletionBlock:(void (^)(NSError* error, BOOL success))block;


/**
 * Attempts to authenticate to Firebase with the given credentials. The block will receive the results of the attempt.
 *
 * @param email The email of the account
 * @param password The password for the account
 * @param block A block to receive the results of the login attempt
 */
- (void) loginWithEmail:(NSString *)email andPassword:(NSString *)password withCompletionBlock:(void (^)(NSError* error, FAUser* user))block;


/**
 * Attempts to change the password for the account with the given credentials to the new password given. Results are reported to the supplied block.
 *
 * @param email The email for the account to be changed
 * @param oldPassword The old password for the account to be changed
 * @param newPassword The desired newPassword for the account
 * @param block A block to receive the results of the operation
 */
- (void) changePasswordForEmail:(NSString *)email oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completionBlock:(void (^)(NSError* error, BOOL success))block;

/**
 * Send a password reset email to the owner of the account with the given email. Results are reported to the supplied block.
 *
 * @param email The email of the account to be removed
 * @param block A block to receive the results of the operation
 */
- (void) sendPasswordResetForEmail:(NSString *)email andCompletionBlock:(void (^)(NSError* error, BOOL success))block;


/** @name Facebook authentication methods */


/**
 * Attempts to log the user in to the Facebook app with the specified appId. The block will be called with the results of the attempt.
 *
 * @param appId The Facebook application id for the app to log into. Make sure that the app has your bundle id registered in the facebook developer console
 * @param permissions An array of strings, specifying the desired permissions for this user. If the array is empty, 'email' permission will be requested
 * @param audience One of ACFacebookAudienceEveryone, ACFacebookAudienceFriends, ACFacebookAudienceOnlyMe, or nil. Required if your requested permissions include any write access. Assumed to be ACFacebookAudienceOnlyMe is nil is passed
 * @param block A block that will be called with the results of the login attempt
 */
- (void) loginToFacebookAppWithId:(NSString *)appId permissions:(NSArray *)permissions audience:(NSString *)audience withCompletionBlock:(void (^)(NSError* error, FAUser* user))block;

- (void) createFacebookUserWithToken:(NSString *)token appId:(NSString *)appId withCompletionBlock:(void (^)(NSError* error, FAUser* user))block;

/**
 * Attempts to log the user in to the Facebook app with the specified access token. The block will be called with the results of the attempt.
 *
 * @param accessToken The Facebook access token to use when logging in
 * @param block A block that will be called with the results of the login attempt
 */
- (void) loginWithFacebookWithAccessToken:(NSString *)accessToken withCompletionBlock:(void (^)(NSError* error, FAUser* user))block;


/** @name Google authentication methods */

/**
 * Attempts to log the user in to the Google app with the specified access token. The block will be called with the results of the attempt.
 *
 * @param accessToken The Google access token to use when logging in
 * @param block A block that will be called with the results of the login attempt
 */
- (void) loginToGoogleWithAccessToken:(NSString *)accessToken withCompletionBlock:(void (^)(NSError* error, FAUser* user))block;

/**
 * Attempts to log the user in to the Google app with the specified access token. The block will be called with the results of the attempt.
 *
 * @param accessToken The Google access token to use when logging in
 * @param block A block that will be called with the results of the login attempt
 */
- (void) loginWithGoogleWithAccessToken:(NSString *)accessToken withCompletionBlock:(void (^)(NSError* error, FAUser* user))block;


/** @name Twitter authentication methods */


/**
 * Attempts to log the user in to the Twitter app with the specified appId.
 * Requires a block to handle the case where multiple twitter accounts are registered with the OS. The block will be given an array of usernames and should return
 * the index of the desired account. If, after seeing the list, no account is selected, return NSNotFound.
 *
 * @param appId The Twitter app id to log the user into
 * @param accountSelection A block to handle the case where the OS presents multiple Twitter accounts to choose from. Return the index of the desired username, or NSNotFound
 * @param block A block that will be called with the results of the login attempt.
 */
- (void) loginToTwitterAppWithId:(NSString *)appId multipleAccountsHandler:(int (^)(NSArray* usernames))accountSelection withCompletionBlock:(void (^)(NSError* error, FAUser* user))block;

/**
 * Attempts to log the user in to the Twitter app with the specified access token, access token secret, and Twitter user id. The
 * block will be called with the results of the attempt.
 *
 * @param accessToken The Twitter access token to use when logging in
 * @param accessTokenSecret The Twitter access token secret to use when logging in
 * @param twitterUserId The Twitter user id to use when logging in
 * @param block A block that will be called with the results of the login attempt
 */

- (void) loginWithTwitterWithAccessToken:(NSString *)accessToken andAccessTokenSecret:(NSString *)accessTokenSecret
         andTwitterUserId:(NSString *)twitterUserId withCompletionBlock:(void (^)(NSError* error, FAUser* user))block;

/** @name Anonymous authentication methods */


/**
 * Attempts to log the user in anonymously. The block will receive the results of the attempt.
 *
 * @param block A block to receive the results of the login attempt.
 */
- (void) loginAnonymouslywithCompletionBlock:(void (^)(NSError* error, FAUser* user))block;


/** @name Global configuration and settings */

/**
 * @return The FirebaseSimpleLogin SDK version
 */
+ (NSString *) sdkVersion;

@end
