//
//  ContentIdentifier.h
//  crypto
//
//  Created by JGehry on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1OctetString.h"

@interface ContentIdentifier : ASN1Object {
    ASN1OctetString *_value;
}

@property (nonatomic, readwrite, retain) ASN1OctetString *value;

+ (ContentIdentifier *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (ASN1OctetString *)getValue;
- (ASN1Primitive *)toASN1Primitive;

@end
