//
//  KeyUsage.m
//  crypto
//
//  Created by JGehry on 7/11/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "KeyUsage.h"
#import "Extension.h"

@interface KeyUsage ()

@property (nonatomic, readwrite, retain) DERBitString *bitString;

@end

@implementation KeyUsage
@synthesize bitString = _bitString;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_bitString) {
        [_bitString release];
        _bitString = nil;
    }
    [super dealloc];
#endif
}

+ (int)digitalSignature {
    static int _digitalSignature = 0;
    @synchronized(self) {
        if (!_digitalSignature) {
            _digitalSignature = 128;
        }
    }
    return _digitalSignature;
}

+ (int)nonRepudiation {
    static int _nonRepudiation = 0;
    @synchronized(self) {
        if (!_nonRepudiation) {
            _nonRepudiation = 64;
        }
    }
    return _nonRepudiation;
}

+ (int)keyEncipherment {
    static int _keyEncipherment = 0;
    @synchronized(self) {
        if (!_keyEncipherment) {
            _keyEncipherment = 32;
        }
    }
    return _keyEncipherment;
}

+ (int)dataEncipherment {
    static int _dataEncipherment = 0;
    @synchronized(self) {
        if (!_dataEncipherment) {
            _dataEncipherment = 16;
        }
    }
    return _dataEncipherment;
}

+ (int)keyAgreement {
    static int _keyAgreement = 0;
    @synchronized(self) {
        if (!_keyAgreement) {
            _keyAgreement = 8;
        }
    }
    return _keyAgreement;
}

+ (int)keyCertSign {
    static int _keyCertSign = 0;
    @synchronized(self) {
        if (!_keyCertSign) {
            _keyCertSign = 4;
        }
    }
    return _keyCertSign;
}

+ (int)cRLSign {
    static int _cRLSign = 0;
    @synchronized(self) {
        if (!_cRLSign) {
            _cRLSign = 2;
        }
    }
    return _cRLSign;
}

+ (int)encipherOnly {
    static int _encipherOnly = 0;
    @synchronized(self) {
        if (!_encipherOnly) {
            _encipherOnly = 1;
        }
    }
    return _encipherOnly;
}

+ (int)decipherOnly {
    static int _decipherOnly = 0;
    @synchronized(self) {
        if (!_decipherOnly) {
            _decipherOnly = 32768;
        }
    }
    return _decipherOnly;
}

+ (KeyUsage *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[KeyUsage class]]) {
        return (KeyUsage *)paramObject;
    }
    if (paramObject) {
        return [[[KeyUsage alloc] initParamDERBitString:[DERBitString getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (KeyUsage *)fromExtensions:(Extensions *)paramExtensions {
    return [KeyUsage getInstance:[paramExtensions getExtensionParsedValue:[Extension keyUsage]]];
}

- (instancetype)initParamInt:(int)paramInt
{
    if (self = [super init]) {
        DERBitString *derBitString = [[DERBitString alloc] initParamInt:paramInt];
        self.bitString = derBitString;
#if !__has_feature(objc_arc)
    if (derBitString) [derBitString release]; derBitString = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamDERBitString:(DERBitString *)paramDERBitString
{
    if (self = [super init]) {
        self.bitString = paramDERBitString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (BOOL)hasUsages:(int)paramInt {
    return (([self.bitString intValue] & paramInt) == paramInt);
}

- (NSMutableData *)getBytes {
    return [self.bitString getBytes];
}

- (int)getPadBits {
    return [self.bitString getPadBits];
}

- (NSString *)toString {
    NSMutableData *arrayOfByte = [self.bitString getBytes];
    if (arrayOfByte.length == 1) {
    }
    return @"KeyUsage: 0x";
}

- (ASN1Primitive *)toASN1Primitive {
    return self.bitString;
}

@end
