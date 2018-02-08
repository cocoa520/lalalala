//
//  X509Name.m
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X509Name.h"
#import "X509ObjectIdentifiers.h"
#import "PKCSObjectIdentifiers.h"
#import "X500Name.h"
#import "ASN1String.h"
#import "DERUniversalString.h"
#import "Hex.h"
#import "X509NameTokenizer.h"
#import "CategoryExtend.h"
#import "DERSequence.h"
#import "DERSet.h"
#import "ASN1EncodableVector.h"
#import "Arrays.h"

@interface X509Name ()

@property (nonatomic, readwrite, retain) X509NameEntryConverter *converter;
@property (nonatomic, readwrite, retain) NSMutableArray *ordering;
@property (nonatomic, readwrite, retain) NSMutableArray *values;
@property (nonatomic, readwrite, retain) NSMutableArray *added;
@property (nonatomic, readwrite, retain) ASN1Sequence *seq;
@property (nonatomic, assign) BOOL isHashCodeCalculated;
@property (nonatomic, assign) int hashCodeValue;

@end

@implementation X509Name
@synthesize converter = _converter;
@synthesize ordering = _ordering;
@synthesize values = _values;
@synthesize added = _added;
@synthesize seq = _seq;
@synthesize isHashCodeCalculated = _isHashCodeCalculated;
@synthesize hashCodeValue = _hashCodeValue;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_converter) {
        [_converter release];
        _converter = nil;
    }
    if (_ordering) {
        [_ordering release];
        _ordering = nil;
    }
    if (_values) {
        [_values release];
        _values = nil;
    }
    if (_added) {
        [_added release];
        _added = nil;
    }
    if (_seq) {
        [_seq release];
        _seq = nil;
    }
    [super dealloc];
#endif
}

+ (ASN1ObjectIdentifier *)C {
    static ASN1ObjectIdentifier *_C = nil;
    @synchronized(self) {
        if (!_C) {
            _C = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.6"];
        }
    }
    return _C;
}

+ (ASN1ObjectIdentifier *)O {
    static ASN1ObjectIdentifier *_O = nil;
    @synchronized(self) {
        if (!_O) {
            _O = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.10"];
        }
    }
    return _O;
}

+ (ASN1ObjectIdentifier *)OU {
    static ASN1ObjectIdentifier *_OU = nil;
    @synchronized(self) {
        if (!_OU) {
            _OU = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.11"];
        }
    }
    return _OU;
}

+ (ASN1ObjectIdentifier *)T {
    static ASN1ObjectIdentifier *_T = nil;
    @synchronized(self) {
        if (!_T) {
            _T = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.12"];
        }
    }
    return _T;
}

+ (ASN1ObjectIdentifier *)CN {
    static ASN1ObjectIdentifier *_CN = nil;
    @synchronized(self) {
        if (!_CN) {
            _CN = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.3"];
        }
    }
    return _CN;
}

+ (ASN1ObjectIdentifier *)SN {
    static ASN1ObjectIdentifier *_SN = nil;
    @synchronized(self) {
        if (!_SN) {
            _SN = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.5"];
        }
    }
    return _SN;
}

+ (ASN1ObjectIdentifier *)STREET {
    static ASN1ObjectIdentifier *_STREET = nil;
    @synchronized(self) {
        if (!_STREET) {
            _STREET = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.9"];
        }
    }
    return _STREET;
}

+ (ASN1ObjectIdentifier *)SERIALNUMBER {
    static ASN1ObjectIdentifier *_SERIALNUMBER = nil;
    @synchronized(self) {
        if (!_SERIALNUMBER) {
            _SERIALNUMBER = [[self SN] retain];
        }
    }
    return _SERIALNUMBER;
}

+ (ASN1ObjectIdentifier *)L {
    static ASN1ObjectIdentifier *_L = nil;
    @synchronized(self) {
        if (!_L) {
            _L = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.7"];
        }
    }
    return _L;
}

+ (ASN1ObjectIdentifier *)ST {
    static ASN1ObjectIdentifier *_ST = nil;
    @synchronized(self) {
        if (!_ST) {
            _ST = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.8"];
        }
    }
    return _ST;
}

+ (ASN1ObjectIdentifier *)SURNAME {
    static ASN1ObjectIdentifier *_SURNAME = nil;
    @synchronized(self) {
        if (!_SURNAME) {
            _SURNAME = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.4"];
        }
    }
    return _SURNAME;
}

+ (ASN1ObjectIdentifier *)GIVENNAME {
    static ASN1ObjectIdentifier *_GIVENNAME = nil;
    @synchronized(self) {
        if (!_GIVENNAME) {
            _GIVENNAME = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.42"];
        }
    }
    return _GIVENNAME;
}

+ (ASN1ObjectIdentifier *)INITIALS {
    static ASN1ObjectIdentifier *_INITIALS = nil;
    @synchronized(self) {
        if (!_INITIALS) {
            _INITIALS = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.43"];
        }
    }
    return _INITIALS;
}

+ (ASN1ObjectIdentifier *)GENERATION {
    static ASN1ObjectIdentifier *_GENERATION = nil;
    @synchronized(self) {
        if (!_GENERATION) {
            _GENERATION = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.44"];
        }
    }
    return _GENERATION;
}

+ (ASN1ObjectIdentifier *)UNIQUE_IDENTIFIER {
    static ASN1ObjectIdentifier *_UNIQUE_IDENTIFIER = nil;
    @synchronized(self) {
        if (!_UNIQUE_IDENTIFIER) {
            _UNIQUE_IDENTIFIER = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.45"];
        }
    }
    return _UNIQUE_IDENTIFIER;
}

+ (ASN1ObjectIdentifier *)BUSINESS_CATEGORY {
    static ASN1ObjectIdentifier *_BUSINESS_CATEGORY = nil;
    @synchronized(self) {
        if (!_BUSINESS_CATEGORY) {
            _BUSINESS_CATEGORY = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.15"];
        }
    }
    return _BUSINESS_CATEGORY;
}

+ (ASN1ObjectIdentifier *)POSTAL_CODE {
    static ASN1ObjectIdentifier *_POSTAL_CODE = nil;
    @synchronized(self) {
        if (!_POSTAL_CODE) {
            _POSTAL_CODE = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.17"];
        }
    }
    return _POSTAL_CODE;
}

+ (ASN1ObjectIdentifier *)DN_QUALIFIER {
    static ASN1ObjectIdentifier *_DN_QUALIFIER = nil;
    @synchronized(self) {
        if (!_DN_QUALIFIER) {
            _DN_QUALIFIER = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.46"];
        }
    }
    return _DN_QUALIFIER;
}

