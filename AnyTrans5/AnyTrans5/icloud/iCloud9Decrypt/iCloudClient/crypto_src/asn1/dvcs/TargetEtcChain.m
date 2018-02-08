//
//  TargetEtcChain.m
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "TargetEtcChain.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"
#import "CategoryExtend.h"

@interface TargetEtcChain ()

@property (nonatomic, readwrite, retain) CertEtcToken *target;
@property (nonatomic, readwrite, retain) ASN1Sequence *chain;
@property (nonatomic, readwrite, retain) PathProcInput *pathProcInput;

@end

@implementation TargetEtcChain
@synthesize target = _target;
@synthesize chain = _chain;
@synthesize pathProcInput = _pathProcInput;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_target) {
        [_target release];
        _target = nil;
    }
    if (_chain) {
        [_chain release];
        _chain = nil;
    }
    if (_pathProcInput) {
        [_pathProcInput release];
        _pathProcInput = nil;
    }
    [super dealloc];
#endif
}

+ (TargetEtcChain *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[TargetEtcChain class]]) {
        return (TargetEtcChain *)paramObject;
    }
    if (paramObject) {
        return [[[TargetEtcChain alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (TargetEtcChain *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [TargetEtcChain getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (NSMutableArray *)arrayFromSequence:(ASN1Sequence *)paramASN1Sequence {
    NSMutableArray *arrayOfTargetEtcChain = [[[NSMutableArray alloc] initWithSize:[paramASN1Sequence size]] autorelease];
    for (int i = 0; i != arrayOfTargetEtcChain.count; i++) {
        arrayOfTargetEtcChain[i] = [TargetEtcChain getInstance:[paramASN1Sequence getObjectAt:i]];
    }
    return arrayOfTargetEtcChain;
}

- (instancetype)initParamCertEtcToken:(CertEtcToken *)paramCertEtcToken
{
    self = [super init];
    if (self) {
        [self initParamCertEtcToken:paramCertEtcToken paramArrayOfCertEtcToken:nil paramPathProcInput:nil];
    }
    return self;
}

- (instancetype)initParamCertEtcToken:(CertEtcToken *)paramCertEtcToken paramArrayOfCertEtcToken:(NSMutableArray *)paramArrayOfCertEtcToken
{
    self = [super init];
    if (self) {
        [self initParamCertEtcToken:paramCertEtcToken paramArrayOfCertEtcToken:paramArrayOfCertEtcToken paramPathProcInput:nil];
    }
    return self;
}

- (instancetype)initParamCertEtcToken:(CertEtcToken *)paramCertEtcToken paramPathProcInput:(PathProcInput *)paramPathProcInput
{
    self = [super init];
    if (self) {
        [self initParamCertEtcToken:paramCertEtcToken paramArrayOfCertEtcToken:nil paramPathProcInput:paramPathProcInput];
    }
    return self;
}

- (instancetype)initParamCertEtcToken:(CertEtcToken *)paramCertEtcToken paramArrayOfCertEtcToken:(NSMutableArray *)paramArrayOfCertEtcToken paramPathProcInput:(PathProcInput *)paramPathProcInput
{
    self = [super init];
    if (self) {
        self.target = paramCertEtcToken;
        if (paramArrayOfCertEtcToken) {
            ASN1Sequence *sequence = [[DERSequence alloc] initDERparamArrayOfASN1Encodable:paramArrayOfCertEtcToken];
            self.chain = sequence;
#if !__has_feature(objc_arc)
    if (sequence) [sequence release]; sequence = nil;
#endif
        }
        self.pathProcInput = paramPathProcInput;
    }
    return self;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        int i = 0;
        ASN1Encodable *localASN1Encodable = [paramASN1Sequence getObjectAt:i++];
        self.target = [CertEtcToken getInstance:localASN1Encodable];
        @try {
            localASN1Encodable = [paramASN1Sequence getObjectAt:i++];
            self.chain = [ASN1Sequence getInstance:localASN1Encodable];
        }
        @catch (NSException *exception) {
            return 0;
        }
        @try {
            localASN1Encodable = [paramASN1Sequence getObjectAt:i++];
            ASN1TaggedObject *localASN1TaggedObject = [ASN1TaggedObject getInstance:localASN1Encodable];
            switch ([localASN1TaggedObject getTagNo]) {
                case 0:
                    self.pathProcInput = [PathProcInput getInstance:localASN1TaggedObject paramBoolean:false];
                    break;
                default:
                    break;
            }
        }
        @catch (NSException *exception) {
        }
    }
    return self;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.target];
    if (self.chain) {
        [localASN1EncodableVector add:self.chain];
    }
    if (self.pathProcInput) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:false paramInt:0 paramASN1Encodable:self.pathProcInput];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (NSString *)toString {
    NSMutableString *localStringBuffer = [[[NSMutableString alloc] init] autorelease];
    [localStringBuffer appendString:@"TargetEtcChain {\n"];
    [localStringBuffer appendString:[NSString stringWithFormat:@"target: %@\n", self.target]];
    if (self.chain) {
        [localStringBuffer appendString:[NSString stringWithFormat:@"chain: %@\n", self.chain]];
    }
    if (self.pathProcInput) {
        [localStringBuffer appendString:[NSString stringWithFormat:@"pathProcInput: %@\n", self.pathProcInput]];
    }
    [localStringBuffer appendString:@"}\n"];
    return [NSString stringWithFormat:@"%@", localStringBuffer.description];
}

- (CertEtcToken *)getTarget {
    return self.target;
}

- (NSMutableArray *)getChain {
    if (self.chain) {
        return [CertEtcToken arrayFromSequence:self.chain];
    }
    return nil;
}

- (void)setChain:(ASN1Sequence *)chain {
    self.chain = chain;
}

- (PathProcInput *)getPathProcInput {
    return self.pathProcInput;
}

- (void)setPathProcInput:(PathProcInput *)pathProcInput {
    self.pathProcInput = pathProcInput;
}

@end
