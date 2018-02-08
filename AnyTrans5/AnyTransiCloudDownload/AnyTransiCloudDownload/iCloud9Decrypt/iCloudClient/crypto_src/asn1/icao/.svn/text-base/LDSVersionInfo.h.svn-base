//
//  LDSVersionInfo.h
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "DERPrintableString.h"

@interface LDSVersionInfo : ASN1Object {
@private
    DERPrintableString *_ldsVersion;
    DERPrintableString *_unicodeVersion;
}

+ (LDSVersionInfo *)getInstance:(id)paramObject;
- (instancetype)initParamString1:(NSString *)paramString1 paramString2:(NSString *)paramString2;
- (NSString *)getLdsVersion;
- (NSString *)getUnicodeVersion;
- (ASN1Primitive *)toASN1Primitive;

@end
