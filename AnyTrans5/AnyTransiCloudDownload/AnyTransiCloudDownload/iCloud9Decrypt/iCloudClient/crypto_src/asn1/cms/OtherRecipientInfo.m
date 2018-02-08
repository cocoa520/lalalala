//
//  OtherRecipientInfo.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OtherRecipientInfo.h"
#import "DERSequence.h"

@interface OtherRecipientInfo ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *oriType;
@property (nonatomic, readwrite, retain) ASN1Encodable *oriValue;

@end

@implementation OtherRecipientInfo
@synthesize oriType = _oriType;
@synthesize oriValue = _oriValue;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_oriType) {
        [_oriType release];
        _oriType = nil;
    }
    if (_oriValue) {
        [_oriValue release];
        _oriValue = nil;
    }
    [super dealloc];
#endif
}

+ (OtherRecipientInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OtherRecipientInfo class]]) {
        return (OtherRecipientInfo *)paramObject;
    }
    if (paramObject) {
        return [[[OtherRecipientInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (OtherRecipientInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [OtherRecipientInfo getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.oriType = [ASN1ObjectIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        self.oriValue = [paramASN1Sequence getObjectAt:1];
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
        self.oriType = paramASN1ObjectIdentifier;
        self.oriValue = paramASN1Encodable;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getType {
    return self.oriType;
}

- (ASN1Encodable *)getValue {
    return self.oriValue;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.oriType];
    [localASN1EncodableVector add:self.oriValue];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
