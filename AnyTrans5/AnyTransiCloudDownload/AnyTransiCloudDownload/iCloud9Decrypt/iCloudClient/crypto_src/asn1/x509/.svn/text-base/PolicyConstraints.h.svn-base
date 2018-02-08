//
//  PolicyConstraints.h
//  crypto
//
//  Created by JGehry on 7/12/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "BigInteger.h"
#import "Extensions.h"

@interface PolicyConstraints : ASN1Object {
@private
    BigInteger *_requireExplicitPolicyMapping;
    BigInteger *_inhibitPolicyMapping;
}

+ (PolicyConstraints *)getInstance:(id)paramObject;
+ (PolicyConstraints *)fromExtensions:(Extensions *)paramExtensions;
- (instancetype)initParamBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2;
- (BigInteger *)getRequireExplicitPolicyMapping;
- (BigInteger *)getInhibitPolicyMapping;
- (ASN1Primitive *)toASN1Primitive;

@end
