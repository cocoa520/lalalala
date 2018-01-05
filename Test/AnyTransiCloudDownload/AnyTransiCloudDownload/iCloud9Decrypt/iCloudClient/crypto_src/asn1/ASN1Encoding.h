//
//  ASN1Encoding.h
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASN1Encoding : NSObject

+ (NSString *)DER;
+ (NSString *)DL;
+ (NSString *)BER;

@end
