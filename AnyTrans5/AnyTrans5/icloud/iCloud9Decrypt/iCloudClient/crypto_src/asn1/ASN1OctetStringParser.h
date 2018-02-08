//
//  ASN1OctetStringParser.h
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Primitive.h"
#import "CategoryExtend.h"

@interface ASN1OctetStringParser : ASN1Primitive

- (Stream *)getOctetStream;

@end
