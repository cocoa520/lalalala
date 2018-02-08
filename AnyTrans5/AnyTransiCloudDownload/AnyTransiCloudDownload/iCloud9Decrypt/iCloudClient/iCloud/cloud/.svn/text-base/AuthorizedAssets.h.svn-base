//
//  AuthorizedAssets.h
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class AssetEx;
@class FileGroups;

@interface AuthorizedAssets : NSObject {
@private
    FileGroups *                            _fileGroups;
    NSDictionary *                          _assets;
}

- (FileGroups*)fileGroups;

+ (AuthorizedAssets*)empty;

- (id)initWithFileGroups:(FileGroups*)fileGroups withAssets:(NSDictionary*)assets;

- (AssetEx*)asset:(NSString*)fileSignature;
- (NSMutableArray*)assets:(NSString*)fileSignature;
- (NSMutableArray*)getAssets;

@end
