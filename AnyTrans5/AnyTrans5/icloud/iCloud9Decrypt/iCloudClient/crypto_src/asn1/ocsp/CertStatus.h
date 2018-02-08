//
//  CertStatus.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1TaggedObject.h"
#import "RevokedInfo.h"
#import "ASN1Encodable.h"

@interface CertStatus : ASN1Choice {
@private
    int _tagNo;
    ASN1Encodable *_value;
}

+ (CertStatus *)getInstance:(id)paramObject;
+ (CertStatus *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)init;
- (instancetype)initParamRevokedInfo:(RevokedInfo *)paramRevokedInfo;
- (instancetype)initParamInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initParamASN1TaggedObject:(ASN1TaggedObject *)paramASN1TaggedObject;
- (int)getTagNo;
- (ASN1Encodable *)getStatus;
- (ASN1Primitive *)toASN1Primitive;

@end
