//
//  ErrorMsgContent.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "PKIStatusInfo.h"
#import "ASN1Integer.h"
#import "PKIFreeText.h"

@interface ErrorMsgContent : ASN1Object {
@private
    PKIStatusInfo *_pkiStatusInfo;
    ASN1Integer *_errorCode;
    PKIFreeText *_errorDetails;
}

+ (ErrorMsgContent *)getInstance:(id)paramObject;
- (instancetype)initParamPKIStatusInfo:(PKIStatusInfo *)paramPKIStatusInfo;
- (instancetype)initParamPKIStatusInfo:(PKIStatusInfo *)paramPKIStatusInfo paramASN1Integer:(ASN1Integer *)paramASN1Integer paramPKIFreeText:(PKIFreeText *)paramPKIFreeText;
- (PKIStatusInfo *)getPKIStatusInfo;
- (ASN1Integer *)getErrorCode;
- (PKIFreeText *)getErrorDetails;
- (ASN1Primitive *)toASN1Primitive;

@end
