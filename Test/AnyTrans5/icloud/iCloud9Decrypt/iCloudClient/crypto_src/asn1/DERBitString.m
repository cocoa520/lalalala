//
//  DERBitString.m
//  crypto
//
//  Created by JGehry on 5/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERBitString.h"
#import "DLBitString.h"
#import "ASN1OctetString.h"
#import "StreamUtil.h"

@implementation DERBitString

+ (DERBitString *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DERBitString class]]) {
        return (DERBitString *)paramObject;
    }
    if ([paramObject isKindOfClass:[DLBitString class]]) {
        return [[[DERBitString alloc] initParamArrayOfByte:((DLBitString *)paramObject).data paramInt:((DLBitString *)paramObject).padBits] autorelease];
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (DERBitString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localASN1Primitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localASN1Primitive isKindOfClass:[DERBitString class]]) {
        return [DERBitString getInstance:localASN1Primitive];
    }
    return [self fromOctetString:[((ASN1OctetString *)localASN1Primitive) getOctets]];
}

+ (DERBitString *)fromOctetString:(NSMutableData *)paramArrayOfByte {
    if (paramArrayOfByte.length < 1) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"truncated BIT STRING detected" userInfo:nil];
    }
    int i = ((Byte *)[paramArrayOfByte bytes])[0];
    NSMutableData *arrayOfByte = [[[NSMutableData alloc] initWithSize:(int)paramArrayOfByte.length - 1] autorelease];
    if (arrayOfByte.length) {
        [arrayOfByte copyFromIndex:0 withSource:paramArrayOfByte withSourceIndex:1 withLength:((int)[paramArrayOfByte length] - 1)];
    }
    return [[[DERBitString alloc] initParamArrayOfByte:arrayOfByte paramInt:i] autorelease];
}

+ (NSMutableData *)toByteArray:(Byte)paramByte {
    NSMutableData *arrayOfByte = [[[NSMutableData alloc] initWithSize:1] autorelease];
    ((Byte *)[arrayOfByte bytes])[0] = paramByte;
    return arrayOfByte;
}

- (DERBitString *)paramByte:(Byte)paramByte paramInt:(int)paramInt {
    return [self initParamArrayOfByte:[DERBitString toByteArray:paramByte] paramInt:paramInt];
}

- (instancetype)initDERBitString:(NSMutableData *)paramArrayOfByte
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
    if (self = [super init]) {
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

- (instancetype)initParamASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        [self initParamArrayOfByte:[[paramASN1Encodable toASN1Primitive] getEncoded:@"DER"] paramInt:0];
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
    NSMutableData *arrayOfByte1 = [DERBitString derForm:self.data paramInt:self.padBits];
    NSMutableData *arrayOfByte2 = [[NSMutableData alloc] initWithSize:(int)arrayOfByte1.length + 1];
    ((Byte *)[arrayOfByte2 bytes])[0] = (Byte)[self getPadBits];
    [arrayOfByte2 copyFromIndex:1 withSource:arrayOfByte1 withSourceIndex:0 withLength:((int)[arrayOfByte2 length] - 1)];
    [paramASN1OutputStream writeEncoded:3 paramArrayOfByte:arrayOfByte2];
#if !__has_feature(objc_arc)
    if (arrayOfByte2) [arrayOfByte2 release]; arrayOfByte2 = nil;
#endif
}

@end
