//
//  SMIMECapabilitiesAttribute.h
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Attribute.h"
#import "SMIMECapabilityVector.h"

@interface SMIMECapabilitiesAttribute : Attribute

- (instancetype)initParamSMIMECapabilityVector:(SMIMECapabilityVector *)paramSMIMECapabilityVector;

@end
