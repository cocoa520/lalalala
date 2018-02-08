//
//  SigPolicyQualifiers.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "SigPolicyQualifierInfo.h"

@interface SigPolicyQualifiers : ASN1Object {
    ASN1Sequence *_qualifiers;
}

@property (nonatomic, readwrite, retain) ASN1Sequence *qualifiers;

+ (SigPolicyQualifiers *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfSigPolicyQualifierInfo:(NSMutableArray *)paramArrayOfSigPolicyQualifierInfo;
- (int)size;
- (SigPolicyQualifierInfo *)getInfoAt:(int)paramInt;
- (ASN1Primitive *)toASN1Primitive;

@end
