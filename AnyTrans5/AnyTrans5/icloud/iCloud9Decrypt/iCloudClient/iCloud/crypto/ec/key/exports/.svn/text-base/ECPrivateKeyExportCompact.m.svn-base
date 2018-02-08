//
//  ECPrivateKeyExportCompact.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "ECPrivateKeyExportCompact.h"
#import "ECPrivateKeyEx.h"
#import "ECCurvePoint.h"
#import "ECKeyExportAssistant.h"

@implementation ECPrivateKeyExportCompact

+ (ECPrivateKeyExportCompact*)instance {
    static ECPrivateKeyExportCompact *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[ECPrivateKeyExportCompact alloc] init];
        }
    }
    return _instance;
}

- (NSMutableData*)exportKey:(id)keyData {
    if (keyData != nil && [keyData isKindOfClass:[ECPrivateKeyEx class]]) {
        return [ECKeyExportAssistant concatenate:[[(ECPrivateKeyEx*)keyData getPoint] xEncoded], [(ECPrivateKeyEx*)keyData dEncoded], nil];
    } else {
        return nil;
    }
}

@end
