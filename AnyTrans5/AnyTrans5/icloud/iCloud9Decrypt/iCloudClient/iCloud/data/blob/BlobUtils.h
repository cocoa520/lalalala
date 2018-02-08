//
//  BlobUtils.h
//  
//
//  Created by Pallas on 4/13/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class DataStream;

@interface BlobUtils : NSObject

+ (int)alignWithIndex:(int)index;

+ (void)alignWithDataStream:(DataStream*)blob;

+ (void)padWithDataStream:(DataStream*)blob;

+ (int)typeWithDataStream:(DataStream*)blob;

@end
