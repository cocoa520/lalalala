//
//  PKCSObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"

@interface PKCSObjectIdentifiers : ASN1Object

+ (ASN1ObjectIdentifier *)pkcs_1;
+ (ASN1ObjectIdentifier *)rsaEncryption;
+ (ASN1ObjectIdentifier *)md2WithRSAEncryption;
+ (ASN1ObjectIdentifier *)md4WithRSAEncryption;
+ (ASN1ObjectIdentifier *)md5WithRSAEncryption;
+ (ASN1ObjectIdentifier *)sha1WithRSAEncryption;
+ (ASN1ObjectIdentifier *)srsaOAEPEncryptionSET;
+ (ASN1ObjectIdentifier *)id_RSAES_OAEP;
+ (ASN1ObjectIdentifier *)id_mgf1;
+ (ASN1ObjectIdentifier *)id_pSpecified;
+ (ASN1ObjectIdentifier *)id_RSASSA_PSS;
+ (ASN1ObjectIdentifier *)sha256WithRSAEncryption;
+ (ASN1ObjectIdentifier *)sha384WithRSAEncryption;
+ (ASN1ObjectIdentifier *)sha512WithRSAEncryption;
+ (ASN1ObjectIdentifier *)sha224WithRSAEncryption;
+ (ASN1ObjectIdentifier *)pkcs_3;
+ (ASN1ObjectIdentifier *)dhKeyAgreement;
+ (ASN1ObjectIdentifier *)pkcs_5;
+ (ASN1ObjectIdentifier *)pbeWithMD2AndDES_CBC;
+ (ASN1ObjectIdentifier *)pbeWithMD2AndRC2_CBC;
+ (ASN1ObjectIdentifier *)pbeWithMD5AndDES_CBC;
+ (ASN1ObjectIdentifier *)pbeWithMD5AndRC2_CBC;
+ (ASN1ObjectIdentifier *)pbeWithSHA1AndDES_CBC;
+ (ASN1ObjectIdentifier *)pbeWithSHA1AndRC2_CBC;
+ (ASN1ObjectIdentifier *)id_PBES2;
+ (ASN1ObjectIdentifier *)id_PBKDF2;
+ (ASN1ObjectIdentifier *)encryptionAlgorithm;
+ (ASN1ObjectIdentifier *)des_EDE3_CBC;
+ (ASN1ObjectIdentifier *)RC2_CBC;
+ (ASN1ObjectIdentifier *)rc4;
+ (ASN1ObjectIdentifier *)digestAlgorithm;
+ (ASN1ObjectIdentifier *)md2;
+ (ASN1ObjectIdentifier *)md4;
+ (ASN1ObjectIdentifier *)md5;
+ (ASN1ObjectIdentifier *)id_hmacWithSHA1;
+ (ASN1ObjectIdentifier *)id_hmacWithSHA224;
+ (ASN1ObjectIdentifier *)id_hmacWithSHA256;
+ (ASN1ObjectIdentifier *)id_hmacWithSHA384;
+ (ASN1ObjectIdentifier *)id_hmacWithSHA512;
+ (ASN1ObjectIdentifier *)pkcs_7;
+ (ASN1ObjectIdentifier *)data;
+ (ASN1ObjectIdentifier *)signedData;
+ (ASN1ObjectIdentifier *)envelopedData;
+ (ASN1ObjectIdentifier *)signedAndEnvelopedData;
+ (ASN1ObjectIdentifier *)digestedData;
+ (ASN1ObjectIdentifier *)encryptedData;
+ (ASN1ObjectIdentifier *)pkcs_9;
+ (ASN1ObjectIdentifier *)pkcs_9_at_emailAddress;
+ (ASN1ObjectIdentifier *)pkcs_9_at_unstructuredName;
+ (ASN1ObjectIdentifier *)pkcs_9_at_contentType;
+ (ASN1ObjectIdentifier *)pkcs_9_at_messageDigest;
+ (ASN1ObjectIdentifier *)pkcs_9_at_signingTime;
+ (ASN1ObjectIdentifier *)pkcs_9_at_counterSignature;
+ (ASN1ObjectIdentifier *)pkcs_9_at_challengePassword;
+ (ASN1ObjectIdentifier *)pkcs_9_at_unstructuredAddress;
+ (ASN1ObjectIdentifier *)pkcs_9_at_extendedCertificateAttributes;
+ (ASN1ObjectIdentifier *)pkcs_9_at_signingDescription;
+ (ASN1ObjectIdentifier *)pkcs_9_at_extensionRequest;
+ (ASN1ObjectIdentifier *)pkcs_9_at_smimeCapabilities;
+ (ASN1ObjectIdentifier *)id_smime;
+ (ASN1ObjectIdentifier *)pkcs_9_at_friendlyName;
+ (ASN1ObjectIdentifier *)pkcs_9_at_localKeyId;

