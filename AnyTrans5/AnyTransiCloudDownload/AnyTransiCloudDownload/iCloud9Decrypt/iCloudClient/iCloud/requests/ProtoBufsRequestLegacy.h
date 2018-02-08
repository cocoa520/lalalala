//
//  ProtoBufsRequest.h
//  
//
//  Created by Pallas on 1/11/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Headers;

@interface ProtoBufsRequestLegacy : NSObject {
@private
    Headers *                           _headers;
}

+ (ProtoBufsRequestLegacy*)singleton;
- (NSMutableURLRequest*)newRequest:(NSString*)url withContainer:(NSString*)container withBundle:(NSString*)bundle withCloudKitUserId:(NSString*)cloudKitUserId withCloudKitToken:(NSString*)cloudKitToken withUuid:(NSString*)uuid withProtobufs:(NSArray*)protobufs;

@end
