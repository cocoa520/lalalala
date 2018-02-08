//
//  X509NameEntryConverter.h
//  crypto
//
//  Created by JGehry on 7/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1Primitive.h"
#import "ASN1ObjectIdentifier.h"

@interface X509NameEntryConverter : NSObject

- (ASN1Primitive *)convertHexEncoded:(NSString *)paramString paramInt:(int)paramInt;
- (BOOL)canBePrintable:(NSString *)paramString;
- (ASN1Primitive *)getConvertedValue:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString;

@end
