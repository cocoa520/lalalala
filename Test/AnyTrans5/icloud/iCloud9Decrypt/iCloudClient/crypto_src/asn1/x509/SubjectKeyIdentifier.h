//
//  SubjectKeyIdentifier.h
//  crypto
//
//  Created by JGehry on 7/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "Extensions.h"
#import "ASN1OctetString.h"

@interface SubjectKeyIdentifier : ASN1Object {
@private
    NSMutableData *_keyidentifier;
}

+ (SubjectKeyIdentifier *)getInstance:(id)paramObject;
+ (SubjectKeyIdentifier *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (SubjectKeyIdentifier *)fromExtensions:(Extensions *)paramExtensions;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (NSMutableData *)getKeyIdentifier;
- (ASN1Primitive *)toASN1Primitive;

@end
