//
//  DERGraphicString.m
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERGraphicString.h"
#import "StreamUtil.h"
#import "StringsEx.h"
#import "Arrays.h"
#import "ASN1OctetString.h"

@interface DERGraphicString ()

@property (nonatomic, readwrite, retain) NSMutableData *string;

@end

@implementation DERGraphicString
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

+ (DERGraphicString *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DERGraphicString class]]) {
        return (DERGraphicString *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return (DERGraphicString *)[self fromByteArray:(NSMutableData *)paramObject];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"encoding error in getInstance: %@", exception.description] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (DERGraphicString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localASN1Primitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localASN1Primitive isKindOfClass:[DERGraphicString class]]) {
        return [DERGraphicString getInstance:localASN1Primitive];
    }
    return [[[DERGraphicString alloc] initParamArrayOfByte:[((ASN1OctetString *)localASN1Primitive) getOctets]] autorelease];
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        NSMutableData *tmpData = [Arrays cloneWithByteArray:paramArrayOfByte];
        self.string = tmpData;
#if !__has_feature(objc_arc)
    if (tmpData) [tmpData release]; tmpData = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
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
    [paramASN1OutputStream writeEncoded:25 paramArrayOfByte:self.string];
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[DERGraphicString class]]) {
        return NO;
    }
    DERGraphicString *localDERGraphicString = (DERGraphicString *)paramASN1Primitive;
    return [Arrays areEqualWithByteArray:self.string withB:localDERGraphicString.string];
}

- (NSString *)getString {
    return [StringsEx fromByteArray:self.string];
}

- (NSUInteger)hash {
    return [Arrays getHashCodeWithByteArray:self.string];
}

@end
