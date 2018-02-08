//
//  NISTNamedCurves.m
//  crypto
//
//  Created by JGehry on 6/16/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "NISTNamedCurves.h"
#import "SECNamedCurves.h"
#import "SECObjectIdentifiers.h"

@implementation NISTNamedCurves

+ (NSMutableDictionary *)objIds {
    static NSMutableDictionary *_objIds = nil;
    @synchronized(self) {
        if (!_objIds) {
            _objIds = [[NSMutableDictionary alloc] init];
        }
    }
    return _objIds;
}

+ (NSMutableDictionary *)names {
    static NSMutableDictionary *_names = nil;
    @synchronized(self) {
        if (!_names) {
            _names = [[NSMutableDictionary alloc] init];
        }
    }
    return _names;
}

+ (void)defineCurveAlia:(NSString *)paramString paramASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    [[self objIds] setObject:paramASN1ObjectIdentifier forKey:[paramString uppercaseString]];
    [[self names] setObject:paramString forKey:paramASN1ObjectIdentifier];
}

+ (X9ECParameters *)getByName:(NSString *)paramString {
    ASN1ObjectIdentifier *localASN1ObjectIdentifier = [self getOID:paramString];
    return localASN1ObjectIdentifier == nil ? nil : [self getByOID:localASN1ObjectIdentifier paramString:paramString];
}

+ (X9ECParameters *)getByOID:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString {
    return [SECNamedCurves getByOID:paramASN1ObjectIdentifier paramString:paramString];
}

+ (ASN1ObjectIdentifier *)getOID:(NSString *)paramString {
    return (ASN1ObjectIdentifier *)[[self objIds] objectForKey:[paramString uppercaseString]];
}

+ (NSString *)getName:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    return (NSString *)[[self names] objectForKey:paramASN1ObjectIdentifier];
}

+ (NSEnumerator *)getNames {
    return [[self names] objectEnumerator];
}

+ (void)load {
    [super load];
    [self defineCurveAlia:@"B-163" paramASN1ObjectIdentifier:[SECObjectIdentifiers sect163r2]];
    [self defineCurveAlia:@"B-233" paramASN1ObjectIdentifier:[SECObjectIdentifiers sect233r1]];
    [self defineCurveAlia:@"B-283" paramASN1ObjectIdentifier:[SECObjectIdentifiers sect283r1]];
    [self defineCurveAlia:@"B-409" paramASN1ObjectIdentifier:[SECObjectIdentifiers sect409r1]];
    [self defineCurveAlia:@"B-571" paramASN1ObjectIdentifier:[SECObjectIdentifiers sect571r1]];
    [self defineCurveAlia:@"K-163" paramASN1ObjectIdentifier:[SECObjectIdentifiers sect163k1]];
    [self defineCurveAlia:@"K-233" paramASN1ObjectIdentifier:[SECObjectIdentifiers sect233k1]];
    [self defineCurveAlia:@"K-283" paramASN1ObjectIdentifier:[SECObjectIdentifiers sect283k1]];
    [self defineCurveAlia:@"K-409" paramASN1ObjectIdentifier:[SECObjectIdentifiers sect409k1]];
    [self defineCurveAlia:@"K-571" paramASN1ObjectIdentifier:[SECObjectIdentifiers sect571k1]];
    [self defineCurveAlia:@"P-192" paramASN1ObjectIdentifier:[SECObjectIdentifiers secp192r1]];
    [self defineCurveAlia:@"P-224" paramASN1ObjectIdentifier:[SECObjectIdentifiers secp224r1]];
    [self defineCurveAlia:@"P-256" paramASN1ObjectIdentifier:[SECObjectIdentifiers secp256r1]];
    [self defineCurveAlia:@"P-384" paramASN1ObjectIdentifier:[SECObjectIdentifiers secp384r1]];
    [self defineCurveAlia:@"P-521" paramASN1ObjectIdentifier:[SECObjectIdentifiers secp521r1]];
}

@end
