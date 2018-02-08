//
//  BERTaggedObject.m
//  crypto
//
//  Created by JGehry on 5/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BERTaggedObject.h"
#import "BERSequence.h"
#import "StreamUtil.h"
#import "ASN1OutputStream.h"
#import "ASN1OctetString.h"
#import "BEROctetString.h"
#import "ASN1Set.h"

@implementation BERTaggedObject

- (instancetype)initParamInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super initParamBoolean:YES paramInt:paramInt paramASN1Encodable:paramASN1Encodable]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
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

- (instancetype)initParamInt:(int)paramInt
{
    ASN1Encodable *encodable = [[BERSequence alloc] init];
    if (self = [super initParamBoolean:NO paramInt:paramInt paramASN1Encodable:encodable]) {
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
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
        ASN1Primitive *localASN1Primitive = [self.obj toASN1Primitive];
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
    [paramASN1OutputStream writeTag:160 paramInt2:self.tagNO];
    [paramASN1OutputStream write:128];
    if (!self.empty) {
        if (!self.explicit) {
            NSEnumerator *localEnumeration;
            if ([self.obj isKindOfClass:[ASN1OctetString class]]) {
                if ([self.obj isKindOfClass:[BEROctetString class]]) {
                    localEnumeration = [((BEROctetString *)self.obj) getObjects];
                }else {
                    ASN1OctetString *localASN1OctetString = (ASN1OctetString *)self.obj;
                    BEROctetString *localBEROctetString = [[BEROctetString alloc] initParamArrayOfByte:[localASN1OctetString getOctets]];
                    localEnumeration = [localBEROctetString getObjects];
#if !__has_feature(objc_arc)
    if (localBEROctetString) [localBEROctetString release]; localBEROctetString = nil;
#endif
                }
            }else if ([self.obj isKindOfClass:[ASN1Sequence class]]) {
                localEnumeration = [((ASN1Sequence *)self.obj) getObjects];
            }else if ([self.obj isKindOfClass:[ASN1Set class]]) {
                localEnumeration = [((ASN1Set *)self.obj) getObjects];
            }else {
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"not implemented: %s", object_getClassName(self.obj)] userInfo:nil];
            }
            ASN1Encodable *encodable = nil;
            while (encodable = [localEnumeration nextObject]) {
                [paramASN1OutputStream writeObject:encodable];
            }
        }else {
            [paramASN1OutputStream writeObject:self.obj];
        }
    }
    [paramASN1OutputStream write:0];
    [paramASN1OutputStream write:0];
}

@end
