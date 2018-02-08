//
//  BCStyle.m
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BCStyle.h"
#import "DERIA5String.h"
#import "ASN1GeneralizedTime.h"
#import "DERPrintableString.h"
#import "IETFUtils.h"

@implementation BCStyle


+ (ASN1ObjectIdentifier *)C {
    static ASN1ObjectIdentifier *_C = nil;
    @synchronized(self) {
        if (!_C) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.6"];
            _C = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _C;
}

+ (ASN1ObjectIdentifier *)O {
    static ASN1ObjectIdentifier *_O = nil;
    @synchronized(self) {
        if (!_O) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.10"];
            _O = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _O;
}

+ (ASN1ObjectIdentifier *)OU {
    static ASN1ObjectIdentifier *_OU = nil;
    @synchronized(self) {
        if (!_OU) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.11"];
            _OU = [obj  intern];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _OU;
}

+ (ASN1ObjectIdentifier *)T {
    static ASN1ObjectIdentifier *_T = nil;
    @synchronized(self) {
        if (!_T) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.12"];
           _T = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _T;
}

+ (ASN1ObjectIdentifier *)CN {
    static ASN1ObjectIdentifier *_CN = nil;
    @synchronized(self) {
        if (!_CN) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.3"];
            _CN = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _CN;
}

+ (ASN1ObjectIdentifier *)SN {
    static ASN1ObjectIdentifier *_SN = nil;
    @synchronized(self) {
        if (!_SN) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.5"];
            _SN = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _SN;
}

+ (ASN1ObjectIdentifier *)STREET {
    static ASN1ObjectIdentifier *_STREET = nil;
    @synchronized(self) {
        if (!_STREET) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.9"];
            _STREET = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _STREET;
}

+ (ASN1ObjectIdentifier *)SERIALNUMBER {
    static ASN1ObjectIdentifier *_SERIALNUMBER = nil;
    @synchronized(self) {
        if (!_SERIALNUMBER) {
            _SERIALNUMBER = [[BCStyle SN] retain];
        }
    }
    return _SERIALNUMBER;
}

+ (ASN1ObjectIdentifier *)L {
    static ASN1ObjectIdentifier *_L = nil;
    @synchronized(self) {
        if (!_L) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.7"];
            _L = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _L;
}

+ (ASN1ObjectIdentifier *)ST {
    static ASN1ObjectIdentifier *_ST = nil;
    @synchronized(self) {
        if (!_ST) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.8"];
            _ST = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _ST;
}

+ (ASN1ObjectIdentifier *)SURNAME {
    static ASN1ObjectIdentifier *_SURNAME = nil;
    @synchronized(self) {
        if (!_SURNAME) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.4"];
            _SURNAME = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _SURNAME;
}

+ (ASN1ObjectIdentifier *)GIVENNAME {
    static ASN1ObjectIdentifier *_GIVENNAME = nil;
    @synchronized(self) {
        if (!_GIVENNAME) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.42"];
           _GIVENNAME = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
       }
    }
    return _GIVENNAME;
}

+ (ASN1ObjectIdentifier *)INITIALS {
    static ASN1ObjectIdentifier *_INITIALS = nil;
    @synchronized(self) {
        if (!_INITIALS) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.43"];
           _INITIALS = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _INITIALS;
}

+ (ASN1ObjectIdentifier *)GENERATION {
    static ASN1ObjectIdentifier *_GENERATION = nil;
    @synchronized(self) {
        if (!_GENERATION) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.44"];
            _GENERATION = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _GENERATION;
}

+ (ASN1ObjectIdentifier *)UNIQUE_IDENTIFIER {
    static ASN1ObjectIdentifier *_UNIQUE_IDENTIFIER = nil;
    @synchronized(self) {
        if (!_UNIQUE_IDENTIFIER) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.45"];
            _UNIQUE_IDENTIFIER = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _UNIQUE_IDENTIFIER;
}

+ (ASN1ObjectIdentifier *)BUSINESS_CATEGORY {
    static ASN1ObjectIdentifier *_BUSINESS_CATEGORY = nil;
    @synchronized(self) {
        if (!_BUSINESS_CATEGORY) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.15"];
            _BUSINESS_CATEGORY = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _BUSINESS_CATEGORY;
}

+ (ASN1ObjectIdentifier *)POSTAL_CODE {
    static ASN1ObjectIdentifier *_POSTAL_CODE = nil;
    @synchronized(self) {
        if (!_POSTAL_CODE) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.17"];
            _POSTAL_CODE = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _POSTAL_CODE;
}

+ (ASN1ObjectIdentifier *)DN_QUALIFIER {
    static ASN1ObjectIdentifier *_DN_QUALIFIER = nil;
    @synchronized(self) {
        if (!_DN_QUALIFIER) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.46"];
           _DN_QUALIFIER = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _DN_QUALIFIER;
}

+ (ASN1ObjectIdentifier *)PSEUDONYM {
    static ASN1ObjectIdentifier *_PSEUDONYM = nil;
    @synchronized(self) {
        if (!_PSEUDONYM) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.65"];
            _PSEUDONYM = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _PSEUDONYM;
}

+ (ASN1ObjectIdentifier *)DATE_OF_BIRTH {
    static ASN1ObjectIdentifier *_DATE_OF_BIRTH = nil;
    @synchronized(self) {
        if (!_DATE_OF_BIRTH) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.9.1"];
            _DATE_OF_BIRTH = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _DATE_OF_BIRTH;
}

+ (ASN1ObjectIdentifier *)PLACE_OF_BIRTH {
    static ASN1ObjectIdentifier *_PLACE_OF_BIRTH = nil;
    @synchronized(self) {
        if (!_PLACE_OF_BIRTH) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.9.2"];
            _PLACE_OF_BIRTH = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _PLACE_OF_BIRTH;
}

+ (ASN1ObjectIdentifier *)GENDER {
    static ASN1ObjectIdentifier *_GENDER = nil;
    @synchronized(self) {
        if (!_GENDER) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.9.3"];
            _GENDER = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _GENDER;
}

+ (ASN1ObjectIdentifier *)COUNTRY_OF_CITIZENSHIP {
    static ASN1ObjectIdentifier *_COUNTRY_OF_CITIZENSHIP = nil;
    @synchronized(self) {
        if (!_COUNTRY_OF_CITIZENSHIP) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.9.4"];
            _COUNTRY_OF_CITIZENSHIP = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _COUNTRY_OF_CITIZENSHIP;
}

+ (ASN1ObjectIdentifier *)COUNTRY_OF_RESIDENCE {
    static ASN1ObjectIdentifier *_COUNTRY_OF_RESIDENCE = nil;
    @synchronized(self) {
        if (!_COUNTRY_OF_RESIDENCE) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.9.5"];
            _COUNTRY_OF_RESIDENCE = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _COUNTRY_OF_RESIDENCE;
}

+ (ASN1ObjectIdentifier *)NAME_AT_BIRTH {
    static ASN1ObjectIdentifier *_NAME_AT_BIRTH = nil;
    @synchronized(self) {
        if (!_NAME_AT_BIRTH) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.36.8.3.14"];
            _NAME_AT_BIRTH = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _NAME_AT_BIRTH;
}

+ (ASN1ObjectIdentifier *)POSTAL_ADDRESS {
    static ASN1ObjectIdentifier *_POSTAL_ADDRESS = nil;
    @synchronized(self) {
        if (!_POSTAL_ADDRESS) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.16"];
            _POSTAL_ADDRESS = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _POSTAL_ADDRESS;
}

+ (ASN1ObjectIdentifier *)DMD_NAME {
    static ASN1ObjectIdentifier *_DMD_NAME = nil;
    @synchronized(self) {
        if (!_DMD_NAME) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.54"];
            _DMD_NAME = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _DMD_NAME;
}

#pragma mark X509
+ (ASN1ObjectIdentifier *)TELEPHONE_NUMBER{
    static ASN1ObjectIdentifier *_TELEPHONE_NUMBER = nil;
    @synchronized(self) {
        if (!_TELEPHONE_NUMBER) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.6"];
            _TELEPHONE_NUMBER = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _TELEPHONE_NUMBER;
}

#pragma mark X509
+ (ASN1ObjectIdentifier *)NAME {
    static ASN1ObjectIdentifier *_NAME = nil;
    @synchronized(self) {
        if (!_NAME) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.6"];
            _NAME = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _NAME;
}

+ (ASN1ObjectIdentifier *)EmailAddress {
    static ASN1ObjectIdentifier *_EmailAddress = nil;
    @synchronized(self) {
        if (!_EmailAddress) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.6"];
            _EmailAddress = [[[obj intern] retain] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _EmailAddress;
}

+ (ASN1ObjectIdentifier *)UnstructuredName {
    static ASN1ObjectIdentifier *_UnstructuredName = nil;
    @synchronized(self) {
        if (!_UnstructuredName) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.6"];
            _UnstructuredName = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _UnstructuredName;
}

+ (ASN1ObjectIdentifier *)UnstructuredAddress {
    static ASN1ObjectIdentifier *_UnstructuredAddress = nil;
    @synchronized(self) {
        if (!_UnstructuredAddress) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.6"];
            _UnstructuredAddress = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _UnstructuredAddress;
}

+ (ASN1ObjectIdentifier *)E {
    static ASN1ObjectIdentifier *_E = nil;
    @synchronized(self) {
        if (!_E) {
            _E = [[BCStyle EmailAddress] retain];
        }
    }
    return _E;
}

+ (ASN1ObjectIdentifier *)DC{
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

+ (NSMutableDictionary *)DefaultSymbols {
    static NSMutableDictionary *_defaultSymbols = nil;
    @synchronized(self) {
        if (!_defaultSymbols) {
            _defaultSymbols = [[NSMutableDictionary alloc] init];
        }
    }
    return _defaultSymbols;
}

+ (NSMutableDictionary *)DefaultLookUp {
    static NSMutableDictionary *_defaultLookUp = nil;
    @synchronized(self) {
        if (!_defaultLookUp) {
            _defaultLookUp = [[NSMutableDictionary alloc] init];
        }
    }
    return _defaultLookUp;
}

+ (X500NameStyle *)INSTANCE {
    static X500NameStyle *_INSTANCE = nil;
    @synchronized(self) {
        if (!_INSTANCE) {
            _INSTANCE = [[BCStyle alloc] init];
        }
    }
    return _INSTANCE;
}

- (NSMutableDictionary *)defaultLookUp {
    NSMutableDictionary *_defaultLookUp = nil;
    if (!_defaultLookUp) {
        _defaultLookUp = [BCStyle copyHashTable:[BCStyle DefaultLookUp]];
    }
    return _defaultLookUp;
}

- (NSMutableDictionary *)defaultSymbols {
    NSMutableDictionary *_defaultSymbols = nil;
    if (!_defaultSymbols) {
        _defaultSymbols = [BCStyle copyHashTable:[BCStyle DefaultSymbols]];
    }
    return _defaultSymbols;
}

- (ASN1Encodable *)encodeStringValue:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString {
    if ([paramASN1ObjectIdentifier isEqual:[BCStyle EmailAddress]] || [paramASN1ObjectIdentifier isEqual:[BCStyle DC]]) {
        return [[[DERIA5String alloc] initParamString:paramString] autorelease];
    }
    if ([paramASN1ObjectIdentifier isEqual:[BCStyle DATE_OF_BIRTH]]) {
        return [[[ASN1GeneralizedTime alloc] initParamString:paramString] autorelease];
    }
    if ([paramASN1ObjectIdentifier isEqual:[BCStyle C]] || [paramASN1ObjectIdentifier isEqual:[BCStyle SN]]) {
        return [[[DERPrintableString alloc] initParamString:paramString] autorelease];
    }
    return [super encodeStringValue:paramASN1ObjectIdentifier paramString:paramString];
}

- (NSString *)oidToDisplayName:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    return (NSString *)[[BCStyle DefaultSymbols] objectForKey:paramASN1ObjectIdentifier];
}

- (NSMutableArray *)oidToAttrNames:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    return [IETFUtils findAttrNamesForOID:paramASN1ObjectIdentifier paramHashTable:self.defaultLookUp];
}

- (ASN1ObjectIdentifier *)attrNameToOID:(NSString *)paramString {
    return [IETFUtils decodeAttrName:paramString paramHashTable:self.defaultLookUp];
}

- (NSMutableArray *)fromString:(NSString *)paramString {
    return [IETFUtils rDNsFromString:paramString paramX500NameStyle:self];
}

- (NSString *)toString:(X500Name *)paramX500Name {
    return nil;
}

+ (void)load {
    [super load];
    [[BCStyle DefaultSymbols] setObject:@"C" forKey:[BCStyle C]];
    [[BCStyle DefaultSymbols] setObject:@"O" forKey:[BCStyle O]];
    [[BCStyle DefaultSymbols] setObject:@"T" forKey:[BCStyle T]];
    [[BCStyle DefaultSymbols] setObject:@"OU" forKey:[BCStyle OU]];
    [[BCStyle DefaultSymbols] setObject:@"CN" forKey:[BCStyle CN]];
    [[BCStyle DefaultSymbols] setObject:@"L" forKey:[BCStyle L]];
    [[BCStyle DefaultSymbols] setObject:@"ST" forKey:[BCStyle ST]];
    [[BCStyle DefaultSymbols] setObject:@"SERIALNUMBER" forKey:[BCStyle SN]];
    [[BCStyle DefaultSymbols] setObject:@"E" forKey:[BCStyle EmailAddress]];
    [[BCStyle DefaultSymbols] setObject:@"DC" forKey:[BCStyle DC]];
    [[BCStyle DefaultSymbols] setObject:@"UID" forKey:[BCStyle UID]];
    [[BCStyle DefaultSymbols] setObject:@"STREET" forKey:[BCStyle STREET]];
    [[BCStyle DefaultSymbols] setObject:@"SURNAME" forKey:[BCStyle SURNAME]];
    [[BCStyle DefaultSymbols] setObject:@"GIVENNAME" forKey:[BCStyle GIVENNAME]];
    [[BCStyle DefaultSymbols] setObject:@"INITIALS" forKey:[BCStyle INITIALS]];
    [[BCStyle DefaultSymbols] setObject:@"GENERATION" forKey:[BCStyle GENERATION]];
    [[BCStyle DefaultSymbols] setObject:@"unstructuredAddress" forKey:[BCStyle UnstructuredAddress]];
    [[BCStyle DefaultSymbols] setObject:@"unstructuredName" forKey:[BCStyle UnstructuredName]];
    [[BCStyle DefaultSymbols] setObject:@"UniqueIdentifier" forKey:[BCStyle UNIQUE_IDENTIFIER]];
    [[BCStyle DefaultSymbols] setObject:@"DN" forKey:[BCStyle DN_QUALIFIER]];
    [[BCStyle DefaultSymbols] setObject:@"Pseudonym" forKey:[BCStyle PSEUDONYM]];
    [[BCStyle DefaultSymbols] setObject:@"PostalAddress" forKey:[BCStyle POSTAL_ADDRESS]];
    [[BCStyle DefaultSymbols] setObject:@"NameAtBirth" forKey:[BCStyle NAME_AT_BIRTH]];
    [[BCStyle DefaultSymbols] setObject:@"CountryOfCitizenship" forKey:[BCStyle COUNTRY_OF_CITIZENSHIP]];
    [[BCStyle DefaultSymbols] setObject:@"CountryOfResidence" forKey:[BCStyle COUNTRY_OF_RESIDENCE]];
    [[BCStyle DefaultSymbols] setObject:@"Gender" forKey:[BCStyle GENDER]];
    [[BCStyle DefaultSymbols] setObject:@"PlaceOfBirth" forKey:[BCStyle PLACE_OF_BIRTH]];
    [[BCStyle DefaultSymbols] setObject:@"DateOfBirth" forKey:[BCStyle DATE_OF_BIRTH]];
    [[BCStyle DefaultSymbols] setObject:@"PostalCode" forKey:[BCStyle POSTAL_CODE]];
    [[BCStyle DefaultSymbols] setObject:@"BusinessCategory" forKey:[BCStyle BUSINESS_CATEGORY]];
    [[BCStyle DefaultSymbols] setObject:@"TelephoneNumber" forKey:[BCStyle TELEPHONE_NUMBER]];
    [[BCStyle DefaultSymbols] setObject:@"Name" forKey:[BCStyle NAME]];
    [[BCStyle DefaultLookUp] setObject:[BCStyle C] forKey:@"c"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle O] forKey:@"o"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle T] forKey:@"t"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle OU] forKey:@"ou"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle CN] forKey:@"cn"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle L] forKey:@"l"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle ST] forKey:@"st"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle SN] forKey:@"sn"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle SN] forKey:@"serialnumber"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle STREET] forKey:@"street"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle E] forKey:@"emailaddress"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle DC] forKey:@"dc"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle E] forKey:@"e"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle UID] forKey:@"uid"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle SURNAME] forKey:@"surname"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle GIVENNAME] forKey:@"givenname"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle INITIALS] forKey:@"initials"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle GENERATION] forKey:@"generation"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle UnstructuredAddress] forKey:@"unstructuredaddress"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle UnstructuredName] forKey:@"unstructuredname"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle UNIQUE_IDENTIFIER] forKey:@"uniqueidentifier"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle DN_QUALIFIER] forKey:@"dn"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle PSEUDONYM] forKey:@"pseudonym"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle POSTAL_ADDRESS] forKey:@"postaladdress"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle NAME_AT_BIRTH] forKey:@"nameofbirth"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle COUNTRY_OF_CITIZENSHIP] forKey:@"countryofcitizenship"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle COUNTRY_OF_RESIDENCE] forKey:@"countryofresidence"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle GENDER] forKey:@"gender"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle PLACE_OF_BIRTH] forKey:@"placeofbirth"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle DATE_OF_BIRTH] forKey:@"dateofbirth"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle POSTAL_CODE] forKey:@"postalcode"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle BUSINESS_CATEGORY] forKey:@"businesscategory"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle TELEPHONE_NUMBER] forKey:@"telephonenumber"];
    [[BCStyle DefaultLookUp] setObject:[BCStyle NAME] forKey:@"name"];
}

@end
