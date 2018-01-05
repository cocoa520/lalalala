//
//  X9ECParametersHolder.m
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X9ECParametersHolder.h"
#import "Hex.h"
#import "ANSSINamedCurves.h"
#import "SECNamedCurves.h"
#import "TeleTrusTNamedCurves.h"
#import "GlvTypeBParameters.h"

@interface X9ECParametersHolder ()

@property (nonatomic, readwrite, retain) X9ECParameters *params;

@end

@implementation X9ECParametersHolder
@synthesize params = _params;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_params) {
        [_params release];
        _params = nil;
    }
    [super dealloc];
#endif
}

- (X9ECParameters *)getParameters:(NSString *)string {
    @synchronized(self) {
        if (!self.params) {
            @autoreleasepool {
                self.params = [self createParameters:string];
            }
//            X9ECParameters *x9ECP = [self createParameters:string];
//            self.params = x9ECP;
//#if !__has_feature(objc_arc)
//    if (x9ECP) [x9ECP release]; x9ECP = nil;
//#endif
        }
        return self.params;
    }
}

- (X9ECParameters *)createParameters:(NSString *)str {
    if ([@"prime192v1" isEqualToString:str]) {
        return [self createParametersPrime192v1];
    }else if ([@"prime192v2" isEqualToString:str]) {
        return [self createParametersPrime192v2];
    }else if ([@"prime192v3" isEqualToString:str]) {
        return [self createParametersPrime192v3];
    }else if ([@"prime239v1" isEqualToString:str]) {
        return [self createParametersPrime239v1];
    }else if ([@"prime239v2" isEqualToString:str]) {
        return [self createParametersPrime239v2];
    }else if ([@"prime239v3" isEqualToString:str]) {
        return [self createParametersPrime239v3];
    }else if ([@"prime256v1" isEqualToString:str]) {
        return [self createParametersPrime256v1];
    }else if ([@"c2pnb163v1" isEqualToString:str]) {
        return [self createParametersC2pnb163v1];
    }else if ([@"c2pnb163v2" isEqualToString:str]) {
        return [self createParametersC2pnb163v2];
    }else if ([@"c2pnb163v3" isEqualToString:str]) {
        return [self createParametersC2pnb163v3];
    }else if ([@"c2pnb176w1" isEqualToString:str]) {
        return [self createParametersC2pnb176w1];
    }else if ([@"c2tnb191v1" isEqualToString:str]) {
        return [self createParametersC2tnb191v1];
    }else if ([@"c2tnb191v2" isEqualToString:str]) {
        return [self createParametersC2tnb191v2];
    }else if ([@"c2tnb191v3" isEqualToString:str]) {
        return [self createParametersC2tnb191v3];
    }else if ([@"c2pnb208w1" isEqualToString:str]) {
        return [self createParametersC2pnb208w1];
    }else if ([@"c2tnb239v1" isEqualToString:str]) {
        return [self createParametersC2tnb239v1];
    }else if ([@"c2tnb239v2" isEqualToString:str]) {
        return [self createParametersC2tnb239v2];
    }else if ([@"c2tnb239v3" isEqualToString:str]) {
        return [self createParametersC2tnb239v3];
    }else if ([@"c2pnb272w1" isEqualToString:str]) {
        return [self createParametersC2pnb272w1];
    }else if ([@"c2pnb304w1" isEqualToString:str]) {
        return [self createParametersC2pnb304w1];
    }else if ([@"c2tnb359v1" isEqualToString:str]) {
        return [self createParametersC2tnb359v1];
    }else if ([@"c2pnb368w1" isEqualToString:str]) {
        return [self createParametersC2pnb368w1];
    }else if ([@"c2tnb431r1" isEqualToString:str]) {
        return [self createParametersC2tnb431r1];
    }else if ([@"FRP256v1" isEqualToString:str]) {
        return [self createParametersFRP256v1];
    }else if ([@"secp112r1" isEqualToString:str]) {
        return [self createParametersSecp112r1];
    }else if ([@"secp112r2" isEqualToString:str]) {
        return [self createParametersSecp112r2];
    }else if ([@"secp128r1" isEqualToString:str]) {
        return [self createParametersSecp128r1];
    }else if ([@"secp128r2" isEqualToString:str]) {
        return [self createParametersSecp128r2];
    }else if ([@"secp160k1" isEqualToString:str]) {
        return [self createParametersSecp160k1];
    }else if ([@"secp160r1" isEqualToString:str]) {
        return [self createParametersSecp160r1];
    }else if ([@"secp160r2" isEqualToString:str]) {
        return [self createParametersSecp160r2];
    }else if ([@"secp192k1" isEqualToString:str]) {
        return [self createParametersSecp192k1];
    }else if ([@"secp192r1" isEqualToString:str]) {
        return [self createParametersSecp192r1];
    }else if ([@"secp224k1" isEqualToString:str]) {
        return [self createParametersSecp224k1];
    }else if ([@"secp224r1" isEqualToString:str]) {
        return [self createParametersSecp224r1];
    }else if ([@"secp256k1" isEqualToString:str]) {
        return [self createParametersSecp256k1];
    }else if ([@"secp256r1" isEqualToString:str]) {
        return [self createParametersSecp256r1];
    }else if ([@"secp384r1" isEqualToString:str]) {
        return [self createParametersSecp384r1];
    }else if ([@"secp521r1" isEqualToString:str]) {
        return [self createParametersSecp521r1];
    }else if ([@"sect113r1" isEqualToString:str]) {
        return [self createParametersSect113r1];
    }else if ([@"sect113r2" isEqualToString:str]) {
        return [self createParametersSect113r2];
    }else if ([@"sect131r1" isEqualToString:str]) {
        return [self createParametersSect131r1];
    }else if ([@"sect131r2" isEqualToString:str]) {
        return [self createParametersSect131r2];
    }else if ([@"sect163k1" isEqualToString:str]) {
        return [self createParametersSect163k1];
    }else if ([@"sect163r1" isEqualToString:str]) {
        return [self createParametersSect163r1];
    }else if ([@"sect163r2" isEqualToString:str]) {
        return [self createParametersSect163r2];
    }else if ([@"sect193r1" isEqualToString:str]) {
        return [self createParametersSect193r1];
    }else if ([@"sect193r2" isEqualToString:str]) {
        return [self createParametersSect193r2];
    }else if ([@"sect233k1" isEqualToString:str]) {
        return [self createParametersSect233k1];
    }else if ([@"sect233r1" isEqualToString:str]) {
        return [self createParametersSect233r1];
    }else if ([@"sect239k1" isEqualToString:str]) {
        return [self createParametersSect239k1];
    }else if ([@"sect283k1" isEqualToString:str]) {
        return [self createParametersSect283k1];
    }else if ([@"sect283r1" isEqualToString:str]) {
        return [self createParametersSect283r1];
    }else if ([@"sect409k1" isEqualToString:str]) {
        return [self createParametersSect409k1];
    }else if ([@"sect409r1" isEqualToString:str]) {
        return [self createParametersSect409r1];
    }else if ([@"sect571k1" isEqualToString:str]) {
        return [self createParametersSect571k1];
    }else if ([@"sect571r1" isEqualToString:str]) {
        return [self createParametersSect571r1];
    }else if ([@"brainpoolP160r1" isEqualToString:str]) {
        return [self createParametersBrainpoolP160r1];
    }else if ([@"brainpoolP160t1" isEqualToString:str]) {
        return [self createParametersBrainpoolP160t1];
    }else if ([@"brainpoolP192r1" isEqualToString:str]) {
        return [self createParametersBrainpoolP192r1];
    }else if ([@"brainpoolP192t1" isEqualToString:str]) {
        return [self createParametersBrainpoolP192t1];
    }else if ([@"brainpoolP224r1" isEqualToString:str]) {
        return [self createParametersBrainpoolP224r1];
    }else if ([@"brainpoolP224t1" isEqualToString:str]) {
        return [self createParametersBrainpoolP224t1];
    }else if ([@"brainpoolP256r1" isEqualToString:str]) {
        return [self createParametersBrainpoolP256r1];
    }else if ([@"brainpoolP256t1" isEqualToString:str]) {
        return [self createParametersBrainpoolP256t1];
    }else if ([@"brainpoolP320r1" isEqualToString:str]) {
        return [self createParametersBrainpoolP320r1];
    }else if ([@"brainpoolP320t1" isEqualToString:str]) {
        return [self createParametersBrainpoolP320t1];
    }else if ([@"brainpoolP384r1" isEqualToString:str]) {
        return [self createParametersBrainpoolP384r1];
    }else if ([@"brainpoolP384t1" isEqualToString:str]) {
        return [self createParametersBrainpoolP384t1];
    }else if ([@"brainpoolP512r1" isEqualToString:str]) {
        return [self createParametersBrainpoolP512r1];
    }else if ([@"brainpoolP512t1" isEqualToString:str]) {
        return [self createParametersBrainpoolP512t1];
    }
    return 0;
}

