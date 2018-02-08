//
//  CKInit.h
//  
//
//  Created by Pallas on 1/11/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class CKContainer;

@interface CKInit : NSObject {
@private
    NSString *                  _cloudKitDeviceUrl;
    NSString *                  _cloudKitDatabaseUrl;
    NSMutableArray *            _containers;                // CKContainer
    NSString *                  _cloudKitShareUrl;
    NSString *                  _cloudKitUserId;
}

- (id)init:(NSString*)cloudKitDeviceUrl withCloudKitDatabaseUrl:(NSString*)cloudKitDatabaseUrl withContainers:(NSArray*)containers withCloudKitShareUrl:(NSString*)cloudKitShareUrl withCloudKitUserId:(NSString*)cloudKitUserId;

- (NSString*)cloudKitDeviceUrl;
- (NSString*)cloudKitDatabaseUrl;
- (CKContainer*)container:(NSString*)env;
- (CKContainer*)production;
- (CKContainer*)sandbox;
- (NSString*)cloudKitShareUrl;
- (NSString*)cloudKitUserId;

@end
