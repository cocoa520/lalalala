//
//  X962NamedCurves.h
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "X9ECParameters.h"
#import "X9ECParametersHolder.h"

@interface X962NamedCurves : NSObject

+ (X9ECParametersHolder *)prime192v1;
+ (X9ECParametersHolder *)prime192v2;
+ (X9ECParametersHolder *)prime192v3;
+ (X9ECParametersHolder *)prime239v1;
+ (X9ECParametersHolder *)prime239v2;
+ (X9ECParametersHolder *)prime239v3;
+ (X9ECParametersHolder *)prime256v1;
+ (X9ECParametersHolder *)c2pnb163v1;
+ (X9ECParametersHolder *)c2pnb163v2;
+ (X9ECParametersHolder *)c2pnb163v3;
+ (X9ECParametersHolder *)c2pnb176w1;
+ (X9ECParametersHolder *)c2tnb191v1;
+ (X9ECParametersHolder *)c2tnb191v2;
+ (X9ECParametersHolder *)c2tnb191v3;
+ (X9ECParametersHolder *)c2pnb208w1;
+ (X9ECParametersHolder *)c2tnb239v1;
+ (X9ECParametersHolder *)c2tnb239v2;
+ (X9ECParametersHolder *)c2tnb239v3;
+ (X9ECParametersHolder *)c2pnb272w1;
+ (X9ECParametersHolder *)c2pnb304w1;
+ (X9ECParametersHolder *)c2tnb359v1;
+ (X9ECParametersHolder *)c2pnb368w1;
+ (X9ECParametersHolder *)c2tnb431r1;

+ (X9ECParameters *)getByName:(NSString *)paramString;
+ (ASN1ObjectIdentifier *)getOID:(NSString *)paramString;
+ (X9ECParameters *)getByOID:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString;
+ (NSString *)getName:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
+ (NSEnumerator *)getNames;
+ (void)defineCurve:(NSString *)paramString paramASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramX9ECParametersHolder:(X9ECParametersHolder *)paramX9ECParametersHolder;

@end