- (X9ECParameters *)createParametersPrime192v1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"ffffffffffffffffffffffff99def836146bc9b1b4d22831" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger One];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"6277101735386680763835789423207666416083908700390324961279"];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"fffffffffffffffffffffffffffffffefffffffffffffffc" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"64210519e59c80e70fa7e9ab72243049feb8deecc146b9b1" withRadix:16];
        FpCurve *localFp = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3  withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localFp paramArrayOfByte:[Hex decodeWithString:@"03188da80eb03090f67cbf20eb43a18800f4ff0afd82ff1012"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localFp ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:[Hex decodeWithString:@"3045AE6FC8422f64ED579528D38120EAE12196D5"]];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
        if (localFp) [localFp release]; localFp = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersPrime192v2 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"fffffffffffffffffffffffe5fb1a724dc80418648d8dd31" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger One];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"6277101735386680763835789423207666416083908700390324961279"];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"fffffffffffffffffffffffffffffffefffffffffffffffc" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"cc22d6dfb95c6b25e49c0d6364a4e5980c393aa21668d953" withRadix:16];
        FpCurve *localFp = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localFp paramArrayOfByte:[Hex decodeWithString:@"03eea2bae7e1497842f2de7769cfe9c989c072ad696f48034a"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localFp ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:[Hex decodeWithString:@"31a92ee2029fd10d901b113e990710f0d21ac6b6"]];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
        if (localFp) [localFp release]; localFp = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersPrime192v3 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"ffffffffffffffffffffffff7a62d031c83f4294f640ec13" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger One];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"6277101735386680763835789423207666416083908700390324961279"];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"fffffffffffffffffffffffffffffffefffffffffffffffc" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"22123dc2395a05caa7423daeccc94760a7d462256bd56916" withRadix:16];
        FpCurve *localFp = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localFp paramArrayOfByte:[Hex decodeWithString:@"027d29778100c65a1da1783716588dce2b8b4aee8e228f1896"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localFp ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:[Hex decodeWithString:@"c469684435deb378c4b65ca9591e2a5763059a2e"]];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
        if (localFp) [localFp release]; localFp = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersPrime239v1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"7fffffffffffffffffffffff7fffff9e5e9a9f5d9071fbd1522688909d0b" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger One];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"883423532389192164791648750360308885314476597252960362792450860609699839"];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"7fffffffffffffffffffffff7fffffffffff8000000000007ffffffffffc" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"6b016c3bdcf18941d0d654921475ca71a9db2fb27d1d37796185c2942c0a" withRadix:16];
        FpCurve *localFp = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localFp paramArrayOfByte:[Hex decodeWithString:@"020ffa963cdca8816ccc33b8642bedf905c3d358573d3f27fbbd3b3cb9aaaf"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localFp ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:[Hex decodeWithString:@"e43bb460f0b80cc0c0b075798e948060f8321b7d"]];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
        if (localFp) [localFp release]; localFp = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersPrime239v2 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"7fffffffffffffffffffffff800000cfa7e8594377d414c03821bc582063" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger One];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"883423532389192164791648750360308885314476597252960362792450860609699839"];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"7fffffffffffffffffffffff7fffffffffff8000000000007ffffffffffc" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"617fab6832576cbbfed50d99f0249c3fee58b94ba0038c7ae84c8c832f2c" withRadix:16];
        FpCurve *localFp = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localFp paramArrayOfByte:[Hex decodeWithString:@"0238af09d98727705120c921bb5e9e26296a3cdcf2f35757a0eafd87b830e7"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localFp ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:[Hex decodeWithString:@"e8b4011604095303ca3b8099982be09fcb9ae616"]];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
        if (localFp) [localFp release]; localFp = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersPrime239v3 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"7fffffffffffffffffffffff7fffff975deb41b3a6057c3c432146526551" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger One];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"883423532389192164791648750360308885314476597252960362792450860609699839"];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"7fffffffffffffffffffffff7fffffffffff8000000000007ffffffffffc" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"255705fa2a306654b1f4cb03d6a750a30c250102d4988717d9ba15ab6d3e" withRadix:16];
        FpCurve *localFp = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localFp paramArrayOfByte:[Hex decodeWithString:@"036768ae8e18bb92cfcf005c949aa2c6d94853d0e660bbf854b1c9505fe95a"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localFp ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:[Hex decodeWithString:@"7d7374168ffe3471b60a857686a19475d3bfa2ff"]];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
        if (localFp) [localFp release]; localFp = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersPrime256v1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"ffffffff00000000ffffffffffffffffbce6faada7179e84f3b9cac2fc632551" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger One];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"115792089210356248762697446949407573530086143415290314195533631308867097853951"];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"ffffffff00000001000000000000000000000000fffffffffffffffffffffffc" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b" withRadix:16];
        FpCurve *localFp = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localFp paramArrayOfByte:[Hex decodeWithString:@"036b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localFp ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:[Hex decodeWithString:@"c49d360886e704936a6678e1139d26b7819f7e90"]];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
        if (localFp) [localFp release]; localFp = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersC2pnb163v1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"0400000000000000000001E60FC8821CC74DAEAFC1" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger Two];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"072546B5435234A422E0789675F432C89435DE5242" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"00C9517D06D5240D3CFF38C74B20B6CD4D6F9DD4D9" withRadix:16];
        F2mCurve *localF2m = [[F2mCurve alloc] initWithM:163 withK1:1 withK2:2 withK3:8 withA:big1 withB:big2 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localF2m paramArrayOfByte:[Hex decodeWithString:@"0307AF69989546103D79329FCC3D74880F33BBE803CB"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localF2m ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:[Hex decodeWithString:@"D2C0FB15760860DEF1EEF4D696E6768756151754"]];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
        if (localF2m) [localF2m release]; localF2m = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersC2pnb163v2 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"03FFFFFFFFFFFFFFFFFFFDF64DE1151ADBB78F10A7" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger Two];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"0108B39E77C4B108BED981ED0E890E117C511CF072" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"0667ACEB38AF4E488C407433FFAE4F1C811638DF20" withRadix:16];
        F2mCurve *localF2m = [[F2mCurve alloc] initWithM:163 withK1:1 withK2:2 withK3:8 withA:big1 withB:big2 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localF2m paramArrayOfByte:[Hex decodeWithString:@"030024266E4EB5106D0A964D92C4860E2671DB9B6CC5"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localF2m ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:nil];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
        if (localF2m) [localF2m release]; localF2m = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersC2pnb163v3 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"03FFFFFFFFFFFFFFFFFFFE1AEE140F110AFF961309" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger Two];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"07A526C63D3E25A256A007699F5447E32AE456B50E" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"03F7061798EB99E238FD6F1BF95B48FEEB4854252B" withRadix:16];
        F2mCurve *localF2m = [[F2mCurve alloc] initWithM:163 withK1:1 withK2:2 withK3:8 withA:big1 withB:big2 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localF2m paramArrayOfByte:[Hex decodeWithString:@"0202F9F87B7C574D0BDECF8A22E6524775F98CDEBDCB"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localF2m ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:nil];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
        if (localF2m) [localF2m release]; localF2m = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersC2pnb176w1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"010092537397ECA4F6145799D62B0A19CE06FE26AD" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger valueOf:65390L];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"00E4E6DB2995065C407D9D39B8D0967B96704BA8E9C90B" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"005DDA470ABE6414DE8EC133AE28E9BBD7FCEC0AE0FFF2" withRadix:16];
        F2mCurve *localF2m = [[F2mCurve alloc] initWithM:176 withK1:1 withK2:2 withK3:43 withA:big1  withB:big2 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localF2m paramArrayOfByte:[Hex decodeWithString:@"038D16C2866798B600F9F08BB4A8E860F3298CE04A5798"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localF2m ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:nil];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
        if (localF2m) [localF2m release]; localF2m = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersC2tnb191v1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"40000000000000000000000004A20E90C39067C893BBB9A5" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger Two];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"401028774D7777C7B7666D1366EA432071274F89FF01E718" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"0620048D28BCBD03B6249C99182B7C8CD19700C362C46A01" withRadix:16];
        F2mCurve *localF2m = [[F2mCurve alloc] initWithM:191 withK:9 withA:big1 withB:big2 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localF2m paramArrayOfByte:[Hex decodeWithString:@"0236B3DAF8A23206F9C4F299D7B21A9C369137F2C84AE1AA0D"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localF2m ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:[Hex decodeWithString:@"4E13CA542744D696E67687561517552F279A8C84"]];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
        if (localF2m) [localF2m release]; localF2m = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersC2tnb191v2 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"20000000000000000000000050508CB89F652824E06B8173" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger Four];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"401028774D7777C7B7666D1366EA432071274F89FF01E718" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"0620048D28BCBD03B6249C99182B7C8CD19700C362C46A01" withRadix:16];
        F2mCurve *localF2m = [[F2mCurve alloc] initWithM:191 withK:9 withA:big1 withB:big2 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localF2m paramArrayOfByte:[Hex decodeWithString:@"023809B2B7CC1B28CC5A87926AAD83FD28789E81E2C9E3BF10"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localF2m ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:nil];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
        if (localF2m) [localF2m release]; localF2m = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersC2tnb191v3 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"155555555555555555555555610C0B196812BFB6288A3EA3" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger Six];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"6C01074756099122221056911C77D77E77A777E7E7E77FCB" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"71FE1AF926CF847989EFEF8DB459F66394D90F32AD3F15E8" withRadix:16];
        F2mCurve *localF2m = [[F2mCurve alloc] initWithM:191 withK:9 withA:big1 withB:big2 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localF2m paramArrayOfByte:[Hex decodeWithString:@"03375D4CE24FDE434489DE8746E71786015009E66E38A926DD"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localF2m ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:nil];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
        if (localF2m) [localF2m release]; localF2m = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersC2pnb208w1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"0101BAF95C9723C57B6C21DA2EFF2D5ED588BDD5717E212F9D" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger valueOf:65096L];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"0" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"00C8619ED45A62E6212E1160349E2BFA844439FAFC2A3FD1638F9E" withRadix:16];
        F2mCurve *localF2m = [[F2mCurve alloc] initWithM:208 withK1:1 withK2:2 withK3:83 withA:big1 withB:big2 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localF2m paramArrayOfByte:[Hex decodeWithString:@"0289FDFBE4ABE193DF9559ECF07AC0CE78554E2784EB8C1ED1A57A"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localF2m ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:nil];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
        if (localF2m) [localF2m release]; localF2m = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersC2tnb239v1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"2000000000000000000000000000000F4D42FFE1492A4993F1CAD666E447" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger Four];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"32010857077C5431123A46B808906756F543423E8D27877578125778AC76" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"790408F2EEDAF392B012EDEFB3392F30F4327C0CA3F31FC383C422AA8C16" withRadix:16];
        F2mCurve *localF2m = [[F2mCurve alloc] initWithM:239 withK:36 withA:big1 withB:big2 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localF2m paramArrayOfByte:[Hex decodeWithString:@"0257927098FA932E7C0A96D3FD5B706EF7E5F5C156E16B7E7C86038552E91D"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localF2m ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:nil];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
        if (localF2m) [localF2m release]; localF2m = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersC2tnb239v2 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"1555555555555555555555555555553C6F2885259C31E3FCDF154624522D" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger Six];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"4230017757A767FAE42398569B746325D45313AF0766266479B75654E65F" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"5037EA654196CFF0CD82B2C14A2FCF2E3FF8775285B545722F03EACDB74B" withRadix:16];
        F2mCurve *localF2m = [[F2mCurve alloc] initWithM:239 withK:36 withA:big1 withB:big2 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localF2m paramArrayOfByte:[Hex decodeWithString:@"0228F9D04E900069C8DC47A08534FE76D2B900B7D7EF31F5709F200C4CA205"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localF2m ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:nil];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
        if (localF2m) [localF2m release]; localF2m = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersC2tnb239v3 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"0CCCCCCCCCCCCCCCCCCCCCCCCCCCCCAC4912D2D9DF903EF9888B8A0E4CFF" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger Ten];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"01238774666A67766D6676F778E676B66999176666E687666D8766C66A9F" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"6A941977BA9F6A435199ACFC51067ED587F519C5ECB541B8E44111DE1D40" withRadix:16];
        F2mCurve *localF2m = [[F2mCurve alloc] initWithM:239 withK:36 withA:big1 withB:big2 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localF2m paramArrayOfByte:[Hex decodeWithString:@"0370F6E9D04D289C4E89913CE3530BFDE903977D42B146D539BF1BDE4E9C92"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localF2m ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:nil];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
        if (localF2m) [localF2m release]; localF2m = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersC2pnb272w1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"0100FAF51354E0E39E4892DF6E319C72C8161603FA45AA7B998A167B8F1E629521" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger valueOf:65286L];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"0091A091F03B5FBA4AB2CCF49C4EDD220FB028712D42BE752B2C40094DBACDB586FB20" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"7167EFC92BB2E3CE7C8AAAFF34E12A9C557003D7C73A6FAF003F99F6CC8482E540F7" withRadix:16];
        F2mCurve *localF2m = [[F2mCurve alloc] initWithM:272 withK1:1 withK2:3 withK3:56 withA:big1 withB:big2 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localF2m paramArrayOfByte:[Hex decodeWithString:@"026108BABB2CEEBCF787058A056CBE0CFE622D7723A289E08A07AE13EF0D10D171DD8D"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localF2m ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:nil];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
        if (localF2m) [localF2m release]; localF2m = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersC2pnb304w1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"0101D556572AABAC800101D556572AABAC8001022D5C91DD173F8FB561DA6899164443051D" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger valueOf:65070L];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"00FD0D693149A118F651E6DCE6802085377E5F882D1B510B44160074C1288078365A0396C8E681" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"00BDDB97E555A50A908E43B01C798EA5DAA6788F1EA2794EFCF57166B8C14039601E55827340BE" withRadix:16];
        F2mCurve *localF2m = [[F2mCurve alloc] initWithM:304 withK1:1 withK2:2 withK3:11 withA:big1 withB:big2 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localF2m paramArrayOfByte:[Hex decodeWithString:@"02197B07845E9BE2D96ADB0F5F3C7F2CFFBD7A3EB8B6FEC35C7FD67F26DDF6285A644F740A2614"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localF2m ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:nil];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
        if (localF2m) [localF2m release]; localF2m = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersC2tnb359v1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"01AF286BCA1AF286BCA1AF286BCA1AF286BCA1AF286BC9FB8F6B85C556892C20A7EB964FE7719E74F490758D3B" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger valueOf:76L];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"5667676A654B20754F356EA92017D946567C46675556F19556A04616B567D223A5E05656FB549016A96656A557" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"2472E2D0197C49363F1FE7F5B6DB075D52B6947D135D8CA445805D39BC345626089687742B6329E70680231988" withRadix:16];
        F2mCurve *localF2m = [[F2mCurve alloc] initWithM:359 withK:68 withA:big1 withB:big2 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localF2m paramArrayOfByte:[Hex decodeWithString:@"033C258EF3047767E7EDE0F1FDAA79DAEE3841366A132E163ACED4ED2401DF9C6BDCDE98E8E707C07A2239B1B097"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localF2m ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:nil];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
        if (localF2m) [localF2m release]; localF2m = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersC2pnb368w1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"010090512DA9AF72B08349D98A5DD4C7B0532ECA51CE03E2D10F3B7AC579BD87E909AE40A6F131E9CFCE5BD967" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger valueOf:65392L];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"00E0D2EE25095206F5E2A4F9ED229F1F256E79A0E2B455970D8D0D865BD94778C576D62F0AB7519CCD2A1A906AE30D" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"00FC1217D4320A90452C760A58EDCD30C8DD069B3C34453837A34ED50CB54917E1C2112D84D164F444F8F74786046A" withRadix:16];
        F2mCurve *localF2m = [[F2mCurve alloc] initWithM:368 withK1:1 withK2:2 withK3:85 withA:big1 withB:big2 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localF2m paramArrayOfByte:[Hex decodeWithString:@"021085E2755381DCCCE3C1557AFA10C2F0C0C2825646C5B34A394CBCFA8BC16B22E7E789E927BE216F02E1FB136A5F"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localF2m ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:nil];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
        if (localF2m) [localF2m release]; localF2m = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersC2tnb431r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"0340340340340340340340340340340340340340340340340340340323C313FAB50589703B5EC68D3587FEC60D161CC149C1AD4A91" withRadix:16];
        BigInteger *localBigInteger2 = [BigInteger valueOf:10080L];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"1A827EF00DD6FC0E234CAF046C6A5D8A85395B236CC4AD2CF32A0CADBDC9DDF620B0EB9906D0957F6C6FEACD615468DF104DE296CD8F" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"10D9B4A3D9047D8B154359ABFB1B7F5485B04CEB868237DDC9DEDA982A679A5A919B626D4E50A8DD731B107A9962381FB5D807BF2618" withRadix:16];
        F2mCurve *localF2m = [[F2mCurve alloc] initWithM:431 withK:120 withA:big1 withB:big2 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localF2m paramArrayOfByte:[Hex decodeWithString:@"02120FC05D3C67A99DE161D2F4092622FECA701BE4F50F4758714E8A87BBF2A658EF8C21E7C5EFE965361F6C2999C0C247B0DBD70CE6B7"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localF2m ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2 ECParamArrayOfByte:nil];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
        if (localF2m) [localF2m release]; localF2m = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersFRP256v1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [ANSSINamedCurves fromHex:@"F1FD178C0B3AD58F10126DE8CE42435B3961ADBCABC8CA6DE8FCF353D86E9C03"];
        BigInteger *localBigInteger2 = [ANSSINamedCurves fromHex:@"F1FD178C0B3AD58F10126DE8CE42435B3961ADBCABC8CA6DE8FCF353D86E9C00"];
        BigInteger *localBigInteger3 = [ANSSINamedCurves fromHex:@"EE353FCA5428A9300D4ABA754A44C00FDFEC0C9AE4B1A1803075ED967B7BB73F"];
        NSMutableData *arrayOfByte = nil;
        BigInteger *localBigInteger4 = [ANSSINamedCurves fromHex:@"F1FD178C0B3AD58F10126DE8CE42435B53DC67E140D2BF941FFDD459C6D655E1"];
        BigInteger *localBigInteger5 = [BigInteger One];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:localBigInteger1 withA:localBigInteger2 withB:localBigInteger3 withOrder:localBigInteger4 withCofactor:localBigInteger5];
        ECCurve *localECCurve = [ANSSINamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"04B6B3D4C356C139EB31183D4749D423958C27D2DCAF98B70164C97A2DD98F5CFF6142E0F7C8B204911F9271F0F3ECEF8C2701C307E8E4C9E183115A1554062CFB"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger4 ECParamBigInteger2:localBigInteger5 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSecp112r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"DB7C2ABF62E35E668076BEAD208B"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"DB7C2ABF62E35E668076BEAD2088"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"659EF8BA043916EEDE8911702B22"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"00F50B028E4D696E676875615175290472783FB1"];
        BigInteger *localBigInteger4 = [SECNamedCurves fromHex:@"DB7C2ABF62E35E7628DFAC6561C5"];
        BigInteger *localBigInteger5 = [BigInteger One];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:localBigInteger1 withA:localBigInteger2 withB:localBigInteger3 withOrder:localBigInteger4 withCofactor:localBigInteger5];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"0409487239995A5EE76B55F9C2F098A89CE5AF8724C0A23E0E0FF77500"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger4 ECParamBigInteger2:localBigInteger5 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
