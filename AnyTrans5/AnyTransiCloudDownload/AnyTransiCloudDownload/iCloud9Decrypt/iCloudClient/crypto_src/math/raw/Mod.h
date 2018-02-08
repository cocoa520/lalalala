//
//  Mod.h
//  
//
//  Created by Pallas on 5/10/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface Mod : NSObject

// p, x, z == uint[]
+ (void)invert:(NSMutableArray*)p withX:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// return == uint[], p == uint[]
+ (NSMutableArray*)random:(NSMutableArray*)p;
// p, x, y, z == uint[]
+ (void)add:(NSMutableArray*)p withX:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// p, x, y, z == uint[]
+ (void)subtract:(NSMutableArray*)p withX:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// p, a, z == uint[]
+ (void)inversionResult:(NSMutableArray*)p withAc:(int)ac withA:(NSMutableArray*)a withZ:(NSMutableArray*)z;
// p, u, x == uint[]
+ (void)inversionStep:(NSMutableArray*)p withU:(NSMutableArray*)u withUlen:(int)uLen withX:(NSMutableArray*)x withXc:(int*)xc;
+ (int)getTrailingZeroes:(uint)x;

@end
