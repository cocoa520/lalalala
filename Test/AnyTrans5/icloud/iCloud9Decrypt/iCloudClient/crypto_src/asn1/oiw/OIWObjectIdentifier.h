//
//  OIWObjectIdentifier.h
//  crypto
//
//  Created by JGehry on 6/16/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface OIWObjectIdentifier : NSObject

+ (ASN1ObjectIdentifier *)md4WithRSA;
+ (ASN1ObjectIdentifier *)md5WithRSA;
+ (ASN1ObjectIdentifier *)md4WithRSAEncryption;
+ (ASN1ObjectIdentifier *)desECB;
+ (ASN1ObjectIdentifier *)desCBC;
+ (ASN1ObjectIdentifier *)desOFB;
+ (ASN1ObjectIdentifier *)desCFB;
+ (ASN1ObjectIdentifier *)desEDE;
+ (ASN1ObjectIdentifier *)idSHA1;
+ (ASN1ObjectIdentifier *)dsaWithSHA1;
+ (ASN1ObjectIdentifier *)sha1WithRSA;
+ (ASN1ObjectIdentifier *)elGamalAlgorithm;

@end