//        if (localBigInteger4) [localBigInteger4 release]; localBigInteger4 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSecp112r2 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"DB7C2ABF62E35E668076BEAD208B"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"6127C24C05F38A0AAAF65C0EF02C"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"51DEF1815DB5ED74FCC34C85D709"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"002757A1114D696E6768756151755316C05E0BD4"];
        BigInteger *localBigInteger4 = [SECNamedCurves fromHex:@"36DF0AAFD8B8D7597CA10520D04B"];
        BigInteger *localBigInteger5 = [BigInteger Four];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:localBigInteger1 withA:localBigInteger2 withB:localBigInteger3 withOrder:localBigInteger4 withCofactor:localBigInteger5];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"044BA30AB5E892B4E1649DD0928643ADCD46F5882E3747DEF36E956E97"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger4 ECParamBigInteger2:localBigInteger5 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
//        if (localBigInteger4) [localBigInteger4 release]; localBigInteger4 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSecp128r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"FFFFFFFDFFFFFFFFFFFFFFFFFFFFFFFF"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"FFFFFFFDFFFFFFFFFFFFFFFFFFFFFFFC"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"E87579C11079F43DD824993C2CEE5ED3"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"000E0D4D696E6768756151750CC03A4473D03679"];
        BigInteger *localBigInteger4 = [SECNamedCurves fromHex:@"FFFFFFFE0000000075A30D1B9038A115"];
        BigInteger *localBigInteger5 = [BigInteger One];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:localBigInteger1 withA:localBigInteger2 withB:localBigInteger3 withOrder:localBigInteger4 withCofactor:localBigInteger5];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"04161FF7528B899B2D0C28607CA52C5B86CF5AC8395BAFEB13C02DA292DDED7A83"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger4 ECParamBigInteger2:localBigInteger5 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
