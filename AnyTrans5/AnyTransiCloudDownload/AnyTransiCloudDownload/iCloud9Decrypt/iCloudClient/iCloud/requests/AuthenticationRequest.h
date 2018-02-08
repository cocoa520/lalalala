//
//  AuthenticationRequest.h
//  
//
//  Created by Pallas on 1/7/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Headers;

@interface AuthenticationRequest : NSObject {
@private
    NSString *                          _url;
    Headers *                           _headers;
}

- (id)init:(Headers*)headers;

- (NSMutableURLRequest*)apply:(NSString*)appleId withPassword:(NSString*)password;

@end
