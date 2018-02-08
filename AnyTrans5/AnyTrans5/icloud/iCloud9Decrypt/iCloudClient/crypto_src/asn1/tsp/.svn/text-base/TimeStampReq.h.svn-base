//
//  TimeStampReq.h
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "MessageImprint.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Boolean.h"
#import "Extensions.h"

@interface TimeStampReq : ASN1Object {
    ASN1Integer *_version;
    MessageImprint *_messageImprint;
    ASN1ObjectIdentifier *_tsaPolicy;
    ASN1Integer *_nonce;
    ASN1Boolean *_certReq;
    Extensions *_extensions;
}

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) MessageImprint *messageImprint;
@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *tsaPolicy;
@property (nonatomic, readwrite, retain) ASN1Integer *nonce;
@property (nonatomic, readwrite, retain) ASN1Boolean *certReq;
@property (nonatomic, readwrite, retain) Extensions *extensions;

+ (TimeStampReq *)getInstance:(id)paramObject;
- (instancetype)initParamMessageImprint:(MessageImprint *)paramMessageImprint paramASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Integer:(ASN1Integer *)paramASN1Integer paramASN1Boolean:(ASN1Boolean *)paramASN1Boolean paramExtensions:(Extensions *)paramExtensions;
- (ASN1Integer *)getVersion;
- (MessageImprint *)getMessageImprint;
- (ASN1ObjectIdentifier *)getReqPolicy;
- (ASN1Integer *)getNonce;
- (ASN1Boolean *)getCertReq;
- (Extensions *)getExtensions;
- (ASN1Primitive *)toASN1Primitive;

@end
