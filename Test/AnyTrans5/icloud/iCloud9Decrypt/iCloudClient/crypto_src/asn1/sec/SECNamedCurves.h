//
//  SECNamedCurves.h
//  crypto
//
//  Created by JGehry on 6/16/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "X9ECParameters.h"
#import "X9ECParametersHolder.h"
#import "GlvTypeBParameters.h"

@interface SECNamedCurves : NSObject

+ (X9ECParametersHolder *)secp112r1;
+ (X9ECParametersHolder *)secp112r2;
+ (X9ECParametersHolder *)secp128r1;
+ (X9ECParametersHolder *)secp128r2;
+ (X9ECParametersHolder *)secp160k1;
+ (X9ECParametersHolder *)secp160r1;
+ (X9ECParametersHolder *)secp160r2;
+ (X9ECParametersHolder *)secp192k1;
+ (X9ECParametersHolder *)secp192r1;
+ (X9ECParametersHolder *)secp224k1;
+ (X9ECParametersHolder *)secp224r1;
+ (X9ECParametersHolder *)secp256k1;
+ (X9ECParametersHolder *)secp256r1;
+ (X9ECParametersHolder *)secp384r1;
+ (X9ECParametersHolder *)secp521r1;
+ (X9ECParametersHolder *)sect113r1;
+ (X9ECParametersHolder *)sect113r2;
+ (X9ECParametersHolder *)sect131r1;
+ (X9ECParametersHolder *)sect131r2;
+ (X9ECParametersHolder *)sect163k1;
+ (X9ECParametersHolder *)sect163r1;
+ (X9ECParametersHolder *)sect163r2;
+ (X9ECParametersHolder *)sect193r1;
+ (X9ECParametersHolder *)sect193r2;
+ (X9ECParametersHolder *)sect233k1;
+ (X9ECParametersHolder *)sect233r1;
+ (X9ECParametersHolder *)sect239k1;
+ (X9ECParametersHolder *)sect283k1;
+ (X9ECParametersHolder *)sect283r1;
+ (X9ECParametersHolder *)sect409k1;
+ (X9ECParametersHolder *)sect409r1;
+ (X9ECParametersHolder *)sect571k1;
+ (X9ECParametersHolder *)sect571r1;
+ (ECCurve *)configureCurve:(ECCurve *)paramECCurve;
+ (ECCurve *)configureCurve:(ECCurve *)paramECCurve paramGLVTypeBParameters:(GlvTypeBParameters *)paramGLVTypeBParameters;
+ (BigInteger *)fromHex:(NSString *)paramString;
+ (void)defineCurve:(NSString *)paramString paramASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramX9ECParametersHolder:(X9ECParametersHolder *)paramX9ECParametersHolder;
+ (X9ECParameters *)getByName:(NSString *)paramString;
+ (X9ECParameters *)getByOID:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString;
+ (ASN1ObjectIdentifier *)getOID:(NSString *)paramString;
+ (NSString *)getName:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
+ (NSEnumerator *)getNames;

@end
