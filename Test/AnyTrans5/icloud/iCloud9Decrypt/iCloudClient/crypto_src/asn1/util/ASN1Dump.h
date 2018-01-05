//
//  ASN1Dump.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1Primitive.h"

@interface ASN1Dump : NSObject

+ (void)_dumpAsString:(NSString *)paramString paramBoolean:(BOOL)paramBoolean paramASN1Primitive:(ASN1Primitive *)paramASN1Primitive paramStringBuffer:(NSMutableString *)paramStringBuffer;
+ (NSString *)dumpAsString:(id)paramObject;
+ (NSString *)dumpAsString:(id)paramObject paramBoolean:(BOOL)paramBoolean;

@end
