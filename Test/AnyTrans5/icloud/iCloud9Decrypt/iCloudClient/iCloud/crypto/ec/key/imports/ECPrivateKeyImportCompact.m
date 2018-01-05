//
//  ECPrivateKeyImportCompact.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "ECPrivateKeyImportCompact.h"
#import "BigInteger.h"
#import "BigIntegers.h"
#import "ECAssistant.h"
#import "ECPointsCompact.h"
#import "ECKeyFactories.h"
#import "Hex.h"
#import "X9ECParameters.h"
#import "ECPrivateKeyEx.h"

@implementation ECPrivateKeyImportCompact

+ (ECPrivateKeyImportCompact*)instance {
    static ECPrivateKeyImportCompact *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[ECPrivateKeyImportCompact alloc] init];
        }
    }
    return _instance;
}

- (id)importKey:(NSString*)curveName withData:(NSMutableData*)data {
    ECPrivateKeyEx *ecEx = nil;
    X9ECParameters *x9ECParameters = [ECAssistant x9ECParameters:curveName];
    int fieldLength = [ECAssistant fieldLengthWithX9ECParameters:x9ECParameters];
    if ([self fieldLength:(int)(data.length)] != fieldLength) {
        NSLog(@"-- importKey() - bad data length: %d curve: %@ data: 0x%@", (int)(data.length), curveName, [NSString dataToHex:data]);
    }
    @autoreleasepool {
        @try {
            BigInteger *x = [BigIntegers fromData:data withOff:0 withLength:fieldLength];
            BigInteger *y = [ECPointsCompact y:[x9ECParameters curve] withX:x];
            BigInteger *d = [BigIntegers fromData:data withOff:fieldLength withLength:fieldLength];
            
            ecEx = [ECKeyFactories privateKeyFactory:x withY:y withD:d withCurveName:curveName];
            [ecEx retain];            
        }
        @catch (NSException *exception) {
        }
    }
    return (ecEx ? [ecEx autorelease] : nil);
}

- (int)fieldLength:(int)dataLength {
    return dataLength > 0 && dataLength % 2 == 0 ? dataLength / 2 : -1;
}

@end
