//
//  FixedPointUtilities.h
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class ECCurve;
@class PreCompInfo;
@class ECPoint;
@class FixedPointPreCompInfo;

@interface FixedPointUtilities : NSObject

+ (NSString*)PRECOMP_NAME;

+ (int)getCombSize:(ECCurve*)c;
+ (FixedPointPreCompInfo*)getFixedPointPreCompInfo:(PreCompInfo*)preCompInfo;
+ (FixedPointPreCompInfo*)precompute:(ECPoint*)p withMinWidth:(int)minWidth;

@end
