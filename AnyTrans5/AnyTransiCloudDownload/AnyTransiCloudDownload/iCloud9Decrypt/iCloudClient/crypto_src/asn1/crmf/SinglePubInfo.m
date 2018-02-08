//
//  SinglePubInfo.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SinglePubInfo.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface SinglePubInfo ()

@property (nonatomic, readwrite, retain) ASN1Integer *pubMethod;
@property (nonatomic, readwrite, retain) GeneralName *pubLocation;

@end

@implementation SinglePubInfo
@synthesize pubMethod = _pubMethod;
@synthesize pubLocation = _pubLocation;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_pubMethod) {
        [_pubMethod release];
        _pubMethod = nil;
    }
    if (_pubLocation) {
        [_pubLocation release];
        _pubLocation = nil;
    }
  [super dealloc];
#endif
}

+ (SinglePubInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[SinglePubInfo class]]) {
        return (SinglePubInfo *)paramObject;
    }
    if (paramObject) {
        return [[[SinglePubInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        self.pubMethod = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:0]];
        if ([paramASN1Sequence size] == 2) {
            self.pubLocation = [GeneralName getInstance:[paramASN1Sequence getObjectAt:1]];
        }
    }
    return self;
}

- (GeneralName *)getPubLocation {
    return self.pubLocation;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.pubMethod];
    if (self.pubLocation) {
        [localASN1EncodableVector add:self.pubLocation];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
