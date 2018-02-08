//
//  X500NameStyle.h
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1Encodable.h"
#import "ASN1ObjectIdentifier.h"
#import "RDN.h"

@class X500Name;

@interface X500NameStyle : NSObject

- (ASN1Encodable *)stringToValue:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString;
- (ASN1ObjectIdentifier *)attrNameToOID:(NSString *)paramString;
- (NSMutableArray *)RDNFromString:(NSString *)paramString;
- (BOOL)areEqual:(X500Name *)paramX500Name1 paramX500Name2:(X500Name *)paramX500Name2;
- (int)calculatedHashCode:(X500Name *)paramX500Name;
- (NSString *)toString:(X500Name *)paramX500Name;
- (NSString *)oidToDisplayName:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (NSMutableArray *)stringOidToAttrNames:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;

@end
