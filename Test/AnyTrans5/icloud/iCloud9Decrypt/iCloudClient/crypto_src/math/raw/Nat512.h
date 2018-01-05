//
//  Nat512.h
//  
//
//  Created by Pallas on 5/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface Nat512 : NSObject

// NSMutableArray == uint[]
+ (void)mul:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz;
// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withZZ:(NSMutableArray*)zz;

@end
