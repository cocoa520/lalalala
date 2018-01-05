//
//  PollReqContent.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "ASN1Integer.h"

@interface PollReqContent : ASN1Object {
@private
    ASN1Sequence *_content;
}

+ (PollReqContent *)getInstance:(id)paramObject;
- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer;
- (NSMutableArray *)getCertReqIds;
- (ASN1Primitive *)toASN1Primitive;

@end
