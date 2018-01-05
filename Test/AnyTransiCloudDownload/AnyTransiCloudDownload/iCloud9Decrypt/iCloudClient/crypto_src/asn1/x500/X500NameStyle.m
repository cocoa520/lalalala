//
//  X500NameStyle.m
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X500NameStyle.h"

@implementation X500NameStyle

- (ASN1Encodable *)stringToValue:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString {
    return nil;
}

- (ASN1ObjectIdentifier *)attrNameToOID:(NSString *)paramString {
    return nil;
}

- (NSMutableArray *)RDNFromString:(NSString *)paramString {
    return nil;
}

- (BOOL)areEqual:(X500Name *)paramX500Name1 paramX500Name2:(X500Name *)paramX500Name2 {
    return NO;
}

- (int)calculatedHashCode:(X500Name *)paramX500Name {
    return 0;
}

- (NSString *)toString:(X500Name *)paramX500Name {
    return nil;
}

- (NSString *)oidToDisplayName:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    return nil;
}

- (NSMutableArray *)stringOidToAttrNames:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    return nil;
}

@end
