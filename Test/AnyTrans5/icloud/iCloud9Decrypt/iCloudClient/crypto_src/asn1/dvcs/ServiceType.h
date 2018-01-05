//
//  ServiceType.h
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Enumerated.h"
#import "ASN1TaggedObject.h"

@interface ServiceType : ASN1Object {
@private
    ASN1Enumerated *_value;
}

+ (ServiceType *)CPD;
+ (ServiceType *)VSD;
+ (ServiceType *)VPKC;
+ (ServiceType *)CCPD;
+ (ServiceType *)getInstance:(id)paramObject;
+ (ServiceType *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamInt:(int)paramInt;
- (instancetype)initParamASN1Enumerated:(ASN1Enumerated *)paramASN1Enumerated;
- (BigInteger *)getValue;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;

@end
