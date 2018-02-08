//
//  Data.h
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1OctetString.h"
#import "DigestInfo.h"
#import "ASN1Sequence.h"
#import "TargetEtcChain.h"

@interface DataDVCS : ASN1Choice {
@private
    ASN1OctetString *_message;
    DigestInfo *_messageImprint;
    ASN1Sequence *_certs;
}

+ (DataDVCS *)getInstance:(id)paramObject;
+ (DataDVCS *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (instancetype)initParamDigestInfo:(DigestInfo *)paramDigestInfo;
- (instancetype)initParamTargetEtcChain:(TargetEtcChain *)paramTargetEtcChain;
- (instancetype)initParamArrayOfTargetEtcChain:(NSMutableArray *)paramArrayOfTargetEtcChain;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;
- (ASN1OctetString *)getMessage;
- (DigestInfo *)getMessageImprint;
- (NSMutableArray *)getCerts;

@end
