//
//  IssuingDistributionPoint.h
//  crypto
//
//  Created by JGehry on 7/11/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "DistributionPointName.h"
#import "ReasonFlags.h"
#import "ASN1Sequence.h"
#import "ASN1TaggedObject.h"

@interface IssuingDistributionPoint : ASN1Object {
@private
    DistributionPointName *_distributionPoint;
    BOOL _onlyContainsUserCerts;
    BOOL _onlyContainsCACerts;
    ReasonFlags *_onlySomeReasons;
    BOOL _indirectCRL;
    BOOL _onlyContainsAttributeCerts;
    ASN1Sequence *_seq;
}

+ (IssuingDistributionPoint *)getInstance:(id)paramObject;
+ (IssuingDistributionPoint *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamDistributionPointName:(DistributionPointName *)paramDistributionPointName paramBoolean1:(BOOL)paramBoolean1 paramBoolean2:(BOOL)paramBoolean2;
- (instancetype)initParamDistributionPointName:(DistributionPointName *)paramDistributionPointName paramBoolean1:(BOOL)paramBoolean1 paramBoolean2:(BOOL)paramBoolean2 paramReasonFlags:(ReasonFlags *)paramReasonFlags paramBoolean3:(BOOL)paramBoolean3 paramBoolean4:(BOOL)paramBoolean4;
- (BOOL)onlyContainsUserCerts;
- (BOOL)onlyContainsCACerts;
- (BOOL)isIndirectCRL;
- (BOOL)onlyContainsAttributeCerts;
- (DistributionPointName *)getDistributionPoint;
- (ReasonFlags *)getOnlySomeReasons;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;

@end
