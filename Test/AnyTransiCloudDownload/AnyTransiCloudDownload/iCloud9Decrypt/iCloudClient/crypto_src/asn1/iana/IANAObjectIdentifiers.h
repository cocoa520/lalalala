//
//  IANAObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface IANAObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)internet;
+ (ASN1ObjectIdentifier *)directory;
+ (ASN1ObjectIdentifier *)mgmt;
+ (ASN1ObjectIdentifier *)experimental;
+ (ASN1ObjectIdentifier *)_private;
+ (ASN1ObjectIdentifier *)security;
+ (ASN1ObjectIdentifier *)SNMPv2;
+ (ASN1ObjectIdentifier *)mail;
+ (ASN1ObjectIdentifier *)security_mechanisms;
+ (ASN1ObjectIdentifier *)security_nametypes;
+ (ASN1ObjectIdentifier *)pkix;
+ (ASN1ObjectIdentifier *)ipsec;
+ (ASN1ObjectIdentifier *)isakmpOakley;
+ (ASN1ObjectIdentifier *)hmacMD5;
+ (ASN1ObjectIdentifier *)hmacSHA1;
+ (ASN1ObjectIdentifier *)hmacTIGER;
+ (ASN1ObjectIdentifier *)hmacRIPEMD160;

@end
