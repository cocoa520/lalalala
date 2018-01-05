//
//  LazyEncodedSequence.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Sequence.h"
#import "ASN1OutputStream.h"

@interface LazyEncodedSequence : ASN1Sequence {
@private
    NSMutableData *_encoded;
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (ASN1Encodable *)getObjectAt:(int)paramInt;
- (NSEnumerator *)getObjects;
- (int)size;
- (ASN1Primitive *)toDERObject;
- (ASN1Primitive *)toDLObject;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;

@end