+ (ASN1ObjectIdentifier *)PSEUDONYM {
    static ASN1ObjectIdentifier *_PSEUDONYM = nil;
    @synchronized(self) {
        if (!_PSEUDONYM) {
            _PSEUDONYM = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.65"];
        }
    }
    return _PSEUDONYM;
}

+ (ASN1ObjectIdentifier *)DATE_OF_BIRTH {
    static ASN1ObjectIdentifier *_DATE_OF_BIRTH = nil;
    @synchronized(self) {
        if (!_DATE_OF_BIRTH) {
            _DATE_OF_BIRTH = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.9.1"];
        }
    }
    return _DATE_OF_BIRTH;
}

+ (ASN1ObjectIdentifier *)PLACE_OF_BIRTH {
    static ASN1ObjectIdentifier *_PLACE_OF_BIRTH = nil;
    @synchronized(self) {
        if (!_PLACE_OF_BIRTH) {
            _PLACE_OF_BIRTH = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.9.2"];
        }
    }
    return _PLACE_OF_BIRTH;
}

+ (ASN1ObjectIdentifier *)GENDER {
    static ASN1ObjectIdentifier *_GENDER = nil;
    @synchronized(self) {
        if (!_GENDER) {
            _GENDER = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.9.3"];
        }
    }
    return _GENDER;
}

+ (ASN1ObjectIdentifier *)COUNTRY_OF_CITIZENSHIP {
    static ASN1ObjectIdentifier *_COUNTRY_OF_CITIZENSHIP = nil;
    @synchronized(self) {
        if (!_COUNTRY_OF_CITIZENSHIP) {
            _COUNTRY_OF_CITIZENSHIP = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.9.4"];
        }
    }
    return _COUNTRY_OF_CITIZENSHIP;
}

+ (ASN1ObjectIdentifier *)COUNTRY_OF_RESIDENCE {
    static ASN1ObjectIdentifier *_COUNTRY_OF_RESIDENCE = nil;
    @synchronized(self) {
        if (!_COUNTRY_OF_RESIDENCE) {
            _COUNTRY_OF_RESIDENCE = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.9.5"];
        }
    }
    return _COUNTRY_OF_RESIDENCE;
}

+ (ASN1ObjectIdentifier *)NAME_AT_BIRTH {
    static ASN1ObjectIdentifier *_NAME_AT_BIRTH = nil;
    @synchronized(self) {
        if (!_NAME_AT_BIRTH) {
            _NAME_AT_BIRTH = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.36.8.3.14"];
        }
    }
    return _NAME_AT_BIRTH;
}

+ (ASN1ObjectIdentifier *)POSTAL_ADDRESS {
    static ASN1ObjectIdentifier *_POSTAL_ADDRESS = nil;
    @synchronized(self) {
        if (!_POSTAL_ADDRESS) {
            _POSTAL_ADDRESS = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.16"];
        }
    }
    return _POSTAL_ADDRESS;
}

+ (ASN1ObjectIdentifier *)DMD_NAME {
    static ASN1ObjectIdentifier *_DMD_NAME = nil;
    @synchronized(self) {
        if (!_DMD_NAME) {
            _DMD_NAME = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.54"];
        }
    }
    return _DMD_NAME;
}

+ (ASN1ObjectIdentifier *)TELEPHONE_NUMBER {
    static ASN1ObjectIdentifier *_TELEPHONE_NUMBER = nil;
    @synchronized(self) {
        if (!_TELEPHONE_NUMBER) {
            _TELEPHONE_NUMBER = [[X509ObjectIdentifiers id_at_telephoneNumber] retain];
        }
    }
    return _TELEPHONE_NUMBER;
}

+ (ASN1ObjectIdentifier *)NAME {
    static ASN1ObjectIdentifier *_NAME = nil;
    @synchronized(self) {
        if (!_NAME) {
            _NAME = [[X509ObjectIdentifiers id_at_name] retain];
        }
    }
    return _NAME;
}

+ (ASN1ObjectIdentifier *)EmailAddress {
    static ASN1ObjectIdentifier *_EmailAddress = nil;
    @synchronized(self) {
        if (!_EmailAddress) {
            _EmailAddress = [[PKCSObjectIdentifiers pkcs_9_at_emailAddress] retain];
        }
    }
    return _EmailAddress;
}

+ (ASN1ObjectIdentifier *)UnstructuredName {
    static ASN1ObjectIdentifier *_UnstructuredName = nil;
    @synchronized(self) {
        if (!_UnstructuredName) {
            _UnstructuredName = [[PKCSObjectIdentifiers pkcs_9_at_unstructuredName] retain];
        }
    }
    return _UnstructuredName;
}

+ (ASN1ObjectIdentifier *)UnstructuredAddress {
    static ASN1ObjectIdentifier *_UnstructuredAddress = nil;
    @synchronized(self) {
        if (!_UnstructuredAddress) {
            _UnstructuredAddress = [[PKCSObjectIdentifiers pkcs_9_at_unstructuredAddress] retain];
        }
    }
    return _UnstructuredAddress;
}

+ (ASN1ObjectIdentifier *)E {
    static ASN1ObjectIdentifier *_E = nil;
    @synchronized(self) {
        if (!_E) {
            _E = [[self EmailAddress] retain];
        }
    }
    return _E;
}

+ (ASN1ObjectIdentifier *)DC {
    static ASN1ObjectIdentifier *_DC = nil;
    @synchronized(self) {
        if (!_DC) {
            _DC = [[ASN1ObjectIdentifier alloc] initParamString:@"0.9.2342.19200300.100.1.25"];
        }
    }
    return _DC;
}

+ (ASN1ObjectIdentifier *)UID {
    static ASN1ObjectIdentifier *_UID = nil;
    @synchronized(self) {
        if (!_UID) {
            _UID = [[ASN1ObjectIdentifier alloc] initParamString:@"0.9.2342.19200300.100.1.1"];
        }
    }
    return _UID;
}

+ (BOOL)DefaultReverse {
    static BOOL _DefaultReverse = false;
    @synchronized(self) {
        if (!_DefaultReverse) {
            _DefaultReverse = false;
        }
    }
    return _DefaultReverse;
}

+ (NSMutableDictionary *)DefaultSymbols {
    static NSMutableDictionary *_DefaultSymbols = nil;
    @synchronized(self) {
        if (!_DefaultSymbols) {
            _DefaultSymbols = [[NSMutableDictionary alloc] init];
        }
    }
    return _DefaultSymbols;
}

