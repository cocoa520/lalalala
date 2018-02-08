//
//  ECPublicKeyImportCompact.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "ECPublicKeyImportCompact.h"
#import "BigInteger.h"
#import "BigIntegers.h"
#import "ECAssistant.h"
#import "ECPointsCompact.h"
#import "ECKeyFactories.h"
#import "Hex.h"
#import "X9ECParameters.h"

@implementation ECPublicKeyImportCompact

+ (ECPublicKeyImportCompact*)instance {
    static ECPublicKeyImportCompact *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[ECPublicKeyImportCompact alloc] init];
        }
    }
    return _instance;
}

- (id)importKey:(NSString*)curveName withData:(NSMutableData*)data {
    id retVal = nil;
    @autoreleasepool {
        @try {
            X9ECParameters *x9ECParameters = [ECAssistant x9ECParameters:curveName];
            int fieldLength = [ECAssistant fieldLengthWithX9ECParameters:x9ECParameters];
            if ([self fieldLength:(int)(data.length)] != fieldLength) {
                NSLog(@"-- importKey() - bad data length: %d curve: %@ data: 0x%@", (int)(data.length), curveName, [NSString dataToHex:data]);
            }
            
            BigInteger *x = [BigIntegers fromData:data];
            BigInteger *y = [ECPointsCompact y:[x9ECParameters curve] withX:x];
            
            retVal = [ECKeyFactories publicKeyFactory:x withY:y withCurveName:curveName];
            [retVal retain];            
        }
        @catch (NSException *exception) {
        }
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (int)fieldLength:(int)dataLength {
    return dataLength > 0 ? dataLength : -1;
}

@end
