//
//  AttributeX509.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "AttributeX509.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface AttributeX509 ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *attrType;
@property (nonatomic, readwrite, retain) ASN1Set *attrValues;

@end

@implementation AttributeX509
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

+ (AttributeX509 *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[AttributeX509 class]]) {
        return (AttributeX509 *)paramObject;
    }
    if (paramObject) {
        return [[[AttributeX509 alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] != 2) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.attrType = [ASN1ObjectIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        self.attrValues = [ASN1Set getInstance:[paramASN1Sequence getObjectAt:1]];
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
    return [[[ASN1ObjectIdentifier alloc] initParamString:[self.attrType getId]] autorelease];
}

- (NSMutableArray *)getAttributeValues {
    return [self.attrValues toArray];
}

- (ASN1Set *)getAttrValues {
    return self.attrValues;
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
