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
#import <Accounts/Accounts.h>
#import "FATypes.h"


/**
 * The FAUser class is a wrapper around the user metadata returned from the Firebase auth server.
 * It includes a (userId, provider) combo that is unique, as well as the token used to authenticate with Firebase.
 *
 * It may include other metadata about the user, depending on the provider used to do the authentication.
 */
@interface FAUser : NSObject


/** @name Required properties */


/**
 * @return A userId for this user. It is unique for the given auth provider.
 */
@property (nonatomic, strong) NSString* userId;


/**
 * @return A uid for this user. It is unique across all auth providers.
 */
@property (nonatomic, strong) NSString* uid;


/**
 * @return The provider that authenticated this user
 */
@property (nonatomic) FAProvider provider;


/**
 * @return The token that was used to authenticate this user with Firebase
 */
@property (nonatomic, strong) NSString* authToken;


/** @name Optional properties */


/**
 * @return The user's email if this user was authenticated via email/password, nil otherwise
 */
@property (strong, nonatomic) NSString* email;


/**
 * @return A flag indicating whether or not the user logged in with a temporary password after a password reset
 */
@property (nonatomic) BOOL* isTemporaryPassword;


/**
 * @return Metadata about the user provided by third party authentication services if such a service was used for this user. Nil otherwise.
 */
@property (strong, nonatomic) NSDictionary* thirdPartyUserData;


/**
 * @return The ACAccount instance provided by the OS. This can be used for getting more information about the user from 
 * a third party via SLRequest
 */
@property (strong, nonatomic) ACAccount* thirdPartyUserAccount;

@end
