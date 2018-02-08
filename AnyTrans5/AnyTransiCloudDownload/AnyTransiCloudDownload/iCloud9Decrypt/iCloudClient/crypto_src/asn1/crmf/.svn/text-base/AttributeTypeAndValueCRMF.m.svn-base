//
//  AttributeTypeAndValueCRMF.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "AttributeTypeAndValueCRMF.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface AttributeTypeAndValueCRMF ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *type;
@property (nonatomic, readwrite, retain) ASN1Encodable *value;

@end

@implementation AttributeTypeAndValueCRMF
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

+ (AttributeTypeAndValueCRMF *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[AttributeTypeAndValueCRMF class]]) {
        return (AttributeTypeAndValueCRMF *)paramObject;
    }
    if (paramObject) {
        return [[[AttributeTypeAndValueCRMF alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.type = (ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:0];
        self.value = [paramASN1Sequence getObjectAt:1];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        ASN1ObjectIdentifier *object = [[ASN1ObjectIdentifier alloc] initParamString:paramString];
        [self initParamASN1ObjectIdentifier:object paramASN1Encodable:paramASN1Encodable];
#if !__has_feature(objc_arc)
        if (object) [object release]; object = nil;
#endif
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
