//
//  PKIHeader.h
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "GeneralName.h"
#import "ASN1Integer.h"
#import "ASN1GeneralizedTime.h"
#import "AlgorithmIdentifier.h"
#import "ASN1OctetString.h"
#import "PKIFreeText.h"
#import "ASN1Sequence.h"

@interface PKIHeader : ASN1Object {
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

+ (GeneralName *)NULL_NAME;
+ (int)CMP_1999;
+ (int)CMP_2000;
+ (PKIHeader *)getInstance:(id)paramObject;
- (instancetype)initParamInt:(int)paramInt paramGeneralName1:(GeneralName *)paramGeneralName1 paramGeneralName2:(GeneralName *)paramGeneralName2;
- (ASN1Integer *)getPvno;
- (GeneralName *)getSender;
- (GeneralName *)getRecipient;
- (ASN1GeneralizedTime *)getMessageTime;
- (AlgorithmIdentifier *)getProtectionAlg;
- (ASN1OctetString *)getSenderKID;
- (ASN1OctetString *)getRecipKID;
- (ASN1OctetString *)getTransactionID;
- (ASN1OctetString *)getSenderNonce;
- (ASN1OctetString *)getRecipNonce;
- (PKIFreeText *)gerFreeText;
- (NSMutableArray *)getGeneralInfo;
- (ASN1Primitive *)toASN1Primitive;

@end
