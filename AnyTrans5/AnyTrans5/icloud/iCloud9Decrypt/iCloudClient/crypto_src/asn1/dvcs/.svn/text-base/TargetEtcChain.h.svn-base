//
//  TargetEtcChain.h
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "CertEtcToken.h"
#import "ASN1Sequence.h"
#import "PathProcInput.h"
#import "ASN1TaggedObject.h"

@interface TargetEtcChain : ASN1Object {
@private
    CertEtcToken *_target;
    ASN1Sequence *_chain;
    PathProcInput *_pathProcInput;
}

+ (TargetEtcChain *)getInstance:(id)paramObject;
+ (TargetEtcChain *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (NSMutableArray *)arrayFromSequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamCertEtcToken:(CertEtcToken *)paramCertEtcToken;
- (instancetype)initParamCertEtcToken:(CertEtcToken *)paramCertEtcToken paramArrayOfCertEtcToken:(NSMutableArray *)paramArrayOfCertEtcToken;
- (instancetype)initParamCertEtcToken:(CertEtcToken *)paramCertEtcToken paramPathProcInput:(PathProcInput *)paramPathProcInput;
- (instancetype)initParamCertEtcToken:(CertEtcToken *)paramCertEtcToken paramArrayOfCertEtcToken:(NSMutableArray *)paramArrayOfCertEtcToken paramPathProcInput:(PathProcInput *)paramPathProcInput;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;
- (CertEtcToken *)getTarget;
- (NSMutableArray *)getChain;
- (PathProcInput *)getPathProcInput;

@end
