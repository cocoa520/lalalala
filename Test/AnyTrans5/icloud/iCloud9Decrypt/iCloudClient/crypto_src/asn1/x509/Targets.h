//
//  Targets.h
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"

@interface Targets : ASN1Object {
@private
    ASN1Sequence *_taregets;
}

+ (Targets *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfTarget:(NSMutableArray *)paramArrayOfTarget;
- (NSMutableArray *)getTargets;
- (ASN1Primitive *)toASN1Primitive;

@end
