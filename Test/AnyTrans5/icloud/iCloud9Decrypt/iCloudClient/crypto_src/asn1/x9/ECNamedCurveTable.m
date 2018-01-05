//
//  ECNamedCurveTable.m
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ECNamedCurveTable.h"
#import "X962NamedCurves.h"
#import "SECNamedCurves.h"
#import "NISTNamedCurves.h"
#import "TeleTrusTNamedCurves.h"
#import "ANSSINamedCurves.h"
#import "ECGOST3410NamedCurves.h"

@implementation ECNamedCurveTable

+ (X9ECParameters *)getByName:(NSString *)paramString {
    X9ECParameters *localX9ECParameters = [X962NamedCurves getByName:paramString];
    if (!localX9ECParameters) {
        localX9ECParameters = [SECNamedCurves getByName:paramString];
    }
    if (!localX9ECParameters) {
        localX9ECParameters = [NISTNamedCurves getByName:paramString];
    }
    if (!localX9ECParameters) {
        localX9ECParameters = [TeleTrusTNamedCurves getByName:paramString];
    }
    if (!localX9ECParameters) {
        localX9ECParameters = [ANSSINamedCurves getByName:paramString];
    }
    return localX9ECParameters;
}

+ (ASN1ObjectIdentifier *)getOID:(NSString *)paramString {
    ASN1ObjectIdentifier *localASN1ObjectIdentifier = [X962NamedCurves getOID:paramString];
    if (!localASN1ObjectIdentifier) {
        localASN1ObjectIdentifier = [SECNamedCurves getOID:paramString];
    }
    if (!localASN1ObjectIdentifier) {
        localASN1ObjectIdentifier = [NISTNamedCurves getOID:paramString];
    }
    if (!localASN1ObjectIdentifier) {
        localASN1ObjectIdentifier = [TeleTrusTNamedCurves getOID:paramString];
    }
    if (!localASN1ObjectIdentifier) {
        localASN1ObjectIdentifier = [ANSSINamedCurves getOID:paramString];
    }
    return localASN1ObjectIdentifier;
}

+ (NSString *)getName:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    NSString *str = [NISTNamedCurves getName:paramASN1ObjectIdentifier];
    if (!str) {
        str = [SECNamedCurves getName:paramASN1ObjectIdentifier];
    }
    if (!str) {
        str = [TeleTrusTNamedCurves getName:paramASN1ObjectIdentifier];
    }
    if (!str) {
        str = [X962NamedCurves getName:paramASN1ObjectIdentifier];
    }
    if (!str) {
        str = [ECGOST3410NamedCurves getName:paramASN1ObjectIdentifier];
    }
    return str;
}

+ (X9ECParameters *)getByOID:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    X9ECParameters *localX9ECParameters = [X962NamedCurves getByOID:paramASN1ObjectIdentifier paramString:paramASN1ObjectIdentifier.identifier];
    if (!localX9ECParameters) {
        localX9ECParameters = [SECNamedCurves getByOID:paramASN1ObjectIdentifier paramString:paramASN1ObjectIdentifier.identifier];
    }
    if (!localX9ECParameters) {
        localX9ECParameters = [TeleTrusTNamedCurves getByOID:paramASN1ObjectIdentifier paramString:paramASN1ObjectIdentifier.identifier];
    }
    if (!localX9ECParameters) {
        localX9ECParameters = [ANSSINamedCurves getByOID:paramASN1ObjectIdentifier paramString:paramASN1ObjectIdentifier.identifier];
    }
    return localX9ECParameters;
}

+ (NSEnumerator *)getNames {
    NSMutableArray *localVector = [[[NSMutableArray alloc] init] autorelease];
    [self addEnumeration:localVector paramEnumeration:[X962NamedCurves getNames]];
    [self addEnumeration:localVector paramEnumeration:[SECNamedCurves getNames]];
    [self addEnumeration:localVector paramEnumeration:[NISTNamedCurves getNames]];
    [self addEnumeration:localVector paramEnumeration:[TeleTrusTNamedCurves getNames]];
    [self addEnumeration:localVector paramEnumeration:[ANSSINamedCurves getNames]];
    return [localVector objectEnumerator];
}

+ (void)addEnumeration:(NSMutableArray *)paramVector paramEnumeration:(NSEnumerator *)paramEnumeration {
    id localObject = nil;
    while (localObject = [paramEnumeration nextObject]) {
        [paramVector addObject:localObject];
    }
}

@end
