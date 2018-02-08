//
//  OcspListID.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"

@interface OcspListID : ASN1Object {
@private
    ASN1Sequence *_ocspResponses;
}

+ (OcspListID *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfOcspResponsesID:(NSMutableArray *)paramArrayOfOcspResponsesID;
- (NSMutableArray *)getOcspResponses;
- (ASN1Primitive *)toASN1Primitive;

@end
