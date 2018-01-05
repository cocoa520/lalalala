//
//  OcspIdentifier.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OcspIdentifier.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface OcspIdentifier ()

@property (nonatomic, readwrite, retain) ResponderID *ocspResponderID;
@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *producedAt;

@end

@implementation OcspIdentifier
@synthesize ocspResponderID = _ocspResponderID;
@synthesize producedAt = _producedAt;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_ocspResponderID) {
        [_ocspResponderID release];
        _ocspResponderID = nil;
    }
    if (_producedAt) {
        [_producedAt release];
        _producedAt = nil;
    }
    [super dealloc];
#endif
}

+ (OcspIdentifier *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OcspIdentifier class]]) {
        return (OcspIdentifier *)paramObject;
    }
    if (paramObject) {
        return [[[OcspIdentifier alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] != 2) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.ocspResponderID = [ResponderID getInstance:[paramASN1Sequence getObjectAt:0]];
        self.producedAt = (ASN1GeneralizedTime *)[paramASN1Sequence getObjectAt:1];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (instancetype)initParamResponderID:(ResponderID *)paramResponderID paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime
{
    if (self = [super init]) {
        self.ocspResponderID = paramResponderID;
        self.producedAt = paramASN1GeneralizedTime;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ResponderID *)getOcspResponderID {
    return self.ocspResponderID;
}

- (ASN1GeneralizedTime *)getProducedAt {
    return self.producedAt;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.ocspResponderID];
    [localASN1EncodableVector add:self.producedAt];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
