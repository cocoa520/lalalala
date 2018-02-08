//
//  CMPObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface CMPObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)passwordBasedMac;
+ (ASN1ObjectIdentifier *)dhBasedMac;
+ (ASN1ObjectIdentifier *)it_caProtEncCert;
+ (ASN1ObjectIdentifier *)it_signKeyPairTypes;
+ (ASN1ObjectIdentifier *)it_encKeyPairTypes;
+ (ASN1ObjectIdentifier *)it_preferredSymAlg;
+ (ASN1ObjectIdentifier *)it_caKeyUpdateInfo;
+ (ASN1ObjectIdentifier *)it_currentCRL;
+ (ASN1ObjectIdentifier *)it_unsupportedOIDs;
+ (ASN1ObjectIdentifier *)it_keyPairParamReq;
+ (ASN1ObjectIdentifier *)it_keyPairParamRep;
+ (ASN1ObjectIdentifier *)it_revPassphrase;
+ (ASN1ObjectIdentifier *)it_implicitConfirm;
+ (ASN1ObjectIdentifier *)it_confirmWaitTime;
+ (ASN1ObjectIdentifier *)it_origPKIMessage;
+ (ASN1ObjectIdentifier *)it_suppLangTags;
+ (ASN1ObjectIdentifier *)id_pkip;
+ (ASN1ObjectIdentifier *)id_regCtrl;
+ (ASN1ObjectIdentifier *)id_regInfo;
+ (ASN1ObjectIdentifier *)regCtrl_regToken;
+ (ASN1ObjectIdentifier *)regCtrl_authenticator;
+ (ASN1ObjectIdentifier *)regCtrl_pkiPublicationInfo;
+ (ASN1ObjectIdentifier *)regCtrl_pkiArchiveOptions;
+ (ASN1ObjectIdentifier *)regCtrl_oldCertID;
+ (ASN1ObjectIdentifier *)regCtrl_protocolEncrKey;
+ (ASN1ObjectIdentifier *)regCtrl_altCertTemplate;
+ (ASN1ObjectIdentifier *)regInfo_utf8Pairs;
+ (ASN1ObjectIdentifier *)regInfo_certReq;
+ (ASN1ObjectIdentifier *)ct_encKeyWithID;

@end
