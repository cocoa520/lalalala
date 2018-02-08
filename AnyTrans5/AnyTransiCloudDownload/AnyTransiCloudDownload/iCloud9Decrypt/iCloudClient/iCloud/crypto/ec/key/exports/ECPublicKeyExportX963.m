//
//  ECPublicKeyExportX963.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "ECPublicKeyExportX963.h"
#import "CategoryExtend.h"
#import "ECPublicKey.h"
#import "ECCurvePoint.h"
#import "ECKeyExportAssistant.h"

@implementation ECPublicKeyExportX963

+ (ECPublicKeyExportX963*)instance {
    static ECPublicKeyExportX963 *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[ECPublicKeyExportX963 alloc] init];
        }
    }
    return _instance;
}

- (NSMutableData*)exportKey:(id)keyData {
    if (keyData != nil && [keyData isKindOfClass:[ECPublicKey class]]) {
        NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:1];
        ((Byte*)(tmpData.bytes))[0] = (Byte)0x04;
        NSMutableData *retData = [ECKeyExportAssistant concatenate:tmpData, [[(ECPublicKey*)keyData getPoint] xEncoded], [[(ECPublicKey*)keyData getPoint] yEncoded], nil];
#if !__has_feature(objc_arc)
        if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        return retData;
    } else {
        return nil;
    }
}

@end
