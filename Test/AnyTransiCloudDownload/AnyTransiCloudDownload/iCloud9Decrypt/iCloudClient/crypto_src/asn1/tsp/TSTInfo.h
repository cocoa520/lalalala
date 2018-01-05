//
//  TSTInfo.h
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "ASN1ObjectIdentifier.h"
#import "MessageImprint.h"
#import "ASN1GeneralizedTime.h"
#import "Accuracy.h"
#import "GeneralName.h"
#import "Extensions.h"

@interface TSTInfo : ASN1Object {
    ASN1Integer *_version;
    ASN1ObjectIdentifier *_tsaPolicyId;
    MessageImprint *_messageImprint;
    ASN1Integer *_serialNumber;
    ASN1GeneralizedTime *_genTime;
    Accuracy *_accuracy;
    ASN1Boolean *_ordering;
    ASN1Integer *_nonce;
    GeneralName *_tsa;
    Extensions *_extensions;
}

+ (TSTInfo *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramMessageImprint:(MessageImprint *)paramMessageImprint paramASN1Integer1:(ASN1Integer *)paramASN1Integer1 paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramAccuracy:(Accuracy *)paramAccuracy paramASN1Boolean:(ASN1Boolean *)paramASN1Boolean paramASN1Integer2:(ASN1Integer *)paramASN1Integer2 paramGeneralName:(GeneralName *)paramGeneralName paramExtensions:(Extensions *)paramExtensions;
- (ASN1Integer *)getVersion;
- (MessageImprint *)getMessageImprint;
- (ASN1ObjectIdentifier *)getPolicy;
- (ASN1Integer *)getSerialNumber;
- (Accuracy *)getAccuracy;
- (ASN1GeneralizedTime *)getGenTime;
- (ASN1Boolean *)getOrdering;
- (ASN1Integer *)getNonce;
- (GeneralName *)getTsa;
- (Extensions *)getExtensions;
- (ASN1Primitive *)toASN1Primitive;

@end
