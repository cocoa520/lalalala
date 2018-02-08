//
//  KeySpecificInfo.m
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "KeySpecificInfo.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface KeySpecificInfo ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *algorithm;
@property (nonatomic, readwrite, retain) ASN1OctetString *counter;

@end

@implementation KeySpecificInfo
@synthesize algorithm = _algorithm;
@synthesize counter = _counter;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_algorithm) {
        [_algorithm release];
        _algorithm = nil;
    }
    if (_counter) {
        [_counter release];
        _counter = nil;
    }
    [super dealloc];
#endif
}

+ (KeySpecificInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[KeySpecificInfo class]]) {
        return (KeySpecificInfo *)paramObject;
    }
    if (paramObject) {
        return [[[KeySpecificInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        self.algorithm = paramASN1ObjectIdentifier;
        self.counter = paramASN1OctetString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.algorithm = (ASN1ObjectIdentifier *)localEnumeration.nextObject;
        self.counter = (ASN1OctetString *)localEnumeration.nextObject;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getAlgorithm {
    return self.algorithm;
}

- (ASN1OctetString *)getCounter {
    return self.counter;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.algorithm];
    [localASN1EncodableVector add:self.counter];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
