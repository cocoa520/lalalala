//
//  FileTokensFactory.h
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Asset;
@class FileTokens;

@interface FileTokensFactory : NSObject

+ (FileTokens*)from:(Asset*)asset,...;
+ (FileTokens*)fromWithArray:(NSArray*)assets;

@end
