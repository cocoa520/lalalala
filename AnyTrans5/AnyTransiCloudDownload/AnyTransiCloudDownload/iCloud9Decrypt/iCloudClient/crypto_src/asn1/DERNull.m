//
//  DERNull.m
//  crypto
//
//  Created by JGehry on 6/2/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERNull.h"

@implementation DERNull

+ (DERNull *)INSTANCE {
    static DERNull *_INSTANCE = nil;
    @synchronized(self) {
        if (!_INSTANCE) {
            _INSTANCE = [[DERNull alloc] init];
        }
    }
    return _INSTANCE;
}

+ (NSMutableData *)zeroBytes {
    static NSMutableData *_zeroBytes = nil;
    @synchronized(self) {
        if (!_zeroBytes) {
            _zeroBytes = [[NSMutableData alloc] initWithSize:0];
        }
    }
    return _zeroBytes;
}

- (BOOL)isConstructed {
    return NO;
}

- (int)encodedLength {
    return 2;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    [paramASN1OutputStream writeEncoded:5 paramArrayOfByte:[DERNull zeroBytes]];
}

@end
