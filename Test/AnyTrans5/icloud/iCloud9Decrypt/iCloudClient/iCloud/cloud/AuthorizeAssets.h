//
//  AuthorizeAssets.h
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class AuthorizedAssets;
@class FileGroups;
@class FileTokens;

@interface AuthorizeAssets : NSObject {
@private
    NSString *                      _container;
    NSString *                      _zone;
}

+ (AuthorizeAssets*)backupd;

- (id)initWithContainer:(NSString*)container withZone:(NSString*)zone;
- (id)initWithContainer:(NSString*)container;

- (AuthorizedAssets*)authorize:(NSArray*)assets;

@end