+ (NSMutableDictionary *)RFC2253Symbols {
    static NSMutableDictionary *_RFC2253Symbols = nil;
    @synchronized(self) {
        if (!_RFC2253Symbols) {
            _RFC2253Symbols = [[NSMutableDictionary alloc] init];
        }
    }
    return _RFC2253Symbols;
}

+ (NSMutableDictionary *)RFC1779Symbols {
    static NSMutableDictionary *_RFC1779Symbols = nil;
    @synchronized(self) {
        if (!_RFC1779Symbols) {
            _RFC1779Symbols = [[NSMutableDictionary alloc] init];
        }
    }
    return _RFC1779Symbols;
}

+ (NSMutableDictionary *)DefaultLookUp {
    static NSMutableDictionary *_DefaultLookUp = nil;
    @synchronized(self) {
        if (!_DefaultLookUp) {
            _DefaultLookUp = [[NSMutableDictionary alloc] init];
        }
    }
    return _DefaultLookUp;
}

+ (NSMutableDictionary *)OIDLookUp {
    static NSMutableDictionary *_OIDLookUp = nil;
    @synchronized(self) {
        if (!_OIDLookUp) {
            _OIDLookUp = [[self DefaultSymbols] retain];
        }
    }
    return _OIDLookUp;
}

+ (NSMutableDictionary *)SymbolLookUp {
    static NSMutableDictionary *_SymbolLookUp = nil;
    @synchronized(self) {
        if (!_SymbolLookUp) {
            _SymbolLookUp = [[self DefaultLookUp] retain];
        }
    }
    return _SymbolLookUp;
}

+ (BOOL)ISTRUE {
    static BOOL _ISTRUE = false;
    @synchronized(self) {
        if (!_ISTRUE) {
            _ISTRUE = TRUE;
        }
    }
    return _ISTRUE;
}

+ (BOOL)ISFALSE {
    static BOOL _ISFALSE = false;
    @synchronized(self) {
        if (!_ISFALSE) {
            _ISFALSE = false;
        }
    }
    return _ISFALSE;
}

