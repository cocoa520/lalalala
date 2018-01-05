//
//  BCStrictStyle.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BCStyle.h"
#import "X500Name.h"

@interface BCStrictStyle : BCStyle

+ (X500NameStyle *)INSTANCE;
- (BOOL)areEqual:(X500Name *)paramX500Name1 paramX500Name2:(X500Name *)paramX500Name2;

@end
