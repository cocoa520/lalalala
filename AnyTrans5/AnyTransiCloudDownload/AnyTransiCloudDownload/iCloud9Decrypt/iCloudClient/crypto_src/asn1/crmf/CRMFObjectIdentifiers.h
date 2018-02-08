//
//  CRMFObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface CRMFObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)id_pkix;
+ (ASN1ObjectIdentifier *)id_pkip;
+ (ASN1ObjectIdentifier *)id_regCtrl;
+ (ASN1ObjectIdentifier *)id_regCtrl_regToken;
+ (ASN1ObjectIdentifier *)id_regCtrl_authenticator;
+ (ASN1ObjectIdentifier *)id_regCtrl_pkiPublicationInfo;
+ (ASN1ObjectIdentifier *)id_regCtrl_pkiArchiveOptions;
+ (ASN1ObjectIdentifier *)id_ct_encKeyWithID;

@end
