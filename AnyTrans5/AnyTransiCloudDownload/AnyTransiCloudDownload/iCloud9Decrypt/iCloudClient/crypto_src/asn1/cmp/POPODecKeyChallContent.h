//
//  POPODecKeyChallContent.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"

@interface POPODecKeyChallContent : ASN1Object {
@private
    ASN1Sequence *_content;
}

+ (POPODecKeyChallContent *)getInstance:(id)paramObject;
- (NSMutableArray *)toChallengeArray;
- (ASN1Primitive *)toASN1Primitive;

@end
