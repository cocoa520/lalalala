//
//  PollRepContent.h
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "PKIFreeText.h"

@interface PollRepContent : ASN1Object {
@private
    NSMutableArray *_certReqId;
    NSMutableArray *_checkAfter;
    NSMutableArray *_reason;
}

+ (PollRepContent *)getInstance:(id)paramObject;
- (instancetype)initParamASN1Integer1:(ASN1Integer *)paramASN1Integer1 paramASN1Integer2:(ASN1Integer *)paramASN1Integer2;
- (instancetype)initParamASN1Integer1:(ASN1Integer *)paramASN1Integer1 paramASN1Integer2:(ASN1Integer *)paramASN1Integer2 paramPKIFreeText:(PKIFreeText *)paramPKIFreeText;
- (int)size;
- (ASN1Integer *)getCertReqId:(int)paramInt;
- (ASN1Integer *)getCheckAfter:(int)paramInt;
- (PKIFreeText *)getReason:(int)paramInt;
- (ASN1Primitive *)toASN1Primitive;

@end
