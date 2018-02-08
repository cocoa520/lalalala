//
//  GOST3410NamedParameters.h
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"

@interface GOST3410NamedParameters : ASN1Object

+ (NSMutableDictionary *)objIds;
+ (NSMutableDictionary *)params;
+ (NSMutableDictionary *)names;

+ (GOST3410NamedParameters *)getByOID:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
+ (NSEnumerator *)getNames;
+ (GOST3410NamedParameters *)getByName:(NSString *)paramString;
+ (ASN1ObjectIdentifier *)getOID:(NSString *)paramString;

@end
