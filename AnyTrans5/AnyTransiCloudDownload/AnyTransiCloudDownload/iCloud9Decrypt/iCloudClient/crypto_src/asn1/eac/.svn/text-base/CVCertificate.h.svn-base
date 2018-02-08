//
//  CVCertificate.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "CertificateBody.h"
#import "ASN1ObjectIdentifier.h"
#import "PackedDate.h"
#import "CertificateHolderReference.h"
#import "CertificationAuthorityReference.h"
#import "Flags.h"
#import "ASN1InputStream.h"

@interface CVCertificate : ASN1Object {
@private
    CertificateBody *_certificateBody;
    NSMutableData *_signature;
    int _valid;
}

+ (CVCertificate *)getInstance:(id)paramObject;
- (instancetype)initParamCertificateBody:(CertificateBody *)paramCertificateBody paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (NSMutableData *)getSignature;
- (CertificateBody *)getBody;
- (ASN1Primitive *)toASN1Primitive;
- (ASN1ObjectIdentifier *)getHolderAuthorization;
- (PackedDate *)getEffectiveDate;
- (int)getCertificateType;
- (PackedDate *)getExpirationDate;
- (int)getRole;
- (CertificationAuthorityReference *)getAuthorityReference;
- (CertificateHolderReference *)getHolderReference;
- (int)getHolderAuthorizationRole;
- (Flags *)getHolderAuthorizationRights;

@end
