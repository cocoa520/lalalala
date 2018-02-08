//
//  CRLDistPoint.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "ASN1TaggedObject.h"

@interface CRLDistPoint : ASN1Object {
    ASN1Sequence *_seq;
}

@property (nonatomic, readwrite, retain) ASN1Sequence *seq;

+ (CRLDistPoint *)getInstance:(id)paramObject;
+ (CRLDistPoint *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamArrayOfDistributionPoint:(NSMutableArray *)paramArrayOfDistributionPoint;
- (NSMutableArray *)getDistributionPoints;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;

@end
