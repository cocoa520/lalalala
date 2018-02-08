//
//  TargetInformation.h
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "Targets.h"

@interface TargetInformation : ASN1Object {
@private
    ASN1Sequence *_targets;
}

+ (TargetInformation *)getInstance:(id)paramObject;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamTargets:(Targets *)paramTargets;
- (instancetype)initParamArrayOfTarget:(NSMutableArray *)paramArrayOfTarget;
- (NSMutableArray *)getTargetsObjects;
- (ASN1Primitive *)toASN1Primitive;

@end
