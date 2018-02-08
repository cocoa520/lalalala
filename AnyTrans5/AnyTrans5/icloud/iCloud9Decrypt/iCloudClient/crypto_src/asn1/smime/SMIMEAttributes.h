//
//  SMIMEAttributes.h
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface SMIMEAttributes : NSObject

+ (ASN1ObjectIdentifier *)smimeCapabilities;
+ (ASN1ObjectIdentifier *)encrypKeyPref;

@end
