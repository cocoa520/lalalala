//
//  DERUniversalString.m
//  crypto
//
//  Created by ; on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERUniversalString.h"
#import "ASN1OutputStream.h"
#import "ASN1OctetString.h"
#import "StreamUtil.h"
#import "Arrays.h"

@interface DERUniversalString ()

@property (nonatomic, readwrite, retain) NSMutableData *string;

@end

@implementation DERUniversalString
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

+ (NSArray *)table {
    static NSArray *_table = nil;
    @synchronized(self) {
        if (!_table) {
            _table = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @"A", @"B", @"C", @"D", @"E", @"F"];
        }
    }
    return _table;
}

+ (DERUniversalString *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DERUniversalString class]]) {
        return (DERUniversalString *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return (DERUniversalString *)[self fromByteArray:(NSMutableData *)paramObject];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"encoding error getInstance: %@", exception.description] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (DERUniversalString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localPrimitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localPrimitive isKindOfClass:[DERUniversalString class]]) {
        return [DERUniversalString getInstance:localPrimitive];
    }
    return [[[DERUniversalString alloc] initParamArrayOfByte:[((ASN1OctetString *)localPrimitive) getOctets]] autorelease];
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

#pragma mark -- getString
- (NSString *)getString {
    NSMutableString *localStringBuffer = [[NSMutableString alloc] initWithString:@"#"];
    MemoryStreamEx *localMemoryStream = [MemoryStreamEx memoryStreamEx];
    ASN1OutputStream *localASN1OutputStream = [[ASN1OutputStream alloc] initASN1OutputStream:localMemoryStream];
    @try {
        [localASN1OutputStream writeObject:self];
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"internal error encoding BitString" userInfo:nil];
    }
    NSMutableData *data = [localMemoryStream availableData];
    NSMutableData *arrayOfByte = [Arrays copyOfWithData:data withNewLength:(int)[data length]];
    for (int i = 0; i != arrayOfByte.length; i++) {
        [localStringBuffer appendString:[NSString stringWithFormat:@"%@", [DERUniversalString table][((uint)(((Byte *)[arrayOfByte bytes])[i]) >> 4) & 0xF]]];
        [localStringBuffer appendString:[NSString stringWithFormat:@"%@", [DERUniversalString table][(uint)(((Byte *)[arrayOfByte bytes])[i]) & 0xF]]];
    }
#if !__has_feature(objc_arc)
    if (arrayOfByte) [arrayOfByte release]; arrayOfByte = nil;
#endif
    return [NSString stringWithFormat:@"%@", localStringBuffer.description];
}

- (NSString *)toString {
    return [self getString];
}

- (NSMutableData *)getOctets {
    return self.string;
}

- (BOOL)isConstructed {
    return NO;
}

- (int)encodedLength {
    return 1 + [StreamUtil calculateBodyLength:(int)self.string.length] + (int)self.string.length;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    [paramASN1OutputStream writeEncoded:28 paramArrayOfByte:[self getOctets]];
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[DERUniversalString class]]) {
        return NO;
    }
    return [Arrays areEqualWithByteArray:self.string withB:[((DERUniversalString *)paramASN1Primitive) string]];
}

- (NSUInteger)hash {
    return [Arrays getHashCodeWithByteArray:self.string];
}

@end
