//
//  CommitmentTypeQualifier.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CommitmentTypeQualifier.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface CommitmentTypeQualifier ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *commitmentTypeIdentifier;
@property (nonatomic, readwrite, retain) ASN1Encodable *qualifier;

@end

@implementation CommitmentTypeQualifier
@synthesize commitmentTypeIdentifier = _commitmentTypeIdentifier;
@synthesize qualifier = _qualifier;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_commitmentTypeIdentifier) {
        [_commitmentTypeIdentifier release];
        _commitmentTypeIdentifier = nil;
    }
    if (_qualifier) {
        [_qualifier release];
        _qualifier = nil;
    }
    [super dealloc];
#endif
}

+ (CommitmentTypeQualifier *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CommitmentTypeQualifier class]]) {
        return (CommitmentTypeQualifier *)paramObject;
    }
    if (paramObject) {
        return [[[CommitmentTypeQualifier alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.commitmentTypeIdentifier = (ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:0];
        if ([paramASN1Sequence size] > 1) {
            self.qualifier = [paramASN1Sequence getObjectAt:1];
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
        [self initParamASN1ObjectIdentifier:paramASN1ObjectIdentifier paramASN1Encodable:nil];
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
        self.commitmentTypeIdentifier = paramASN1ObjectIdentifier;
        self.qualifier = paramASN1Encodable;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getCommitmentTypeIdentifier {
    return self.commitmentTypeIdentifier;
}

- (ASN1Encodable *)getQualifier {
    return self.qualifier;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.commitmentTypeIdentifier];
    if (self.qualifier) {
        [localASN1EncodableVector add:self.qualifier];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
