//
//  GenMsgContent.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "InfoTypeAndValue.h"

@interface GenMsgContent : ASN1Object {
@private
    ASN1Sequence *_content;
}

+ (GenMsgContent *)getInstance:(id)paramObject;
- (instancetype)initParamInfoTypeAndValue:(InfoTypeAndValue *)paramInfoTypeAndValue;
- (instancetype)initParamArrayOfInfoTypeAndValue:(NSMutableArray *)paramArrayOfInfoTypeAndValue;
- (NSMutableArray *)toInfoTypeAndValueArray;
- (ASN1Primitive *)toASN1Primitive;

@end
