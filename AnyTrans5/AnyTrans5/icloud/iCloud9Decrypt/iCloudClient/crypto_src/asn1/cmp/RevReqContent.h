//
//  RevReqContent.h
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "RevDetails.h"

@interface RevReqContent : ASN1Object {
@private
    ASN1Sequence *_content;
}

+ (RevReqContent *)getInstance:(id)paramObject;
- (instancetype)initParamRevDetails:(RevDetails *)paramRevDetails;
- (instancetype)initParamArrayOfRevDetails:(NSMutableArray *)paramArrayOfRevDetails;
- (NSMutableArray *)toRevDetailsArray;
- (ASN1Primitive *)toASN1Primitive;

@end
