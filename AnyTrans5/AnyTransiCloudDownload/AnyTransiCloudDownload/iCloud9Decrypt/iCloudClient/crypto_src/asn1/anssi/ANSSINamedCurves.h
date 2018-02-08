//
//  ANSSINamedCurves.h
//  crypto
//
//  Created by JGehry on 6/2/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "X9ECParameters.h"
#import "X9ECParametersHolder.h"

@interface ANSSINamedCurves : NSObject

+ (X9ECParametersHolder *)FRP256v1;
+ (X9ECParameters *)getByName:(NSString *)paramString;
+ (ASN1ObjectIdentifier *)getOID:(NSString *)paramString;
+ (X9ECParameters *)getByOID:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString;
+ (NSString *)getName:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
+ (NSEnumerator *)getNames;
+ (ECCurve *)configureCurve:(ECCurve *)paramECCurve;
+ (BigInteger *)fromHex:(NSString *)paramString;
+ (void)defineCurve:(NSString *)paramString paramASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramX9ECParametersHolder:(X9ECParametersHolder *)paramX9ECParametersHolder;

@end
