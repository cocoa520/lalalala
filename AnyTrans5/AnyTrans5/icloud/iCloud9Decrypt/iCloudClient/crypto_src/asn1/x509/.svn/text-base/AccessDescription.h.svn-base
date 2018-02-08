//
//  AccessDescription.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "GeneralName.h"

@interface AccessDescription : ASN1Object {
    ASN1ObjectIdentifier *_accessMethod;
    GeneralName *_accessLocation;
}

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *accessMethod;
@property (nonatomic, readwrite, retain) GeneralName *accessLocation;

+ (ASN1ObjectIdentifier *)id_ad_caIssuers;
+ (ASN1ObjectIdentifier *)id_ad_ocsp;
+ (AccessDescription *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramGeneralName:(GeneralName *)paramGeneralName;
- (ASN1ObjectIdentifier *)getAccessMethod;
- (GeneralName *)getAccessLocation;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;

@end
