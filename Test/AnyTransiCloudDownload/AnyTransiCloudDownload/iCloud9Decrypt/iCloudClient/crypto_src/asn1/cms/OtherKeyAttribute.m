//
//  OtherKeyAttribute.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OtherKeyAttribute.h"
#import "DERSequence.h"

@interface OtherKeyAttribute ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *keyAttrId;
@property (nonatomic, readwrite, retain) ASN1Encodable *keyAttr;

@end

@implementation OtherKeyAttribute
@synthesize keyAttrId = _keyAttrId;
@synthesize keyAttr = _keyAttr;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_keyAttrId) {
        [_keyAttrId release];
        _keyAttrId = nil;
    }
    if (_keyAttr) {
        [_keyAttr release];
        _keyAttr = nil;
    }
    [super dealloc];
#endif
}

+ (OtherKeyAttribute *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OtherKeyAttribute class]]) {
        return (OtherKeyAttribute *)paramObject;
    }
    if (paramObject) {
        return [[[OtherKeyAttribute alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.keyAttrId = (ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:0];
        self.keyAttr = [paramASN1Sequence getObjectAt:1];
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
        self.keyAttrId = paramASN1ObjectIdentifier;
        self.keyAttr = paramASN1Encodable;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getKeyAttrId {
    return self.keyAttrId;
}

- (ASN1Encodable *)getKeyAttr {
    return self.keyAttr;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.keyAttrId];
    [localASN1EncodableVector add:self.keyAttr];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
