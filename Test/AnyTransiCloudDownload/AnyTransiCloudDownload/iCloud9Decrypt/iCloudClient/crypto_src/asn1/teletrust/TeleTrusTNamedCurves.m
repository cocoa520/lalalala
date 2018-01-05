//
//  TeleTrusTNamedCurves.m
//  crypto
//
//  Created by JGehry on 6/16/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "TeleTrusTNamedCurves.h"
#import "TeleTrusTObjectIdentifiers.h"

@implementation TeleTrusTNamedCurves

+ (X9ECParametersHolder *)brainpoolP160r1 {
    static X9ECParametersHolder *_brainpoolP160r1 = nil;
    @synchronized(self) {
        if (!_brainpoolP160r1) {
            _brainpoolP160r1 = [[X9ECParametersHolder alloc] init];
        }
    }
    return _brainpoolP160r1;
}

+ (X9ECParametersHolder *)brainpoolP160t1 {
    static X9ECParametersHolder *_brainpoolP160t1 = nil;
    @synchronized(self) {
        if (!_brainpoolP160t1) {
            _brainpoolP160t1 = [[X9ECParametersHolder alloc] init];
        }
    }
    return _brainpoolP160t1;
}

+ (X9ECParametersHolder *)brainpoolP192r1 {
    static X9ECParametersHolder *_brainpoolP192r1 = nil;
    @synchronized(self) {
        if (!_brainpoolP192r1) {
            _brainpoolP192r1 = [[X9ECParametersHolder alloc] init];
        }
    }
    return _brainpoolP192r1;
}

+ (X9ECParametersHolder *)brainpoolP192t1 {
    static X9ECParametersHolder *_brainpoolP192t1 = nil;
    @synchronized(self) {
        if (!_brainpoolP192t1) {
            _brainpoolP192t1 = [[X9ECParametersHolder alloc] init];
        }
    }
    return _brainpoolP192t1;
}

+ (X9ECParametersHolder *)brainpoolP224r1 {
    static X9ECParametersHolder *_brainpoolP224r1 = nil;
    @synchronized(self) {
        if (!_brainpoolP224r1) {
            _brainpoolP224r1 = [[X9ECParametersHolder alloc] init];
        }
    }
    return _brainpoolP224r1;
}

+ (X9ECParametersHolder *)brainpoolP224t1 {
    static X9ECParametersHolder *_brainpoolP224t1 = nil;
    @synchronized(self) {
        if (!_brainpoolP224t1) {
            _brainpoolP224t1 = [[X9ECParametersHolder alloc] init];
        }
    }
    return _brainpoolP224t1;
}

+ (X9ECParametersHolder *)brainpoolP256r1 {
    static X9ECParametersHolder *_brainpoolP256r1 = nil;
    @synchronized(self) {
        if (!_brainpoolP256r1) {
            _brainpoolP256r1 = [[X9ECParametersHolder alloc] init];
        }
    }
    return _brainpoolP256r1;
}

+ (X9ECParametersHolder *)brainpoolP256t1 {
    static X9ECParametersHolder *_brainpoolP256t1 = nil;
    @synchronized(self) {
        if (!_brainpoolP256t1) {
            _brainpoolP256t1 = [[X9ECParametersHolder alloc] init];
        }
    }
    return _brainpoolP256t1;
}

+ (X9ECParametersHolder *)brainpoolP320r1 {
    static X9ECParametersHolder *_brainpoolP320r1 = nil;
    @synchronized(self) {
        if (!_brainpoolP320r1) {
            _brainpoolP320r1 = [[X9ECParametersHolder alloc] init];
        }
    }
    return _brainpoolP320r1;
}

+ (X9ECParametersHolder *)brainpoolP320t1 {
    static X9ECParametersHolder *_brainpoolP320t1 = nil;
    @synchronized(self) {
        if (!_brainpoolP320t1) {
            _brainpoolP320t1 = [[X9ECParametersHolder alloc] init];
        }
    }
    return _brainpoolP320t1;
}

+ (X9ECParametersHolder *)brainpoolP384r1 {
    static X9ECParametersHolder *_brainpoolP384r1 = nil;
    @synchronized(self) {
        if (!_brainpoolP384r1) {
            _brainpoolP384r1 = [[X9ECParametersHolder alloc] init];
        }
    }
    return _brainpoolP384r1;
}

+ (X9ECParametersHolder *)brainpoolP384t1 {
    static X9ECParametersHolder *_brainpoolP384t1 = nil;
    @synchronized(self) {
        if (!_brainpoolP384t1) {
            _brainpoolP384t1 = [[X9ECParametersHolder alloc] init];
        }
    }
    return _brainpoolP384t1;
}

+ (X9ECParametersHolder *)brainpoolP512r1 {
    static X9ECParametersHolder *_brainpoolP512r1 = nil;
    @synchronized(self) {
        if (!_brainpoolP512r1) {
            _brainpoolP512r1 = [[X9ECParametersHolder alloc] init];
        }
    }
    return _brainpoolP512r1;
}

+ (X9ECParametersHolder *)brainpoolP512t1 {
    static X9ECParametersHolder *_brainpoolP512t1 = nil;
    @synchronized(self) {
        if (!_brainpoolP512t1) {
            _brainpoolP512t1 = [[X9ECParametersHolder alloc] init];
        }
    }
    return _brainpoolP512t1;
}

