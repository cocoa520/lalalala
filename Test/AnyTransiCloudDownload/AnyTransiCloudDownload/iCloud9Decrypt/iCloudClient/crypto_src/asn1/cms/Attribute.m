//
//  Attribute.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Attribute.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface Attribute ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *attrType;
@property (nonatomic, readwrite, retain) ASN1Set *attrValues;

@end

@implementation Attribute
@synthesize attrType = _attrType;
@synthesize attrValues = _attrValues;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_attrType) {
        [_attrType release];
        _attrType = nil;
    }
    if (_attrValues) {
        [_attrValues release];
        _attrValues = nil;
    }
    [super dealloc];
#endif
}

+ (Attribute *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[Attribute class]]) {
        return (Attribute *)paramObject;
    }
    if (paramObject) {
        return [[[Attribute alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.attrType = (ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:0];
        self.attrValues = (ASN1Set *)[paramASN1Sequence getObjectAt:1];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Set:(ASN1Set *)paramASN1Set
{
    if (self = [super init]) {
        self.attrType = paramASN1ObjectIdentifier;
        self.attrValues = paramASN1Set;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getAttrType {
    return self.attrType;
}

- (ASN1Set *)getAttrValues {
    return self.attrValues;
}

- (NSMutableArray *)getAttributeValues {
    return [self.attrValues toArray];
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.attrType];
    [localASN1EncodableVector add:self.attrValues];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
