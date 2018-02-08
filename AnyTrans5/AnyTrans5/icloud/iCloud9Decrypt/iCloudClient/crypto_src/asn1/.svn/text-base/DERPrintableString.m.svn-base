//
//  DERPrintableString.m
//  crypto
//
//  Created by JGehry on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERPrintableString.h"
#import "StringsEx.h"
#import "Arrays.h"
#import "StreamUtil.h"
#import "ASN1OctetString.h"

@interface DERPrintableString ()

@property (nonatomic, readwrite, retain) NSMutableData *string;

@end

@implementation DERPrintableString
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

+ (DERPrintableString *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DERPrintableString class]]) {
        return (DERPrintableString *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return (DERPrintableString *)[self fromByteArray:(NSMutableData *)paramObject];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"encoding error in getInstance: %@", exception.description] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (DERPrintableString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localASN1Primitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localASN1Primitive isKindOfClass:[DERPrintableString class]]) {
        return [DERPrintableString getInstance:localASN1Primitive];
    }
    return [[[DERPrintableString alloc] initParamArrayOfByte:[[ASN1OctetString getInstance:localASN1Primitive] getOctets]] autorelease];
}

+ (BOOL)isPrintableString:(NSString *)paramString {
    for (int i = ((int)paramString.length - 1); i >= 0; i--) {
        int j = [paramString characterAtIndex:i];
        if (j > 127) {
            return NO;
        }
        if (((97 > j) || (j > 122)) && ((65 > j) || (j > 90)) && ((48 > j) || (j > 57))) {
            switch (j) {
                case 32:
                case 39:
                case 40:
                case 41:
                case 43:
                case 44:
                case 45:
                case 46:
                case 47:
                case 58:
                case 61:
                case 63:
                    break;
                case 33:
                case 34:
                case 35:
                case 36:
                case 37:
                case 38:
                case 42:
                case 48:
                case 49:
                case 50:
                case 51: 
                case 52: 
                case 53: 
                case 54: 
                case 55: 
                case 56: 
                case 57: 
                case 59: 
                case 60: 
                case 62:
                default:
                    return NO;
            }
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
        if (paramBoolean && (![DERPrintableString isPrintableString:paramString])) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"string contains illegal characters" userInfo:nil];
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
    return 1 + [StreamUtil calculateBodyLength:(int)self.string.length] + (int)self.string.length;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    [paramASN1OutputStream writeEncoded:19 paramArrayOfByte:self.string];
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[DERPrintableString class]]) {
        return NO;
    }
    DERPrintableString *localDERPrintableString = (DERPrintableString *)paramASN1Primitive;
    return [Arrays areEqualWithByteArray:self.string withB:localDERPrintableString.string];
}

- (NSUInteger)hash {
    return [Arrays getHashCodeWithByteArray:self.string];
}

@end
