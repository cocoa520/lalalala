//
//  DERIA5String.m
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERIA5String.h"
#import "StringsEx.h"
#import "ASN1OctetString.h"
#import "Arrays.h"
#import "StreamUtil.h"

@interface DERIA5String ()

@property (nonatomic, readwrite, retain) NSMutableData *string;

@end

@implementation DERIA5String
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

+ (DERIA5String *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DERIA5String class]]) {
        return (DERIA5String *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return (DERIA5String *)[self fromByteArray:(NSMutableData *)paramObject];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"encoding error in getInstance: %@", exception.description] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (DERIA5String *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localASN1Primitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localASN1Primitive isKindOfClass:[DERIA5String class]]) {
        return [DERIA5String getInstance:localASN1Primitive];
    }
    return [[[DERIA5String alloc] initParamArrayOfByte:[((ASN1OctetString *)localASN1Primitive) getOctets]] autorelease];
}

+ (BOOL)isIA5String:(NSString *)paramString {
    for (int i = (int)paramString.length - 1; i >= 0; i--) {
        int j = [paramString characterAtIndex:i];
        if (j > 127) {
            return NO;
        }
    }
    return YES;
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
        [self initParamString:paramString paramBoolean:NO];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString paramBoolean:(BOOL)paramBoolean
{
    if (self = [super init]) {
        if (!paramString) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"string cannot be null" userInfo:nil];
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
    return [StringsEx fromByteArray:self.string];
}

- (NSString *)toString {
    return [self getString];
}

- (NSMutableData *)getOctets {
    return [[Arrays cloneWithByteArray:self.string] autorelease];
}

- (BOOL)isConstructed {
    return NO;
}

- (int)encodedLength {
    return 1 + [StreamUtil calculateBodyLength:(int)self.string.length] + (int)self.string.length;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    [paramASN1OutputStream writeEncoded:22 paramArrayOfByte:self.string];
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[DERIA5String class]]) {
        return NO;
    }
    DERIA5String *localDERIA5String = (DERIA5String *)paramASN1Primitive;
    return [Arrays areEqualWithByteArray:self.string withB:localDERIA5String.string];
}

- (NSUInteger)hash {
    return [Arrays getHashCodeWithByteArray:self.string];
}

@end
