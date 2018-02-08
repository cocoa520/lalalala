//
//  DERT61UTF8String.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERT61UTF8String.h"
#import "DERT61String.h"
#import "ASN1OctetString.h"
#import "StringsEx.h"
#import "StreamUtil.h"
#import "Arrays.h"

@interface DERT61UTF8String ()

@property (nonatomic, readwrite, retain) NSMutableData *string;

@end

@implementation DERT61UTF8String
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

+ (DERT61UTF8String *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[DERT61String class]]) {
        return [[[DERT61UTF8String alloc] initParamArrayOfByte:[((DERT61String *)paramObject) getOctets]] autorelease];
    }
    if (!paramObject || [paramObject isKindOfClass:[DERT61UTF8String class]]) {
        return (DERT61UTF8String *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return [[[DERT61UTF8String alloc] initParamArrayOfByte:[((DERT61String *)[self fromByteArray:(NSMutableData *)paramObject]) getOctets]] autorelease];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"encoding error in getInstance: %@", exception.description] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (DERT61UTF8String *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localASN1Primitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localASN1Primitive isKindOfClass:[DERT61String class]] || [localASN1Primitive isKindOfClass:[DERT61UTF8String class]]) {
        return [DERT61UTF8String getInstance:localASN1Primitive];
    }
    return [[[DERT61UTF8String alloc] initParamArrayOfByte:[[ASN1OctetString getInstance:localASN1Primitive] getOctets]] autorelease];
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
        [self initParamArrayOfByte:[StringsEx toUtf8ByteArrayWithString:paramString]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSString *)getString {
    return [StringsEx fromUtf8ByteArray:(NSData *)self.string];
}

- (NSString *)toString {
    return [self getString];
}

- (BOOL)isConstructed {
    return NO;
}

- (int)encodedLength {
    return 1 + [StreamUtil calculateBodyLength:(int)[self.string length]] + (int)[self.string length];
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    [paramASN1OutputStream writeEncoded:20 paramArrayOfByte:self.string];
}

- (NSMutableData *)getOctets {
    return [[Arrays cloneWithByteArray:self.string] autorelease];
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[DERT61UTF8String class]]) {
        return NO;
    }
    return [Arrays areEqualWithByteArray:self.string withB:[((DERT61UTF8String *)paramASN1Primitive) string]];
}

- (NSUInteger)hash {
    return [Arrays getHashCodeWithByteArray:self.string];
}

@end
