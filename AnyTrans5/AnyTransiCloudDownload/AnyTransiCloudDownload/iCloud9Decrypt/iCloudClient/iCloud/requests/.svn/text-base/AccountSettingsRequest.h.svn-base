//
//  AccountSettingsRequest.h
//  
//
//  Created by Pallas on 1/7/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Headers;

@interface AccountSettingsRequest : NSObject {
@private
    NSString *                          _url;
    Headers *                           _headers;
}

- (id)init:(Headers*)headers;
- (NSMutableURLRequest*)apply:(NSString*)dsPrsID withPassword:(NSString*)mmeAuthToken;

@end
