//
//  DERUTF8String.m
//  crypto
//
//  Created by JGehry on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERUTF8String.h"
#import "StringsEx.h"
#import "Arrays.h"
#import "StreamUtil.h"
#import "ASN1OctetString.h"

@interface DERUTF8String ()

@property (nonatomic, readwrite, retain) NSMutableData *string;

@end

@implementation DERUTF8String
@synthesize string = _string;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_string) {
        [_string release];
        _string = nil;
    }
    [super dealloc];
#endif
}

+ (DERUTF8String *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DERUTF8String class]]) {
        return (DERUTF8String *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return (DERUTF8String *)[self fromByteArray:(NSMutableData *)paramObject];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"encoding error in getInstance: %@", exception.description] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (DERUTF8String *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localASN1Primitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localASN1Primitive isKindOfClass:[DERUTF8String class]]) {
        return [DERUTF8String getInstance:localASN1Primitive];
    }
    return [[[DERUTF8String alloc] initParamArrayOfByte:[[ASN1OctetString getInstance:localASN1Primitive] getOctets]] autorelease];
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        self.string = paramArrayOfByte;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString
{
    if (self = [super init]) {
        @autoreleasepool {
            self.string = [StringsEx toUtf8ByteArrayWithString:paramString];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSString *)getString {
    return [StringsEx fromUtf8ByteArray:self.string];
}

- (NSString *)toString {
    return [self getString];
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[DERUTF8String class]]) {
        return NO;
    }
    DERUTF8String *localDERUTF8String = (DERUTF8String *)paramASN1Primitive;
    return [Arrays areEqualWithByteArray:self.string withB:localDERUTF8String.string];
}

- (BOOL)isConstructed {
    return NO;
}

- (int)encodedLength {
    return 1 + [StreamUtil calculateBodyLength:(int)self.string.length] + (int)self.string.length;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    [paramASN1OutputStream writeEncoded:12 paramArrayOfByte:self.string];
}

- (NSUInteger)hash {
    return [Arrays getHashCodeWithByteArray:self.string];
}

@end
