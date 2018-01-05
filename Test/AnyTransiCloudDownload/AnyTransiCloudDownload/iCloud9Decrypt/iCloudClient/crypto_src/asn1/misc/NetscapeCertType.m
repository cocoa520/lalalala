//
//  NetscapeCertType.m
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "NetscapeCertType.h"
#import "ASN1BitString.h"

@implementation NetscapeCertType

+ (int)sslClient {
    static int _sslClient = 0;
    @synchronized(self) {
        if (!_sslClient) {
            _sslClient = 128;
        }
    }
    return _sslClient;
}

+ (int)sslServer {
    static int _sslServer = 0;
    @synchronized(self) {
        if (!_sslServer) {
            _sslServer = 64;
        }
    }
    return _sslServer;
}

+ (int)smime {
    static int _smime = 0;
    @synchronized(self) {
        if (!_smime) {
            _smime = 32;
        }
    }
    return _smime;
}

+ (int)objectSigning {
    static int _objectSigning = 0;
    @synchronized(self) {
        if (!_objectSigning) {
            _objectSigning = 16;
        }
    }
    return _objectSigning;
}

+ (int)reserved {
    static int _reserved = 0;
    @synchronized(self) {
        if (!_reserved) {
            _reserved = 8;
        }
    }
    return _reserved;
}

+ (int)sslCA {
    static int _sslCA = 0;
    @synchronized(self) {
        if (!_sslCA) {
            _sslCA = 4;
        }
    }
    return _sslCA;
}

+ (int)smimeCA {
    static int _smimeCA = 0;
    @synchronized(self) {
        if (!_smimeCA) {
            _smimeCA = 2;
        }
    }
    return _smimeCA;
}

+ (int)objectSigningCA {
    static int _objectSigningCA = 0;
    @synchronized(self) {
        if (!_objectSigningCA) {
            _objectSigningCA = 1;
        }
    }
    return _objectSigningCA;
}

- (instancetype)initParamInt:(int)paramInt
{
    self = [super initParamArrayOfByte:[ASN1BitString getBytes:paramInt] paramInt:[ASN1BitString getPadBits:paramInt]];
    if (self) {
        
    }
    return self;
}

- (instancetype)initParamDERBitString:(DERBitString *)paramDERBitString
{
    self = [super initParamArrayOfByte:[paramDERBitString getBytes] paramInt:[paramDERBitString getPadBits]];
    if (self) {
        
    }
    return self;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"NetscapeCertType: 0x"];
}

@end
