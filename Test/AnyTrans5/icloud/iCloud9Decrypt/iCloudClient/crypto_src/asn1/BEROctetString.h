//
//  BEROctetString.h
//  crypto
//
//  Created by iMobie on 6/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1OctetString.h"
#import "ASN1Sequence.h"

@interface BEROctetString : ASN1OctetString {
    NSMutableArray *_octs;
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamArrayOfASN1OctetString:(NSMutableArray *)paramArrayOfASN1OctetString;
- (NSMutableData *)getOctets;
- (NSEnumerator *)getObjects;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;
+ (BEROctetString *)fromSequence:(ASN1Sequence *)paramASN1Sequence;
@end
