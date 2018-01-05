//
//  ECPublicKeyImportX963.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "ECPublicKeyImportX963.h"
#import "BigInteger.h"
#import "BigIntegers.h"
#import "ECAssistant.h"
#import "ECKeyFactories.h"
#import "Hex.h"
#import "CategoryExtend.h"
#import "ECPublicKey.h"

@implementation ECPublicKeyImportX963

+ (ECPublicKeyImportX963*)instance {
    static ECPublicKeyImportX963 *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[ECPublicKeyImportX963 alloc] init];
        }
    }
    return _instance;
}

- (id)importKey:(NSString*)curveName withData:(NSMutableData*)data {
    int fieldLength = [ECAssistant fieldLengthWithCurveName:curveName];
    if ([self fieldLength:(int)(data.length)] != fieldLength) {
        NSLog(@"-- importKey() - bad data length: %d curve: %@ data: 0x%@", (int)(data.length), curveName, [NSString dataToHex:data]);
    }
    
    int b0 = (int)(((Byte*)(data.bytes))[0]);
    if (![self checkType:b0]) {
        NSLog(@"-- importKey() - bad data type: %d", b0);
    }
    
    ECPublicKey *ecKey = nil;
    @autoreleasepool {
        @try {
            BigInteger *x = [BigIntegers fromData:data withOff:1 withLength:fieldLength];
            BigInteger *y = [BigIntegers fromData:data withOff:(1 + fieldLength) withLength:fieldLength];
            
            ecKey = [[ECKeyFactories publicKeyFactory:x withY:y withCurveName:curveName] retain];
        }
        @catch (NSException *exception) {
        }
    }
    return (ecKey ? [ecKey autorelease] : nil);
}

- (BOOL)checkType:(int)type {
    switch (type) {
        case 0x04:
        case 0x06: /* legacy */
        case 0x07: /* legacy */ {
            return YES;
        }
        default: {
            return NO;
        }
    }
}

- (int)fieldLength:(int)dataLength {
    return dataLength > 0 && dataLength % 2 == 1 ? (dataLength - 1) / 2 : -1;
}

@end
