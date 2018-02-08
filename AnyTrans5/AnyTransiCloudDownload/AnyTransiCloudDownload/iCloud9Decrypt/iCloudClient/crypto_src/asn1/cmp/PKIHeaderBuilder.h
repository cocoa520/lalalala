//
//  PKIHeaderBuilder.h
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKIHeader.h"
#import "GeneralName.h"
#import "ASN1Integer.h"
#import "ASN1GeneralizedTime.h"
#import "AlgorithmIdentifier.h"
#import "ASN1OctetString.h"
#import "PKIFreeText.h"
#import "ASN1Sequence.h"
#import "DEROctetString.h"
#import "InfoTypeAndValue.h"

@interface PKIHeaderBuilder : NSObject {
@private
    ASN1Integer *_pvno;
    GeneralName *_sender;
    GeneralName *_recipient;
    ASN1GeneralizedTime *_messageTime;
    AlgorithmIdentifier *_protectionAlg;
    ASN1OctetString *_senderKID;
    ASN1OctetString *_recipKID;
    ASN1OctetString *_transactionID;
    ASN1OctetString *_senderNonce;
    ASN1OctetString *_recipNonce;
    PKIFreeText *_freeText;
    ASN1Sequence *_generalInfo;
}

- (PKIHeader *)build;
- (instancetype)initParamInt:(int)paramInt paramGeneralName1:(GeneralName *)paramGeneralName1 paramGeneralName2:(GeneralName *)paramGeneralName2;
- (PKIHeaderBuilder *)getMessageTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime;
- (PKIHeaderBuilder *)getProtectionAlg:(AlgorithmIdentifier *)paramAlgorithmIdentifier;
- (PKIHeaderBuilder *)getSenderKID:(NSMutableData *)paramArrayOfByte;
- (PKIHeaderBuilder *)getSenderKIDs:(ASN1OctetString *)paramASN1OctetString;
- (PKIHeaderBuilder *)getRecipKID:(NSMutableData *)paramArrayOfByte;
- (PKIHeaderBuilder *)getRecipKIDs:(DEROctetString *)paramASN1OctetString;
- (PKIHeaderBuilder *)getTransactionID:(NSMutableData *)paramArrayOfByte;
- (PKIHeaderBuilder *)getTransactionIDs:(ASN1OctetString *)paramASN1OctetString;
- (PKIHeaderBuilder *)getSenderNonce:(NSMutableData *)paramArrayOfByte;
- (PKIHeaderBuilder *)getSenderNonces:(ASN1OctetString *)paramASN1OctetString;
- (PKIHeaderBuilder *)getsetRecipNonce:(NSMutableData *)paramArrayOfByte;
- (PKIHeaderBuilder *)getsetRecipNonces:(ASN1OctetString *)paramASN1OctetString;
- (PKIHeaderBuilder *)getFreeText:(PKIFreeText *)paramPKIFreeText;
- (PKIHeaderBuilder *)getGeneralInfo:(InfoTypeAndValue *)paramInfoTypeAndValue;
- (PKIHeaderBuilder *)getGeneralInfoParamArrayOf:(NSMutableArray *)paramArrayOfInfoTypeAndValue;
- (PKIHeaderBuilder *)getGeneralInfoParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;

@end
