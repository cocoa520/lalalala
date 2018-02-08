//
//  DLSet.m
//  crypto
//
//  Created by JGehry on 6/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DLSet.h"
#import "StreamUtil.h"

@interface DLSet ()

@property (nonatomic, readwrite, assign) int bodyLength;

@end

@implementation DLSet
@synthesize bodyLength = _bodyLength;

- (instancetype)init
{
    if (self = [super init]) {
        [self setBodyLength:-1];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initDLParamASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super initParamASN1Encodable:paramASN1Encodable]) {
        [self setBodyLength:-1];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initDLParamASN1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVector
{
    if (self = [super initParamASN1EncodableVector:paramASN1EncodableVector paramBoolean:NO]) {
        [self setBodyLength:-1];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initDLParamArrayOfASN1Encodable:(NSMutableArray *)paramArrayOfASN1Encodable
{
    if (self = [super initParamArrayOfASN1Encodable:paramArrayOfASN1Encodable paramBoolean:NO]) {
        [self setBodyLength:-1];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (int)getBodyLength {
    if (self.bodyLength < 0) {
        int i = 0;
        NSEnumerator *localEnumeration = [self getObjects];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            i += [[[((ASN1Encodable *)localObject) toASN1Primitive] toDLObject] encodedLength];
        }
        self.bodyLength = i;
    }
    return self.bodyLength;
}

- (int)encodedLength {
    int i = [self getBodyLength];
    return 1 + [StreamUtil calculateBodyLength:i] + i;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    ASN1OutputStream *localASN1OutputStream = [paramASN1OutputStream getDLSubStream];
    int i = [self getBodyLength];
    [paramASN1OutputStream write:49];
    [paramASN1OutputStream writeLength:i];
    NSEnumerator *localEnumeration = [self getObjects];
    id localObject = nil;
    while (localObject = [localEnumeration nextObject]) {
        [localASN1OutputStream writeObject:((ASN1Encodable *)localObject)];
    }
}

@end
