//
//  NISTNamedCurves.h
//  crypto
//
//  Created by JGehry on 6/16/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"
#import "X9ECParameters.h"

@interface NISTNamedCurves : NSObject

+ (NSMutableDictionary *)objIds;
+ (NSMutableDictionary *)names;
+ (void)defineCurveAlia:(NSString *)paramString paramASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
+ (X9ECParameters *)getByName:(NSString *)paramString;
+ (X9ECParameters *)getByOID:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString;
+ (ASN1ObjectIdentifier *)getOID:(NSString *)paramString;
+ (NSString *)getName:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
+ (NSEnumerator *)getNames;

@end
