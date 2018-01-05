//
//  ECGOST3410NamedCurves.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ECGOST3410NamedCurves.h"
#import "BigInteger.h"
#import "ECCurve.h"
#import "CryptoProObjectIdentifiers.h"
#import "ECDomainParameters.h"

@implementation ECGOST3410NamedCurves

+ (NSMutableDictionary *)objIds {
    static NSMutableDictionary *_objIds = nil;
    @synchronized(self) {
        if (!_objIds) {
            _objIds = [[NSMutableDictionary alloc] init];
        }
    }
    return _objIds;
}

+ (NSMutableDictionary *)params {
    static NSMutableDictionary *_params = nil;
    @synchronized(self) {
        if (!_params) {
            _params = [[NSMutableDictionary alloc] init];
        }
    }
    return _params;
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

+ (NSEnumerator *)getNames {
    return [[self names] objectEnumerator];
}

+ (NSString *)getName:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    return (NSString *)[[self names] objectForKey:paramASN1ObjectIdentifier];
}

+ (ASN1ObjectIdentifier *)getOID:(NSString *)paramString {
    return (ASN1ObjectIdentifier *)[[self objIds] objectForKey:paramString];
}

+ (void)load {
    [super load];
    BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"115792089237316195423570985008687907853269984665640564039457584007913129639319"];
    BigInteger *localBigInteger2 = [[BigInteger alloc] initWithValue:@"115792089237316195423570985008687907853073762908499243225378155805079068850323"];
    BigInteger *big1 = [[BigInteger alloc] initWithValue:@"115792089237316195423570985008687907853269984665640564039457584007913129639316"];
    BigInteger *big2 = [[BigInteger alloc] initWithValue:@"166"];
    FpCurve *localFp = [[FpCurve alloc] initWithQ:localBigInteger1 withA:big1 withB:big2 withOrder:localBigInteger2 withCofactor:[BigInteger One]];
    BigInteger *big3 = [[BigInteger alloc] initWithValue:@"1"];
    BigInteger *big4 = [[BigInteger alloc] initWithValue:@"64033881142927202683649881450433473985931760268884941288852745803908878638612"];
    ECDomainParameters *localECDomainParameters = [[ECDomainParameters alloc] initWithCurve:localFp withG:[localFp createPoint:big3 withY:big4] withN:localBigInteger2];
    [[self params] setObject:localECDomainParameters forKey:[CryptoProObjectIdentifiers gostR3410_2001_CryptoPro_A]];
#if !__has_feature(objc_arc)
    if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
    if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
    if (localFp) [localFp release]; localFp = nil;
    if (localECDomainParameters) [localECDomainParameters release]; localECDomainParameters = nil;
#endif
    
    localBigInteger1 = [[BigInteger alloc] initWithValue:@"115792089237316195423570985008687907853269984665640564039457584007913129639319"];
    localBigInteger2 = [[BigInteger alloc] initWithValue:@"115792089237316195423570985008687907853073762908499243225378155805079068850323"];
    BigInteger *big5 = [[BigInteger alloc] initWithValue:@"115792089237316195423570985008687907853269984665640564039457584007913129639316"];
    BigInteger *big6 = [[BigInteger alloc] initWithValue:@"166"];
    localFp = [[FpCurve alloc] initWithQ:localBigInteger1 withA:big5 withB:big6 withOrder:localBigInteger2 withCofactor:[BigInteger One]];
    BigInteger *big7 = [[BigInteger alloc] initWithValue:@"1"];
    BigInteger *big8 = [[BigInteger alloc] initWithValue:@"64033881142927202683649881450433473985931760268884941288852745803908878638612"];
    localECDomainParameters = [[ECDomainParameters alloc] initWithCurve:localFp withG:[localFp createPoint:big7 withY:big8] withN:localBigInteger2];
    [[self params] setObject:localECDomainParameters forKey:[CryptoProObjectIdentifiers gostR3410_2001_CryptoPro_XchA]];
#if !__has_feature(objc_arc)
    if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
    if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
    if (localFp) [localFp release]; localFp = nil;
    if (localECDomainParameters) [localECDomainParameters release]; localECDomainParameters = nil;
#endif
    
    localBigInteger1 = [[BigInteger alloc] initWithValue:@"57896044618658097711785492504343953926634992332820282019728792003956564823193"];
    localBigInteger2 = [[BigInteger alloc] initWithValue:@"57896044618658097711785492504343953927102133160255826820068844496087732066703"];
    BigInteger *big9 = [[BigInteger alloc] initWithValue:@"57896044618658097711785492504343953926634992332820282019728792003956564823190"];
    BigInteger *big10 = [[BigInteger alloc] initWithValue:@"28091019353058090096996979000309560759124368558014865957655842872397301267595"];
    localFp = [[FpCurve alloc] initWithQ:localBigInteger1 withA:big9 withB:big10 withOrder:localBigInteger2 withCofactor:[BigInteger One]];
    BigInteger *big11 = [[BigInteger alloc] initWithValue:@"1"];
    BigInteger *big12 = [[BigInteger alloc] initWithValue:@"28792665814854611296992347458380284135028636778229113005756334730996303888124"];
    localECDomainParameters = [[ECDomainParameters alloc] initWithCurve:localFp withG:[localFp createPoint:big11 withY:big12] withN:localBigInteger2];
    [[self params] setObject:localECDomainParameters forKey:[CryptoProObjectIdentifiers gostR3410_2001_CryptoPro_B]];
#if !__has_feature(objc_arc)
    if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
    if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
    if (localFp) [localFp release]; localFp = nil;
    if (localECDomainParameters) [localECDomainParameters release]; localECDomainParameters = nil;
