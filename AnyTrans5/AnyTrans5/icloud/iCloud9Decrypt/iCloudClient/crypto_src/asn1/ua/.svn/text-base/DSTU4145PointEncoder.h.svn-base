//
//  DSTU4145PointEncoder.h
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECPoint.h"
#import "ECFieldElement.h"

@interface DSTU4145PointEncoder : NSObject

+ (NSMutableData *)encodePoint:(ECPoint *)paramECPoint;
+ (ECPoint *)decodePoint:(ECCurve *)paramECCurve paramArrayOfByte:(NSMutableData *)paramArrayOfByte;

@end
