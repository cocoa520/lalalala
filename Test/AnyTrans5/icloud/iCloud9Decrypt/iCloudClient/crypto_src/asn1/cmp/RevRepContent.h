//
//  RevRepContent.h
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"

@interface RevRepContent : ASN1Object {
@private
    ASN1Sequence *_status;
    ASN1Sequence *_revCerts;
    ASN1Sequence *_crls;
}

+ (RevRepContent *)getInstance:(id)paramObject;
- (NSMutableArray *)getStatus;
- (NSMutableArray *)getRevCerts;
- (NSMutableArray *)getCrls;
- (ASN1Primitive *)toASN1Primitive;

@end