//        if (localBigInteger4) [localBigInteger4 release]; localBigInteger4 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSecp128r2 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"FFFFFFFDFFFFFFFFFFFFFFFFFFFFFFFF"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"D6031998D1B3BBFEBF59CC9BBFF9AEE1"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"5EEEFCA380D02919DC2C6558BB6D8A5D"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"004D696E67687561517512D8F03431FCE63B88F4"];
        BigInteger *localBigInteger4 = [SECNamedCurves fromHex:@"3FFFFFFF7FFFFFFFBE0024720613B5A3"];
        BigInteger *localBigInteger5 = [BigInteger Four];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:localBigInteger1 withA:localBigInteger2 withB:localBigInteger3 withOrder:localBigInteger4 withCofactor:localBigInteger5];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"047B6AA5D85E572983E6FB32A7CDEBC14027B6916A894D3AEE7106FE805FC34B44"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger4 ECParamBigInteger2:localBigInteger5 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
//        if (localBigInteger4) [localBigInteger4 release]; localBigInteger4 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSecp160k1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFAC73"];
        BigInteger *localBigInteger2 = [BigInteger Zero];
        BigInteger *localBigInteger3 = [BigInteger Seven];
        NSMutableData *arrayOfByte = nil;
        BigInteger *localBigInteger4 = [SECNamedCurves fromHex:@"0100000000000000000001B8FA16DFAB9ACA16B6B3"];
        BigInteger *localBigInteger5 = [BigInteger One];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"9ba48cba5ebcb9b6bd33b92830b2a2e0e192f10a" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"c39c6c3b3a36d7701b9c71a1f5804ae5d0003f4" withRadix:16];
        BigInteger *bigID11 = [[BigInteger alloc] initWithValue:@"9162fbe73984472a0a9e" withRadix:16];
        BigInteger *bigID12 = [[BigInteger alloc] initWithValue:@"-96341f1138933bc2f505" withRadix:16];
        NSMutableArray *ary1 = [[NSMutableArray alloc] initWithObjects:bigID11, bigID12, nil];
        BigInteger *bigID21 = [[BigInteger alloc] initWithValue:@"127971af8721782ecffa3" withRadix:16];
        BigInteger *bigID22 = [[BigInteger alloc] initWithValue:@"9162fbe73984472a0a9e" withRadix:16];
        NSMutableArray *ary2 = [[NSMutableArray alloc] initWithObjects:bigID21, bigID22, nil];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"9162fbe73984472a0a9d0590" withRadix:16];
        BigInteger *big4 = [[BigInteger alloc] initWithValue:@"96341f1138933bc2f503fd44" withRadix:16];
        GlvTypeBParameters *tmpType = [[GlvTypeBParameters alloc] initWithBeta:big1 withLambda:big2 withV1:ary1 withV2:ary2 withG1:big3 withG2:big4 withBits:176];
        GlvTypeBParameters *localGLVTypeBParameters = tmpType;
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:localBigInteger1 withA:localBigInteger2 withB:localBigInteger3 withOrder:localBigInteger4 withCofactor:localBigInteger5];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:fpCurve paramGLVTypeBParameters:localGLVTypeBParameters];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"043B4C382CE37AA192A4019E763036F4F5DD4D7EBB938CF935318FDCED6BC28286531733C3F03C4FEE"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger4 ECParamBigInteger2:localBigInteger5 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger4) [localBigInteger4 release]; localBigInteger4 = nil;
//        if (bigID11) [bigID11 release]; bigID11 = nil;
//        if (bigID12) [bigID12 release]; bigID12 = nil;
//        if (bigID21) [bigID21 release]; bigID21 = nil;
//        if (bigID22) [bigID22 release]; bigID22 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (ary1) [ary1 release]; ary1 = nil;
//        if (ary2) [ary2 release]; ary2 = nil;
//        if (big3) [big3 release]; big3 = nil;
//        if (big4) [big4 release]; big4 = nil;
        if (tmpType) [tmpType release]; tmpType = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSecp160r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFFFF"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFFFC"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"1C97BEFC54BD7A8B65ACF89F81D4D4ADC565FA45"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"1053CDE42C14D696E67687561517533BF3F83345"];
        BigInteger *localBigInteger4 = [SECNamedCurves fromHex:@"0100000000000000000001F4C8F927AED3CA752257"];
        BigInteger *localBigInteger5 = [BigInteger One];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:localBigInteger1 withA:localBigInteger2 withB:localBigInteger3 withOrder:localBigInteger4 withCofactor:localBigInteger5];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"044A96B5688EF573284664698968C38BB913CBFC8223A628553168947D59DCC912042351377AC5FB32"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger4 ECParamBigInteger2:localBigInteger5 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
//        if (localBigInteger4) [localBigInteger4 release]; localBigInteger4 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSecp160r2 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFAC73"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFAC70"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"B4E134D3FB59EB8BAB57274904664D5AF50388BA"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"B99B99B099B323E02709A4D696E6768756151751"];
        BigInteger *localBigInteger4 = [SECNamedCurves fromHex:@"0100000000000000000000351EE786A818F3A1A16B"];
        BigInteger *localBigInteger5 = [BigInteger One];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:localBigInteger1 withA:localBigInteger2 withB:localBigInteger3 withOrder:localBigInteger4 withCofactor:localBigInteger5];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"0452DCB034293A117E1F4FF11B30F7199D3144CE6DFEAFFEF2E331F296E071FA0DF9982CFEA7D43F2E"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger4 ECParamBigInteger2:localBigInteger5 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
//        if (localBigInteger4) [localBigInteger4 release]; localBigInteger4 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSecp192k1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFEE37"];
        BigInteger *localBigInteger2 = [BigInteger Zero];
        BigInteger *localBigInteger3 = [BigInteger Three];
        NSMutableData *arrayOfByte = nil;
        BigInteger *localBigInteger4 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFE26F2FC170F69466A74DEFD8D"];
        BigInteger *localBigInteger5 = [BigInteger One];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"bb85691939b869c1d087f601554b96b80cb4f55b35f433c2" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"3d84f26c12238d7b4f3d516613c1759033b1a5800175d0b1" withRadix:16];
        BigInteger *bigID11 = [[BigInteger alloc] initWithValue:@"71169be7330b3038edb025f1" withRadix:16];
        BigInteger *bigID12 = [[BigInteger alloc] initWithValue:@"-b3fb3400dec5c4adceb8655c" withRadix:16];
        NSMutableArray *ary1 = [[NSMutableArray alloc] initWithObjects:bigID11, bigID12, nil];
        BigInteger *bigID21 = [[BigInteger alloc] initWithValue:@"12511cfe811d0f4e6bc688b4d" withRadix:16];
        BigInteger *bigID22 = [[BigInteger alloc] initWithValue:@"71169be7330b3038edb025f1" withRadix:16];
        NSMutableArray *ary2 = [[NSMutableArray alloc] initWithObjects:bigID21, bigID22, nil];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"71169be7330b3038edb025f1d0f9" withRadix:16];
        BigInteger *big4 = [[BigInteger alloc] initWithValue:@"b3fb3400dec5c4adceb8655d4c94" withRadix:16];
        GlvTypeBParameters *tmpType = [[GlvTypeBParameters alloc] initWithBeta:big1 withLambda:big2 withV1:ary1 withV2:ary2 withG1:big3 withG2:big4 withBits:208];
        GlvTypeBParameters *localGLVTypeBParameters = tmpType;
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:localBigInteger1 withA:localBigInteger2 withB:localBigInteger3 withOrder:localBigInteger4 withCofactor:localBigInteger5];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:fpCurve  paramGLVTypeBParameters:localGLVTypeBParameters];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"04DB4FF10EC057E9AE26B07D0280B7F4341DA5D1B1EAE06C7D9B2F2F6D9C5628A7844163D015BE86344082AA88D95E2F9D"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger4 ECParamBigInteger2:localBigInteger5 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger4) [localBigInteger4 release]; localBigInteger4 = nil;
//        if (bigID11) [bigID11 release]; bigID11 = nil;
//        if (bigID12) [bigID12 release]; bigID12 = nil;
//        if (bigID21) [bigID21 release]; bigID21 = nil;
//        if (bigID22) [bigID22 release]; bigID22 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (ary1) [ary1 release]; ary1 = nil;
//        if (ary2) [ary2 release]; ary2 = nil;
//        if (big3) [big3 release]; big3 = nil;
//        if (big4) [big4 release]; big4 = nil;
        if (tmpType) [tmpType release]; tmpType = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSecp192r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFF"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFC"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"64210519E59C80E70FA7E9AB72243049FEB8DEECC146B9B1"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"3045AE6FC8422F64ED579528D38120EAE12196D5"];
        BigInteger *localBigInteger4 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFF99DEF836146BC9B1B4D22831"];
        BigInteger *localBigInteger5 = [BigInteger One];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:localBigInteger1 withA:localBigInteger2 withB:localBigInteger3 withOrder:localBigInteger4 withCofactor:localBigInteger5];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"04188DA80EB03090F67CBF20EB43A18800F4FF0AFD82FF101207192B95FFC8DA78631011ED6B24CDD573F977A11E794811"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger4 ECParamBigInteger2:localBigInteger5 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
