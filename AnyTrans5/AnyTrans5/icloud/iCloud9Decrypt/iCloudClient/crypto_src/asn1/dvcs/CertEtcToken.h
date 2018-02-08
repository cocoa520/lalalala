//
//  CertEtcToken.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "Extension.h"

@interface CertEtcToken : ASN1Choice {
@private
    int _tagNo;
    ASN1Encodable *_value;
    Extension *_extension;
}

+ (int)TAG_CERTIFICATE;
+ (int)TAG_ESSCERTID;
+ (int)TAG_PKISTATUS;
+ (int)TAG_ASSERTION;
+ (int)TAG_CRL;
+ (int)TAG_OCSPCERTSTATUS;
+ (int)TAG_OCSPCERTID;
+ (int)TAG_OCSPRESPONSE;
+ (int)TAG_CAPABILITIES;
+ (CertEtcToken *)getInstance:(id)paramObject;
+ (NSMutableArray *)arrayFromSequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initParamExtension:(Extension *)paramExtension;
- (instancetype)initParamASN1TaggedObject:(ASN1TaggedObject *)paramASN1TaggedObject;
- (ASN1Primitive *)toASN1Primitive;
- (int)getTagNo;
- (ASN1Encodable *)getValue;
- (Extension *)getExtension;
- (NSString *)toString;

@end
