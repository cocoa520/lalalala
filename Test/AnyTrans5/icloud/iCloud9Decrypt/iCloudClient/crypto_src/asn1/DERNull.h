//
//  DERNull.h
//  crypto
//
//  Created by JGehry on 6/2/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Null.h"
#import "ASN1OutputStream.h"

@interface DERNull : ASN1Null

+ (DERNull *)INSTANCE;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;

@end
