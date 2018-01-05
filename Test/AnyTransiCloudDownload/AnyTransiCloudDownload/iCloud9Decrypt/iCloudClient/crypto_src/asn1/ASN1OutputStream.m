//
//  ASN1OutputStream.m
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1OutputStream.h"
#import "DEROutputStream.h"
#import "DLOutputStream.h"

@interface ASN1OutputStream ()

@property (nonatomic, readwrite, retain) Stream *oUT;

@end

@implementation ASN1OutputStream
@synthesize oUT = _oUT;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_oUT) {
        [_oUT release];
        _oUT = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initASN1OutputStream:(Stream *)paramOutputStream
{
    if (self = [super init]) {
        self.oUT = paramOutputStream;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)writeLength:(int)paramInt {
    if (paramInt > 127) {
        int i = 1;
        uint j = paramInt;
        while ((j >>= 8) != 0) {
            i++;
        }
        [self write:(Byte)(i | 0x80)];
        for (int k = (i - 1) * 8; k >= 0; k -= 8) {
            [self write:(Byte)(paramInt >> k)];
        }
    }else {
        [self write:(Byte)paramInt];
    }
}

- (void)write:(int)paramInt {
    [self.oUT writeWithByte:paramInt];
}

- (void)writeParamArrayOfByte:(NSMutableData *)paramArrayOfByte {
    [self.oUT write:paramArrayOfByte];
}

- (void)writeParamAOBAndInt:(NSMutableData *)paramArrayOfByte paramInt1:(int)paramInt1 paramInt2:(int)paramInt2 {
    [self.oUT write:paramArrayOfByte withOffset:paramInt1 withCount:paramInt2];
}

- (void)writeEncoded:(int)paramInt paramArrayOfByte:(NSMutableData *)paramArrayofByte {
    [self write:paramInt];
    [self writeLength:(int)paramArrayofByte.length];
    [self writeParamArrayOfByte:paramArrayofByte];
}

- (void)writeTag:(int)paramInt1 paramInt2:(int)paramInt2 {
    if (paramInt2 < 31) {
        [self write:(paramInt1 | paramInt2)];
    }else {
        [self write:(paramInt1 | 0x1F)];
        if (paramInt2 < 128) {
            [self write:paramInt2];
        }else {
            NSMutableData *arrayOfByte = [[NSMutableData alloc] initWithSize:5];
            int i = [arrayOfByte length];
            ((Byte *)[arrayOfByte bytes])[--i] = ((Byte)(paramInt2 & 0x7F));
            do {
                paramInt2 >>= 7;
                ((Byte *)[arrayOfByte bytes])[--i] = ((Byte)((paramInt2 & 0x7F) | 0x80));
            } while (paramInt2 > 127);
            [self write:arrayOfByte withOffset:i withCount:((int)[arrayOfByte length] - i)];
#if !__has_feature(objc_arc)
    if (arrayOfByte) [arrayOfByte release]; arrayOfByte = nil;
#endif
        }
    }
}

- (void)writeEncoded:(int)paramInt1 paramInt2:(int)paramInt2 paramArrayOfByte:(NSMutableData *)paramArrayofByte {
    [self writeTag:paramInt1 paramInt2:paramInt2];
    [self writeLength:(int)paramArrayofByte.length];
    [self writeParamArrayOfByte:paramArrayofByte];
}

- (void)writeNull {
    [self.oUT writeWithByte:5];
    [self.oUT writeWithByte:0];
}

- (void)writeObject:(ASN1Encodable *)paramASN1Encodable {
    if (paramASN1Encodable) {
        [[paramASN1Encodable toASN1Primitive] encode:self];
    }else {
        @throw [NSException exceptionWithName:NSObjectNotAvailableException reason:@"null object detected" userInfo:nil];
    }
}

- (void)writeImplicitObject:(ASN1Primitive *)paramASN1Primitive {
    if (paramASN1Primitive) {
        ImplicitOutputStream *outputStream = [[ImplicitOutputStream alloc] initParamOutputStream:self.oUT];
        [paramASN1Primitive encode:outputStream];
#if !__has_feature(objc_arc)
    if (outputStream) [outputStream release]; outputStream = nil;
#endif
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"null object detected" userInfo:nil];
    }
}

- (ASN1OutputStream *)getDERSubStream
{
    return [[[DEROutputStream alloc] initDERParamOutputStream:self.oUT] autorelease];
}

- (ASN1OutputStream *)getDLSubStream
{
    return [[[DLOutputStream alloc] initDLParamOutputStream:self.oUT] autorelease];
}

- (void)close {
    [self.oUT close];
}

@end

@interface ImplicitOutputStream ()

@property (nonatomic, assign) BOOL first;

@end

@implementation ImplicitOutputStream
@synthesize first = _first;

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream
{
    if (self = [super init]) {
        self.first = YES;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (void)dealloc
{
    [super dealloc];
}

- (void)write:(int)paramInt {
    if (self.first) {
        self.first = NO;
    }else {
        [super write:paramInt];
    }
}

@end
