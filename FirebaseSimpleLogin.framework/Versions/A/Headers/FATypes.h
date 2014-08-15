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

#ifndef FirebaseSimpleLogin_FATypes_h
#define FirebaseSimpleLogin_FATypes_h

typedef enum {
    FAErrorUserDoesNotExist = -1,
    FAErrorInvalidPassword = -2,
    FAErrorAccessNotGranted = -3,
    FAErrorAccountNotFound = -4,
    FAErrorAuthenticationProviderNotEnabled = -5,
    FAErrorInvalidEmail = -6,
    FAErrorBadSystemToken = -7,
    FAErrorUnknown = -9999
} FAError;

typedef enum {
    FAProviderInvalid = -1,
    FAProviderPassword = 1,
    FAProviderFacebook = 2,
    FAProviderTwitter = 3,
    FAProviderAnonymous = 4,
    FAProviderGoogle = 5
} FAProvider;

#endif
