//
//  DERTaggedObject.m
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERTaggedObject.h"
#import "StreamUtil.h"

@implementation DERTaggedObject

+ (NSMutableData *)ZERO_BYTES {
    static NSMutableData *_ZERO_BYTES = nil;
    @synchronized(self) {
        if (!_ZERO_BYTES) {
            _ZERO_BYTES = [[NSMutableData alloc] initWithSize:0];
        }
    }
    return _ZERO_BYTES;
}

- (instancetype)initParamBoolean:(BOOL)paramBoolean paramInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super initParamBoolean:paramBoolean paramInt:paramInt paramASN1Encodable:paramASN1Encodable]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super initParamBoolean:TRUE paramInt:paramInt paramASN1Encodable:paramASN1Encodable]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (BOOL)isConstructed {
    if (!self.empty) {
        if (self.explicit) {
            return YES;
        }
        ASN1Primitive *localASN1Primitive = [[self.obj toASN1Primitive] toDERObject];
        return [localASN1Primitive isConstructed];
    }
    return YES;
}

- (int)encodedLength {
    if (!self.empty) {
        ASN1Primitive *localASN1Primitive = [[self.obj toASN1Primitive] toDERObject];
        int i = [localASN1Primitive encodedLength];
        if (self.explicit) {
            return [StreamUtil calculateBodyLength:self.tagNO] + [StreamUtil calculateBodyLength:i] + i;
        }
        i -= 1;
        return [StreamUtil calculateBodyLength:self.tagNO] + i;
    }
    return [StreamUtil calculateBodyLength:self.tagNO] + 1;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    if (!self.empty) {
        ASN1Primitive *localASN1Primitive = [[self.obj toASN1Primitive] toDERObject];
        if (self.explicit) {
            [paramASN1OutputStream writeTag:160 paramInt2:self.tagNO];
            [paramASN1OutputStream writeLength:[localASN1Primitive encodedLength]];
            [paramASN1OutputStream writeObject:localASN1Primitive];
        }else {
            int i;
            if ([localASN1Primitive isConstructed]) {
                i = 160;
            }else {
                i = 128;
            }
            [paramASN1OutputStream writeTag:i paramInt2:self.tagNO];
            [paramASN1OutputStream writeImplicitObject:localASN1Primitive];
        }
    }else {
        [paramASN1OutputStream writeEncoded:160 paramInt2:self.tagNO paramArrayOfByte:[DERTaggedObject ZERO_BYTES]];
    }
}

@end
