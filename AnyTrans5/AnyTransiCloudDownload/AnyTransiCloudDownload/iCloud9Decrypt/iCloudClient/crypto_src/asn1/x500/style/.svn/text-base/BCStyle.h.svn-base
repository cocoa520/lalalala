//
//  BCStyle.h
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "AbstractX500NameStyle.h"
#import "X500NameStyle.h"

@interface BCStyle : AbstractX500NameStyle

+ (ASN1ObjectIdentifier *)C;
+ (ASN1ObjectIdentifier *)O;
+ (ASN1ObjectIdentifier *)OU;
+ (ASN1ObjectIdentifier *)T;
+ (ASN1ObjectIdentifier *)CN;
+ (ASN1ObjectIdentifier *)SN;
+ (ASN1ObjectIdentifier *)STREET;
+ (ASN1ObjectIdentifier *)SERIALNUMBER;
+ (ASN1ObjectIdentifier *)L;
+ (ASN1ObjectIdentifier *)ST;
+ (ASN1ObjectIdentifier *)SURNAME;
+ (ASN1ObjectIdentifier *)GIVENNAME;
+ (ASN1ObjectIdentifier *)INITIALS;
+ (ASN1ObjectIdentifier *)GENERATION;
+ (ASN1ObjectIdentifier *)UNIQUE_IDENTIFIER;
+ (ASN1ObjectIdentifier *)BUSINESS_CATEGORY;
+ (ASN1ObjectIdentifier *)POSTAL_CODE;
+ (ASN1ObjectIdentifier *)DN_QUALIFIER;
+ (ASN1ObjectIdentifier *)PSEUDONYM;
+ (ASN1ObjectIdentifier *)DATE_OF_BIRTH;
+ (ASN1ObjectIdentifier *)PLACE_OF_BIRTH;
+ (ASN1ObjectIdentifier *)GENDER;
+ (ASN1ObjectIdentifier *)COUNTRY_OF_CITIZENSHIP;
+ (ASN1ObjectIdentifier *)COUNTRY_OF_RESIDENCE;
+ (ASN1ObjectIdentifier *)NAME_AT_BIRTH;
+ (ASN1ObjectIdentifier *)POSTAL_ADDRESS;
+ (ASN1ObjectIdentifier *)DMD_NAME;
+ (ASN1ObjectIdentifier *)TELEPHONE_NUMBER;
+ (ASN1ObjectIdentifier *)NAME;
+ (ASN1ObjectIdentifier *)EmailAddress;
+ (ASN1ObjectIdentifier *)UnstructuredName;
+ (ASN1ObjectIdentifier *)UnstructuredAddress;
+ (ASN1ObjectIdentifier *)E;
+ (ASN1ObjectIdentifier *)DC;
+ (ASN1ObjectIdentifier *)UID;
+ (NSMutableDictionary *)DefaultSymbols;
+ (NSMutableDictionary *)DefaultLookUp;
+ (X500NameStyle *)INSTANCE;

- (NSMutableDictionary *)defaultLookUp;
- (NSMutableDictionary *)defaultSymbols;
- (ASN1Encodable *)encodeStringValue:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString;
- (NSString *)oidToDisplayName:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (NSMutableArray *)oidToAttrNames:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (ASN1ObjectIdentifier *)attrNameToOID:(NSString *)paramString;
- (NSMutableArray *)fromString:(NSString *)paramString;
- (NSString *)toString:(X500Name *)paramX500Name;

@end
