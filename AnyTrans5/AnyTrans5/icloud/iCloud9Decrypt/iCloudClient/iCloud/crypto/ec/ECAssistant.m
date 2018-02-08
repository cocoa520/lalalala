//
//  ECAssistant.m
//  
//
//  Created by Pallas on 7/28/16.
//
//  Complete

#import "ECAssistant.h"
#import "BigIntegers.h"
#import "ECCurve.h"
#import "ECNamedCurveTable.h"
#import "ECDomainParameters.h"
#import "X9ECParameters.h"

@implementation ECAssistant

+ (NSString*)fieldLengthToCurveName:(NSArray*)curveNames withDataLength:(int)dataLength {
    NSString *retCurveName = nil;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSEnumerator *iterator = [curveNames objectEnumerator];
    NSString *value = nil;
    while (value = [iterator nextObject]) {
        [dict setObject:value forKey:[NSString stringWithFormat:@"%d", [ECAssistant fieldLengthWithCurveName:value]]];
    }
    NSString *dataLengthStr = [NSString stringWithFormat:@"%d", dataLength];
    if ([dict.allKeys containsObject:dataLengthStr]) {
        retCurveName = [[[NSString alloc] initWithString:((NSString*)[dict objectForKey:dataLengthStr])] autorelease];
    }
#if !__has_feature(objc_arc)
    if (dict != nil) [dict release]; dict = nil;
#endif
    return retCurveName;
}

+ (int)fieldLengthWithCurveName:(NSString *)curveName {
    return [ECAssistant fieldLengthWithX9ECParameters:[ECAssistant x9ECParameters:curveName]];
}

+ (int)fieldLengthWithX9ECParameters:(X9ECParameters*)x9ECParameters {
    return [ECAssistant fieldLengthWithECCurve:[x9ECParameters curve]];
}

+ (int)fieldLengthWithECCurve:(ECCurve*)curve {
    return [ECAssistant fieldLengthWithInt:[curve fieldSize]];
}

+ (int)fieldLengthWithInt:(int)fieldBitLength {
    return (fieldBitLength + 7) / 8;
}

+ (NSMutableData*)encodedField:(int)length withBigInteger:(BigInteger*)i {
    return [BigIntegers asUnsignedByteArray:length withN:i];
}

+ (X9ECParameters*)x9ECParameters:(NSString*)curveName {
    X9ECParameters *x9ECParameters = [ECNamedCurveTable getByName:curveName];
    if (!x9ECParameters) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"unsupported elliptic curve: %@", curveName] userInfo:nil];
    }
    return x9ECParameters;
}

+ (ECDomainParameters*)ecDomainParametersFrom:(X9ECParameters*)x9ECParameters {
    return [[[ECDomainParameters alloc] initWithCurve:[x9ECParameters curve] withG:[x9ECParameters getG] withN:[x9ECParameters getN] withH:[x9ECParameters getH] withSeed:[x9ECParameters getSeed]] autorelease];
}

@end
