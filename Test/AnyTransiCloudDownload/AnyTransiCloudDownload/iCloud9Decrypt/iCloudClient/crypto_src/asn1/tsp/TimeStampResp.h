//
//  TimeStampResp.h
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "PKIStatusInfo.h"
#import "ContentInfo.h"

@interface TimeStampResp : ASN1Object {
    PKIStatusInfo *_pkiStatusInfo;
    ContentInfo *_timeStampToken;
}

@property (nonatomic, readwrite, retain) PKIStatusInfo *pkiStatusInfo;
@property (nonatomic, readwrite, retain) ContentInfo *timeStampToken;

+ (TimeStampResp *)getInstance:(id)paramObject;
- (instancetype)initParamPKIStatusInfo:(PKIStatusInfo *)paramPKIStatusInfo paramContentInfo:(ContentInfo *)paramContentInfo;
- (PKIStatusInfo *)getStatus;
- (ContentInfo *)getTimeStampToken;
- (ASN1Primitive *)toASN1Primitive;

@end
