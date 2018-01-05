//
//  ASN1Boolean.m
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Boolean.h"
#import "ASN1OctetString.h"
#import "Arrays.h"

@interface ASN1Boolean ()

@property (nonatomic, readwrite, retain) NSMutableData *value;

@end

@implementation ASN1Boolean
@synthesize value = _value;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_value) {
        [_value release];
        _value = nil;
    }
    [super dealloc];
#endif
}

+ (NSMutableData *)TRUE_VALUE {
    static NSMutableData *_TRUE_VALUE = nil;
    @synchronized(self) {
        if (!_TRUE_VALUE) {
            _TRUE_VALUE = [[NSMutableData alloc] initWithSize:1];
            ((Byte*)(_TRUE_VALUE.bytes))[0] = -1;
        }
    }
    return _TRUE_VALUE;
}

+ (NSMutableData *)FALSE_VALUE {
    static NSMutableData *_FALSE_VALUE = nil;
    @synchronized(self) {
        if (!_FALSE_VALUE) {
            _FALSE_VALUE = [[NSMutableData alloc] initWithSize:1];
            ((Byte*)(_FALSE_VALUE.bytes))[0] = -1;
        }
    }
    return _FALSE_VALUE;
}

+ (ASN1Boolean *)FALSEALLOC {
    static ASN1Boolean *_falseAlloc = false;
    @synchronized(self) {
        if (!_falseAlloc) {
            _falseAlloc = [[ASN1Boolean alloc] initParamBoolean:NO];
        }
    }
    return _falseAlloc;
}

+ (ASN1Boolean *)TRUEALLOC {
    static ASN1Boolean *_trueAlloc = false;
    @synchronized(self) {
        if (!_trueAlloc) {
            _trueAlloc = [[ASN1Boolean alloc] initParamBoolean:YES];
        }
    }
    return _trueAlloc;
}

+ (ASN1Boolean *)getInstanceObject:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[ASN1Boolean class]]) {
        return (ASN1Boolean *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        NSMutableData *arrayOfByte = (NSMutableData *)paramObject;
        @try {
            return (ASN1Boolean *)[self fromByteArray:arrayOfByte];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"failed to construct boolean from byte[]: %@", exception.description] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (ASN1Boolean *)getInstanceBoolean:(BOOL)paramBoolean {
    return paramBoolean ? [self TRUEALLOC] : [self FALSEALLOC];
}

+ (ASN1Boolean *)getInstanceInt:(int)paramInt {
    return paramInt != 0 ? [self TRUEALLOC] : [self FALSEALLOC];
}

+ (ASN1Boolean *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localASN1Primitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localASN1Primitive isKindOfClass:[ASN1Boolean class]]) {
        return [self getInstanceObject:localASN1Primitive];
    }
    return [self fromOctetString:[((ASN1OctetString *)localASN1Primitive) getOctets]];
}

+ (ASN1Boolean *)fromOctetString:(NSMutableData *)paramArrayOfByte {
    if (paramArrayOfByte.length != 1) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"BOOLEAN value should have 1 byte in it" userInfo:nil];
    }
    if (((Byte *)[paramArrayOfByte bytes])[0] == 0) {
        return [self FALSEALLOC];
    }
    if ((((Byte *)[paramArrayOfByte bytes])[0] & 0xFF) == 255) {
        return [self TRUEALLOC];
    }
    return [[[ASN1Boolean alloc] initParamArrayOfByte:paramArrayOfByte] autorelease];
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        if (paramArrayOfByte.length != 1) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"byte value should have 1 byte in it" userInfo:nil];
        }
        if (((Byte *)[paramArrayOfByte bytes])[0] == 0) {
            self.value = [ASN1Boolean FALSE_VALUE];
        }else if ((((Byte *)[paramArrayOfByte bytes])[0] & 0xFF) == 255) {
            self.value = [ASN1Boolean TRUE_VALUE];
        }else {
            NSMutableData *tmpValue = [Arrays cloneWithByteArray:paramArrayOfByte];
            self.value = tmpValue;
#if !__has_feature(objc_arc)
    if (tmpValue) [tmpValue release]; tmpValue = nil;
#endif
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBoolean:(BOOL)paramBoolean
{
    if (self = [super init]) {
        self.value = (paramBoolean ? [ASN1Boolean TRUE_VALUE] : [ASN1Boolean FALSE_VALUE]);
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (BOOL)isTrue {
    return ((Byte *)[self.value bytes])[0] != 0;
}

- (BOOL)isConstructed {
    return NO;
}

- (int)encodedLength {
    return 3;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    [paramASN1OutputStream writeEncoded:1 paramArrayOfByte:self.value];
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if ([paramASN1Primitive isKindOfClass:[ASN1Boolean class]]) {
        return ((Byte *)[self.value bytes])[0] == ((Byte *)[[((ASN1Boolean *)paramASN1Primitive) value] bytes])[0];
    }
    return NO;
}

- (NSString *)toString {
    return ((Byte *)[self.value bytes])[0] != 0 ? @"TRUE" : @"FALSE";
}

- (NSUInteger)hash {
    return ((Byte*)[self.value bytes])[0];
}

@end
