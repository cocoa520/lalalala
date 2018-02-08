//
//  GOST3410NamedParameters.m
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "GOST3410NamedParameters.h"
#import "GOST3410ParamSetParameters.h"
#import "CryptoProObjectIdentifiers.h"

@implementation GOST3410NamedParameters

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

+ (GOST3410ParamSetParameters *)cryptoProA {
    static GOST3410ParamSetParameters *_cryptoProA = nil;
    @synchronized(self) {
        if (!_cryptoProA) {
            BigInteger *big1 = [[BigInteger alloc] initWithValue:@"127021248288932417465907042777176443525787653508916535812817507265705031260985098497423188333483401180925999995120988934130659205614996724254121049274349357074920312769561451689224110579311248812610229678534638401693520013288995000362260684222750813532307004517341633685004541062586971416883686778842537820383"];
            BigInteger *big2 = [[BigInteger alloc] initWithValue:@"68363196144955700784444165611827252895102170888761442055095051287550314083023"];
            BigInteger *big3 = [[BigInteger alloc] initWithValue:@"100997906755055304772081815535925224869841082572053457874823515875577147990529272777244152852699298796483356699682842027972896052747173175480590485607134746852141928680912561502802222185647539190902656116367847270145019066794290930185446216399730872221732889830323194097355403213400972588322876850946740663962"];
            _cryptoProA = [[GOST3410ParamSetParameters alloc] initParamInt:1024 paramBigInteger1:big1 paramBigInteger2:big2 paramBigInteger3:big3];
#if !__has_feature(objc_arc)
    if (big1) [big1 release]; big1 = nil;
    if (big2) [big2 release]; big2 = nil;
    if (big3) [big3 release]; big3 = nil;
#endif
        }
    }
    return _cryptoProA;
}

+ (GOST3410ParamSetParameters *)cryptoProB {
    static GOST3410ParamSetParameters *_cryptoProB = nil;
    @synchronized(self) {
        if (!_cryptoProB) {
            BigInteger *big1 = [[BigInteger alloc] initWithValue:@"139454871199115825601409655107690713107041707059928031797758001454375765357722984094124368522288239833039114681648076688236921220737322672160740747771700911134550432053804647694904686120113087816240740184800477047157336662926249423571248823968542221753660143391485680840520336859458494803187341288580489525163"];
            BigInteger *big2 = [[BigInteger alloc] initWithValue:@"79885141663410976897627118935756323747307951916507639758300472692338873533959"];
            BigInteger *big3 = [[BigInteger alloc] initWithValue:@"42941826148615804143873447737955502392672345968607143066798112994089471231420027060385216699563848719957657284814898909770759462613437669456364882730370838934791080835932647976778601915343474400961034231316672578686920482194932878633360203384797092684342247621055760235016132614780652761028509445403338652341"];
            _cryptoProB = [[GOST3410ParamSetParameters alloc] initParamInt:1024 paramBigInteger1:big1 paramBigInteger2:big2 paramBigInteger3:big3];
#if !__has_feature(objc_arc)
            if (big1) [big1 release]; big1 = nil;
            if (big2) [big2 release]; big2 = nil;
            if (big3) [big3 release]; big3 = nil;
#endif
        }
    }
    return _cryptoProB;
}

+ (GOST3410ParamSetParameters *)cryptoProXchA {
    static GOST3410ParamSetParameters *_cryptoProXchA = nil;
    @synchronized(self) {
        if (!_cryptoProXchA) {
            BigInteger *big1 = [[BigInteger alloc] initWithValue:@"142011741597563481196368286022318089743276138395243738762872573441927459393512718973631166078467600360848946623567625795282774719212241929071046134208380636394084512691828894000571524625445295769349356752728956831541775441763139384457191755096847107846595662547942312293338483924514339614727760681880609734239"];
            BigInteger *big2 = [[BigInteger alloc] initWithValue:@"91771529896554605945588149018382750217296858393520724172743325725474374979801"];
            BigInteger *big3 = [[BigInteger alloc] initWithValue:@"133531813272720673433859519948319001217942375967847486899482359599369642528734712461590403327731821410328012529253871914788598993103310567744136196364803064721377826656898686468463277710150809401182608770201615324990468332931294920912776241137878030224355746606283971659376426832674269780880061631528163475887"];
            _cryptoProXchA = [[GOST3410ParamSetParameters alloc] initParamInt:1024 paramBigInteger1:big1 paramBigInteger2:big2 paramBigInteger3:big3];
#if !__has_feature(objc_arc)
            if (big1) [big1 release]; big1 = nil;
            if (big2) [big2 release]; big2 = nil;
            if (big3) [big3 release]; big3 = nil;
#endif
        }
    }
    return _cryptoProXchA;
}

+ (GOST3410NamedParameters *)getByOID:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    return (GOST3410NamedParameters *)[[self params] objectForKey:paramASN1ObjectIdentifier];
}

+ (NSEnumerator *)getNames {
    return [[self objIds] keyEnumerator];
}

+ (GOST3410NamedParameters *)getByName:(NSString *)paramString {
    ASN1ObjectIdentifier *localASN1ObjectIdentifier = (ASN1ObjectIdentifier *)[[self objIds] objectForKey:paramString];
    if (localASN1ObjectIdentifier) {
        return (GOST3410NamedParameters *)[[self params] objectForKey:localASN1ObjectIdentifier];
    }
    return nil;
}

+ (ASN1ObjectIdentifier *)getOID:(NSString *)paramString {
    return (ASN1ObjectIdentifier *)[[self objIds] objectForKey:paramString];
}

+ (void)load {
    [super load];
    [[self params] setObject:[GOST3410NamedParameters cryptoProA] forKey:[CryptoProObjectIdentifiers gostR3410_94_CryptoPro_A]];
    [[self params] setObject:[GOST3410NamedParameters cryptoProB] forKey:[CryptoProObjectIdentifiers gostR3410_94_CryptoPro_B]];
    [[self params] setObject:[GOST3410NamedParameters cryptoProXchA] forKey:[CryptoProObjectIdentifiers gostR3410_94_CryptoPro_XchA]];
    [[self objIds] setObject:[CryptoProObjectIdentifiers gostR3410_94_CryptoPro_A] forKey:@"GostR3410-94-CryptoPro-A"];
    [[self objIds] setObject:[CryptoProObjectIdentifiers gostR3410_94_CryptoPro_B] forKey:@"GostR3410-94-CryptoPro-B"];
    [[self objIds] setObject:[CryptoProObjectIdentifiers gostR3410_94_CryptoPro_XchA] forKey:@"GostR3410-94-CryptoPro-XchA"];
}

@end
