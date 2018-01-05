//
//  Authenticator.h
//  
//
//  Created by Pallas on 1/8/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class AuthenticationRequest;
@class Headers;
@class Auth;

@interface Authenticator : NSObject {
@private
    AuthenticationRequest *                 _request;
}

- (id)init:(Headers*)headers;
- (Auth*)authenticate:(NSString*)appleId withPassword:(NSString*)password;

@end
