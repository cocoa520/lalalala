//
//  V2TBSCertListGenerator.h
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1Integer.h"
#import "AlgorithmIdentifier.h"
#import "X500Name.h"
#import "X509Name.h"
#import "Time.h"
#import "Extensions.h"
#import "TBSCertList.h"
#import "ASN1UTCTime.h"
#import "ASN1GeneralizedTime.h"
#import "X509Extensions.h"

@interface V2TBSCertListGenerator : NSObject {
@private
    ASN1Integer *_version;
    AlgorithmIdentifier *_signature;
    X500Name *_issuer;
    Time *_thisUpdate;
    Time *_nextUpdate;
    Extensions *_extensions;
    ASN1EncodableVector *_crlentries;
}

- (TBSCertList *)generateTBSCertList;
- (void)setIssuerParamX509Name:(X509Name *)paramX509Name;
- (void)setThisUpdateParamASN1UTCTime:(ASN1UTCTime *)paramASN1UTCTime;
- (void)setNextUpdateParamASN1UTCTime:(ASN1UTCTime *)paramASN1UTCTime;
- (void)setExtensionsParamX509Extensions:(X509Extensions *)paramX509Extensions;
- (void)addCRLEntry:(ASN1Sequence *)paramASN1Sequence;
- (void)addCRLEntry:(ASN1Integer *)paramASN1Integer paramASN1UTCTime:(ASN1UTCTime *)paramASN1UTCTime paramInt:(int)paramInt;
- (void)addCRLEntry:(ASN1Integer *)paramASN1Integer paramTime:(Time *)paramTime paramInt:(int)paramInt;
- (void)addCRLEntry:(ASN1Integer *)paramASN1Integer paramTime:(Time *)paramTime paramInt:(int)paramInt paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime;
- (void)addCRLEntry:(ASN1Integer *)paramASN1Integer paramTime:(Time *)paramTime paramExtensions:(Extensions *)paramExtensions;

@end
