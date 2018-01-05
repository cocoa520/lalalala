//
//  ASN1Encoding.m
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Encoding.h"

@implementation ASN1Encoding

+ (NSString *)DER {
    static NSString *_der = nil;
    @synchronized(self) {
        if (!_der) {
            _der = [[NSString alloc] initWithString:@"DER"];
        }
    }
    return _der;
}

+ (NSString *)DL {
    static NSString *_dl = nil;
    @synchronized(self) {
        if (!_dl) {
            _dl = [[NSString alloc] initWithString:@"DL"];
        }
    }
    return _dl;
}

+ (NSString *)BER {
    static NSString *_ber = nil;
    @synchronized(self) {
        if (!_ber) {
            _ber = [[NSString alloc] initWithString:@"BER"];
        }
    }
    return _ber;
}

@end
