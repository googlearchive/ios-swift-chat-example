//
// Created by Katherine Fang on 9/9/14.
// Copyright (c) 2014 Firebase. All rights reserved.
//

#import <Social/Social.h>
#import "TwitterAuthHelper.h"

@interface TwitterAuthHelper ()
@property (strong, nonatomic) SLRequest *request;
@property (strong, nonatomic) ACAccount *account;
@property (nonatomic, copy) void (^userCallback)(NSError *, FAuthData *);
@end

@implementation TwitterAuthHelper

@synthesize store;
@synthesize ref;
@synthesize appId;
@synthesize account;
@synthesize userCallback;

- (id) initWithFirebaseRef:(Firebase *)ref twitterAppId:(NSString *)appId {
    self = [super init];
    if (self) {
        self.store = [[ACAccountStore alloc] init];
        self.ref = ref;
        self.appId = appId;
    }
    return self;
}

// Step 1a -- get account
- (void) selectTwitterAccountWithCallback:(void (^)(NSError *error, NSArray *accounts))callback {
    ACAccountType *accountType = [self.store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.store requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [self.store accountsWithAccountType:accountType];
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(nil, accounts);
            });
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"TwitterAuthHelper"
                                                        code:AuthHelperErrorAccountAccessDenied
                                                    userInfo:@{NSLocalizedDescriptionKey:@"Access to twitter accounts denied."}];
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(error, nil);
            });
        }
    }];
}

// Last public facing method
- (void) authenticateAccount:(ACAccount *)account withCallback:(void (^)(NSError *error, FAuthData *authData))callback {
    self.account = account;
    self.userCallback = callback;
    [self makeReverseRequest]; // kick off step 1b
}

- (void) callbackIfExistsWithError:(NSError *)error authData:(FAuthData *)authData {
    if (self.userCallback) {
        self.userCallback(error, authData);
    }
}

// Step 1b -- get request token from Twitter
- (void) makeReverseRequest {
    [self.ref makeReverseOAuthRequestTo:@"twitter" withCompletionBlock:^(NSError *error, NSDictionary *json) {
        if (error) {
            [self callbackIfExistsWithError:error authData:nil];
        } else {
            self.request = [self createCredentialRequestWithReverseAuthPayload:json];
            [self requestTwitterCredentials];
        }
    }];
}

// Step 1b Helper -- creates request to Twitter
- (SLRequest *) createCredentialRequestWithReverseAuthPayload:(NSDictionary *)json {
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    
    NSString *requestToken = [json objectForKey:@"oauth"];
    [params setValue:requestToken forKey:@"x_reverse_auth_parameters"];
    [params setValue:self.appId forKey:@"x_reverse_auth_target"];
    
    NSURL* url = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    SLRequest* req = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:url parameters:params];
    [req setAccount:self.account];
    
    return req;
}

// Step 2 -- request credentials from Twitter
- (void) requestTwitterCredentials {
    [self.request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            [self callbackIfExistsWithError:error authData:nil];
        } else {
            [self authenticateWithTwitterCredentials:responseData];
        }
    }];
}

// Step 3 -- authenticate with Firebase using Twitter credentials
- (void) authenticateWithTwitterCredentials:(NSData *)responseData {
    NSDictionary *params = [self parseTwitterCredentials:responseData];
    [self.ref authWithOAuthProvider:@"twitter" parameters:params withCompletionBlock:self.userCallback];
}

// Step 3 Helper -- parsers credentials into dictionary
- (NSDictionary *) parseTwitterCredentials:(NSData *)responseData {
    NSString *accountData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSArray* creds = [accountData componentsSeparatedByString:@"&"];
    for (NSString* param in creds) {
        NSArray* parts = [param componentsSeparatedByString:@"="];
        [params setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
    }
    
    return params;
}

@end