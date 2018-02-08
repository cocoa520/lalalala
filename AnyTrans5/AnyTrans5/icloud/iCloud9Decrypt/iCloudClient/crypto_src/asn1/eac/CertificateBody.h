//
//  CertificateBody.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1InputStream.h"
#import "DERApplicationSpecific.h"
#import "PackedDate.h"
#import "CertificateHolderReference.h"
#import "CertificateHolderAuthorization.h"
#import "CertificationAuthorityReference.h"
#import "PublicKeyDataObject.h"

@interface CertificateBody : ASN1Object {
@private
    DERApplicationSpecific *_certificateProfileIdentifier;
    DERApplicationSpecific *_certificationAuthorityReference;
    PublicKeyDataObject *_publicKey;
    DERApplicationSpecific *_certificateHolderReference;
    CertificateHolderAuthorization *_certificateHolderAuthorization;
    DERApplicationSpecific *_certificateEffectiveDate;
    DERApplicationSpecific *_certificateExpirationDate;
    int _certificateType;
@public
    ASN1InputStream *_seq;
}

@property (nonatomic, readwrite, retain) ASN1InputStream *seq;

+ (CertificateBody *)getInstance:(id)paramObject;
- (instancetype)initParamDERApplicationSpecific:(DERApplicationSpecific *)paramDERApplicationSpecific paramCertificationAuthorityReference:(CertificationAuthorityReference *)paramCertificationAuthorityReference paramPublicKeyDataObject:(PublicKeyDataObject *)paramPublicKeyDataObject paramCertificateHolderReference:(CertificateHolderReference *)paramCertificateHolderReference paramCertificateHolderAuthorization:(CertificateHolderAuthorization *)paramCertificateHolderAuthorization paramPackedDate1:(PackedDate *)paramPackedDate1 paramPackedDate2:(PackedDate *)paramPackedDate2;
- (ASN1Primitive *)toASN1Primitive;
- (int)getCertificateType;
- (PackedDate *)getCertificateEffectiveDate;
- (PackedDate *)getCertificateExpirationDate;
- (CertificateHolderAuthorization *)getCertificateHolderAuthorization;
- (CertificateHolderReference *)getCertificateHolderReference;
- (DERApplicationSpecific *)getCertificateProfileIdentifier;
- (CertificationAuthorityReference *)getCertificationAuthorityReference;
- (PublicKeyDataObject *)getPublicKey;

@end
