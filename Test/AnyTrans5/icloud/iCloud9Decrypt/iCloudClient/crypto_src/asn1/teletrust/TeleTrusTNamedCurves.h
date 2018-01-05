//
//  TeleTrusTNamedCurves.h
//  crypto
//
//  Created by JGehry on 6/16/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECCurve.h"
#import "X9ECParametersHolder.h"

@interface TeleTrusTNamedCurves : NSObject

+ (X9ECParametersHolder *)brainpoolP160r1;
+ (X9ECParametersHolder *)brainpoolP160t1;
+ (X9ECParametersHolder *)brainpoolP192r1;
+ (X9ECParametersHolder *)brainpoolP192t1;
+ (X9ECParametersHolder *)brainpoolP224r1;
+ (X9ECParametersHolder *)brainpoolP224t1;
+ (X9ECParametersHolder *)brainpoolP256r1;
+ (X9ECParametersHolder *)brainpoolP256t1;
+ (X9ECParametersHolder *)brainpoolP320r1;
+ (X9ECParametersHolder *)brainpoolP320t1;
+ (X9ECParametersHolder *)brainpoolP384r1;
+ (X9ECParametersHolder *)brainpoolP384t1;
+ (X9ECParametersHolder *)brainpoolP512r1;
+ (X9ECParametersHolder *)brainpoolP512t1;
+ (NSMutableDictionary *)objIds;
+ (NSMutableDictionary *)curves;
+ (NSMutableDictionary *)names;
+ (ECCurve *)configureCurve:(ECCurve *)paramECCurve;
+ (void)defineCurve:(NSString *)paramString paramASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramX9ECParametersHolder:(X9ECParametersHolder *)paramX9ECParametersHolder;
+ (X9ECParameters *)getByName:(NSString *)paramString;
+ (X9ECParameters *)getByOID:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString;
+ (ASN1ObjectIdentifier *)getOID:(NSString *)paramString;
+ (NSString *)getName:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
+ (NSEnumerator *)getNames;
+ (ASN1ObjectIdentifier *)getOID:(short)paramShort paramBoolean:(BOOL)paramBoolean;

@end
