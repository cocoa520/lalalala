//
//  ASN1ApplicationSpecificParser.h
//  crypto
//
//  Created by JGehry on 7/25/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Encodable.h"

@interface ASN1ApplicationSpecificParser : ASN1Encodable

- (ASN1Encodable *)readObject;

@end
