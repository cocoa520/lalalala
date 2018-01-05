//
//  SMIMEEncryptionKeyPreferenceAttribute.h
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Attribute.h"
#import "IssuerAndSerialNumber.h"
#import "RecipientKeyIdentifier.h"
#import "ASN1OctetString.h"

@interface SMIMEEncryptionKeyPreferenceAttribute : Attribute

- (instancetype)initParamIssuerAndSerialNumber:(IssuerAndSerialNumber *)paramIssuerAndSerialNumber;
- (instancetype)initParamRecipientKeyIdentifier:(RecipientKeyIdentifier *)paramRecipientKeyIdentifier;
- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString;

@end
