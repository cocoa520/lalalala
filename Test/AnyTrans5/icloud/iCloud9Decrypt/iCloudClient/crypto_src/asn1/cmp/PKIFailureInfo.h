//
//  PKIFailureInfo.h
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERBitString.h"

@interface PKIFailureInfo : DERBitString

+ (int)badAlg;
+ (int)badMessageCheck;
+ (int)badRequest;
+ (int)badTime;
+ (int)badCertId;
+ (int)badDataFormat;
+ (int)wrongAuthority;
+ (int)incorrectData;
+ (int)missingTimeStamp;
+ (int)badPOP;
+ (int)certRevoked;
+ (int)certConfirmed;
+ (int)wrongIntegrity;
+ (int)badRecipientNonce;
+ (int)timeNotAvailable;
+ (int)unacceptedPolicy;
+ (int)unacceptedExtension;
+ (int)addInfoNotAvailable;
+ (int)badSenderNonce;
+ (int)badCertTemplate;
+ (int)signerNotTrusted;
+ (int)transactionIdInUse;
+ (int)unsupportedVersion;
+ (int)notAuthorized;
+ (int)systemUnavail;
+ (int)systemFailure;
+ (int)duplicateCertReq;
+ (int)BAD_ALG;
+ (int)BAD_MESSAGE_CHECK;
+ (int)BAD_REQUEST;
+ (int)BAD_TIME;
+ (int)BAD_CERT_ID;
+ (int)BAD_DATA_FORMAT;
+ (int)WRONG_AUTHORITY;
+ (int)INCORRECT_DATA;
+ (int)MISSING_TIME_STAMP;
+ (int)BAD_POP;
+ (int)TIME_NOT_AVAILABLE;
+ (int)UNACCEPTED_POLICY;
+ (int)UNACCEPTED_EXTENSION;
+ (int)ADD_INFO_NOT_AVAILABLE;
+ (int)SYSTEM_FAILURE;
- (instancetype)initParamInt:(int)paramInt;
- (instancetype)initParamDERBitString:(DERBitString *)paramDERBitString;
- (NSString *)toString;

@end
