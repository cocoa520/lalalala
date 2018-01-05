//
//  ASN1ObjectIdentifier.m
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1ObjectIdentifier.h"
#import "ASN1Encodable.h"
#import "ASN1OctetString.h"
#import "BigInteger.h"
#import "CategoryExtend.h"
#import "Arrays.h"
#import "StreamUtil.h"
#import "OIDTokenizer.h"

@interface ASN1ObjectIdentifier ()

@property (nonatomic, readwrite, retain) NSString *identifier;
@property (nonatomic, readwrite, retain) NSMutableData *body;

@end

@implementation ASN1ObjectIdentifier
@synthesize identifier = _identifier;
@synthesize body = _body;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_identifier) {
        [_identifier release];
        _identifier = nil;
    }
    if (_body) {
        [_body release];
        _body = nil;
    }
    [super dealloc];
#endif
}

+ (NSMutableDictionary *)pool {
    static NSMutableDictionary *_pool = nil;
    @synchronized(self) {
        if (!_pool) {
            _pool = [[NSMutableDictionary alloc] init];
        }
    }
    return _pool;
}

+ (ASN1ObjectIdentifier *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[ASN1ObjectIdentifier class]]) {
        return (ASN1ObjectIdentifier *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Encodable class]] && [[((ASN1Encodable *)paramObject) toASN1Primitive] isKindOfClass:[ASN1ObjectIdentifier class]]) {
        return (ASN1ObjectIdentifier *)[((ASN1Encodable *)paramObject) toASN1Primitive];
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        NSMutableData *arrayOfByte = (NSMutableData *)paramObject;
        @try {
            return (ASN1ObjectIdentifier *)[self fromByteArray:arrayOfByte];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"failed to construct object identifier from byte[]: %@", exception.description] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (ASN1ObjectIdentifier *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localASN1Primitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localASN1Primitive isKindOfClass:[ASN1ObjectIdentifier class]]) {
        return [ASN1ObjectIdentifier getInstance:localASN1Primitive];
    }
    return [self fromOctetString:[[ASN1OctetString getInstance:[paramASN1TaggedObject getObject]] getOctets]];
}

+ (ASN1ObjectIdentifier *)fromOctetString:(NSMutableData *)paramArrayOfByte {
    OidHandle *localOidHandle = [[[OidHandle alloc] initParamArrayOfByte:paramArrayOfByte] autorelease];
    @synchronized(self) {
        ASN1ObjectIdentifier *localASN1ObjectIdentifier = (ASN1ObjectIdentifier *)[[self pool] objectForKey:localOidHandle];
        if (localASN1ObjectIdentifier) {
            return localASN1ObjectIdentifier;
        }
    }
    return [[[ASN1ObjectIdentifier alloc] initParamOfByte:paramArrayOfByte] autorelease];
}

- (instancetype)initParamOfByte:(NSMutableData *)paramOfByte
{
    if (self = [super init]) {
        NSMutableString *localMutString = [[[NSMutableString alloc] init] autorelease];
        long l = 0;
        BigInteger *localBigInteger = nil;
        int i = 1;
        for (int j = 0; j != paramOfByte.length; j++) {
            int k = (((Byte *)[paramOfByte bytes])[j] & 0xFF);
            if (l <= 72057594037927808) {
                l += (k & 0x7F);
                if ((k & 0x80) == 0) {
                    if (i != 0) {
                        if (l < 40) {
                            [localMutString appendString:@"0"];
                        }else if (l < 80) {
                            [localMutString appendString:@"1"];
                            l -= 40;
                        }else {
                            [localMutString appendString:@"2"];
                            l -= 80;
                        }
                        i = 0;
                    }
                    [localMutString appendString:@"."];
                    [localMutString appendString:[NSString stringWithFormat:@"%ld", l]];
                    l = 0;
                }else {
                    l <<= 7;
                }
            }else {
                if (!localBigInteger) {
                    localBigInteger = [BigInteger valueOf:l];
                }
                localBigInteger = [localBigInteger orWithValue:[BigInteger valueOf:(k & 0x7F)]];
                if ((k & 0x80) == 0) {
                    if (i) {
                        [localMutString appendString:@"2"];
                        localBigInteger = [localBigInteger subtractWithN:[BigInteger valueOf:80]];
                        i = 0;
                    }
                    [localMutString appendString:@"."];
                    [localMutString appendString:[NSString stringWithFormat:@"%@", localBigInteger]];
                    localBigInteger = nil;
                    l = 0;
                }else {
                    localBigInteger = [localBigInteger shiftLeftWithN:7];
                }
            }
        }
        self.identifier = [localBigInteger toString];
        NSMutableData *tmpData = [Arrays cloneWithByteArray:paramOfByte];
        self.body = tmpData;
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

- (instancetype)initParamString:(NSString *)paramString
{
    if (self = [super init]) {
        if (!paramString) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'identifier' cannot be null" userInfo:nil];
        }
        if (![ASN1ObjectIdentifier isValidIdentifier:paramString]) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"string %@ not an OID", paramString] userInfo:nil];
        }
        self.identifier = paramString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString
{
    if (self = [super init]) {
        if (![ASN1ObjectIdentifier isValidBranchID:paramString paramInt:0]) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"string %@ not a valid OID branch", paramString] userInfo:nil];
        }
        @autoreleasepool {
            self.identifier = [NSString stringWithFormat:@"%@.%@", [paramASN1ObjectIdentifier getId], paramString];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSString *)getId {
    return self.identifier;
}

