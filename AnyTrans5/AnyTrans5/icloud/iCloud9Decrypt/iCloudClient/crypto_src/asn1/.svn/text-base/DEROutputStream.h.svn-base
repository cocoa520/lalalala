//
//  DEROutputStream.h
//  crypto
//
//  Created by JGehry on 5/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1OutputStream.h"

@interface DEROutputStream : ASN1OutputStream

- (instancetype)initDERParamOutputStream:(Stream *)paramOutputStream;
- (void)writeObject:(ASN1Encodable *)paramASN1Encodable;
- (ASN1OutputStream *)getDERSubStream;
- (ASN1OutputStream *)getDLSubStream;

@end