//        if (localBigInteger4) [localBigInteger4 release]; localBigInteger4 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSecp224k1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFE56D"];
        BigInteger *localBigInteger2 = [BigInteger Zero];
        BigInteger *localBigInteger3 = [BigInteger Five];
        NSMutableData *arrayOfByte = nil;
        BigInteger *localBigInteger4 = [SECNamedCurves fromHex:@"010000000000000000000000000001DCE8D2EC6184CAF0A971769FB1F7"];
        BigInteger *localBigInteger5 = [BigInteger One];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"fe0e87005b4e83761908c5131d552a850b3f58b749c37cf5b84d6768" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"60dcd2104c4cbc0be6eeefc2bdd610739ec34e317f9b33046c9e4788" withRadix:16];
        BigInteger *bigID11 = [[BigInteger alloc] initWithValue:@"6b8cf07d4ca75c88957d9d670591" withRadix:16];
        BigInteger *bigID12 = [[BigInteger alloc] initWithValue:@"-b8adf1378a6eb73409fa6c9c637d" withRadix:16];
        NSMutableArray *ary1 = [[NSMutableArray alloc] initWithObjects:bigID11, bigID12, nil];
        BigInteger *bigID21 = [[BigInteger alloc] initWithValue:@"1243ae1b4d71613bc9f780a03690e" withRadix:16];
        BigInteger *bigID22 = [[BigInteger alloc] initWithValue:@"6b8cf07d4ca75c88957d9d670591" withRadix:16];
        NSMutableArray *ary2 = [[NSMutableArray alloc] initWithObjects:bigID21, bigID22, nil];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"6b8cf07d4ca75c88957d9d67059037a4" withRadix:16];
        BigInteger *big4 = [[BigInteger alloc] initWithValue:@"b8adf1378a6eb73409fa6c9c637ba7f5" withRadix:16];
        GlvTypeBParameters *tmpType = [[GlvTypeBParameters alloc] initWithBeta:big1 withLambda:big2  withV1:ary1 withV2:ary2 withG1:big3 withG2:big4 withBits:240];
        GlvTypeBParameters *localGLVTypeBParameters = tmpType;
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:localBigInteger1 withA:localBigInteger2 withB:localBigInteger3 withOrder:localBigInteger4 withCofactor:localBigInteger5];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:fpCurve paramGLVTypeBParameters:localGLVTypeBParameters];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"04A1455B334DF099DF30FC28A169A467E9E47075A90F7E650EB6B7A45C7E089FED7FBA344282CAFBD6F7E319F7C0B0BD59E2CA4BDB556D61A5"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger4 ECParamBigInteger2:localBigInteger5 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger4) [localBigInteger4 release]; localBigInteger4 = nil;
//        if (bigID11) [bigID11 release]; bigID11 = nil;
//        if (bigID12) [bigID12 release]; bigID12 = nil;
//        if (bigID21) [bigID21 release]; bigID21 = nil;
//        if (bigID22) [bigID22 release]; bigID22 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (ary1) [ary1 release]; ary1 = nil;
//        if (ary2) [ary2 release]; ary2 = nil;
//        if (big3) [big3 release]; big3 = nil;
//        if (big4) [big4 release]; big4 = nil;
        if (tmpType) [tmpType release]; tmpType = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSecp224r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000001"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFE"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"B4050A850C04B3ABF54132565044B0B7D7BFD8BA270B39432355FFB4"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"BD71344799D5C7FCDC45B59FA3B9AB8F6A948BC5"];
        BigInteger *localBigInteger4 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFF16A2E0B8F03E13DD29455C5C2A3D"];
        BigInteger *localBigInteger5 = [BigInteger One];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:localBigInteger1 withA:localBigInteger2 withB:localBigInteger3 withOrder:localBigInteger4 withCofactor:localBigInteger5];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"04B70E0CBD6BB4BF7F321390B94A03C1D356C21122343280D6115C1D21BD376388B5F723FB4C22DFE6CD4375A05A07476444D5819985007E34"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger4 ECParamBigInteger2:localBigInteger5 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
//        if (localBigInteger4) [localBigInteger4 release]; localBigInteger4 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSecp256k1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F"];
        BigInteger *localBigInteger2 = [BigInteger Zero];
        BigInteger *localBigInteger3 = [BigInteger Seven];
        NSMutableData *arrayOfByte = nil;
        BigInteger *localBigInteger4 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141"];
        BigInteger *localBigInteger5 = [BigInteger One];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"7ae96a2b657c07106e64479eac3434e99cf0497512f58995c1396c28719501ee" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"5363ad4cc05c30e0a5261c028812645a122e22ea20816678df02967c1b23bd72" withRadix:16];
        BigInteger *bigID11 = [[BigInteger alloc] initWithValue:@"3086d221a7d46bcde86c90e49284eb15" withRadix:16];
        BigInteger *bigID12 = [[BigInteger alloc] initWithValue:@"-e4437ed6010e88286f547fa90abfe4c3" withRadix:16];
        NSMutableArray *ary1 = [[NSMutableArray alloc] initWithObjects:bigID11, bigID12, nil];
        BigInteger *bigID21 = [[BigInteger alloc] initWithValue:@"114ca50f7a8e2f3f657c1108d9d44cfd8" withRadix:16];
        BigInteger *bigID22 = [[BigInteger alloc] initWithValue:@"3086d221a7d46bcde86c90e49284eb15" withRadix:16];
        NSMutableArray *ary2 = [[NSMutableArray alloc] initWithObjects:bigID21, bigID22, nil];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"3086d221a7d46bcde86c90e49284eb153dab" withRadix:16];
        BigInteger *big4 = [[BigInteger alloc] initWithValue:@"e4437ed6010e88286f547fa90abfe4c42212" withRadix:16];
        GlvTypeBParameters *tmpType = [[GlvTypeBParameters alloc] initWithBeta:big1 withLambda:big2 withV1:ary1 withV2:ary2 withG1:big3 withG2:big4 withBits:272];
        GlvTypeBParameters *localGLVTypeBParameters = tmpType;
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:localBigInteger1 withA:localBigInteger2 withB:localBigInteger3 withOrder:localBigInteger4 withCofactor:localBigInteger5];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:fpCurve paramGLVTypeBParameters:localGLVTypeBParameters];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"0479BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger4 ECParamBigInteger2:localBigInteger5 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger4) [localBigInteger4 release]; localBigInteger4 = nil;
//        if (bigID11) [bigID11 release]; bigID11 = nil;
//        if (bigID12) [bigID12 release]; bigID12 = nil;
//        if (bigID21) [bigID21 release]; bigID21 = nil;
//        if (bigID22) [bigID22 release]; bigID22 = nil;
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (ary1) [ary1 release]; ary1 = nil;
//        if (ary2) [ary2 release]; ary2 = nil;
//        if (big3) [big3 release]; big3 = nil;
//        if (big4) [big4 release]; big4 = nil;
        if (tmpType) [tmpType release]; tmpType = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSecp256r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"FFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"FFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFC"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"5AC635D8AA3A93E7B3EBBD55769886BC651D06B0CC53B0F63BCE3C3E27D2604B"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"C49D360886E704936A6678E1139D26B7819F7E90"];
        BigInteger *localBigInteger4 = [SECNamedCurves fromHex:@"FFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551"];
        BigInteger *localBigInteger5 = [BigInteger One];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:localBigInteger1 withA:localBigInteger2 withB:localBigInteger3 withOrder:localBigInteger4 withCofactor:localBigInteger5];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"046B17D1F2E12C4247F8BCE6E563A440F277037D812DEB33A0F4A13945D898C2964FE342E2FE1A7F9B8EE7EB4A7C0F9E162BCE33576B315ECECBB6406837BF51F5"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger4 ECParamBigInteger2:localBigInteger5 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
//        if (localBigInteger4) [localBigInteger4 release]; localBigInteger4 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSecp384r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFF0000000000000000FFFFFFFF"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFF0000000000000000FFFFFFFC"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"B3312FA7E23EE7E4988E056BE3F82D19181D9C6EFE8141120314088F5013875AC656398D8A2ED19D2A85C8EDD3EC2AEF"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"A335926AA319A27A1D00896A6773A4827ACDAC73"];
        BigInteger *localBigInteger4 = [SECNamedCurves fromHex:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC7634D81F4372DDF581A0DB248B0A77AECEC196ACCC52973"];
        BigInteger *localBigInteger5 = [BigInteger One];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:localBigInteger1 withA:localBigInteger2 withB:localBigInteger3 withOrder:localBigInteger4 withCofactor:localBigInteger5];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"04AA87CA22BE8B05378EB1C71EF320AD746E1D3B628BA79B9859F741E082542A385502F25DBF55296C3A545E3872760AB73617DE4A96262C6F5D9E98BF9292DC29F8F41DBD289A147CE9DA3113B5F0B8C00A60B1CE1D7E819D7A431D7C90EA0E5F"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger4 ECParamBigInteger2:localBigInteger5 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
//        if (localBigInteger4) [localBigInteger4 release]; localBigInteger4 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSecp521r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"01FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"01FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"0051953EB9618E1C9A1F929A21A0B68540EEA2DA725B99B315F3B8B489918EF109E156193951EC7E937B1652C0BD3BB1BF073573DF883D2C34F1EF451FD46B503F00"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"D09E8800291CB85396CC6717393284AAA0DA64BA"];
        BigInteger *localBigInteger4 = [SECNamedCurves fromHex:@"01FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA51868783BF2F966B7FCC0148F709A5D03BB5C9B8899C47AEBB6FB71E91386409"];
        BigInteger *localBigInteger5 = [BigInteger One];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:localBigInteger1 withA:localBigInteger2 withB:localBigInteger3 withOrder:localBigInteger4 withCofactor:localBigInteger5];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"0400C6858E06B70404E9CD9E3ECB662395B4429C648139053FB521F828AF606B4D3DBAA14B5E77EFE75928FE1DC127A2FFA8DE3348B3C1856A429BF97E7E31C2E5BD66011839296A789A3BC0045C8A5FB42C7D1BD998F54449579B446817AFBD17273E662C97EE72995EF42640C550B9013FAD0761353C7086A272C24088BE94769FD16650"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger4 ECParamBigInteger2:localBigInteger5 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
