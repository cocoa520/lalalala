//
//  ASN1TaggedObjectParser.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Primitive.h"

@interface ASN1TaggedObjectParser : ASN1Primitive

- (int)getTagNo;
- (ASN1Encodable *)getObjectParser:(int)paramInt paramBoolean:(BOOL)paramBoolean;

@end
