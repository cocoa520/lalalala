//
//  DERNumericString.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERNumericString.h"
#import "ASN1OctetString.h"
#import "StringsEx.h"
#import "Arrays.h"
#import "StreamUtil.h"

@interface DERNumericString ()

@property (nonatomic, readwrite, retain) NSMutableData *string;

@end

@implementation DERNumericString
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

+ (DERNumericString *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DERNumericString class]]) {
        return (DERNumericString *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return (DERNumericString *)[self fromByteArray:(NSMutableData *)paramObject];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"encoding error in getInstance: %@", exception.description] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (DERNumericString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localASN1Primitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localASN1Primitive isKindOfClass:[DERNumericString class]]) {
        return [DERNumericString getInstance:localASN1Primitive];
    }
    return [[[DERNumericString alloc] initParamArrayOfByte:[[ASN1OctetString getInstance:localASN1Primitive] getOctets]] autorelease];
}

+ (BOOL)isNumericString:(NSString *)paramString {
    for (int i = ((int)[paramString length] - 1); i >= 0; i--) {
        int j = [paramString characterAtIndex:i];
        if (j > 127) {
            return NO;
        }
        if (((j < 48) || (j > 57)) && (j != 32)) {
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
        if (paramBoolean && (![DERNumericString isNumericString:paramString])) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"string contains illegal characters" userInfo:nil];
        }
        @autoreleasepool {
            self.string = [StringsEx toByteArrayWithString:paramString];
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
    return 1 + [StreamUtil calculateBodyLength:(int)[self.string length]] + (int)[self.string length];
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    [paramASN1OutputStream writeEncoded:18 paramArrayOfByte:self.string];
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[DERNumericString class]]) {
        return NO;
    }
    DERNumericString *localDERNumericString = (DERNumericString *)paramASN1Primitive;
    return [Arrays areEqualWithByteArray:self.string withB:[localDERNumericString string]];
}

- (NSUInteger)hash {
    return [Arrays getHashCodeWithByteArray:self.string];
}

@end
