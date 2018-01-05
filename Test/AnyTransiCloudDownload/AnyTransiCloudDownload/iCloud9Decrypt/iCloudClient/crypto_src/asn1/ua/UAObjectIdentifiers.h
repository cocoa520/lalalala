//
//  UAObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface UAObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)UaOid;
+ (ASN1ObjectIdentifier *)dstu4145le;
+ (ASN1ObjectIdentifier *)dstu4145be;

@end
