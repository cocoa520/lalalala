//
//  ECGOST3410NamedCurves.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface ECGOST3410NamedCurves : NSObject

+ (NSMutableDictionary *)objIds;
+ (NSMutableDictionary *)params;
+ (NSMutableDictionary *)names;
+ (NSEnumerator *)getNames;
+ (NSString *)getName:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
+ (ASN1ObjectIdentifier *)getOID:(NSString *)paramString;

@end
