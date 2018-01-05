//
//  DERDump.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Dump.h"
#import "ASN1Primitive.h"
#import "ASN1Encodable.h"

@interface DERDump : ASN1Dump

+ (NSString *)dumpAsStringParamASN1Primitive:(ASN1Primitive *)paramASN1Primitive;
+ (NSString *)dumpAsStringParamASN1Encodable:(ASN1Encodable *)paramASN1Encodable;

@end
