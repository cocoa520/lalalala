//
//  BERSequence.m
//  crypto
//
//  Created by JGehry on 5/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BERSequence.h"

@implementation BERSequence

- (instancetype)init
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

- (instancetype)initBERParamASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super initParamASN1Encodable:paramASN1Encodable]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initBERParamASn1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVector
{
    if (self = [super initParamASN1EncodableVector:paramASN1EncodableVector]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initBERParamArrayOfASN1Encodable:(NSMutableArray *)paramArrayOfASN1Encodable
{
    if (self = [super initParamArrayOfASN1Encodable:paramArrayOfASN1Encodable]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (int)encodedLength {
    int i = 0;
    NSEnumerator *localEnumeration = [self getObjects];
    ASN1Encodable *encodable = nil;
    while (encodable = [localEnumeration nextObject]) {
        i += [[encodable toASN1Primitive] encodedLength];
    }
    return 2 + i + 2;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    [paramASN1OutputStream write:48];
    [paramASN1OutputStream write:128];
    NSEnumerator *localEnumeration = [self getObjects];
    ASN1Encodable *encodable = nil;
    while (encodable = [localEnumeration nextObject]) {
        [paramASN1OutputStream writeObject:encodable];
    }
    [paramASN1OutputStream write:0];
    [paramASN1OutputStream write:0];
}

@end
