//
//  POPODecKeyRespContent.h
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"

@interface POPODecKeyRespContent : ASN1Object {
@private
    ASN1Sequence *_content;
}

+ (POPODecKeyRespContent *)getInstance:(id)paramObject;
- (NSMutableArray *)toASN1IntegerArray;
- (ASN1Primitive *)toASN1Primitive;

@end