//        if (localBigInteger4) [localBigInteger4 release]; localBigInteger4 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect113r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 113;
        int j = 9;
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"003088250CA6E7C7FE649CE85820F7"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"00E8BEE4D3E2260744188BE0E9C723"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"10E723AB14D696E6768756151756FEBF8FCB49A9"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"0100000000000000D9CCEC8A39E56F"];
        BigInteger *localBigInteger4 = [BigInteger Two];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK:j withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"04009D73616F35F4AB1407D73562C10F00A52830277958EE84D1315ED31886"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect113r2 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 113;
        int j = 9;
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"00689918DBEC7E5A0DD6DFC0AA55C7"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"0095E9A9EC9B297BD4BF36E059184F"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"10C0FB15760860DEF1EEF4D696E676875615175D"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"010000000000000108789B2496AF93"];
        BigInteger *localBigInteger4 = [BigInteger Two];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK:j withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"0401A57A6A7B26CA5EF52FCDB816479700B3ADC94ED1FE674C06E695BABA1D"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect131r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 131;
        int j = 2;
        int k = 3;
        int m = 8;
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"07A11B09A76B562144418FF3FF8C2570B8"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"0217C05610884B63B9C6C7291678F9D341"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"4D696E676875615175985BD3ADBADA21B43A97E2"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"0400000000000000023123953A9464B54D"];
        BigInteger *localBigInteger4 = [BigInteger Two];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK1:j withK2:k withK3:m withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"040081BAF91FDF9833C40F9C181343638399078C6E7EA38C001F73C8134B1B4EF9E150"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect131r2 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 131;
        int j = 2;
        int k = 3;
        int m = 8;
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"03E5A88919D7CAFCBF415F07C2176573B2"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"04B8266A46C55657AC734CE38F018F2192"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"985BD3ADBAD4D696E676875615175A21B43A97E3"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"0400000000000000016954A233049BA98F"];
        BigInteger *localBigInteger4 = [BigInteger Two];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK1:j withK2:k withK3:m withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"040356DCD8F2F95031AD652D23951BB366A80648F06D867940A5366D9E265DE9EB240F"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect163k1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 163;
        int j = 3;
        int k = 6;
        int m = 7;
        BigInteger *localBigInteger1 = [BigInteger One];
        BigInteger *localBigInteger2 = [BigInteger One];
        NSMutableData *arrayOfByte = nil;
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"04000000000000000000020108A2E0CC0D99F8A5EF"];
        BigInteger *localBigInteger4 = [BigInteger Two];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK1:j withK2:k withK3:m withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"0402FE13C0537BBC11ACAA07D793DE4E6D5E5C94EEE80289070FB05D38FF58321F2E800536D538CCDAA3D9"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect163r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 163;
        int j = 3;
        int k = 6;
        int m = 7;
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"07B6882CAAEFA84F9554FF8428BD88E246D2782AE2"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"0713612DCDDCB40AAB946BDA29CA91F73AF958AFD9"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"24B7B137C8A14D696E6768756151756FD0DA2E5C"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"03FFFFFFFFFFFFFFFFFFFF48AAB689C29CA710279B"];
        BigInteger *localBigInteger4 = [BigInteger Two];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK1:j withK2:k withK3:m withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"040369979697AB43897789566789567F787A7876A65400435EDB42EFAFB2989D51FEFCE3C80988F41FF883"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect163r2 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 163;
        int j = 3;
        int k = 6;
        int m = 7;
        BigInteger *localBigInteger1 = [BigInteger One];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"020A601907B8C953CA1481EB10512F78744A3205FD"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"85E25BFE5C86226CDB12016F7553F9D0E693A268"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"040000000000000000000292FE77E70C12A4234C33"];
        BigInteger *localBigInteger4 = [BigInteger Two];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK1:j withK2:k withK3:m withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"0403F0EBA16286A2D57EA0991168D4994637E8343E3600D51FBC6C71A0094FA2CDD545B11C5C0C797324F1"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect193r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 193;
        int j = 15;
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"0017858FEB7A98975169E171F77B4087DE098AC8A911DF7B01"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"00FDFB49BFE6C3A89FACADAA7A1E5BBC7CC1C2E5D831478814"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"103FAEC74D696E676875615175777FC5B191EF30"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"01000000000000000000000000C7F34A778F443ACC920EBA49"];
        BigInteger *localBigInteger4 = [BigInteger Two];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK:j withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"0401F481BC5F0FF84A74AD6CDF6FDEF4BF6179625372D8C0C5E10025E399F2903712CCF3EA9E3A1AD17FB0B3201B6AF7CE1B05"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect193r2 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 193;
        int j = 15;
        BigInteger *localBigInteger1 = [SECNamedCurves fromHex:@"0163F35A5137C2CE3EA6ED8667190B0BC43ECD69977702709B"];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"00C9BB9E8927D4D64C377E2AB2856A5B16E3EFB7F61D4316AE"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"10B7B4D696E676875615175137C8A16FD0DA2211"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"010000000000000000000000015AAB561B005413CCD4EE99D5"];
        BigInteger *localBigInteger4 = [BigInteger Two];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK:j withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"0400D9B67D192E0367C803F39E1A7E82CA14A651350AAE617E8F01CE94335607C304AC29E7DEFBD9CA01F596F927224CDECF6C"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect233k1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 233;
        int j = 74;
        BigInteger *localBigInteger1 = [BigInteger Zero];
        BigInteger *localBigInteger2 = [BigInteger One];
        NSMutableData *arrayOfByte = nil;
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"8000000000000000000000000000069D5BB915BCD46EFB1AD5F173ABDF"];
        BigInteger *localBigInteger4 = [BigInteger Four];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK:j withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"04017232BA853A7E731AF129F22FF4149563A419C26BF50A4C9D6EEFAD612601DB537DECE819B7F70F555A67C427A8CD9BF18AEB9B56E0C11056FAE6A3"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect233r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 233;
        int j = 74;
        BigInteger *localBigInteger1 = [BigInteger One];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"0066647EDE6C332C7F8C0923BB58213B333B20E9CE4281FE115F7D8F90AD"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"74D59FF07F6B413D0EA14B344B20A2DB049B50C3"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"01000000000000000000000000000013E974E72F8A6922031D2603CFE0D7"];
        BigInteger *localBigInteger4 = [BigInteger Two];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK:j withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"0400FAC9DFCBAC8313BB2139F1BB755FEF65BC391F8B36F8F8EB7371FD558B01006A08A41903350678E58528BEBF8A0BEFF867A7CA36716F7E01F81052"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect239k1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 239;
        int j = 158;
        BigInteger *localBigInteger1 = [BigInteger Zero];
        BigInteger *localBigInteger2 = [BigInteger One];
        NSMutableData *arrayOfByte = nil;
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"2000000000000000000000000000005A79FEC67CB6E91F1C1DA800E478A5"];
        BigInteger *localBigInteger4 = [BigInteger Four];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK:j withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"0429A0B6A887A983E9730988A68727A8B2D126C44CC2CC7B2A6555193035DC76310804F12E549BDB011C103089E73510ACB275FC312A5DC6B76553F0CA"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect283k1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 283;
        int j = 5;
        int k = 7;
        int m = 12;
        BigInteger *localBigInteger1 = [BigInteger Zero];
        BigInteger *localBigInteger2 = [BigInteger One];
        NSMutableData *arrayOfByte = nil;
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"01FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE9AE2ED07577265DFF7F94451E061E163C61"];
        BigInteger *localBigInteger4 = [BigInteger Four];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK1:j withK2:k withK3:m withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"040503213F78CA44883F1A3B8162F188E553CD265F23C1567A16876913B0C2AC245849283601CCDA380F1C9E318D90F95D07E5426FE87E45C0E8184698E45962364E34116177DD2259"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect283r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 283;
        int j = 5;
        int k = 7;
        int m = 12;
        BigInteger *localBigInteger1 = [BigInteger One];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"027B680AC8B8596DA5A4AF8A19A0303FCA97FD7645309FA2A581485AF6263E313B79A2F5"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"77E2B07370EB0F832A6DD5B62DFC88CD06BB84BE"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"03FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEF90399660FC938A90165B042A7CEFADB307"];
        BigInteger *localBigInteger4 = [BigInteger Two];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK1:j withK2:k withK3:m withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"0405F939258DB7DD90E1934F8C70B0DFEC2EED25B8557EAC9C80E2E198F8CDBECD86B1205303676854FE24141CB98FE6D4B20D02B4516FF702350EDDB0826779C813F0DF45BE8112F4"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect409k1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 409;
        int j = 87;
        BigInteger *localBigInteger1 = [BigInteger Zero];
        BigInteger *localBigInteger2 = [BigInteger One];
        NSMutableData *arrayOfByte = nil;
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5F83B2D4EA20400EC4557D5ED3E3E7CA5B4B5C83B8E01E5FCF"];
        BigInteger *localBigInteger4 = [BigInteger Four];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK:j withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"040060F05F658F49C1AD3AB1890F7184210EFD0987E307C84C27ACCFB8F9F67CC2C460189EB5AAAA62EE222EB1B35540CFE902374601E369050B7C4E42ACBA1DACBF04299C3460782F918EA427E6325165E9EA10E3DA5F6C42E9C55215AA9CA27A5863EC48D8E0286B"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect409r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 409;
        int j = 87;
        BigInteger *localBigInteger1 = [BigInteger One];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"0021A5C2C8EE9FEB5C4B9A753B7B476B7FD6422EF1F3DD674761FA99D6AC27C8A9A197B272822F6CD57A55AA4F50AE317B13545F"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"4099B5A457F9D69F79213D094C4BCD4D4262210B"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"010000000000000000000000000000000000000000000000000001E2AAD6A612F33307BE5FA47C3C9E052F838164CD37D9A21173"];
        BigInteger *localBigInteger4 = [BigInteger Two];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK:j withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"04015D4860D088DDB3496B0C6064756260441CDE4AF1771D4DB01FFE5B34E59703DC255A868A1180515603AEAB60794E54BB7996A70061B1CFAB6BE5F32BBFA78324ED106A7636B9C5A7BD198D0158AA4F5488D08F38514F1FDF4B4F40D2181B3681C364BA0273C706"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
        //    if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
        //    if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect571k1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 571;
        int j = 2;
        int k = 5;
        int m = 10;
        BigInteger *localBigInteger1 = [BigInteger Zero];
        BigInteger *localBigInteger2 = [BigInteger One];
        NSMutableData *arrayOfByte = nil;
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"020000000000000000000000000000000000000000000000000000000000000000000000131850E1F19A63E4B391A8DB917F4138B630D84BE5D639381E91DEB45CFE778F637C1001"];
        BigInteger *localBigInteger4 = [BigInteger Four];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK1:j withK2:k withK3:m withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"04026EB7A859923FBC82189631F8103FE4AC9CA2970012D5D46024804801841CA44370958493B205E647DA304DB4CEB08CBBD1BA39494776FB988B47174DCA88C7E2945283A01C89720349DC807F4FBF374F4AEADE3BCA95314DD58CEC9F307A54FFC61EFC006D8A2C9D4979C0AC44AEA74FBEBBB9F772AEDCB620B01A7BA7AF1B320430C8591984F601CD4C143EF1C7A3"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersSect571r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        int i = 571;
        int j = 2;
        int k = 5;
        int m = 10;
        BigInteger *localBigInteger1 = [BigInteger One];
        BigInteger *localBigInteger2 = [SECNamedCurves fromHex:@"02F40E7E2221F295DE297117B7F3D62F5C6A97FFCB8CEFF1CD6BA8CE4A9A18AD84FFABBD8EFA59332BE7AD6756A66E294AFD185A78FF12AA520E4DE739BACA0C7FFEFF7F2955727A"];
        NSMutableData *arrayOfByte = [Hex decodeWithString:@"2AA058F73A0E33AB486B0F610410C53A7F132310"];
        BigInteger *localBigInteger3 = [SECNamedCurves fromHex:@"03FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE661CE18FF55987308059B186823851EC7DD9CA1161DE93D5174D66E8382E9BB2FE84E47"];
        BigInteger *localBigInteger4 = [BigInteger Two];
        ECCurve *f2mCurve = [[F2mCurve alloc] initWithM:i withK1:j withK2:k withK3:m withA:localBigInteger1 withB:localBigInteger2 withOrder:localBigInteger3 withCofactor:localBigInteger4];
        ECCurve *localECCurve = [SECNamedCurves configureCurve:f2mCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"040303001D34B856296C16C0D40D3CD7750A93D1D2955FA80AA5F40FC8DB7B2ABDBDE53950F4C0D293CDD711A35B67FB1499AE60038614F1394ABFA3B4C850D927E1E7769C8EEC2D19037BF27342DA639B6DCCFFFEB73D69D78C6C27A6009CBBCA1980F8533921E8A684423E43BAB08A576291AF8F461BB2A8B3531D2F0485C19B16E2F1516E23DD3C1A4827AF1B8AC15B"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger3 ECParamBigInteger2:localBigInteger4 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
//        if (localBigInteger3) [localBigInteger3 release]; localBigInteger3 = nil;
        if (f2mCurve) [f2mCurve release]; f2mCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersBrainpoolP160r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"E95E4A5F737059DC60DF5991D45029409E60FC09" withRadix:16];
        BigInteger *localBigInteger2 = [[BigInteger alloc] initWithValue:@"01" withRadix:16];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"E95E4A5F737059DC60DFC7AD95B3D8139515620F" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"340E7BE2A280EB74E2BE61BADA745D97E8F7C300" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"1E589A8595423412134FAA2DBDEC95C8D8675E58" withRadix:16];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        ECCurve *localECCurve = [TeleTrusTNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"04BED5AF16EA3F6A4F62938C4631EB5AF7BDBCDBC31667CB477A1A8EC338F94741669C976316DA6321"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2];
