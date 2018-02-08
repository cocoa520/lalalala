//
//  KeyRecRepContent.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "PKIStatusInfo.h"
#import "CMPCertificate.h"
#import "ASN1Sequence.h"

@interface KeyRecRepContent : ASN1Object {
@private
    PKIStatusInfo *_status;
    CMPCertificate *_nSC;
    ASN1Sequence *_caCerts;
    ASN1Sequence *_keyPairHist;
}

+ (KeyRecRepContent *)getInstance:(id)paramObject;
- (PKIStatusInfo *)getStatus;
- (CMPCertificate *)getNewSigCert;
- (NSMutableArray *)getCaCerts;
- (NSMutableArray *)getKeyPairHist;
- (ASN1Primitive *)toASN1Primitive;

@end
