//
//  AbstrackX500NameStyle.h
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X500NameStyle.h"

@class RDN;

@interface AbstractX500NameStyle : X500NameStyle

+ (NSMutableDictionary *)copyHashTable:(NSMutableDictionary *)paramHashTable;
- (ASN1Encodable *)encodeStringValue:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString;
- (BOOL)rdnAreEqual:(RDN *)paramRDN1 paramRDN2:(RDN *)paramRDN2;

@end
