//
//  DistributionPoint.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "ASN1Sequence.h"
#import "DistributionPointName.h"
#import "ReasonFlags.h"
#import "GeneralNames.h"

@interface DistributionPoint : ASN1Object {
    DistributionPointName *_distributionPoint;
    ReasonFlags *_reasons;
    GeneralNames *_cRLIssuer;
}

@property (nonatomic, readwrite, retain) DistributionPointName *distributionPoint;
@property (nonatomic, readwrite, retain) ReasonFlags *reasons;
@property (nonatomic, readwrite, retain) GeneralNames *cRLIssuer;

+ (DistributionPoint *)getInstance:(id)paramObject;
+ (DistributionPoint *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamDistributionPointName:(DistributionPointName *)paramDistributionPointName paramReasonFlags:(ReasonFlags *)paramReasonFlags paramGeneralNames:(GeneralNames *)paramGeneralNames;
- (DistributionPointName *)getDistributionPoint;
- (ReasonFlags *)getReasons;
- (GeneralNames *)getCRLIssuer;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;

@end
