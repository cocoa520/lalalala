//
//  CAKeyUpdAnnContent.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "CMPCertificate.h"

@interface CAKeyUpdAnnContent : ASN1Object {
@private
    CMPCertificate *_oldWithNew;
    CMPCertificate *_nWO;
    CMPCertificate *_nWN;
}

+ (CAKeyUpdAnnContent *)getInstance:(id)paramObject;
- (instancetype)initParamCMPCertificate1:(CMPCertificate *)paramCMPCertificate1 paramCMPCertificate2:(CMPCertificate *)paramCMPCertificate2 paramCMPCertificate3:(CMPCertificate *)paramCMPCertificate3;
- (CMPCertificate *)getOldWithNew;
- (CMPCertificate *)getNewWithOld;
- (CMPCertificate *)getNewWithNew;
- (ASN1Primitive *)toASN1Primitive;

@end