#if !__has_feature(objc_arc)
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersBrainpoolP160t1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"E95E4A5F737059DC60DF5991D45029409E60FC09" withRadix:16];
        BigInteger *localBigInteger2 = [[BigInteger alloc] initWithValue:@"01" withRadix:16];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"E95E4A5F737059DC60DFC7AD95B3D8139515620F" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"E95E4A5F737059DC60DFC7AD95B3D8139515620C" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"7A556B6DAE535B7B51ED2C4D7DAA7A0B5C55F380" withRadix:16];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        ECCurve *localECCurve = [TeleTrusTNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"04B199B13B9B34EFC1397E64BAEB05ACC265FF2378ADD6718B7C7C1961F0991B842443772152C9E0AD"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint  ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2];
#if !__has_feature(objc_arc)
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersBrainpoolP192r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"C302F41D932A36CDA7A3462F9E9E916B5BE8F1029AC4ACC1" withRadix:16];
        BigInteger *localBigInteger2 = [[BigInteger alloc] initWithValue:@"01" withRadix:16];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"C302F41D932A36CDA7A3463093D18DB78FCE476DE1A86297" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"6A91174076B1E0E19C39C031FE8685C1CAE040E5C69A28EF" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"469A28EF7C28CCA3DC721D044F4496BCCA7EF4146FBF25C9" withRadix:16];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        ECCurve *localECCurve = [TeleTrusTNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"04C0A0647EAAB6A48753B033C56CB0F0900A2F5C4853375FD614B690866ABD5BB88B5F4828C1490002E6773FA2FA299B8F"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2];
#if !__has_feature(objc_arc)
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersBrainpoolP192t1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"C302F41D932A36CDA7A3462F9E9E916B5BE8F1029AC4ACC1" withRadix:16];
        BigInteger *localBigInteger2 = [[BigInteger alloc] initWithValue:@"01" withRadix:16];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"C302F41D932A36CDA7A3463093D18DB78FCE476DE1A86297" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"C302F41D932A36CDA7A3463093D18DB78FCE476DE1A86294" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"13D56FFAEC78681E68F9DEB43B35BEC2FB68542E27897B79" withRadix:16];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        ECCurve *localECCurve = [TeleTrusTNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"043AE9E58C82F63C30282E1FE7BBF43FA72C446AF6F4618129097E2C5667C2223A902AB5CA449D0084B7E5B3DE7CCC01C9"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2];
#if !__has_feature(objc_arc)
        //    if (big1) [big1 release]; big1 = nil;
        //    if (big2) [big2 release]; big2 = nil;
        //    if (big3) [big3 release]; big3 = nil;
        //    if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
        //    if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersBrainpoolP224r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"D7C134AA264366862A18302575D0FB98D116BC4B6DDEBCA3A5A7939F" withRadix:16];
        BigInteger *localBigInteger2 = [[BigInteger alloc] initWithValue:@"01" withRadix:16];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"D7C134AA264366862A18302575D1D787B09F075797DA89F57EC8C0FF" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"68A5E62CA9CE6C1C299803A6C1530B514E182AD8B0042A59CAD29F43" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"2580F63CCFE44138870713B1A92369E33E2135D266DBB372386C400B" withRadix:16];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        ECCurve *localECCurve = [TeleTrusTNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"040D9029AD2C7E5CF4340823B2A87DC68C9E4CE3174C1E6EFDEE12C07D58AA56F772C0726F24C6B89E4ECDAC24354B9E99CAA3F6D3761402CD"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint  ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2];
#if !__has_feature(objc_arc)
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersBrainpoolP224t1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"D7C134AA264366862A18302575D0FB98D116BC4B6DDEBCA3A5A7939F" withRadix:16];
        BigInteger *localBigInteger2 = [[BigInteger alloc] initWithValue:@"01" withRadix:16];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"D7C134AA264366862A18302575D1D787B09F075797DA89F57EC8C0FF" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"D7C134AA264366862A18302575D1D787B09F075797DA89F57EC8C0FC" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"4B337D934104CD7BEF271BF60CED1ED20DA14C08B3BB64F18A60888D" withRadix:16];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        ECCurve *localECCurve = [TeleTrusTNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"046AB1E344CE25FF3896424E7FFE14762ECB49F8928AC0C76029B4D5800374E9F5143E568CD23F3F4D7C0D4B1E41C8CC0D1C6ABD5F1A46DB4C"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2];
#if !__has_feature(objc_arc)
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersBrainpoolP256r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"A9FB57DBA1EEA9BC3E660A909D838D718C397AA3B561A6F7901E0E82974856A7" withRadix:16];
        BigInteger *localBigInteger2 = [[BigInteger alloc] initWithValue:@"01" withRadix:16];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"A9FB57DBA1EEA9BC3E660A909D838D726E3BF623D52620282013481D1F6E5377" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"7D5A0975FC2C3057EEF67530417AFFE7FB8055C126DC5C6CE94A4B44F330B5D9" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"26DC5C6CE94A4B44F330B5D9BBD77CBF958416295CF7E1CE6BCCDC18FF8C07B6" withRadix:16];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        ECCurve *localECCurve = [TeleTrusTNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"048BD2AEB9CB7E57CB2C4B482FFC81B7AFB9DE27E1E3BD23C23A4453BD9ACE3262547EF835C3DAC4FD97F8461A14611DC9C27745132DED8E545C1D54C72F046997"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2];
#if !__has_feature(objc_arc)
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersBrainpoolP256t1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"A9FB57DBA1EEA9BC3E660A909D838D718C397AA3B561A6F7901E0E82974856A7" withRadix:16];
        BigInteger *localBigInteger2 = [[BigInteger alloc] initWithValue:@"01" withRadix:16];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"A9FB57DBA1EEA9BC3E660A909D838D726E3BF623D52620282013481D1F6E5377" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"A9FB57DBA1EEA9BC3E660A909D838D726E3BF623D52620282013481D1F6E5374" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"662C61C430D84EA4FE66A7733D0B76B7BF93EBC4AF2F49256AE58101FEE92B04" withRadix:16];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        ECCurve *localECCurve = [TeleTrusTNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"04A3E8EB3CC1CFE7B7732213B23A656149AFA142C47AAFBC2B79A191562E1305F42D996C823439C56D7F7B22E14644417E69BCB6DE39D027001DABE8F35B25C9BE"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2];
