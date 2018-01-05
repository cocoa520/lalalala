//
//  X509ObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 7/12/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"

@interface X509ObjectIdentifiers : ASN1Object

+ (ASN1ObjectIdentifier *)commonName;
+ (ASN1ObjectIdentifier *)countryName;
+ (ASN1ObjectIdentifier *)localityName;
+ (ASN1ObjectIdentifier *)stateOrProvinceName;
+ (ASN1ObjectIdentifier *)organization;
+ (ASN1ObjectIdentifier *)organizationalUnitName;
+ (ASN1ObjectIdentifier *)id_at_telephoneNumber;
+ (ASN1ObjectIdentifier *)id_at_name;
+ (ASN1ObjectIdentifier *)id_SHA1;
+ (ASN1ObjectIdentifier *)ripemd160;
+ (ASN1ObjectIdentifier *)ripemd160WithRSAEncryption;
+ (ASN1ObjectIdentifier *)id_ea_rsa;
+ (ASN1ObjectIdentifier *)id_pkix;
+ (ASN1ObjectIdentifier *)id_pe;
+ (ASN1ObjectIdentifier *)id_ce;
+ (ASN1ObjectIdentifier *)id_ad;
+ (ASN1ObjectIdentifier *)id_ad_caIssuers;
+ (ASN1ObjectIdentifier *)id_ad_ocsp;
+ (ASN1ObjectIdentifier *)ocspAccessMethod;
+ (ASN1ObjectIdentifier *)crlAccessMethod;

@end
