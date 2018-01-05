//
//  RequestOperation.h
//  
//
//  Created by iMobie on 7/27/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class RequestOperationHeader;
@class Identifier;

@interface RequestOperationFactory : NSObject {
@private
    RequestOperationHeader *            _requestOperationHeaderProto;
    Identifier *                        _cloudKitUserId;
    NSString *                          _container;
    NSString *                          _bundle;
}

- (id)initWithCloudKitUserId:(NSString*)cloudKitUserId withContainer:(NSString*)container withBundle:(NSString*)bundle withDeviceHardwareID:(NSString*)deviceHardwareID withDeviceID:(NSString*)deviceID;

// return == RequestOperation[], zones = string[]
- (NSMutableArray*)zoneRetrieveRequestOperation:(NSArray*)zones;
// return == RequestOperation[], zones = string[]
- (NSMutableArray*)zoneRetrieveRequestOperation:(RequestOperationHeader*)requestOperationHeader withZones:(NSArray*)zones;
// return == RequestOperation[]
- (NSMutableArray*)recordRetrieveRequestOperations:(NSString*)zone withRecordNames:(NSArray*)recordNames;

- (NSString*)toString;

@end