+ (X509Name *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[X509Name class]]) {
        return (X509Name *)paramObject;
    }
    if ([paramObject isKindOfClass:[X500Name class]]) {
        return [[[X509Name alloc] initParamASN1Sequence:[ASN1Sequence getInstance:[(X500Name *)paramObject toASN1Primitive]]] autorelease];
    }
    if (paramObject) {
        return [[[X509Name alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (X509Name *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [X509Name getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)init
{
    if (self = [super init]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.seq = paramASN1Sequence;
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        ASN1Encodable *encodable = nil;
        while (encodable = [localEnumeration nextObject]) {
            ASN1Set *localASN1Set = [ASN1Set getInstance:[encodable toASN1Primitive]];
            for (int i = 0; i < [localASN1Set size]; i++) {
                ASN1Sequence *localASN1Sequence = [ASN1Sequence getInstance:[[localASN1Set getObjectAt:i] toASN1Primitive]];
                if ([localASN1Sequence size] != 2) {
                    @throw [NSException exceptionWithName:NSGenericException reason:@"badly sized pair" userInfo:nil];
                }
                [self.ordering addObject:[ASN1ObjectIdentifier getInstance:[localASN1Sequence getObjectAt:0]]];
                ASN1Encodable *localASN1Encodable = [localASN1Sequence getObjectAt:1];
                if ([localASN1Encodable isKindOfClass:[ASN1String class]] && ![localASN1Encodable isKindOfClass:[DERUniversalString class]]) {
                    NSString *str = [((ASN1String *)localASN1Encodable) getString];
                    if (([str length] > 0) && ([str characterAtIndex:0] == '#')) {
                        [self.values addObject:[NSString stringWithFormat:@"\\%@", str]];
                    }else {
                        [self.values addObject:str];
                    }
                }else {
                    @try {
                        [self.values addObject:[NSString stringWithFormat:@"#%@", [self bytesToString:[Hex encode:[[localASN1Encodable toASN1Primitive] getEncoded:@"DER"]]]]];
                    }
                    @catch (NSException *exception) {
                        @throw [NSException exceptionWithName:NSGenericException reason:@"cannot encode value" userInfo:nil];
                    }
                }
                [self.added addObject:[NSString stringWithFormat:@"%d", i != 0 ? [X509Name ISTRUE] : [X509Name ISFALSE]]];
            }
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamHashtable:(NSMutableDictionary *)paramHashtable
{
    if (self = [super init]) {
        [self initParamVector:nil paramHashtable:paramHashtable];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamVector:(NSMutableArray *)paramVector paramHashtable:(NSMutableDictionary *)paramHashtable
{
    if (self = [super init]) {
        X509NameEntryConverter *converter = [[X509NameEntryConverter alloc] init];
        [self initParamVector:paramVector paramHashtable:paramHashtable paramX509NameEntryConverter:converter];
#if !__has_feature(objc_arc)
    if (converter) [converter release]; converter = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamVector:(NSMutableArray *)paramVector paramHashtable:(NSMutableDictionary *)paramHashtable paramX509NameEntryConverter:(X509NameEntryConverter *)paramX509NameEntryConverter
{
    if (self = [super init]) {
        self.converter = paramX509NameEntryConverter;
        if (paramVector) {
            for (int i = 0; i != [paramVector count]; i++) {
                [self.ordering addObject:[paramVector objectAtIndex:i]];
                [self.added addObject:[NSString stringWithFormat:@"%d", [X509Name ISFALSE]]];
            }
        }else {
            NSEnumerator *localEnumration = [paramHashtable keyEnumerator];
            id localObject = nil;
            while (localObject = [localEnumration nextObject]) {
                [self.ordering addObject:localObject];
                [self.added addObject:[NSString stringWithFormat:@"%d", [X509Name ISFALSE]]];
            }
        }
        for (int j = 0; j != self.ordering.count; j++) {
            ASN1ObjectIdentifier *localASN1ObjectIdentifier = (ASN1ObjectIdentifier *)[self.ordering objectAtIndex:j];
            if (![paramHashtable objectForKey:localASN1ObjectIdentifier]) {
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"No attribute for object id - %@ - passed to distinguished name", [localASN1ObjectIdentifier getId]] userInfo:nil];
            }
            [self.values addObject:[paramHashtable objectForKey:localASN1ObjectIdentifier]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamVector1:(NSMutableArray *)paramVector1 paramVector2:(NSMutableArray *)paramVector2
{
    if (self = [super init]) {
        X509NameEntryConverter *converter = [[X509NameEntryConverter alloc] init];
        [self initParamVector1:paramVector1 paramVector2:paramVector2 paramX509NameEntryConverter:converter];
#if !__has_feature(objc_arc)
    if (converter) [converter release]; converter = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamVector1:(NSMutableArray *)paramVector1 paramVector2:(NSMutableArray *)paramVector2 paramX509NameEntryConverter:(X509NameEntryConverter *)paramX509NameEntryConverter
{
    if (self = [super init]) {
        self.converter = paramX509NameEntryConverter;
        if ([paramVector1 count] != [paramVector2 count]) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"oids vector must be same length as values." userInfo:nil];
        }
        for (int i = 0; i < [paramVector1 count]; i++) {
            [self.ordering addObject:[paramVector1 objectAtIndex:i]];
            [self.values addObject:[paramVector2 objectAtIndex:i]];
            [self.added addObject:[NSString stringWithFormat:@"%d", [X509Name ISFALSE]]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString
{
    if (self = [super init]) {
        [self initParamBoolean:[X509Name DefaultReverse] paramHashtable:[X509Name DefaultLookUp] paramString:paramString];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString paramX509NameEntryConverter:(X509NameEntryConverter *)paramX509NameEntryConverter
{
    if (self = [super init]) {
        [self initParamBoolean:[X509Name DefaultReverse] paramHashtable:[X509Name DefaultLookUp] paramString:paramString paramX509NameEntryConverter:paramX509NameEntryConverter];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBoolean:(BOOL)paramBoolean paramString:(NSString *)paramString
{
    if (self = [super init]) {
        [self initParamBoolean:paramBoolean paramHashtable:[X509Name DefaultLookUp] paramString:paramString];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBoolean:(BOOL)paramBoolean paramString:(NSString *)paramString paramX509NameEntryConverter:(X509NameEntryConverter *)paramX509NameEntryConverter
{
    if (self = [super init]) {
        [self initParamBoolean:paramBoolean paramHashtable:[X509Name DefaultLookUp] paramString:paramString paramX509NameEntryConverter:paramX509NameEntryConverter];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBoolean:(BOOL)paramBoolean paramHashtable:(NSMutableDictionary *)paramHashtable paramString:(NSString *)paramString
{
    if (self = [super init]) {
        X509NameEntryConverter *converter = [[X509NameEntryConverter alloc] init];
        [self initParamBoolean:paramBoolean paramHashtable:paramHashtable paramString:paramString paramX509NameEntryConverter:converter];
#if !__has_feature(objc_arc)
    if (converter) [converter release]; converter = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBoolean:(BOOL)paramBoolean paramHashtable:(NSMutableDictionary *)paramHashtable paramString:(NSString *)paramString paramX509NameEntryConverter:(X509NameEntryConverter *)paramX509NameEntryConverter
{
    if (self = [super init]) {
        self.converter = paramX509NameEntryConverter;
        X509NameTokenizer *localX509NameTokenizer = [[X509NameTokenizer alloc] initParamString:paramString];
        id localObject1;
        id localObject2;
        while ([localX509NameTokenizer hasMoreTokens]) {
            localObject1 = [localX509NameTokenizer nextToken];
            if ([((NSString *)localObject1) rangeOfString:@"+"].location > 0) {
                localObject2 = [[X509NameTokenizer alloc] initParamString:(NSString *)localObject1 paramChar:'+'];
                [self addEntry:paramHashtable paramString:[((X509NameTokenizer *)localObject2) nextToken] paramBoolean:[X509Name ISFALSE]];
                while ([((X509NameTokenizer *)localObject2) hasMoreTokens]) {
                    [self addEntry:paramHashtable paramString:[((X509NameTokenizer *)localObject2) nextToken] paramBoolean:[X509Name ISTRUE]];
                }
#if !__has_feature(objc_arc)
                if (localObject2) [localObject2 release]; localObject2 = nil;
#endif
            }else {
                [self addEntry:paramHashtable paramString:(NSString *)localObject1 paramBoolean:[X509Name ISFALSE]];
            }
        }
        if (paramBoolean) {
            localObject1 = [[NSMutableArray alloc] init];
            localObject2 = [[NSMutableArray alloc] init];
            NSMutableArray *localVector = [[NSMutableArray alloc] init];
            int i = 1;
            for (int j = 0; j < [self.ordering count]; j++) {
                if (((BOOL)[self.added objectAtIndex:j])) {
                    [((NSMutableArray *)localObject1) insertObject:[self.ordering objectAtIndex:j] atIndex:i];
                    [((NSMutableArray *)localObject2) insertObject:[self.values objectAtIndex:j] atIndex:i];
                    [localVector insertObject:[self.added objectAtIndex:j] atIndex:i];
                    i++;
                }else {
                    [((NSMutableArray *)localObject1) insertObject:[self.ordering objectAtIndex:j] atIndex:0];
                    [((NSMutableArray *)localObject2) insertObject:[self.ordering objectAtIndex:j] atIndex:0];
                    [localVector insertObject:[self.added objectAtIndex:j] atIndex:0];
                    i = 1;
                }
            }
            self.ordering = (NSMutableArray *)localObject1;
            self.values = (NSMutableArray *)localObject2;
            self.added = localVector;
#if !__has_feature(objc_arc)
            if (localObject1) [localObject1 release]; localObject1 = nil;
            if (localObject2) [localObject2 release]; localObject2 = nil;
            if (localVector) [localVector release]; localVector = nil;
#endif
        }
#if !__has_feature(objc_arc)
        if (localX509NameTokenizer) [localX509NameTokenizer release]; localX509NameTokenizer = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)decodeOID:(NSString *)paramString paramHashtable:(NSMutableDictionary *)paramHashtable {
    paramString = [paramString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([[paramString uppercaseString] startWithString:@"OID."]) {
        return [[[ASN1ObjectIdentifier alloc] initParamString:[paramString substringToIndex:4]] autorelease];
    }
    if (([paramString characterAtIndex:0] >= '0') && ([paramString characterAtIndex:0] <= '9')) {
        return [[[ASN1ObjectIdentifier alloc] initParamString:paramString] autorelease];
    }
    ASN1ObjectIdentifier *localASN1ObjectIdentifier = (ASN1ObjectIdentifier *)[paramHashtable objectForKey:[paramString lowercaseString]];
    if (!localASN1ObjectIdentifier) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Unknown object id - %@ - passed to distinguished name", paramString] userInfo:nil];
    }
    return localASN1ObjectIdentifier;
}

- (NSString *)unescape:(NSString *)paramString {
    if (([paramString length] == 0) || (([paramString rangeOfString:@"\\"].location < NSNotFound) && ([paramString rangeOfString:@"\""].location < NSNotFound))) {
        return [paramString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    NSMutableArray *arrayOfChar = [paramString mutableCopy];
    int i = 0;
    int j = 0;
    NSMutableString *localStringBuffer = [[[NSMutableString alloc] initWithCapacity:[paramString length]] autorelease];
    int k = 0;
    if (([arrayOfChar[0] isEqualToString:@"\\"]) && ([arrayOfChar[1] isEqualToString:@"#"])) {
        k = 2;
        [localStringBuffer appendString:@"\\#"];
    }
    int m = 0;
    int n = 0;
    for (int i1 = k; i1 != arrayOfChar.count; i1++) {
        char c = (char)arrayOfChar[i1];
        if (c != ' ') {
            m = 1;
        }
        if (c == '\"') {
            if (i == 0) {
                j = j == 0 ? 1 : 0;
            }else {
                [localStringBuffer appendString:[NSString stringWithCString:&c encoding:NSUTF8StringEncoding]];
            }
            i = 0;
        }else if ((c == '\\') && (i == 0) && (j == 0)) {
            i = 1;
            n = (int)[localStringBuffer length];
        }else if ((c != ' ') || (i != 0) || (m != 0)) {
            [localStringBuffer appendString:[NSString stringWithCString:&c encoding:NSUTF8StringEncoding]];
            i = 0;
        }
    }
    if ([localStringBuffer length] > 0) {
        while (([localStringBuffer characterAtIndex:((int)[localStringBuffer length] - 1)] == ' ') && (n != (((int)[localStringBuffer length]) - 1))) {
        }
    }
    NSString *tmpLocalStringBuffer = localStringBuffer.description;
#if !__has_feature(objc_arc)
    if (localStringBuffer) [localStringBuffer release]; localStringBuffer = nil;
#endif
    return [NSString stringWithFormat:@"%@", tmpLocalStringBuffer];
}

- (void)addEntry:(NSMutableDictionary *)paramHashtable paramString:(NSString *)paramString paramBoolean:(BOOL)paramBoolean {
    X509NameTokenizer *localX509NameTokenizer = [[X509NameTokenizer alloc] initParamString:paramString paramChar:'='];
    NSString *str1 = [localX509NameTokenizer nextToken];
    if (![localX509NameTokenizer hasMoreTokens]) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"badly formatted directory string" userInfo:nil];
    }
    NSString *str2 = [localX509NameTokenizer nextToken];
#if !__has_feature(objc_arc)
    if (localX509NameTokenizer) [localX509NameTokenizer release]; localX509NameTokenizer = nil;
#endif
    ASN1ObjectIdentifier *localASN1ObjectIdentifier = [self decodeOID:str1 paramHashtable:paramHashtable];
    [self.ordering addObject:localASN1ObjectIdentifier];
    [self.values addObject:[self unescape:str2]];
    [self.added addObject:[NSString stringWithFormat:@"%d", paramBoolean]];
}

- (NSMutableArray *)getOIDs {
    NSMutableArray *localVector = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i != [self.ordering count]; i++) {
        [localVector addObject:[self.ordering objectAtIndex:i]];
    }
    return localVector;
}

- (NSMutableArray *)getValues {
    NSMutableArray *localVector = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i != [self.values count]; i++) {
        [localVector addObject:[self.values objectAtIndex:i]];
    }
    return localVector;
}

- (NSMutableArray *)getValues:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    NSMutableArray *localVector = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i != [self.values count]; i++) {
        if ([[self.ordering objectAtIndex:i] isEqual:paramASN1ObjectIdentifier]) {
            NSString *str = (NSString *)[self.values objectAtIndex:i];
            if (([str length] > 2) && ([str characterAtIndex:0] == '\\') && ([str characterAtIndex:1] == '#')) {
                [localVector addObject:[str substringToIndex:1]];
            }else {
                [localVector addObject:str];
            }
        }
    }
    return localVector;
}

- (ASN1Primitive *)toASN1Primitive {
    if (!self.seq) {
        ASN1EncodableVector *localASN1EncodableVector1 = [[ASN1EncodableVector alloc] init];
        ASN1EncodableVector *localASN1EncodableVector2 = [[ASN1EncodableVector alloc] init];
        id localObject = nil;
        for (int i = 0; i != [self.ordering count]; i++) {
            ASN1EncodableVector *localASN1EncodableVector3 = [[ASN1EncodableVector alloc] init];
            ASN1ObjectIdentifier *localASN1ObjectIdentifier = (ASN1ObjectIdentifier *)[self.ordering objectAtIndex:i];
            [localASN1EncodableVector3 add:localASN1ObjectIdentifier];
            NSString *str = (NSString *)[self.values objectAtIndex:i];
            [localASN1EncodableVector3 add:[self.converter getConvertedValue:localASN1ObjectIdentifier paramString:str]];
            if (!localObject || ((BOOL)[self.added objectAtIndex:i])) {
                ASN1Encodable *encodable = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector3];
                [localASN1EncodableVector2 add:encodable];
#if !__has_feature(objc_arc)
                if (encodable) [encodable release]; encodable = nil;
#endif
            }else {
                ASN1Encodable *setEncodable = [[DERSet alloc] initDERParamASN1EncodableVector:localASN1EncodableVector2];
                localASN1EncodableVector2 = [[ASN1EncodableVector alloc] init];
                ASN1Encodable *sequenceEncodable = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector3];
                [localASN1EncodableVector1 add:setEncodable];
                [localASN1EncodableVector2 add:sequenceEncodable];
#if !__has_feature(objc_arc)
                if (setEncodable) [setEncodable release]; setEncodable = nil;
                if (sequenceEncodable) [sequenceEncodable release]; sequenceEncodable = nil;
#endif
            }
            localObject = localASN1ObjectIdentifier;
#if !__has_feature(objc_arc)
            if (localASN1EncodableVector3) [localASN1EncodableVector3 release]; localASN1EncodableVector3 = nil;
#endif
        }
        ASN1Encodable *derSetEncodable = [[DERSet alloc] initDERParamASN1EncodableVector:localASN1EncodableVector2];
        [localASN1EncodableVector1 add:derSetEncodable];
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector1];
        self.seq = sequence;
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector1) [localASN1EncodableVector1 release]; localASN1EncodableVector1 = nil;
    if (localASN1EncodableVector2) [localASN1EncodableVector2 release]; localASN1EncodableVector2 = nil;
    if (derSetEncodable) [derSetEncodable release]; derSetEncodable = nil;
    if (sequence) [sequence release]; sequence = nil;
#endif
    }
    return self.seq;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    if (![object isKindOfClass:[X509Name class]] && ![object isKindOfClass:[ASN1Sequence class]]) {
        return NO;
    }
    ASN1Primitive *localASN1Primitive = [((ASN1Encodable *)object) toASN1Primitive];
    if ([[self toASN1Primitive] isEqual:localASN1Primitive]) {
        return YES;
    }
    X509Name *localX509Name;
    @try {
        localX509Name = [X509Name getInstance:object];
    }
    @catch (NSException *exception) {
        return NO;
    }
    int i = (int)[self.ordering count];
    if (i != [[localX509Name ordering] count]) {
        return NO;
    }
    NSMutableArray *arrayOfBoolean = [[NSMutableArray alloc] initWithSize:i];
    int j;
    int k;
    int m;
    if ([[self.ordering objectAtIndex:0] isEqual:[[localX509Name ordering] objectAtIndex:0]]) {
        j = 0;
        k = i;
        m = 1;
    }else {
        j = i - 1;
        k = -1;
        m = -1;
    }
    int n = j;
    while (n != k) {
        int i1 = 0;
        ASN1ObjectIdentifier *localASN1ObjectIdentifier1 = (ASN1ObjectIdentifier *)[self.ordering objectAtIndex:n];
        NSString *str1 = (NSString *)[self.values objectAtIndex:n];
        for (int i2 = 0; i2 < i; i2++) {
            if (arrayOfBoolean[i2] == 0) {
                ASN1ObjectIdentifier *localASN1ObjectIdentifier2 = (ASN1ObjectIdentifier *)[localX509Name.ordering objectAtIndex:i2];
                if ([localASN1ObjectIdentifier1 isEqual:localASN1ObjectIdentifier2]) {
                    NSString *str2 = (NSString *)[localX509Name.values objectAtIndex:i2];
                    if ([self equivalentStrings:str1 paramString2:str2]) {
                        arrayOfBoolean[i2] = [NSNumber numberWithBool:TRUE];
                        i1 = 1;
                        break;
                    }
                }
            }
        }
        if (i1 == 0) {
            return NO;
        }
        n += m;
    }
    return YES;
}

- (BOOL)equals:(id)paramObject paramBoolean:(BOOL)paramBoolean {
    if (!paramBoolean) {
        return [self isEqual:paramObject];
    }
    if (paramObject == self) {
        return YES;
    }
    if (![paramObject isKindOfClass:[X509Name class]] && ![paramObject isKindOfClass:[ASN1Sequence class]]) {
        return NO;
    }
    ASN1Primitive *localASN1Primitive = [((ASN1Encodable *)paramObject) toASN1Primitive];
    if ([[self toASN1Primitive] isEqual:localASN1Primitive]) {
        return YES;
    }
    X509Name *localX509Name;
    @try {
        localX509Name = [X509Name getInstance:paramObject];
    }
    @catch (NSException *exception) {
        return NO;
    }
    int i = (int)[self.ordering count];
    if (i != [[localX509Name ordering] count]) {
        return NO;
    }
    for (int j = 0; j < i; j++) {
        ASN1ObjectIdentifier *localASN1ObjectIdentifier1 = (ASN1ObjectIdentifier *)[self.ordering objectAtIndex:j];
        ASN1ObjectIdentifier *localASN1ObjectIdentifier2 = (ASN1ObjectIdentifier *)[[localX509Name ordering] objectAtIndex:j];
        if ([localASN1ObjectIdentifier1 isEqual:localASN1ObjectIdentifier2]) {
            NSString *str1 = (NSString *)[self.values objectAtIndex:j];
            NSString *str2 = (NSString *)[[localX509Name values] objectAtIndex:j];
            if (![self equivalentStrings:str1 paramString2:str2]) {
                return NO;
            }
        }else {
            return NO;
        }
    }
    return YES;
}

- (BOOL)equivalentStrings:(NSString *)paramString1 paramString2:(NSString *)paramString2 {
    NSString *str1 = [self canonicalize:paramString1];
    NSString *str2 = [self canonicalize:paramString2];
    if (![str1 isEqualToString:str2]) {
        str1 = [self stripInternalSpaces:str1];
        str2 = [self stripInternalSpaces:str2];
        if (![str1 isEqualToString:str2]) {
            return NO;
        }
    }
    return YES;
}

- (NSString *)canonicalize:(NSString *)paramString {
    NSString *str = [[paramString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if (([str length] > 0) && ([str characterAtIndex:0] == '#')) {
        ASN1Primitive *localASN1Primitive = [self decodeObject:str];
        if ([localASN1Primitive isKindOfClass:[ASN1String class]]) {
            str = [[[((ASN1String *)localASN1Primitive) getString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
        }
    }
    return str;
}

- (ASN1Primitive *)decodeObject:(NSString *)paramString {
    @try {
        return [ASN1Primitive fromByteArray:[Hex decodeWithString:[paramString substringToIndex:1]]];
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown encoding in name: %@", exception.description] userInfo:nil];
    }
}

- (NSString *)stripInternalSpaces:(NSString *)paramString {
    NSMutableString *localStringBuffer = [[[NSMutableString alloc] init] autorelease];
    if ([paramString length] != 0) {
        char c1 = [paramString characterAtIndex:0];
        [localStringBuffer appendString:[NSString stringWithCString:&c1 encoding:NSUTF8StringEncoding]];
        for (int i = 1; i < [paramString length]; i++) {
            char c2 = [paramString characterAtIndex:i];
            if ((c1 != ' ') || (c2 != ' ')) {
                [localStringBuffer appendString:[NSString stringWithCString:&c2 encoding:NSUTF8StringEncoding]];
            }
            c1 = c2;
        }
    }
    return [NSString stringWithFormat:@"%@", localStringBuffer.description];
}

- (void)appendValue:(NSMutableString *)paramStringBuffer paramHashtable:(NSMutableDictionary *)paramHashtable paramASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString {
    NSString *str = (NSString *)[paramHashtable objectForKey:paramASN1ObjectIdentifier];
    if (str) {
        [paramStringBuffer appendString:str];
    }else {
        [paramStringBuffer appendString:[paramASN1ObjectIdentifier getId]];
    }
    [paramStringBuffer appendString:@"="];
    int i = (int)[paramStringBuffer length];
    [paramStringBuffer appendString:paramString];
    int j = (int)[paramStringBuffer length];
    if (([paramString length] >= 2) && ([paramString characterAtIndex:0] == '\\') && ([paramString characterAtIndex:1] == '#')) {
        i += 2;
    }
    while ((i < j) && ([paramStringBuffer characterAtIndex:i] == ' ')) {
        [paramStringBuffer insertString:@"\\" atIndex:i];
        i += 2;
        j++;
    }
    for (; ;) {
        j--;
        if ((j <= i) || ([paramStringBuffer characterAtIndex:j] != ' ')) {
            break;
        }
        [paramStringBuffer insertString:@"\\" atIndex:j];
    }
    while (i <= j) {
        switch ([paramStringBuffer characterAtIndex:i]) {
            case '"':
            case '+':
            case ',':
            case ';':
            case '<':
            case '=':
            case '>':
            case '\\': {
                [paramStringBuffer insertString:@"\\" atIndex:i];
                i += 2;
                j++;
                break;
            }
            default:
                i++;
                break;
        }
    }
}

- (NSString *)toString:(BOOL)paramBoolean paramHashtable:(NSMutableDictionary *)paramHashtable {
    NSMutableString *localStringBuffer1 = [[[NSMutableString alloc] init] autorelease];
    NSMutableArray *localVector = [[[NSMutableArray alloc] init] autorelease];
    int i = 1;
    NSMutableString *localStringBuffer2 = nil;
    for (int j = 0; j < [self.ordering count]; j++) {
        if ((BOOL)[self.added objectAtIndex:j]) {
            [localStringBuffer2 appendString:[NSString stringWithCString:'+' encoding:NSUTF8StringEncoding]];
            [self appendValue:localStringBuffer2 paramHashtable:paramHashtable paramASN1ObjectIdentifier:(ASN1ObjectIdentifier *)[self.ordering objectAtIndex:j] paramString:(NSString *)[self.values objectAtIndex:j]];
        }else {
            localStringBuffer2 = [[[NSMutableString alloc] init] autorelease];
            [self appendValue:localStringBuffer2 paramHashtable:paramHashtable paramASN1ObjectIdentifier:(ASN1ObjectIdentifier *)[self.ordering objectAtIndex:j] paramString:(NSString *)[self.values objectAtIndex:j]];
            [localVector addObject:localStringBuffer2];
        }
    }
    if (paramBoolean) {
        for (int j = (int)[localVector count] - 1; j >= 0; j--) {
            if (i != 0) {
                i = 0;
            }else {
                [localStringBuffer1 appendString:[NSString stringWithCString:',' encoding:NSUTF8StringEncoding]];
            }
            [localStringBuffer1 appendString:[[localVector objectAtIndex:j] toString]];
        }
    }else {
        for (int j = 0; j < [localVector count]; j++) {
            if (i != 0) {
                i = 0;
            }else {
                [localStringBuffer1 appendString:[NSString stringWithCString:',' encoding:NSUTF8StringEncoding]];
            }
            [localStringBuffer1 appendString:[[localVector objectAtIndex:j] toString]];
        }
    }
    return [NSString stringWithFormat:@"%@", localStringBuffer1.description];
}

- (NSString *)bytesToString:(NSMutableData *)paramArrayOfByte {
    NSMutableArray *arrayOfChar = [[[NSMutableArray alloc] initWithSize:(int)[paramArrayOfByte length]] autorelease];
    for (int i = 0; i != [arrayOfChar count]; i++) {
        arrayOfChar[i] = @((char)(((Byte *)[paramArrayOfByte bytes])[i] & 0xFF));
    }
    return [Arrays toString:arrayOfChar];
}

- (NSString *)toString {
    return [self toString:[X509Name DefaultReverse] paramHashtable:[X509Name DefaultSymbols]];
}

- (NSUInteger)hash {
    if (self.isHashCodeCalculated) {
        return self.hashCodeValue;
    }
    self.isHashCodeCalculated = YES;
    for (int i = 0; i != [self.ordering count]; i++) {
        NSString *str = (NSString *)[self.values objectAtIndex:i];
        str = [self canonicalize:str];
        str = [self stripInternalSpaces:str];
        self.hashCodeValue ^= [[self.ordering objectAtIndex:i] hash];
        self.hashCodeValue ^= [str hash];
    }
    return self.hashCodeValue;
}

+ (void)load {
    [super load];
    [[X509Name DefaultSymbols] setObject:@"C" forKey:[X509Name C]];
    [[X509Name DefaultSymbols] setObject:@"O" forKey:[X509Name O]];
    [[X509Name DefaultSymbols] setObject:@"T" forKey:[X509Name T]];
    [[X509Name DefaultSymbols] setObject:@"OU" forKey:[X509Name OU]];
    [[X509Name DefaultSymbols] setObject:@"CN" forKey:[X509Name CN]];
    [[X509Name DefaultSymbols] setObject:@"L" forKey:[X509Name L]];
    [[X509Name DefaultSymbols] setObject:@"ST" forKey:[X509Name ST]];
    [[X509Name DefaultSymbols] setObject:@"SERIALNUMBER" forKey:[X509Name SN]];
    [[X509Name DefaultSymbols] setObject:@"E" forKey:[X509Name EmailAddress]];
    [[X509Name DefaultSymbols] setObject:@"DC" forKey:[X509Name DC]];
    [[X509Name DefaultSymbols] setObject:@"UID" forKey:[X509Name UID]];
    [[X509Name DefaultSymbols] setObject:@"STREET" forKey:[X509Name STREET]];
    [[X509Name DefaultSymbols] setObject:@"SURNAME" forKey:[X509Name SURNAME]];
    [[X509Name DefaultSymbols] setObject:@"GIVENNAME" forKey:[X509Name GIVENNAME]];
    [[X509Name DefaultSymbols] setObject:@"INITIALS" forKey:[X509Name INITIALS]];
    [[X509Name DefaultSymbols] setObject:@"GENERATION" forKey:[X509Name GENERATION]];
    [[X509Name DefaultSymbols] setObject:@"unstructuredAddress" forKey:[X509Name UnstructuredAddress]];
    [[X509Name DefaultSymbols] setObject:@"unstructuredName" forKey:[X509Name UnstructuredName]];
    [[X509Name DefaultSymbols] setObject:@"UniqueIdentifier" forKey:[X509Name UNIQUE_IDENTIFIER]];
    [[X509Name DefaultSymbols] setObject:@"DN" forKey:[X509Name DN_QUALIFIER]];
    [[X509Name DefaultSymbols] setObject:@"Pseudonym" forKey:[X509Name PSEUDONYM]];
    [[X509Name DefaultSymbols] setObject:@"PostalAddress" forKey:[X509Name POSTAL_ADDRESS]];
    [[X509Name DefaultSymbols] setObject:@"NameAtBirth" forKey:[X509Name NAME_AT_BIRTH]];
    [[X509Name DefaultSymbols] setObject:@"CountryOfCitizenship" forKey:[X509Name COUNTRY_OF_CITIZENSHIP]];
    [[X509Name DefaultSymbols] setObject:@"CountryOfResidence" forKey:[X509Name COUNTRY_OF_RESIDENCE]];
    [[X509Name DefaultSymbols] setObject:@"Gender" forKey:[X509Name GENDER]];
    [[X509Name DefaultSymbols] setObject:@"PlaceOfBirth" forKey:[X509Name PLACE_OF_BIRTH]];
    [[X509Name DefaultSymbols] setObject:@"DateOfBirth" forKey:[X509Name DATE_OF_BIRTH]];
    [[X509Name DefaultSymbols] setObject:@"PostalCode" forKey:[X509Name POSTAL_CODE]];
    [[X509Name DefaultSymbols] setObject:@"BusinessCategory" forKey:[X509Name BUSINESS_CATEGORY]];
    [[X509Name DefaultSymbols] setObject:@"TelephoneNumber" forKey:[X509Name TELEPHONE_NUMBER]];
    [[X509Name DefaultSymbols] setObject:@"Name" forKey:[X509Name NAME]];
    
    [[X509Name RFC2253Symbols] setObject:@"C" forKey:[X509Name C]];
    [[X509Name RFC2253Symbols] setObject:@"O" forKey:[X509Name O]];
    [[X509Name RFC2253Symbols] setObject:@"OU" forKey:[X509Name OU]];
    [[X509Name RFC2253Symbols] setObject:@"CN" forKey:[X509Name CN]];
    [[X509Name RFC2253Symbols] setObject:@"L" forKey:[X509Name L]];
    [[X509Name RFC2253Symbols] setObject:@"ST" forKey:[X509Name ST]];
    [[X509Name RFC2253Symbols] setObject:@"STREET" forKey:[X509Name STREET]];
    [[X509Name RFC2253Symbols] setObject:@"DC" forKey:[X509Name DC]];
    [[X509Name RFC2253Symbols] setObject:@"UID" forKey:[X509Name UID]];
    
    [[X509Name RFC1779Symbols] setObject:@"C" forKey:[X509Name C]];
    [[X509Name RFC1779Symbols] setObject:@"O" forKey:[X509Name O]];
    [[X509Name RFC1779Symbols] setObject:@"OU" forKey:[X509Name OU]];
    [[X509Name RFC1779Symbols] setObject:@"CN" forKey:[X509Name CN]];
    [[X509Name RFC1779Symbols] setObject:@"L" forKey:[X509Name L]];
    [[X509Name RFC1779Symbols] setObject:@"ST" forKey:[X509Name ST]];
    [[X509Name RFC1779Symbols] setObject:@"STREET" forKey:[X509Name STREET]];
    
    [[X509Name DefaultLookUp] setObject:[X509Name C] forKey:@"c"];
    [[X509Name DefaultLookUp] setObject:[X509Name O] forKey:@"o"];
    [[X509Name DefaultLookUp] setObject:[X509Name T] forKey:@"t"];
    [[X509Name DefaultLookUp] setObject:[X509Name OU] forKey:@"ou"];
    [[X509Name DefaultLookUp] setObject:[X509Name CN] forKey:@"cn"];
    [[X509Name DefaultLookUp] setObject:[X509Name L] forKey:@"l"];
    [[X509Name DefaultLookUp] setObject:[X509Name ST] forKey:@"st"];
    [[X509Name DefaultLookUp] setObject:[X509Name SN] forKey:@"sn"];
    [[X509Name DefaultLookUp] setObject:[X509Name SN] forKey:@"serialnumber"];
    [[X509Name DefaultLookUp] setObject:[X509Name STREET] forKey:@"street"];
    [[X509Name DefaultLookUp] setObject:[X509Name E] forKey:@"emailaddress"];
    [[X509Name DefaultLookUp] setObject:[X509Name DC] forKey:@"dc"];
    [[X509Name DefaultLookUp] setObject:[X509Name E] forKey:@"e"];
    [[X509Name DefaultLookUp] setObject:[X509Name UID] forKey:@"uid"];
    [[X509Name DefaultLookUp] setObject:[X509Name SURNAME] forKey:@"surname"];
    [[X509Name DefaultLookUp] setObject:[X509Name GIVENNAME] forKey:@"givenname"];
    [[X509Name DefaultLookUp] setObject:[X509Name INITIALS] forKey:@"initials"];
    [[X509Name DefaultLookUp] setObject:[X509Name GENERATION] forKey:@"generation"];
    [[X509Name DefaultLookUp] setObject:[X509Name UnstructuredAddress] forKey:@"unstructuredaddress"];
    [[X509Name DefaultLookUp] setObject:[X509Name UnstructuredName] forKey:@"unstructuredname"];
    [[X509Name DefaultLookUp] setObject:[X509Name UNIQUE_IDENTIFIER] forKey:@"uniqueidentifier"];
    [[X509Name DefaultLookUp] setObject:[X509Name DN_QUALIFIER] forKey:@"dn"];
    [[X509Name DefaultLookUp] setObject:[X509Name PSEUDONYM] forKey:@"pseudonym"];
    [[X509Name DefaultLookUp] setObject:[X509Name POSTAL_ADDRESS] forKey:@"postaladdress"];
    [[X509Name DefaultLookUp] setObject:[X509Name NAME_AT_BIRTH] forKey:@"nameofbirth"];
    [[X509Name DefaultLookUp] setObject:[X509Name COUNTRY_OF_CITIZENSHIP] forKey:@"countryofcitizenship"];
    [[X509Name DefaultLookUp] setObject:[X509Name COUNTRY_OF_RESIDENCE] forKey:@"countryofresidence"];
    [[X509Name DefaultLookUp] setObject:[X509Name GENDER] forKey:@"gender"];
    [[X509Name DefaultLookUp] setObject:[X509Name PLACE_OF_BIRTH] forKey:@"placeofbirth"];
    [[X509Name DefaultLookUp] setObject:[X509Name DATE_OF_BIRTH] forKey:@"dateofbirth"];
    [[X509Name DefaultLookUp] setObject:[X509Name POSTAL_CODE] forKey:@"postalcode"];
    [[X509Name DefaultLookUp] setObject:[X509Name BUSINESS_CATEGORY] forKey:@"businesscategory"];
    [[X509Name DefaultLookUp] setObject:[X509Name TELEPHONE_NUMBER] forKey:@"telephonenumber"];
    [[X509Name DefaultLookUp] setObject:[X509Name NAME] forKey:@"name"];

}

@end
