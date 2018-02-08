//
//  CertConfirmContent.h
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"

@interface CertConfirmContent : ASN1Object {
@private
    ASN1Sequence *_content;
}

+ (CertConfirmContent *)getInstance:(id)paramObject;
- (NSMutableArray *)toCertStatusArray;
- (ASN1Primitive *)toASN1Primitive;

@end
