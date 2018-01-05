//
//  X509Name.h
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "X509NameEntryConverter.h"
#import "ASN1Sequence.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1TaggedObject.h"

@interface X509Name : ASN1Object {
    X509NameEntryConverter *_converter;
    NSMutableArray *_ordering;
    NSMutableArray *_values;
    NSMutableArray *_added;
    ASN1Sequence *_seq;
    BOOL _isHashCodeCalculated;
    int _hashCodeValue;
}

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
+ (BOOL)DefaultReverse;
+ (NSMutableDictionary *)DefaultSymbols;
+ (NSMutableDictionary *)RFC2253Symbols;
+ (NSMutableDictionary *)RFC1779Symbols;
+ (NSMutableDictionary *)DefaultLookUp;
+ (NSMutableDictionary *)OIDLookUp;
+ (NSMutableDictionary *)SymbolLookUp;
+ (BOOL)ISTRUE;
+ (BOOL)ISFALSE;
+ (X509Name *)getInstance:(id)paramObject;
+ (X509Name *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)init;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamHashtable:(NSMutableDictionary *)paramHashtable;
- (instancetype)initParamVector:(NSMutableArray *)paramVector paramHashtable:(NSMutableDictionary *)paramHashtable;
- (instancetype)initParamVector:(NSMutableArray *)paramVector paramHashtable:(NSMutableDictionary *)paramHashtable paramX509NameEntryConverter:(X509NameEntryConverter *)paramX509NameEntryConverter;
- (instancetype)initParamVector1:(NSMutableArray *)paramVector1 paramVector2:(NSMutableArray *)paramVector2;
- (instancetype)initParamVector1:(NSMutableArray *)paramVector1 paramVector2:(NSMutableArray *)paramVector2 paramX509NameEntryConverter:(X509NameEntryConverter *)paramX509NameEntryConverter;
- (instancetype)initParamString:(NSString *)paramString;
- (instancetype)initParamString:(NSString *)paramString paramX509NameEntryConverter:(X509NameEntryConverter *)paramX509NameEntryConverter;
- (instancetype)initParamBoolean:(BOOL)paramBoolean paramString:(NSString *)paramString;
- (instancetype)initParamBoolean:(BOOL)paramBoolean paramString:(NSString *)paramString paramX509NameEntryConverter:(X509NameEntryConverter *)paramX509NameEntryConverter;
- (instancetype)initParamBoolean:(BOOL)paramBoolean paramHashtable:(NSMutableDictionary *)paramHashtable paramString:(NSString *)paramString;
- (instancetype)initParamBoolean:(BOOL)paramBoolean paramHashtable:(NSMutableDictionary *)paramHashtable paramString:(NSString *)paramString paramX509NameEntryConverter:(X509NameEntryConverter *)paramX509NameEntryConverter;
- (NSMutableArray *)getOIDs;
- (NSMutableArray *)getValues;
- (NSMutableArray *)getValues:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (ASN1Primitive *)toASN1Primitive;
- (BOOL)equals:(id)paramObject paramBoolean:(BOOL)paramBoolean;
- (NSString *)toString:(BOOL)paramBoolean paramHashtable:(NSMutableDictionary *)paramHashtable;
- (NSString *)toString;

@end
