//
//  ANSSINamedCurves.m
//  crypto
//
//  Created by JGehry on 6/2/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ANSSINamedCurves.h"
#import "X9ECParametersHolder.h"
#import "Strings.h"
#import "ECCurve.h"
#import "Hex.h"
#import "ANSSIObjectIdentifiers.h"

@implementation ANSSINamedCurves

+ (X9ECParametersHolder *)FRP256v1 {
    static X9ECParametersHolder *_FRP256v1 = nil;
    @synchronized(self) {
        if (!_FRP256v1) {
            _FRP256v1 = [[X9ECParametersHolder alloc] init];
        }
    }
    return _FRP256v1;
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

+ (BigInteger *)fromHex:(NSString *)paramString {
    BigInteger *retVal = nil;
    @autoreleasepool {
        NSData *data = [Hex decodeWithString:paramString];
        retVal = [[BigInteger alloc] initWithSign:1 withBytes:data];
    }
    return (retVal ? [retVal autorelease] : nil);
}

+ (void)defineCurve:(NSString *)paramString paramASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramX9ECParametersHolder:(X9ECParametersHolder *)paramX9ECParametersHolder {
    
    [[self objIds] setObject:paramASN1ObjectIdentifier forKey:paramString.lowercaseString];
    [[self names] setObject:paramString forKey:paramASN1ObjectIdentifier];
    [[self curves] setObject:paramX9ECParametersHolder forKey:paramASN1ObjectIdentifier];
}

+ (X9ECParameters *)getByName:(NSString *)paramString {
    ASN1ObjectIdentifier *localASN1ObjectIdentifier = [self getOID:paramString];
    return localASN1ObjectIdentifier == nil ? nil : [self getByOID:localASN1ObjectIdentifier paramString:paramString];
}

+ (X9ECParameters *)getByOID:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString {
    X9ECParametersHolder *localX9ECParametersHolder = (X9ECParametersHolder *)[[self curves] objectForKey:paramASN1ObjectIdentifier];
    return localX9ECParametersHolder == nil ? nil : [localX9ECParametersHolder getParameters:paramString];
}

+ (ASN1ObjectIdentifier *)getOID:(NSString *)paramString {
    return (ASN1ObjectIdentifier *)[[self objIds] objectForKey:[paramString lowercaseString]];
}

+ (NSString *)getName:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    return (NSString *)[[self names] objectForKey:paramASN1ObjectIdentifier];
}

+ (NSEnumerator *)getNames {
    return [[self names] objectEnumerator];
}

+ (void)load {
    [super load];
    [self defineCurve:@"FRP256v1" paramASN1ObjectIdentifier:[ANSSIObjectIdentifiers FRP256v1] paramX9ECParametersHolder:[self FRP256v1]];
}

@end
