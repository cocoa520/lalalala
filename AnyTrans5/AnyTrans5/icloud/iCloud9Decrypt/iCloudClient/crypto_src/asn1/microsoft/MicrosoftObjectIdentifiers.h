//
//  MicrosoftObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface MicrosoftObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)microsoft;
+ (ASN1ObjectIdentifier *)microsoftCertTemplateV1;
+ (ASN1ObjectIdentifier *)microsoftCaVersion;
+ (ASN1ObjectIdentifier *)microsoftPrevCaCertHash;
+ (ASN1ObjectIdentifier *)microsoftCrlNextPublish;
+ (ASN1ObjectIdentifier *)microsoftCertTemplateV2;
+ (ASN1ObjectIdentifier *)microsoftAppPolicies;

@end
