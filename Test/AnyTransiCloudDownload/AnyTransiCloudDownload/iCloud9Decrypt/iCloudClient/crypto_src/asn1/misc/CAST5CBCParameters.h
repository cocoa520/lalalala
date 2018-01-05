//
//  CAST5CBCParameters.h
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "ASN1OctetString.h"
#import "ASN1Sequence.h"

@interface CAST5CBCParameters : ASN1Object {
    ASN1Integer *_keyLength;
    ASN1OctetString *_iv;
}

@property (nonatomic, readwrite, retain) ASN1Integer *keyLength;
@property (nonatomic, readwrite, retain) ASN1OctetString *iv;

+ (CAST5CBCParameters *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (NSMutableData *)getIV;
- (int)getKeyLength;
- (ASN1Primitive *)toASN1Primitive;

@end
