//
//  ProtoBufsRequest.h
//  
//
//  Created by iMobie on 7/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Headers;

@interface ProtoBufsRequest : NSObject {
@private
    Headers *                               _headers;
    NSString *                              _url;
    NSString *                              _container;
    NSString *                              _bundle;
    NSString *                              _cloudKitUserId;
    NSString *                              _cloudKitToken;
}

- (NSString*)url;
- (NSString*)container;
- (NSString*)bundle;
- (NSString*)cloudKitUserId;
- (NSString*)cloudKitToken;

- (id)initWithHeaders:(Headers*)headers withUrl:(NSString*)url withContainer:(NSString*)container withBundle:(NSString*)bundle withCloudKitUserId:(NSString*)cloudKitUserId withCloudKitToken:(NSString*)cloudKitToken;
- (id)initWithUrl:(NSString*)url withContainer:(NSString*)container withBundle:(NSString*)bundle withCloudKitUserId:(NSString*)cloudKitUserId withCloudKitToken:(NSString*)cloudKitToken;


@end
