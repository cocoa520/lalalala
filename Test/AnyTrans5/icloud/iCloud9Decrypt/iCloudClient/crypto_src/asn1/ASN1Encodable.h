//
//  ASN1Encodable.h
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASN1Primitive;

@interface ASN1Encodable : NSObject<NSCopying, NSMutableCopying>

- (ASN1Primitive *)toASN1Primitive;
- (id)copyWithZone:(NSZone *)zone;
- (id)mutableCopyWithZone:(NSZone *)zone;

@end
