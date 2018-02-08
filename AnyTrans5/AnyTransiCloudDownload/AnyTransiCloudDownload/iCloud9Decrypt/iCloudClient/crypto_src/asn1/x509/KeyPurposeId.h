//
//  KeyPurposeId.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"

@interface KeyPurposeId : ASN1Object {
@private
    ASN1ObjectIdentifier *_id;
}

+ (KeyPurposeId *)anyExtendedKeyUsage;
+ (KeyPurposeId *)id_kp_serverAuth;
+ (KeyPurposeId *)id_kp_clientAuth;
+ (KeyPurposeId *)id_kp_codeSigning;
+ (KeyPurposeId *)id_kp_emailProtection;
+ (KeyPurposeId *)id_kp_ipsecEndSystem;
+ (KeyPurposeId *)id_kp_ipsecTunnel;
+ (KeyPurposeId *)id_kp_ipsecUser;
+ (KeyPurposeId *)id_kp_timeStamping;
+ (KeyPurposeId *)id_kp_OCSPSigning;
+ (KeyPurposeId *)id_kp_dvcs;
+ (KeyPurposeId *)id_kp_sbgpCertAAServerAuth;
+ (KeyPurposeId *)id_kp_scvp_responder;
+ (KeyPurposeId *)id_kp_eapOverPPP;
+ (KeyPurposeId *)id_kp_eapOverLAN;
+ (KeyPurposeId *)id_kp_scvpServer;
+ (KeyPurposeId *)id_kp_scvpClient;
+ (KeyPurposeId *)id_kp_ipsecIKE;
+ (KeyPurposeId *)id_kp_capwapAC;
+ (KeyPurposeId *)id_kp_capwapWTP;
+ (KeyPurposeId *)id_kp_smartcardlogon;
+ (KeyPurposeId *)getInstance:(id)paramObject;
- (instancetype)initParamString:(NSString *)paramString;
- (ASN1ObjectIdentifier *)toOID;
- (NSString *)getId;
- (NSString *)toString;
- (ASN1Primitive *)toASN1Primitive;

@end
