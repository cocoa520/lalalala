//
//  BlockDecrypters.h
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BlockDecrypter;

@interface BlockDecrypters : NSObject

+ (BlockDecrypter*)create:(NSMutableData*)key;

@end
