//
//  CertificationAuthorityReference.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertificateHolderReference.h"

@interface CertificationAuthorityReference : CertificateHolderReference

- (instancetype)initParamString1:(NSString *)paramString1 paramString2:(NSString *)paramString2 paramString3:(NSString *)paramString3;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;

@end
