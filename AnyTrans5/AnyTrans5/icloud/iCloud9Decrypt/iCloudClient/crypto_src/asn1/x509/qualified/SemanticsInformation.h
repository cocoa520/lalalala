//
//  SemanticsInformation.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"

@interface SemanticsInformation : ASN1Object {
@private
    ASN1ObjectIdentifier *_semanticsIdentifier;
    NSMutableArray *_nameRegistrationAuthorities;
}

+ (SemanticsInformation *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramArrayOfGeneralName:(NSMutableArray *)paramArrayOfGeneralName;
- (instancetype)initParamArrayOfGeneralName:(NSMutableArray *)paramArrayOfGeneralName;
- (ASN1ObjectIdentifier *)getSemanticsIdentifier;
- (NSMutableArray *)getNameRegistrationAuthorities;
- (ASN1Primitive *)toASN1Primitive;

@end