- (ASN1ObjectIdentifier *)branch:(NSString *)paramString {
    return [[[ASN1ObjectIdentifier alloc] initParamASN1ObjectIdentifier:self paramString:paramString] autorelease];
}

- (BOOL)on:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    NSString *str1 = [self getId];
    NSString *str2 = [paramASN1ObjectIdentifier getId];
    return ((str1.length > str2.length) && ([str1 characterAtIndex:str2.length] == '.') && ([str1 startWithString:str2]));
}

- (void)writeField:(MemoryStreamEx *)paramByteArrayOutputStream paramLong:(long)paramLong {
    NSMutableData *arrayOfByte = [[NSMutableData alloc] initWithSize:9];
    int i = 8;
    ((Byte *)[arrayOfByte bytes])[i] = ((Byte)((int)paramLong  & 0x7F));
    while (paramLong >= 128) {
        paramLong >>= 7;
        ((Byte *)[arrayOfByte bytes])[--i] = ((Byte)(((int)paramLong & 0x7F) | 0x80));
    }
    [paramByteArrayOutputStream write:arrayOfByte withOffset:i withCount:9 - i];
#if !__has_feature(objc_arc)
    if (arrayOfByte) [arrayOfByte release]; arrayOfByte = nil;
#endif
}

- (void)writeField:(MemoryStreamEx *)paramByteArrayOutputStream paramBigInteger:(BigInteger *)paramBigInteger {
    int i = ([paramBigInteger bitLength] + 6) / 7;
    if (i == 0) {
        [paramByteArrayOutputStream writeWithByte:0];
    }else {
        BigInteger *localBigInteger = paramBigInteger;
        NSMutableData *arrayOfByte = [[NSMutableData alloc] initWithSize:i];
        for (int j = i - 1; j >= 0; j--) {
            ((Byte *)[arrayOfByte bytes])[j] = ((Byte)(([localBigInteger intValue] & 0x7F) | 0x80));
            localBigInteger = [localBigInteger shiftRightWithN:7];
        }
        int tmp79_78 = (i -1);
        NSMutableData *tmp79_74 = arrayOfByte;
        ((Byte *)[tmp79_74 bytes])[tmp79_78] = ((Byte)((Byte *)[tmp79_74 bytes])[tmp79_78] & 0x7F);
        [paramByteArrayOutputStream write:arrayOfByte withOffset:0 withCount:(int)[arrayOfByte length]];
#if !__has_feature(objc_arc)
    if (arrayOfByte) [arrayOfByte release]; arrayOfByte = nil;
#endif
    }
}

- (NSString *)toString {
    return [self getId];
}

+ (BOOL)isValidIdentifier:(NSString *)paramString {
    if (paramString.length < 3 || ([paramString characterAtIndex:1] != '.')) {
        return NO;
    }
    int i = [paramString characterAtIndex:0];
    if ((i <48) || (i > 50)) {
        return false;
    }
    return [self isValidBranchID:paramString paramInt:2];
}

+ (BOOL)isValidBranchID:(NSString *)paramString paramInt:(int)paramInt {
    BOOL isBool = false;
    int i = (int)[paramString length];
    for (; ;) {
        i--;
        if (i < paramInt) {
            return isBool;
        }
        int j = [paramString characterAtIndex:i];
        if ((j >= 48) && (j <= 57)) {
            isBool = TRUE;
        }else {
            if (j != 46) {
                break;
            }
            if (!isBool) {
                return NO;
            }
            isBool = NO;
        }
    }
    return NO;
    return isBool;
}

