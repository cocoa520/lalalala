//
//  ISISMTTObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface ISISMTTObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)id_isismtt;
+ (ASN1ObjectIdentifier *)id_isismtt_cp;
+ (ASN1ObjectIdentifier *)id_isismtt_cp_accredited;
+ (ASN1ObjectIdentifier *)id_isismtt_at;
+ (ASN1ObjectIdentifier *)id_isismtt_at_dateOfCertGen;
+ (ASN1ObjectIdentifier *)id_isismtt_at_procuration;
+ (ASN1ObjectIdentifier *)id_isismtt_at_admission;
+ (ASN1ObjectIdentifier *)id_isismtt_at_monetaryLimit;
+ (ASN1ObjectIdentifier *)id_isismtt_at_declarationOfMajority;
+ (ASN1ObjectIdentifier *)id_isismtt_at_iCCSN;
+ (ASN1ObjectIdentifier *)id_isismtt_at_PKReference;
+ (ASN1ObjectIdentifier *)id_isismtt_at_restriction;
+ (ASN1ObjectIdentifier *)id_isismtt_at_retrieveIfAllowed;
+ (ASN1ObjectIdentifier *)id_isismtt_at_requestedCertificate;
+ (ASN1ObjectIdentifier *)id_isismtt_at_namingAuthorities;
+ (ASN1ObjectIdentifier *)id_isismtt_at_certInDirSince;
+ (ASN1ObjectIdentifier *)id_isismtt_at_certHash;
+ (ASN1ObjectIdentifier *)id_isismtt_at_nameAtBirth;
+ (ASN1ObjectIdentifier *)id_isismtt_at_additionalInformation;
+ (ASN1ObjectIdentifier *)id_isismtt_at_liabilityLimitationFlag;

@end
