//
//  GCMDataA.h
//
//
//  Created by Pallas on 8/1/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface GCMDataA : NSObject

+ (NSMutableData*)decrypt:(NSMutableData*)key withData:(NSMutableData*)data;
+ (NSMutableData*)decrypt:(NSMutableData*)key withData:(NSMutableData*)data withOptional:(NSMutableData*)optional;

@end