#endif

    localBigInteger1 = [[BigInteger alloc] initWithValue:@"70390085352083305199547718019018437841079516630045180471284346843705633502619"];
    localBigInteger2 = [[BigInteger alloc] initWithValue:@"70390085352083305199547718019018437840920882647164081035322601458352298396601"];
    BigInteger *big13 = [[BigInteger alloc] initWithValue:@"70390085352083305199547718019018437841079516630045180471284346843705633502616"];
    BigInteger *big14 = [[BigInteger alloc] initWithValue:@"32858"];
    localFp = [[FpCurve alloc] initWithQ:localBigInteger1 withA:big13 withB:big14 withOrder:localBigInteger2 withCofactor:[BigInteger One]];
    BigInteger *big15 = [[BigInteger alloc] initWithValue:@"0"];
    BigInteger *big16 = [[BigInteger alloc] initWithValue:@"29818893917731240733471273240314769927240550812383695689146495261604565990247"];
    localECDomainParameters = [[ECDomainParameters alloc] initWithCurve:localFp withG:[localFp createPoint:big15 withY:big16] withN:localBigInteger2];
    [[self params] setObject:localECDomainParameters forKey:[CryptoProObjectIdentifiers gostR3410_2001_CryptoPro_XchB]];
#if !__has_feature(objc_arc)
    if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
    if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
    if (localFp) [localFp release]; localFp = nil;
    if (localECDomainParameters) [localECDomainParameters release]; localECDomainParameters = nil;
#endif

    localBigInteger1 = [[BigInteger alloc] initWithValue:@"70390085352083305199547718019018437841079516630045180471284346843705633502619"];
    localBigInteger2 = [[BigInteger alloc] initWithValue:@"70390085352083305199547718019018437840920882647164081035322601458352298396601"];
    BigInteger *big17 = [[BigInteger alloc] initWithValue:@"70390085352083305199547718019018437841079516630045180471284346843705633502616"];
    BigInteger *big18 = [[BigInteger alloc] initWithValue:@"32858"];
    localFp = [[FpCurve alloc] initWithQ:localBigInteger1 withA:big17 withB:big18 withOrder:localBigInteger2 withCofactor:[BigInteger One]];
    BigInteger *big19 = [[BigInteger alloc] initWithValue:@"0"];
    BigInteger *big20 = [[BigInteger alloc] initWithValue:@"29818893917731240733471273240314769927240550812383695689146495261604565990247"];
    localECDomainParameters = [[ECDomainParameters alloc] initWithCurve:localFp withG:[localFp createPoint:big19 withY:big20] withN:localBigInteger2];
    [[self params] setObject:localECDomainParameters forKey:[CryptoProObjectIdentifiers gostR3410_2001_CryptoPro_C]];
#if !__has_feature(objc_arc)
    if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
    if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
    if (localFp) [localFp release]; localFp = nil;
    if (localECDomainParameters) [localECDomainParameters release]; localECDomainParameters = nil;
#endif

    [[self objIds] setObject:[CryptoProObjectIdentifiers gostR3410_2001_CryptoPro_A] forKey:@"GostR3410-2001-CryptoPro-A"];
    [[self objIds] setObject:[CryptoProObjectIdentifiers gostR3410_2001_CryptoPro_B] forKey:@"GostR3410-2001-CryptoPro-B"];
    [[self objIds] setObject:[CryptoProObjectIdentifiers gostR3410_2001_CryptoPro_C] forKey:@"GostR3410-2001-CryptoPro-C"];
    [[self objIds] setObject:[CryptoProObjectIdentifiers gostR3410_2001_CryptoPro_XchA] forKey:@"GostR3410-2001-CryptoPro-XchA"];
    [[self objIds] setObject:[CryptoProObjectIdentifiers gostR3410_2001_CryptoPro_XchB] forKey:@"GostR3410-2001-CryptoPro-XchB"];
    [[self names] setObject:@"GostR3410-2001-CryptoPro-A" forKey:[CryptoProObjectIdentifiers gostR3410_2001_CryptoPro_A]];
    [[self names] setObject:@"GostR3410-2001-CryptoPro-B" forKey:[CryptoProObjectIdentifiers gostR3410_2001_CryptoPro_B]];
    [[self names] setObject:@"GostR3410-2001-CryptoPro-C" forKey:[CryptoProObjectIdentifiers gostR3410_2001_CryptoPro_C]];
    [[self names] setObject:@"GostR3410-2001-CryptoPro-XchA" forKey:[CryptoProObjectIdentifiers gostR3410_2001_CryptoPro_XchA]];
    [[self names] setObject:@"GostR3410-2001-CryptoPro-XchB" forKey:[CryptoProObjectIdentifiers gostR3410_2001_CryptoPro_XchB]];
#if !__has_feature(objc_arc)
    if (big1) [big1 release]; big1 = nil;
    if (big2) [big2 release]; big2 = nil;
    if (big3) [big3 release]; big3 = nil;
    if (big4) [big4 release]; big4 = nil;
    if (big5) [big5 release]; big5 = nil;
    if (big6) [big6 release]; big6 = nil;
    if (big7) [big7 release]; big7 = nil;
    if (big8) [big8 release]; big8 = nil;
    if (big9) [big9 release]; big9 = nil;
    if (big10) [big10 release]; big10 = nil;
    if (big11) [big11 release]; big11 = nil;
    if (big12) [big12 release]; big12 = nil;
    if (big13) [big13 release]; big13 = nil;
    if (big14) [big14 release]; big14 = nil;
    if (big15) [big15 release]; big15 = nil;
    if (big16) [big16 release]; big16 = nil;
    if (big17) [big17 release]; big17 = nil;
    if (big18) [big18 release]; big18 = nil;
    if (big19) [big19 release]; big19 = nil;
    if (big20) [big20 release]; big20 = nil;
#endif
}

@end
