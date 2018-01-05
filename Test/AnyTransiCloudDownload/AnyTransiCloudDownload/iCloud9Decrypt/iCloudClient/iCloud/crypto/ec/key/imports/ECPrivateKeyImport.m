//
//  ECPrivateKeyImport.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "ECPrivateKeyImport.h"
#import "BigInteger.h"
#import "BigIntegers.h"
#import "ECAssistant.h"
#import "ECKeyFactories.h"
#import "Hex.h"
#import "CategoryExtend.h"
#import "ECPrivateKeyEx.h"

@implementation ECPrivateKeyImport

+ (ECPrivateKeyImport*)instance {
    static ECPrivateKeyImport *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[ECPrivateKeyImport alloc] init];
        }
    }
    return _instance;
}

- (id)importKey:(NSString*)curveName withData:(NSMutableData*)data {
    int fieldLength = [ECAssistant fieldLengthWithCurveName:curveName];
    if ([self fieldLength:(int)(data.length)] != fieldLength) {
        NSLog(@"-- importKey() - bad data length: %d curve: %@ data: 0x%@", (int)(data.length), curveName, [NSString dataToHex:data]);
    }
    ECPrivateKeyEx *ecEx = nil;
    @autoreleasepool {
        @try {
            BigInteger *d = [BigIntegers fromData:data withOff:0 withLength:fieldLength];
            ecEx = [[ECKeyFactories privateKeyFactory:d withCurveName:curveName] retain];            
        }
        @catch (NSException *exception) {
        }
    }
    return (ecEx ? [ecEx autorelease] : nil);
}

- (int)fieldLength:(int)dataLength {
    return dataLength > 0 ? dataLength : -1;
}

@end