+ (ASN1ObjectIdentifier *)x509certType;
+ (ASN1ObjectIdentifier *)certTypes;
+ (ASN1ObjectIdentifier *)x509Certificate;
+ (ASN1ObjectIdentifier *)sdsiCertificate;
+ (ASN1ObjectIdentifier *)crlTypes;
+ (ASN1ObjectIdentifier *)x509Crl;
+ (ASN1ObjectIdentifier *)id_aa_cmsAlgorithmProtect;
+ (ASN1ObjectIdentifier *)preferSignedData;
+ (ASN1ObjectIdentifier *)canNotDecryptAny;
+ (ASN1ObjectIdentifier *)sMIMECapabilitiesVersions;
+ (ASN1ObjectIdentifier *)id_ct;
+ (ASN1ObjectIdentifier *)id_ct_authData;
+ (ASN1ObjectIdentifier *)id_ct_TSTInfo;
+ (ASN1ObjectIdentifier *)id_ct_compressedData;
+ (ASN1ObjectIdentifier *)id_ct_authEnvelopedData;
+ (ASN1ObjectIdentifier *)id_ct_timestampedData;
+ (ASN1ObjectIdentifier *)id_alg;
+ (ASN1ObjectIdentifier *)id_alg_PWRI_KEK;
+ (ASN1ObjectIdentifier *)id_rsa_KEM;
+ (ASN1ObjectIdentifier *)id_cti;
+ (ASN1ObjectIdentifier *)id_cti_ets_proofOfOrigin;
+ (ASN1ObjectIdentifier *)id_cti_ets_proofOfReceipt;
+ (ASN1ObjectIdentifier *)id_cti_ets_proofOfDelivery;
+ (ASN1ObjectIdentifier *)id_cti_ets_proofOfSender;
+ (ASN1ObjectIdentifier *)id_cti_ets_proofOfApproval;
+ (ASN1ObjectIdentifier *)id_cti_ets_proofOfCreation;
+ (ASN1ObjectIdentifier *)id_aa;
+ (ASN1ObjectIdentifier *)id_aa_receiptRequest;
+ (ASN1ObjectIdentifier *)id_aa_contentHint;
+ (ASN1ObjectIdentifier *)id_aa_msgSigDigest;
+ (ASN1ObjectIdentifier *)id_aa_contentReference;
+ (ASN1ObjectIdentifier *)id_aa_encrypKeyPref;
+ (ASN1ObjectIdentifier *)id_aa_signingCertificate;
+ (ASN1ObjectIdentifier *)id_aa_signingCertificateV2;
+ (ASN1ObjectIdentifier *)id_aa_contentIdentifier;
+ (ASN1ObjectIdentifier *)id_aa_signatureTimeStampToken;
+ (ASN1ObjectIdentifier *)id_aa_ets_sigPolicyId;
+ (ASN1ObjectIdentifier *)id_aa_ets_commitmentType;
+ (ASN1ObjectIdentifier *)id_aa_ets_signerLocation;
+ (ASN1ObjectIdentifier *)id_aa_ets_signerAttr;
+ (ASN1ObjectIdentifier *)id_aa_ets_otherSigCert;
+ (ASN1ObjectIdentifier *)id_aa_ets_contentTimestamp;
+ (ASN1ObjectIdentifier *)id_aa_ets_certificateRefs;
+ (ASN1ObjectIdentifier *)id_aa_ets_revocationRefs;
+ (ASN1ObjectIdentifier *)id_aa_ets_certValues;
+ (ASN1ObjectIdentifier *)id_aa_ets_revocationValues;
+ (ASN1ObjectIdentifier *)id_aa_ets_escTimeStamp;
+ (ASN1ObjectIdentifier *)id_aa_ets_certCRLTimestamp;
+ (ASN1ObjectIdentifier *)id_aa_ets_archiveTimestamp;

+ (ASN1ObjectIdentifier *)id_aa_sigPolicyId;
+ (ASN1ObjectIdentifier *)id_aa_commitmentType;
+ (ASN1ObjectIdentifier *)id_aa_signerLocation;

+ (ASN1ObjectIdentifier *)id_aa_otherSigCert;
+ (NSString *)id_spq;
+ (ASN1ObjectIdentifier *)id_spq_ets_uri;
+ (ASN1ObjectIdentifier *)id_spq_ets_unotice;
+ (ASN1ObjectIdentifier *)pkcs_12;
+ (ASN1ObjectIdentifier *)bagtypes;
+ (ASN1ObjectIdentifier *)keyBag;
+ (ASN1ObjectIdentifier *)pkcs8ShroudedKeyBag;
+ (ASN1ObjectIdentifier *)certBag;
+ (ASN1ObjectIdentifier *)crlBag;
+ (ASN1ObjectIdentifier *)secretBag;
+ (ASN1ObjectIdentifier *)safeContentsBag;
+ (ASN1ObjectIdentifier *)pkcs_12PbeIds;
+ (ASN1ObjectIdentifier *)pbeWithSHAAnd128BitRC4;
+ (ASN1ObjectIdentifier *)pbeWithSHAAnd40BitRC4;
+ (ASN1ObjectIdentifier *)pbeWithSHAAnd3_KeyTripleDES_CBC;
+ (ASN1ObjectIdentifier *)pbeWithSHAAnd2_KeyTripleDES_CBC;
+ (ASN1ObjectIdentifier *)pbeWithSHAAnd128BitRC2_CBC;
+ (ASN1ObjectIdentifier *)pbeWithSHAAnd40BitRC2_CBC;

+ (ASN1ObjectIdentifier *)pbewithSHAAnd40BitRC2_CBC;
+ (ASN1ObjectIdentifier *)id_alg_CMS3DESwrap;
+ (ASN1ObjectIdentifier *)id_alg_CMSRC2wrap;
+ (ASN1ObjectIdentifier *)id_alg_ESDH;
+ (ASN1ObjectIdentifier *)id_alg_SSDH;

@end
