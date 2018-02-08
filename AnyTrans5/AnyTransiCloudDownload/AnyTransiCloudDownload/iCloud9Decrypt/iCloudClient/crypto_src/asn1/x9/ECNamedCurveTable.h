//
//  ECNamedCurveTable.h
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "X9ECParameters.h"
#import "ASN1ObjectIdentifier.h"

@interface ECNamedCurveTable : NSObject

+ (X9ECParameters *)getByName:(NSString *)paramString;
+ (ASN1ObjectIdentifier *)getOID:(NSString *)paramString;
+ (NSString *)getName:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
+ (X9ECParameters *)getByOID:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
+ (NSEnumerator *)getNames;

@end
