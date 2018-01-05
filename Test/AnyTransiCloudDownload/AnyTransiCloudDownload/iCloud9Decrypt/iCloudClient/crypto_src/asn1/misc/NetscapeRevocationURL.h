//
//  NetscapeRevocationURL.h
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERIA5String.h"

@interface NetscapeRevocationURL : DERIA5String

- (instancetype)initParamDERIA5String:(DERIA5String *)paramDERIA5String;
- (NSString *)toString;

@end