#if !__has_feature(objc_arc)
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersBrainpoolP320r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"D35E472036BC4FB7E13C785ED201E065F98FCFA5B68F12A32D482EC7EE8658E98691555B44C59311" withRadix:16];
        BigInteger *localBigInteger2 = [[BigInteger alloc] initWithValue:@"01" withRadix:16];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"D35E472036BC4FB7E13C785ED201E065F98FCFA6F6F40DEF4F92B9EC7893EC28FCD412B1F1B32E27" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"3EE30B568FBAB0F883CCEBD46D3F3BB8A2A73513F5EB79DA66190EB085FFA9F492F375A97D860EB4" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"520883949DFDBC42D3AD198640688A6FE13F41349554B49ACC31DCCD884539816F5EB4AC8FB1F1A6" withRadix:16];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        ECCurve *localECCurve = [TeleTrusTNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"0443BD7E9AFB53D8B85289BCC48EE5BFE6F20137D10A087EB6E7871E2A10A599C710AF8D0D39E2061114FDD05545EC1CC8AB4093247F77275E0743FFED117182EAA9C77877AAAC6AC7D35245D1692E8EE1"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2];
#if !__has_feature(objc_arc)
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersBrainpoolP320t1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"D35E472036BC4FB7E13C785ED201E065F98FCFA5B68F12A32D482EC7EE8658E98691555B44C59311" withRadix:16];
        BigInteger *localBigInteger2 = [[BigInteger alloc] initWithValue:@"01" withRadix:16];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"D35E472036BC4FB7E13C785ED201E065F98FCFA6F6F40DEF4F92B9EC7893EC28FCD412B1F1B32E27" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"D35E472036BC4FB7E13C785ED201E065F98FCFA6F6F40DEF4F92B9EC7893EC28FCD412B1F1B32E24" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"A7F561E038EB1ED560B3D147DB782013064C19F27ED27C6780AAF77FB8A547CEB5B4FEF422340353" withRadix:16];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        ECCurve *localECCurve = [TeleTrusTNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"04925BE9FB01AFC6FB4D3E7D4990010F813408AB106C4F09CB7EE07868CC136FFF3357F624A21BED5263BA3A7A27483EBF6671DBEF7ABB30EBEE084E58A0B077AD42A5A0989D1EE71B1B9BC0455FB0D2C3"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2];
#if !__has_feature(objc_arc)
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersBrainpoolP384r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"8CB91E82A3386D280F5D6F7E50E641DF152F7109ED5456B31F166E6CAC0425A7CF3AB6AF6B7FC3103B883202E9046565" withRadix:16];
        BigInteger *localBigInteger2 = [[BigInteger alloc] initWithValue:@"01" withRadix:16];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"8CB91E82A3386D280F5D6F7E50E641DF152F7109ED5456B412B1DA197FB71123ACD3A729901D1A71874700133107EC53" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"7BC382C63D8C150C3C72080ACE05AFA0C2BEA28E4FB22787139165EFBA91F90F8AA5814A503AD4EB04A8C7DD22CE2826" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"4A8C7DD22CE28268B39B55416F0447C2FB77DE107DCD2A62E880EA53EEB62D57CB4390295DBC9943AB78696FA504C11" withRadix:16];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        ECCurve *localECCurve = [TeleTrusTNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"041D1C64F068CF45FFA2A63A81B7C13F6B8847A3E77EF14FE3DB7FCAFE0CBD10E8E826E03436D646AAEF87B2E247D4AF1E8ABE1D7520F9C2A45CB1EB8E95CFD55262B70B29FEEC5864E19C054FF99129280E4646217791811142820341263C5315"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2];
#if !__has_feature(objc_arc)
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersBrainpoolP384t1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"8CB91E82A3386D280F5D6F7E50E641DF152F7109ED5456B31F166E6CAC0425A7CF3AB6AF6B7FC3103B883202E9046565" withRadix:16];
        BigInteger *localBigInteger2 = [[BigInteger alloc] initWithValue:@"01" withRadix:16];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"8CB91E82A3386D280F5D6F7E50E641DF152F7109ED5456B412B1DA197FB71123ACD3A729901D1A71874700133107EC53" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"8CB91E82A3386D280F5D6F7E50E641DF152F7109ED5456B412B1DA197FB71123ACD3A729901D1A71874700133107EC50" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"7F519EADA7BDA81BD826DBA647910F8C4B9346ED8CCDC64E4B1ABD11756DCE1D2074AA263B88805CED70355A33B471EE" withRadix:16];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        ECCurve *localECCurve = [TeleTrusTNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"0418DE98B02DB9A306F2AFCD7235F72A819B80AB12EBD653172476FECD462AABFFC4FF191B946A5F54D8D0AA2F418808CC25AB056962D30651A114AFD2755AD336747F93475B7A1FCA3B88F2B6A208CCFE469408584DC2B2912675BF5B9E582928"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2];
#if !__has_feature(objc_arc)
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersBrainpoolP512r1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"AADD9DB8DBE9C48B3FD4E6AE33C9FC07CB308DB3B3C9D20ED6639CCA70330870553E5C414CA92619418661197FAC10471DB1D381085DDADDB58796829CA90069" withRadix:16];
        BigInteger *localBigInteger2 = [[BigInteger alloc] initWithValue:@"01" withRadix:16];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"AADD9DB8DBE9C48B3FD4E6AE33C9FC07CB308DB3B3C9D20ED6639CCA703308717D4D9B009BC66842AECDA12AE6A380E62881FF2F2D82C68528AA6056583A48F3" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"7830A3318B603B89E2327145AC234CC594CBDD8D3DF91610A83441CAEA9863BC2DED5D5AA8253AA10A2EF1C98B9AC8B57F1117A72BF2C7B9E7C1AC4D77FC94CA" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"3DF91610A83441CAEA9863BC2DED5D5AA8253AA10A2EF1C98B9AC8B57F1117A72BF2C7B9E7C1AC4D77FC94CADC083E67984050B75EBAE5DD2809BD638016F723" withRadix:16];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        ECCurve *localECCurve = [TeleTrusTNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"0481AEE4BDD82ED9645A21322E9C4C6A9385ED9F70B5D916C1B43B62EEF4D0098EFF3B1F78E2D0D48D50D1687B93B97D5F7C6D5047406A5E688B352209BCB9F8227DDE385D566332ECC0EABFA9CF7822FDF209F70024A57B1AA000C55B881F8111B2DCDE494A5F485E5BCA4BD88A2763AED1CA2B2FA8F0540678CD1E0F3AD80892"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2];
#if !__has_feature(objc_arc)
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

- (X9ECParameters *)createParametersBrainpoolP512t1 {
    X9ECParameters *parameters = nil;
    @autoreleasepool {
        BigInteger *localBigInteger1 = [[BigInteger alloc] initWithValue:@"AADD9DB8DBE9C48B3FD4E6AE33C9FC07CB308DB3B3C9D20ED6639CCA70330870553E5C414CA92619418661197FAC10471DB1D381085DDADDB58796829CA90069" withRadix:16];
        BigInteger *localBigInteger2 = [[BigInteger alloc] initWithValue:@"01" withRadix:16];
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"AADD9DB8DBE9C48B3FD4E6AE33C9FC07CB308DB3B3C9D20ED6639CCA703308717D4D9B009BC66842AECDA12AE6A380E62881FF2F2D82C68528AA6056583A48F3" withRadix:16];
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"AADD9DB8DBE9C48B3FD4E6AE33C9FC07CB308DB3B3C9D20ED6639CCA703308717D4D9B009BC66842AECDA12AE6A380E62881FF2F2D82C68528AA6056583A48F0" withRadix:16];
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"7CBBBCF9441CFAB76E1890E46884EAE321F70C0BCB4981527897504BEC3E36A62BCDFA2304976540F6450085F2DAE145C22553B465763689180EA2571867423E" withRadix:16];
        ECCurve *fpCurve = [[FpCurve alloc] initWithQ:big1 withA:big2 withB:big3 withOrder:localBigInteger1 withCofactor:localBigInteger2];
        ECCurve *localECCurve = [TeleTrusTNamedCurves configureCurve:fpCurve];
        X9ECPoint *tmpX9ECPoint = [[X9ECPoint alloc] initParamECCurve:localECCurve paramArrayOfByte:[Hex decodeWithString:@"04640ECE5C12788717B9C1BA06CBC2A6FEBA85842458C56DDE9DB1758D39C0313D82BA51735CDB3EA499AA77A7D6943A64F7A3F25FE26F06B51BAA2696FA9035DA5B534BD595F5AF0FA2C892376C84ACE1BB4E3019B71634C01131159CAE03CEE9D9932184BEEF216BD71DF2DADF86A627306ECFF96DBB8BACE198B61E00F8B332"]];
        parameters = [[X9ECParameters alloc] initX9ECParametersECCurve:localECCurve ECParamX9ECPoint:tmpX9ECPoint ECParamBigInteger1:localBigInteger1 ECParamBigInteger2:localBigInteger2];
#if !__has_feature(objc_arc)
//        if (big1) [big1 release]; big1 = nil;
//        if (big2) [big2 release]; big2 = nil;
//        if (big3) [big3 release]; big3 = nil;
//        if (localBigInteger1) [localBigInteger1 release]; localBigInteger1 = nil;
//        if (localBigInteger2) [localBigInteger2 release]; localBigInteger2 = nil;
        if (fpCurve) [fpCurve release]; fpCurve = nil;
        if (tmpX9ECPoint) [tmpX9ECPoint release]; tmpX9ECPoint = nil;
#endif
    }
    return [parameters autorelease];
}

@end
