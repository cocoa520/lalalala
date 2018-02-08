//
//  NameConstraintValidatorException.h
//  crypto
//
//  Created by JGehry on 7/12/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NameConstraintValidatorException : NSObject

- (instancetype)initParamString:(NSString *)paramString;

@end
