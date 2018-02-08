//
//  DistributionPointName.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1TaggedObject.h"
#import "GeneralNames.h"

@interface DistributionPointName : ASN1Choice {
    ASN1Encodable *_name;
    int _type;
}

@property (nonatomic, readwrite, retain) ASN1Encodable *name;
@property (nonatomic, assign) int type;

+ (int)FULL_NAME;
+ (int)NAME_RELATIVE_TO_CRL_ISSUER;
+ (DistributionPointName *)getInstance:(id)paramObject;
+ (DistributionPointName *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames;
- (instancetype)initParamASN1TaggedObject:(ASN1TaggedObject *)paramASN1TaggedObject;
- (int)getType;
- (ASN1Encodable *)getName;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;

@end
