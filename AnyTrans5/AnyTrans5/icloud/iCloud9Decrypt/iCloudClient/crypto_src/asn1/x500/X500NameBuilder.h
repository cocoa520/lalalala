//
//  X500NameBuilder.h
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "X500Name.h"
#import "X500NameStyle.h"

@interface X500NameBuilder : NSObject {
@private
    X500NameStyle *_template;
}

- (instancetype)init;
- (instancetype)initParamX500NameStyle:(X500NameStyle *)paramX500NameStyle;
- (X500NameBuilder *)addRDNParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString;
- (X500NameBuilder *)addRDNParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (X500NameBuilder *)addRDNParamAttributeTypeAndValue:(AttributeTypeAndValue *)paramAttributeTypeAndValue;
- (X500NameBuilder *)addMultiValueRDNParamArrayOfASN1ObjectIdentifier:(NSMutableArray *)paramArrayOfASN1ObjectIdentifier paramArrayOfString:(NSMutableArray *)paramArrayOfString;
- (X500NameBuilder *)addMultiValueRDNParamArrayOfASN1ObjectIdentifier:(NSMutableArray *)paramArrayOfASN1ObjectIdentifier paramArrayOfASN1Encodable:(NSMutableArray *)paramArrayOfASN1Encodable;
- (X500NameBuilder *)addMultiValueRDNParamArrayOfAttributeTypeAndValue:(NSMutableArray *)paramArrayOfAttributeTypeAndValue;
- (X500Name *)build;
@end
