//
//  ECPublicKeyExportCompact.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "ECPublicKeyExportCompact.h"
#import "ECCurvePoint.h"
#import "ECPublicKey.h"

@implementation ECPublicKeyExportCompact

+ (ECPublicKeyExportCompact*)instance {
    static ECPublicKeyExportCompact *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[ECPublicKeyExportCompact alloc] init];
        }
    }
    return _instance;
}

- (NSMutableData*)exportKey:(id)keyData {
    if (keyData != nil && [keyData isKindOfClass:[ECPublicKey class]]) {
        return [[(ECPublicKey*)keyData getPoint] xEncoded];
    } else {
        return nil;
    }
}

@end
