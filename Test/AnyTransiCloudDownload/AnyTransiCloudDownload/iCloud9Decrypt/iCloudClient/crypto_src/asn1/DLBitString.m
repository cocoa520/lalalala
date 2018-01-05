//
//  DLBitString.m
//  crypto
//
//  Created by JGehry on 5/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DLBitString.h"
#import "StreamUtil.h"
#import "DERBitString.h"
#import "ASN1OctetString.h"
#import "CategoryExtend.h"

@implementation DLBitString

+ (ASN1BitString *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DLBitString class]]) {
        return (DLBitString *)paramObject;
    }
    if ([paramObject isKindOfClass:[DERBitString class]]) {
        return (DERBitString *)paramObject;
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (ASN1BitString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localASN1Primitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localASN1Primitive isKindOfClass:[DLBitString class]]) {
        return [DLBitString getInstance:localASN1Primitive];
    }
    return [self fromOctetString:[((ASN1OctetString *)localASN1Primitive) getOctets]];
}

+ (NSMutableData *)toByteArray:(Byte)paramByte {
    NSMutableData *arrayOfByte = [[[NSMutableData alloc] initWithSize:1] autorelease];
    ((Byte *)[arrayOfByte bytes])[0] = paramByte;
    return arrayOfByte;
}

+ (DLBitString *)fromOctetString:(NSMutableData *)paramArrayOfByte {
    if ([paramArrayOfByte length] < 1) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"truncated BIT STRING detected" userInfo:nil];
    }
    int i = ((Byte *)[paramArrayOfByte bytes])[0];
    NSMutableData *arrayOfByte = [[NSMutableData alloc] initWithSize:(int)paramArrayOfByte.length - 1];
    if (arrayOfByte.length != 0) {
        [arrayOfByte copyFromIndex:0 withSource:paramArrayOfByte withSourceIndex:1 withLength:((int)[paramArrayOfByte length] - 1)];
    }
    DLBitString *dlBit = [[[DLBitString alloc] initParamArrayOfByte:arrayOfByte paramInt:i] autorelease];
#if !__has_feature(objc_arc)
    if (arrayOfByte) [arrayOfByte release]; arrayOfByte = nil;
#endif
    return dlBit;
}

- (instancetype)initParamByte:(Byte)paramByte paramInt:(int)paramInt
{
    if (self = [super init]) {
        [self initParamArrayOfByte:[DLBitString toByteArray:paramByte] paramInt:paramInt];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt
{
    if (self = [super initParamArrayOfByte:paramArrayOfByte paramInt:paramInt]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        [self initParamArrayOfByte:paramArrayOfByte paramInt:0];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt:(int)paramInt
{
    if (self = [super initParamArrayOfByte:[DLBitString getBytes:paramInt] paramInt:[DLBitString getPadBits:paramInt]]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super initParamArrayOfByte:[[paramASN1Encodable toASN1Primitive] getEncoded:@"DER"] paramInt:0]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BOOL)isConstructed {
    return NO;
}

- (int)encodedLength {
    return 1 + [StreamUtil calculateBodyLength:(int)self.data.length + 1] + (int)self.data.length + 1;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    NSMutableData *arrayOfByte1 = self.data;
    NSMutableData *arrayOfByte2 = [[NSMutableData alloc] initWithSize:(int)arrayOfByte1.length + 1];
    ((Byte *)[arrayOfByte2 bytes])[0] = (Byte)[self getPadBits];
    [arrayOfByte2 copyFromIndex:1 withSource:arrayOfByte1 withSourceIndex:0 withLength:((int)[arrayOfByte2 length] - 1)];
    [paramASN1OutputStream writeEncoded:3 paramArrayOfByte:arrayOfByte2];
#if !__has_feature(objc_arc)
    if (arrayOfByte2) [arrayOfByte2 release]; arrayOfByte2 = nil;
#endif
}



@end
