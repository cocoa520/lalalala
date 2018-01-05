//
//  DataGroupHash.h
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "ASN1OctetString.h"

@interface DataGroupHash : ASN1Object {
@private
    ASN1Integer *_dataGroupNumber;
    ASN1OctetString *_dataGroupHashValue;
}

+ (DataGroupHash *)getInstance:(id)paramObject;
- (instancetype)initParamInt:(int)paramInt paramASN1OctecString:(ASN1OctetString *)paramASN1OctetString;
- (int)getDataGroupNumber;
- (ASN1OctetString *)getDataGroupHashValue;
- (ASN1Primitive *)toASN1Primitive;

@end