- (void)doOutput:(MemoryStreamEx*)paramByteArrayOutputStream {
    OIDTokenizer *localOIDTokenizer = [[OIDTokenizer alloc] initParamString:self.identifier];
    int i = ([[localOIDTokenizer nextToken] intValue]) * 40;
    NSString *str1 = [localOIDTokenizer nextToken];
    if (str1.length <= 18) {
        [self writeField:paramByteArrayOutputStream paramLong:(i + [str1 longLongValue])];
    }else {
        BigInteger *big = [[BigInteger alloc] initWithValue:str1];
        [big addWithValue:[BigInteger valueOf:i]];
        [self writeField:paramByteArrayOutputStream paramBigInteger:big];
#if !__has_feature(objc_arc)
    if (big) [big release]; big = nil;
#endif
    }
    while ([localOIDTokenizer hasMoreTokens]) {
        NSString *str2 = [localOIDTokenizer nextToken];
        if ([str2 length] <= 18) {
            [self writeField:paramByteArrayOutputStream paramLong:[str2 longLongValue]];
        }else {
            BigInteger *big = [[BigInteger alloc] initWithValue:str2];
            [self writeField:paramByteArrayOutputStream paramBigInteger:big];
#if !__has_feature(objc_arc)
    if (big) [big release]; big = nil;
#endif
        }
    }
#if !__has_feature(objc_arc)
    if (localOIDTokenizer) [localOIDTokenizer release]; localOIDTokenizer = nil;
#endif
}

- (NSMutableData *)getBody {
    if (!self.body) {
        MemoryStreamEx *localMemoryStream = [MemoryStreamEx memoryStreamEx];
        [self doOutput:localMemoryStream];
        NSMutableData *data = [localMemoryStream availableData];
        NSMutableData *tmpData = [Arrays copyOfWithData:data withNewLength:(int)[data length]];
        self.body = tmpData;
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
    }
    return self.body;
}

- (ASN1ObjectIdentifier *)intern {
    @synchronized([ASN1ObjectIdentifier pool]) {
        OidHandle *localOidHandle = [[OidHandle alloc] initParamArrayOfByte:[self getBody]];
        ASN1ObjectIdentifier *localASN1ObjectIdentifier = (ASN1ObjectIdentifier *)[[ASN1ObjectIdentifier pool] objectForKey:localOidHandle];
#if !__has_feature(objc_arc)
        if (localOidHandle) [localOidHandle release]; localOidHandle = nil;
#endif
        if (localASN1ObjectIdentifier) {
            return localASN1ObjectIdentifier;
        }else {
            [[ASN1ObjectIdentifier pool] setObject:self forKey:@"localOidHandle"];
            return self;
        }
    }
}

- (BOOL)isConstructed {
    return NO;
}

- (int)encodedLength {
    int i = (int)[[self getBody] length];
    return 1 + [StreamUtil calculateBodyLength:i] + i;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    NSMutableData *arrayOfByte = [self getBody];
    [paramASN1OutputStream write:6];
    [paramASN1OutputStream writeLength:(int)[arrayOfByte length]];
    [paramASN1OutputStream writeParamArrayOfByte:arrayOfByte];
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (paramASN1Primitive == self) {
        return YES;
    }
    if (![paramASN1Primitive isKindOfClass:[ASN1ObjectIdentifier class]]) {
        return NO;
    }
    return [self.identifier isEqualToString:[((ASN1ObjectIdentifier *)paramASN1Primitive) identifier]];
}

- (NSUInteger)hash {
    return [self.identifier hash];
}

@end

#import "Arrays.h"

@interface OidHandle ()

@property (nonatomic, assign) int key;
@property (nonatomic, readwrite, retain) NSMutableData *enc;

@end

@implementation OidHandle
@synthesize key = _key;
@synthesize enc = _enc;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_enc) {
        [_enc release];
        _enc = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        self.enc = paramArrayOfByte;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (int)hashCode {
    return self.key;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[OidHandle class]]) {
        return [Arrays areEqualWithByteArray:self.enc withB:((OidHandle *)object).enc];
    }
    return NO;
}

@end
