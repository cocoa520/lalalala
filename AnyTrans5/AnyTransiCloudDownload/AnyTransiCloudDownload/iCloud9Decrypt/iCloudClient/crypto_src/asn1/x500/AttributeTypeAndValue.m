//
//  AttributeTypeAndValue.m
//  crypto
//
//  Created by JGehry on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "AttributeTypeAndValue.h"
#import "ASN1EncodableVector.h"
#import "DERSequence.h"

@interface AttributeTypeAndValue ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *type;
@property (nonatomic, readwrite, retain) ASN1Encodable *value;

@end

@implementation AttributeTypeAndValue
@synthesize type = _type;
@synthesize value = _value;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_type) {
        [_type release];
        _type = nil;
    }
    if (_value) {
        [_value release];
        _value = nil;
    }
    [super dealloc];
#endif
}

+ (AttributeTypeAndValue *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[AttributeTypeAndValue class]]) {
        return (AttributeTypeAndValue *)paramObject;
    }
    if (paramObject) {
        return [[[AttributeTypeAndValue alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"null value in getInstance()" userInfo:nil];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.type = (ASN1ObjectIdentifier *)([paramASN1Sequence getObjectAt:0]);
        self.value = [paramASN1Sequence getObjectAt:1];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        self.type = paramASN1ObjectIdentifier;
        self.value = paramASN1Encodable;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getType {
    return self.type;
}

- (ASN1Encodable *)getValue {
    return self.value;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.type];
    [localASN1EncodableVector add:self.value];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
