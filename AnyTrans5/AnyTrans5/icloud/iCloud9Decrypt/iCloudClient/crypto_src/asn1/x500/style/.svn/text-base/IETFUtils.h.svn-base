//
//  IETFUtils.h
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"
#import "X500NameStyle.h"

@interface IETFUtils : NSObject

+ (NSMutableArray *)findAttrNamesForOID:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramHashTable:(NSMutableDictionary *)paramHashTable;
+ (ASN1ObjectIdentifier *)decodeAttrName:(NSString *)paramString paramHashTable:(NSMutableDictionary *)paramHashTable;
+ (NSMutableArray *)rDNsFromString:(NSString *)paramString paramX500NameStyle:(X500NameStyle *)paramX500NameStyle;
+ (ASN1Encodable *)valueFromHexString:(NSString *)paramString paramInt:(int)paramInt;
+ (void)appendRDN:(NSMutableString *)paramStringBuffer paramRDN:(RDN *)paramRDN paramHashTable:(NSMutableDictionary *)paramHashTable;
+ (void)appendTypeAndValue:(NSMutableString *)paramStringBuffer paramAttributeTypeAndValue:(AttributeTypeAndValue *)paramAttributeTypeAndValue paramHashTable:(NSMutableDictionary *)paramHashTable;
+ (NSString *)canonicalize:(NSString *)paramString;
+ (NSString *)stripInternalSpaces:(NSString *)paramString;
+ (BOOL)rDNAreEqual:(RDN *)paramRDN1 paramRDN2:(RDN *)paramRDN2;

@end
