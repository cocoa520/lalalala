//
//  CkAppInitBackupRequest.h
//  
//
//  Created by Pallas on 1/7/16.
//
//

#import <Foundation/Foundation.h>

@class Headers;

@interface CkAppInitBackupRequest : NSObject {
@private
    NSString *                      _url;
    Headers *                       _headers;
}

+ (CkAppInitBackupRequest*)singleton;
- (NSMutableURLRequest*)newRequest:(NSString*)dsPrsID withMmeAuthToken:(NSString*)mmeAuthToken withCloudKitAuthToken:(NSString*)cloudKitAuthToken withBundle:(NSString*)bundle withContainer:(NSString*)container;

@end