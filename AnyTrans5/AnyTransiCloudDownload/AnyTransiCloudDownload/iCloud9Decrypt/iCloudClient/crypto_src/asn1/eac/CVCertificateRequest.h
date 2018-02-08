//
//  CVCertificateRequest.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "CertificateBody.h"
#import "ASN1ObjectIdentifier.h"
#import "PublicKeyDataObject.h"

@interface CVCertificateRequest : ASN1Object {
@private
    CertificateBody *_certificateBody;
    NSMutableData *_innerSignature;
    NSMutableData *_outerSignature;
    int _valid;
    ASN1ObjectIdentifier *_signOid;
    ASN1ObjectIdentifier *_keyOid;
    NSString *_strCertificateHolderReference;
    NSMutableData *_encodedAuthorityReference;
    int _ProfileId;
    NSMutableData *_certificate;
    NSString *_overSignerReference;
    NSMutableData *_encoded;
    PublicKeyDataObject *_iso7816PubKey;
}

+ (NSMutableData *)ZeroArray;
+ (CVCertificateRequest *)getInstance:(id)paramObject;
- (CertificateBody *)getCertificateBody;
- (PublicKeyDataObject *)getPublicKey;
- (NSMutableData *)getInnerSignature;
- (NSMutableData *)getOuterSignature;
- (BOOL)hasOuterSignature;
- (ASN1Primitive *)toASN1Primitive;

@end
