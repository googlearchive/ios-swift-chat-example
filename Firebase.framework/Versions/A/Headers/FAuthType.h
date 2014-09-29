//
//  FAuthType.h
//  Firebase
//
//  Created by Katherine Fang on 7/30/14.
//
// All public-facing auth enums.
//

#ifndef Firebase_FAuthenticationTypes_h
#define Firebase_FAuthenticationTypes_h

typedef NS_ENUM(NSInteger, FAuthenticationError) {
    FAuthenticationErrorUserDoesNotExist = -1,
    FAuthenticationErrorInvalidPassword = -2,
    FAuthenticationErrorAccessNotGranted = -3,
    FAuthenticationErrorAccountNotFound = -4,
    FAuthenticationErrorAuthenticationProviderNotEnabled = -5,
    FAuthenticationErrorInvalidEmail = -6,
    FAuthenticationErrorBadSystemToken = -7,
    FAuthenticationErrorFromProvider = -8,
    FAuthenticationErrorInvalidConfiguration = -9,
    FAuthenticationErrorInvalidCredentials = -10,
    FAuthenticationErrorEmailTaken = -11,
    FAuthenticationErrorPreempted = -12,
    FAuthenticationErrorUnknown = -9999
};

#endif