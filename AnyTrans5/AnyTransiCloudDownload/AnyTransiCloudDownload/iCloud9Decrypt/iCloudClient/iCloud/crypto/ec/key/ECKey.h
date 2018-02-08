//
//  ECKey.h
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class ECCurvePoint;

@interface ECKey : NSObject

- (ECCurvePoint*)getPoint;

@end
