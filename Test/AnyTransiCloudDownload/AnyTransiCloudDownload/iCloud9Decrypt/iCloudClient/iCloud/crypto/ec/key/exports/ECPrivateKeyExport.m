//
//  ECPrivateKeyExport.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "ECPrivateKeyExport.h"
#import "ECPrivateKeyEx.h"

@implementation ECPrivateKeyExport

+ (ECPrivateKeyExport*)instance {
    static ECPrivateKeyExport *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[ECPrivateKeyExport alloc] init];
        }
    }
    return _instance;
}

- (NSMutableData*)exportKey:(id)keyData {
    if (keyData != nil && [keyData isKindOfClass:[ECPrivateKeyEx class]]) {
        return [(ECPrivateKeyEx*)keyData dEncoded];
    } else {
        return nil;
    }
}

@end
