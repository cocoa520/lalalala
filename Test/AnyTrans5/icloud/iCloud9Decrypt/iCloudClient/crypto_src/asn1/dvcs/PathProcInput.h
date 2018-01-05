//
//  PathProcInput.h
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"

@interface PathProcInput : ASN1Object {
@private
    NSMutableArray *_acceptablePolicySet;
    BOOL _inhibitPolicyMapping;
    BOOL _explicitPolicyReqd;
    BOOL _inhibitAnyPolicy;
}

+ (PathProcInput *)getInstance:(id)paramObject;
+ (PathProcInput *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamArrayOfPolicyInformation:(NSMutableArray *)paramArrayOfPolicyInformation;
- (instancetype)initParamArrayOfPolicyInformation:(NSMutableArray *)paramArrayOfPolicyInformation paramBoolean1:(BOOL)paramBoolean1 paramBoolean2:(BOOL)paramBoolean2 paramBoolean3:(BOOL)paramBoolean3;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;
- (NSMutableArray *)getAcceptablePolicySet;
- (BOOL)isInhibitPolicyMapping;
- (BOOL)isExplicitPolicyReqd;
- (BOOL)isInhibitAnyPolicy;

@end
