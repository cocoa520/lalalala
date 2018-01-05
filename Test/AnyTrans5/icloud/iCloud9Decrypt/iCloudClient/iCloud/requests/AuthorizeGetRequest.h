//
//  AuthorizeGetRequest.h
//  
//
//  Created by iMobie on 8/8/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Headers;
@class FileTokens;

@interface AuthorizeGetRequest : NSObject {
@private
    Headers *                           _headers;
}

+ (AuthorizeGetRequest*)instance;

- (NSMutableURLRequest*)newRequest:(NSString*)dsPrsID withContentBaseUrl:(NSString*)contentBaseUrl withContainer:(NSString*)container withZone:(NSString*)zone withFileTokens:(FileTokens*)fileTokens;

@end
