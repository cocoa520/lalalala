//
//  PublicKeyDataObject.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"

@interface PublicKeyDataObject : ASN1Object

+ (PublicKeyDataObject *)getInstance:(id)paramObject;
- (ASN1ObjectIdentifier *)getUsage;

@end
