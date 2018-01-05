//
//  RecipientInfo.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1Integer.h"
#import "KeyTransRecipientInfo.h"
#import "KeyAgreeRecipientInfo.h"
#import "KEKRecipientInfo.h"
#import "PasswordRecipientInfo.h"
#import "OtherRecipientInfo.h"

@interface RecipientInfo : ASN1Choice {
    ASN1Encodable *_info;
}

@property (nonatomic, readwrite, retain) ASN1Encodable *info;

+ (RecipientInfo *)getInstance:(id)paramObject;
- (instancetype)initParamKeyTransRecipientInfo:(KeyTransRecipientInfo *)paramKeyTransRecipientInfo;
- (instancetype)initParamKeyAgreeRecipientInfo:(KeyAgreeRecipientInfo *)paramKeyAgreeRecipientInfo;
- (instancetype)initParamKEKRecipientInfo:(KEKRecipientInfo *)paramKEKRecipientInfo;
- (instancetype)initParamPasswordRecipientInfo:(PasswordRecipientInfo *)paramPasswordRecipientInfo;
- (instancetype)initParamOtherRecipientInfo:(OtherRecipientInfo *)paramOtherRecipientInfo;
- (instancetype)initParamASN1Primitive:(ASN1Primitive *)paramASN1Primitive;
- (ASN1Integer *)getVersion;
- (BOOL)isTagged;
- (ASN1Encodable *)getInfo;
- (ASN1Primitive *)toASN1Primitive;

@end
