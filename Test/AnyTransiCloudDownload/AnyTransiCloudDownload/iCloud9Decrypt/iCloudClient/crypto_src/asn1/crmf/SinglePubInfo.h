//
//  SinglePubInfo.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "GeneralName.h"

@interface SinglePubInfo : ASN1Object {
@private
    ASN1Integer *_pubMethod;
    GeneralName *_pubLocation;
}

+ (SinglePubInfo *)getInstance:(id)paramObject;
- (GeneralName *)getPubLocation;
- (ASN1Primitive *)toASN1Primitive;

@end
