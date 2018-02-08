//
//  OcspResponsesID.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OcspResponsesID.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface OcspResponsesID ()

@property (nonatomic, readwrite, retain) OcspIdentifier *ocspIdentifier;
@property (nonatomic, readwrite, retain) OtherHash *ocspRepHash;

@end

@implementation OcspResponsesID
@synthesize ocspIdentifier = _ocspIdentifier;
@synthesize ocspRepHash = _ocspRepHash;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_ocspIdentifier) {
        [_ocspIdentifier release];
        _ocspIdentifier = nil;
    }
    if (_ocspRepHash) {
        [_ocspRepHash release];
        _ocspRepHash = nil;
    }
    [super dealloc];
#endif
}

+ (OcspResponsesID *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OcspResponsesID class]]) {
        return (OcspResponsesID *)paramObject;
    }
    if (paramObject) {
        return [[[OcspResponsesID alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (([paramASN1Sequence size] < 1) || ([paramASN1Sequence size] > 2)) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.ocspIdentifier = [OcspIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        if ([paramASN1Sequence size] > 1) {
            self.ocspRepHash = [OtherHash getInstance:[paramASN1Sequence getObjectAt:1]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamOcspIdentifier:(OcspIdentifier *)paramOcspIdentifier
{
    if (self = [super init]) {
        [self initParamOcspIdentifier:paramOcspIdentifier paramOtherHash:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamOcspIdentifier:(OcspIdentifier *)paramOcspIdentifier paramOtherHash:(OtherHash *)paramOtherHash
{
    if (self = [super init]) {
        self.ocspIdentifier = paramOcspIdentifier;
        self.ocspRepHash = paramOtherHash;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (OcspIdentifier *)getOcspIdentifier {
    return self.ocspIdentifier;
}

- (OtherHash *)getOcspRepHash {
    return self.ocspRepHash;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.ocspIdentifier];
    if (self.ocspRepHash) {
        [localASN1EncodableVector add:self.ocspRepHash];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
