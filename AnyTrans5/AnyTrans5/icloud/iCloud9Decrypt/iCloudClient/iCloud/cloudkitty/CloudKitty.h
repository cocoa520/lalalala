//
//  CloudKitty.h
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class RequestOperationFactory;
@class CKInit;
@class Account;

@interface CloudKitty : NSObject {
@private
    RequestOperationFactory *                   _factory;
    NSString *                                  _container;
    NSString *                                  _bundle;
    NSString *                                  _cloudKitUserId;
    NSString *                                  _cloudKitToken;
    NSString *                                  _baseUrl;
}

+ (CloudKitty*)backupd:(CKInit*)ckInit withAccount:(Account*)account;
- (id)init:(RequestOperationFactory*)factory withContainer:(NSString*)container withBundle:(NSString*)bundle withCloudKitUserId:(NSString*)cloudKitUserId withCloudKitToken:(NSString*)cloudKitToken withBaseUrl:(NSString*)baseUrl;

// return == ZoneRetrieveResponse[]
- (NSMutableArray*)zoneRetrieveRequest:(NSString*)zone, ...;
// return == ZoneRetrieveResponse[]
- (NSMutableArray*)zoneRetrieveRequestWithArray:(NSArray*)zones;
// return == RecordRetrieveResponse[]
- (NSMutableArray*)recordRetrieveRequest:(NSString*)zone withRecordName:(NSString*)recordName, ...;
// return == RecordRetrieveResponse[]
- (NSMutableArray*)recordRetrieveRequest:(NSString*)zone withRecordNames:(NSArray*)recordNames;


@end
