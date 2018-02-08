//
//  CommitmentTypeIndication.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CommitmentTypeIndication.h"
#import "DERSequence.h"

@interface CommitmentTypeIndication ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *commitmentTypeId;
@property (nonatomic, readwrite, retain) ASN1Sequence *commitmentTypeQualifier;

@end

@implementation CommitmentTypeIndication
@synthesize commitmentTypeId = _commitmentTypeId;
@synthesize commitmentTypeQualifier = _commitmentTypeQualifier;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_commitmentTypeId) {
        [_commitmentTypeId release];
        _commitmentTypeId = nil;
    }
    if (_commitmentTypeQualifier) {
        [_commitmentTypeQualifier release];
        _commitmentTypeQualifier = nil;
    }
    [super dealloc];
#endif
}

+ (CommitmentTypeIndication *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[CommitmentTypeIndication class]]) {
        return (CommitmentTypeIndication *)paramObject;
    }
    return [[[CommitmentTypeIndication alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.commitmentTypeId = (ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:0];
        if ([paramASN1Sequence size] > 1) {
            self.commitmentTypeQualifier = (ASN1Sequence *)[paramASN1Sequence getObjectAt:1];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier
{
    if (self = [super init]) {
        self.commitmentTypeId = paramASN1ObjectIdentifier;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.commitmentTypeId = paramASN1ObjectIdentifier;
        self.commitmentTypeQualifier = paramASN1Sequence;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getCommitmentTypeId {
    return self.commitmentTypeId;
}

- (ASN1Sequence *)getCommitmentTypeQualifier {
    return self.commitmentTypeQualifier;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.commitmentTypeId];
    if (self.commitmentTypeQualifier) {
        [localASN1EncodableVector add:self.commitmentTypeQualifier];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
