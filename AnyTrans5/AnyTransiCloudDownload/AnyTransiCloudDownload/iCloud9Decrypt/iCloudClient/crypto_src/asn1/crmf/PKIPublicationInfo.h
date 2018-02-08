//
//  PKIPublicationInfo.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "ASN1Sequence.h"

@interface PKIPublicationInfo : ASN1Object {
@private
    ASN1Integer *_action;
    ASN1Sequence *_pubInfos;
}

+ (PKIPublicationInfo *)getInstance:(id)paramObject;
- (ASN1Integer *)getAction;
- (NSMutableArray *)getPubInfos;
- (ASN1Primitive *)toASN1Primitive;

@end
