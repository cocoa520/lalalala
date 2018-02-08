//
//  RequestedCertificate.h
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "Certificate.h"
#import "ASN1TaggedObject.h"

@interface RequestedCertificate : ASN1Choice {
@private
    Certificate *_cert;
    NSMutableData *_publicKeyCert;
    NSMutableData *_attributeCert;
}

+ (int)certificate;
+ (int)publicKeyCertificate;
+ (int)attributeCertificate;
+ (RequestedCertificate *)getInstance:(id)paramObject;
+ (RequestedCertificate *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamCertificate:(Certificate *)paramCertificate;
- (instancetype)initParamInt:(int)paramInt paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (int)getType;
- (NSMutableData *)getCertificateBytes;
- (ASN1Primitive *)toASN1Primitive;

@end