+ (NSMutableDictionary *)objIds {
    static NSMutableDictionary *_objIds = nil;
    @synchronized(self) {
        if (!_objIds) {
            _objIds = [[NSMutableDictionary alloc] init];
        }
    }
    return _objIds;
}

+ (NSMutableDictionary *)curves {
    static NSMutableDictionary *_curves = nil;
    @synchronized(self) {
        if (!_curves) {
            _curves = [[NSMutableDictionary alloc] init];
        }
    }
    return _curves;
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

+ (ECCurve *)configureCurve:(ECCurve *)paramECCurve {
    return paramECCurve;
}

+ (void)defineCurve:(NSString *)paramString paramASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramX9ECParametersHolder:(X9ECParametersHolder *)paramX9ECParametersHolder {
    [[self objIds] setObject:paramASN1ObjectIdentifier forKey:[paramString lowercaseString]];
    [[self names] setObject:paramString forKey:paramASN1ObjectIdentifier];
    [[self curves] setObject:paramX9ECParametersHolder forKey:paramASN1ObjectIdentifier];
}

+ (X9ECParameters *)getByName:(NSString *)paramString {
    ASN1ObjectIdentifier *localASN1ObjectIdentifier = [self getOID:paramString];
    return (localASN1ObjectIdentifier == nil ? nil : [self getByOID:localASN1ObjectIdentifier paramString:paramString]);
}

+ (X9ECParameters *)getByOID:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString {
    X9ECParametersHolder *localX9ECParametersHolder = (X9ECParametersHolder *)[[self curves] objectForKey:paramASN1ObjectIdentifier];
    return (localX9ECParametersHolder == nil ? nil : [localX9ECParametersHolder getParameters:paramString]);
}

+ (ASN1ObjectIdentifier *)getOID:(NSString *)paramString {
    return (ASN1ObjectIdentifier *)[[self objIds] objectForKey:paramString.lowercaseString];
}

+ (NSString *)getName:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    return (NSString *)[[self names] objectForKey:paramASN1ObjectIdentifier];
}

+ (NSEnumerator *)getNames {
    return [[self names] objectEnumerator];
}

+ (ASN1ObjectIdentifier *)getOID:(short)paramShort paramBoolean:(BOOL)paramBoolean {
    return [self getOID:[NSString stringWithFormat:@"brainpoolP%i%@1", paramShort, (paramBoolean ? @"t" : @"r")]];
}

+ (void)load {
    [self defineCurve:@"brainpoolP160r1" paramASN1ObjectIdentifier:[TeleTrusTObjectIdentifiers brainpoolP160r1] paramX9ECParametersHolder:[self brainpoolP160r1]];
    [self defineCurve:@"brainpoolP160t1" paramASN1ObjectIdentifier:[TeleTrusTObjectIdentifiers brainpoolP160t1] paramX9ECParametersHolder:[self brainpoolP160t1]];
    [self defineCurve:@"brainpoolP192r1" paramASN1ObjectIdentifier:[TeleTrusTObjectIdentifiers brainpoolP192r1] paramX9ECParametersHolder:[self brainpoolP192r1]];
    [self defineCurve:@"brainpoolP192t1" paramASN1ObjectIdentifier:[TeleTrusTObjectIdentifiers brainpoolP192t1] paramX9ECParametersHolder:[self brainpoolP192t1]];
    [self defineCurve:@"brainpoolP224r1" paramASN1ObjectIdentifier:[TeleTrusTObjectIdentifiers brainpoolP224r1] paramX9ECParametersHolder:[self brainpoolP224r1]];
    [self defineCurve:@"brainpoolP224t1" paramASN1ObjectIdentifier:[TeleTrusTObjectIdentifiers brainpoolP224t1] paramX9ECParametersHolder:[self brainpoolP224t1]];
    [self defineCurve:@"brainpoolP256r1" paramASN1ObjectIdentifier:[TeleTrusTObjectIdentifiers brainpoolP256r1] paramX9ECParametersHolder:[self brainpoolP256r1]];
    [self defineCurve:@"brainpoolP256t1" paramASN1ObjectIdentifier:[TeleTrusTObjectIdentifiers brainpoolP256t1] paramX9ECParametersHolder:[self brainpoolP256t1]];
    [self defineCurve:@"brainpoolP320r1" paramASN1ObjectIdentifier:[TeleTrusTObjectIdentifiers brainpoolP320r1] paramX9ECParametersHolder:[self brainpoolP320r1]];
    [self defineCurve:@"brainpoolP320t1" paramASN1ObjectIdentifier:[TeleTrusTObjectIdentifiers brainpoolP320t1] paramX9ECParametersHolder:[self brainpoolP320t1]];
    [self defineCurve:@"brainpoolP384r1" paramASN1ObjectIdentifier:[TeleTrusTObjectIdentifiers brainpoolP384r1] paramX9ECParametersHolder:[self brainpoolP384r1]];
    [self defineCurve:@"brainpoolP384t1" paramASN1ObjectIdentifier:[TeleTrusTObjectIdentifiers brainpoolP384t1] paramX9ECParametersHolder:[self brainpoolP384t1]];
    [self defineCurve:@"brainpoolP512r1" paramASN1ObjectIdentifier:[TeleTrusTObjectIdentifiers brainpoolP512r1] paramX9ECParametersHolder:[self brainpoolP512r1]];
    [self defineCurve:@"brainpoolP512t1" paramASN1ObjectIdentifier:[TeleTrusTObjectIdentifiers brainpoolP512t1] paramX9ECParametersHolder:[self brainpoolP512t1]];
}

@end
