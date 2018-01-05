//
//  DERObjectIdentifier.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1ObjectIdentifier.h"

@interface DERObjectIdentifier : ASN1ObjectIdentifier

- (instancetype)initParamString:(NSString *)paramString;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString;

@end
