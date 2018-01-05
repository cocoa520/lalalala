//
//  AbstrackX500NameStyle.m
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "AbstractX500NameStyle.h"
#import "IETFUtils.h"

@implementation AbstractX500NameStyle

+ (NSMutableDictionary *)copyHashTable:(NSMutableDictionary *)paramHashTable {
    NSMutableDictionary *localHashTable =  [[[NSMutableDictionary alloc] init] autorelease];
    NSEnumerator *localEnumeration = [paramHashTable keyEnumerator];
    id localObject = nil;
    while (localObject = [localEnumeration nextObject]) {
        [localHashTable setObject:[paramHashTable objectForKey:localObject] forKey:localObject];
    }
    return localHashTable;
}

- (ASN1Encodable *)encodeStringValue:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString {
    return nil;
}

- (BOOL)rdnAreEqual:(RDN *)paramRDN1 paramRDN2:(RDN *)paramRDN2 {
    return [IETFUtils rDNAreEqual:paramRDN1 paramRDN2:paramRDN2];
}

@end
