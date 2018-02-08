//
//  DERGeneralString.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERGeneralString.h"
#import "StringsEx.h"
#import "Arrays.h"
#import "StreamUtil.h"
#import "ASN1OctetString.h"

@interface DERGeneralString ()

@property (nonatomic, readwrite, retain) NSMutableData *string;

@end

@implementation DERGeneralString
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

+ (DERGeneralString *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DERGeneralString class]]) {
        return (DERGeneralString *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return (DERGeneralString *)[self fromByteArray:(NSMutableData *)paramObject];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"encoding error in getInstance: %@", exception.description] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (DERGeneralString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localASN1Primitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localASN1Primitive isKindOfClass:[DERGeneralString class]]) {
        return [DERGeneralString getInstance:localASN1Primitive];
    }
    return [[[DERGeneralString alloc] initParamArrayOfByte:[((ASN1OctetString *)localASN1Primitive) getOctets]] autorelease];
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
    [paramASN1OutputStream writeEncoded:27 paramArrayOfByte:self.string];
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[DERGeneralString class]]) {
        return NO;
    }
    DERGeneralString *localDERGeneralString = (DERGeneralString *)paramASN1Primitive;
    return [Arrays areEqualWithByteArray:self.string withB:[localDERGeneralString string]];
}

- (NSUInteger)hash {
    return [Arrays getHashCodeWithByteArray:self.string];
}

@end
