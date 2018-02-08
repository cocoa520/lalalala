//
//  DEROctetString.h
//  crypto
//
//  Created by JGehry on 5/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1OctetString.h"
#import "ASN1Encodable.h"
#import "DEROutputStream.h"

@interface DEROctetString : ASN1OctetString

+ (void)encode:(DEROutputStream *)paramDEROutputStream paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initDEROctetString:(NSMutableData *)paramArrayOfByte;
- (instancetype)initDEROctetASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;

@end
