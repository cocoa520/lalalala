//
//  SignedData.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKCSObjectIdentifiers.h"
#import "ASN1Integer.h"
#import "ASN1Set.h"
#import "ContentInfoPKCS.h"
#import "ASN1Sequence.h"

@interface SignedData : PKCSObjectIdentifiers {
@private
    ASN1Integer *_version;
    ASN1Set *_digestAlgorithm;
    ContentInfoPKCS *_contentInfo;
    ASN1Set *_certificates;
    ASN1Set *_crls;
    ASN1Set *_signerInfos;
}

+ (SignedData *)getInstance:(id)paramObject;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer paramASN1Set1:(ASN1Set *)paramASN1Set1 paramContentInfo:(ContentInfoPKCS *)paramContentInfo paramASN1Set2:(ASN1Set *)paramASN1Set2 paramASN1Set3:(ASN1Set *)paramASN1Set3 paramASN1Set4:(ASN1Set *)paramASN1Set4;
- (ASN1Integer *)getVersion;
- (ASN1Set *)getDigestAlgorithms;
- (ContentInfoPKCS *)getContentInfo;
- (ASN1Set *)getCertificates;
- (ASN1Set *)getCRLs;
- (ASN1Set *)getSignerInfos;
- (ASN1Primitive *)toASN1Primitive;

@end
