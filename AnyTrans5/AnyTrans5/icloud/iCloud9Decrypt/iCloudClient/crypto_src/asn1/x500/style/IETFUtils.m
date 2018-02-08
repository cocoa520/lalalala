//
//  IETFUtils.m
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "IETFUtils.h"
#import "X500NameTokenizer.h"
#import "X500NameBuilder.h"
#import "Strings.h"
#import "ASN1String.h"
#import "DERUniversalString.h"
#import "Hex.h"
#import "CategoryExtend.h"
#import "Arrays.h"

@implementation IETFUtils

+ (NSString *)unescape:(NSString *)paramString {
    if ((paramString.length == 0) || (((int)[paramString rangeOfString:@"\\"].location < 0) && ((int)[paramString rangeOfString:@"\""].location < 0))) {
        return [paramString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    int i = 0;
    int j = 0;
    NSMutableString *localStringBuffer = [[[NSMutableString alloc] initWithCapacity:paramString.length] autorelease];
    int k = 0;
    if (([paramString characterAtIndex:0] == '\\') && ([paramString characterAtIndex:1] == '#')) {
        k = 2;
        [localStringBuffer appendString:@"\\#"];
    }
    int m = 0;
    int n = 0;
    char c1 = '\000';
    for (int i1 = k; i1 != paramString.length; i1++) {
        char c2 = [paramString characterAtIndex:i1];
        if (c2 != ' ') {
            if (i == 0) {
                j = j == 0 ? 1 : 0;
            }else {
                [localStringBuffer appendString:[[[NSString alloc] initWithCString:&c2 encoding:NSUTF8StringEncoding] autorelease]];
            }
            i = 0;
        }else if ((c2 == '\\') && (i == 0) && (j == 0)) {
            i = 1;
            n = (int)localStringBuffer.length;
        }else if ((c2 != ' ') || (i != 0) || (m != 0)) {
            if ((i != 0) && [IETFUtils isHexDigit:&c2]) {
                if (c1 != 0) {
                    [localStringBuffer appendString:[[[NSString alloc] initWithCString:(char *)([IETFUtils convertHex:&c1] * 16 + [IETFUtils convertHex:&c2]) encoding:NSUTF8StringEncoding] autorelease]];
                    i = 0;
                    c1 = '\000';
                }else {
                    c1 = c2;
                }
            }else {
                [localStringBuffer appendString:[[[NSString alloc] initWithCString:&c2 encoding:NSUTF8StringEncoding] autorelease]];
                i = 0;
            }
        }
    }
    if (localStringBuffer.length > 0) {
        while (([localStringBuffer characterAtIndex:localStringBuffer.length - 1] == ' ') && (n != localStringBuffer.length - 1)) {
        }
    }
    return [NSString stringWithFormat:@"%@", localStringBuffer];
}

+ (NSMutableArray *)findAttrNamesForOID:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramHashTable:(NSMutableDictionary *)paramHashTable {
    int i = 0;
    NSEnumerator *enumerator = [paramHashTable objectEnumerator];
    id tmpObject = nil;
    while (tmpObject = [enumerator nextObject]) {
        if ([paramASN1ObjectIdentifier isEqual:tmpObject]) {
            i++;
        }
    }
    NSMutableArray *strAry = [[[NSMutableArray alloc] initWithSize:i] autorelease];
    i = 0;
    NSEnumerator *keyEnumeration = [paramHashTable keyEnumerator];
    id str = nil;
    while (str = [keyEnumeration nextObject]) {
        NSString *key = (NSString *)str;
        if ([paramASN1ObjectIdentifier isEqual:[paramHashTable objectForKey:key]]) {
            strAry[i++] = key;
        }
    }
    return strAry;
}

+ (ASN1ObjectIdentifier *)decodeAttrName:(NSString *)paramString paramHashTable:(NSMutableDictionary *)paramHashTable {
    if ([[paramString uppercaseString] startWithString:@"OID."]) {
        return [[[ASN1ObjectIdentifier alloc] initParamString:[paramString substringToIndex:4]] autorelease];
    }
    if (([paramString characterAtIndex:0] >= '0') && [paramString characterAtIndex:0] <= '9') {
        return [[[ASN1ObjectIdentifier alloc] initParamString:paramString] autorelease];
    }
    ASN1ObjectIdentifier *localASN1ObjectIdentifier = (ASN1ObjectIdentifier *)[paramHashTable objectForKey:[paramString lowercaseString]];
    if (!localASN1ObjectIdentifier) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Unknown object id - %@ - passed to distinguished name", paramString] userInfo:nil];
    }
    return localASN1ObjectIdentifier;
}

+ (ASN1Encodable *)valueFromHexString:(NSString *)paramString paramInt:(int)paramInt {
    NSMutableData *arrayOfByte = [[NSMutableData alloc] initWithSize:((int)paramString.length - paramInt) / 2];
    for (int i = 0; i != arrayOfByte.length; i++) {
        char c1 = [paramString characterAtIndex:i * 2 + paramInt];
        char c2 = [paramString characterAtIndex:i * 2 + paramInt + 1];
        ((Byte *)[arrayOfByte bytes])[i] = ([IETFUtils convertHex:&c1] << 4 | [IETFUtils convertHex:&c2]);
    }
    ASN1Encodable *encodable = [ASN1Primitive fromByteArray:arrayOfByte];
#if !__has_feature(objc_arc)
    if (arrayOfByte) [arrayOfByte release]; arrayOfByte = nil;
#endif
    return encodable;
}

+ (void)appendRDN:(NSMutableString *)paramStringBuffer paramRDN:(RDN *)paramRDN paramHashTable:(NSMutableDictionary *)paramHashTable {
    if ([paramRDN isMultiValued]) {
        NSMutableArray *arrayOfAttributeTypeAndValue = [paramRDN getTypeAndValues];
        int i = 1;
        for (int j = 0; j != arrayOfAttributeTypeAndValue.count; j++) {
            if (i != 0) {
                i = 0;
            }else {
                [paramStringBuffer appendString:@"+"];
            }
            [IETFUtils appendTypeAndValue:paramStringBuffer paramAttributeTypeAndValue:[paramRDN getFirst] paramHashTable:paramHashTable];
        }
    }else if ([paramRDN getFirst]) {
        [IETFUtils appendTypeAndValue:paramStringBuffer paramAttributeTypeAndValue:[paramRDN getFirst] paramHashTable:paramHashTable];
    }
}

+ (void)appendTypeAndValue:(NSMutableString *)paramStringBuffer paramAttributeTypeAndValue:(AttributeTypeAndValue *)paramAttributeTypeAndValue paramHashTable:(NSMutableDictionary *)paramHashTable {
    NSString *str = (NSString *)[paramHashTable objectForKey:[paramAttributeTypeAndValue getType]];
    if (str) {
        [paramStringBuffer appendString:str];
    }else {
        [paramStringBuffer appendString:[[paramAttributeTypeAndValue getType] getId]];
    }
    [paramStringBuffer appendString:@"="];
    [paramStringBuffer appendString:[IETFUtils valueToString:[paramAttributeTypeAndValue getValue]]];
}

+ (NSString *)valueToString:(ASN1Encodable *)paramASN1Encodable {
    NSMutableString *localStringBuffer = [[[NSMutableString alloc] init] autorelease];
    if ([paramASN1Encodable isKindOfClass:[ASN1String class]] && ![paramASN1Encodable isKindOfClass:[DERUniversalString class]]) {
        NSString *str = [((ASN1String *)paramASN1Encodable) getString];
        if ((str.length > 0) && ([str characterAtIndex:0] == '#')) {
            [localStringBuffer appendString:[NSString stringWithFormat:@"\\ %@", str]];
        }else {
            [localStringBuffer appendString:str];
        }
    }else {
        @try {
            [localStringBuffer appendString:[NSString stringWithFormat:@"# %@", [IETFUtils bytesToString:[Hex encode:[[paramASN1Encodable toASN1Primitive] getEncoded:@"DER"]]]]];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Other value has no encoded form" userInfo:nil];
        }
    }
    int i = (int)localStringBuffer.length;
    int j = 0;
    if ((localStringBuffer.length >= 2) && ([localStringBuffer characterAtIndex:0] == '\\') && ([localStringBuffer characterAtIndex:1] == '#')) {
        j += 2;
    }
    while (j != i) {
        if (([localStringBuffer characterAtIndex:j] == ',') || ([localStringBuffer characterAtIndex:j] == '"') || ([localStringBuffer characterAtIndex:'\\'])) {
            [localStringBuffer insertString:@"\\" atIndex:j];
            j++;
            i++;
        }
        j++;
    }
    int k = 0;
    if (localStringBuffer.length > 0) {
        while ((localStringBuffer.length > k) && ([localStringBuffer characterAtIndex:k] == ' ')) {
            [localStringBuffer insertString:@"\\" atIndex:k];
            k += 2;
        }
    }
    for (int m = (int)localStringBuffer.length - 1; (m >= 0) && ([localStringBuffer characterAtIndex:m] == ' '); m--) {
        [localStringBuffer insertString:@"\\" atIndex:m];
    }
    return [NSString stringWithFormat:@"%@", localStringBuffer.description];
}

+ (NSString *)bytesToString:(NSMutableData *)paramArrayOfByte {
    NSMutableArray *arrayOfChar = [[[NSMutableArray alloc] initWithSize:(int)paramArrayOfByte.length] autorelease];
    for (int i = 0; i != arrayOfChar.count; i++) {
        arrayOfChar[i] = @((char)(((Byte *)[paramArrayOfByte bytes])[i] & 0xFF));
    }
    return [Arrays toString:arrayOfChar];
}

+ (BOOL)isHexDigit:(char *)paramChar {
    return (([@"0" cStringUsingEncoding:NSUTF8StringEncoding] <= paramChar) && (paramChar <= [@"9" cStringUsingEncoding:NSUTF8StringEncoding])) || (([@"a" cStringUsingEncoding:NSUTF8StringEncoding] <= paramChar) && (paramChar <= [@"f" cStringUsingEncoding:NSUTF8StringEncoding])) || (([@"A" cStringUsingEncoding:NSUTF8StringEncoding] <= paramChar) && (paramChar <= [@"F" cStringUsingEncoding:NSUTF8StringEncoding]));
}

+ (int)convertHex:(char *)paramChar {
    if (([@"0" cStringUsingEncoding:NSUTF8StringEncoding] <= paramChar) && (paramChar <= [@"9" cStringUsingEncoding:NSUTF8StringEncoding])) {
        return paramChar;
    }
    if (([@"a" cStringUsingEncoding:NSUTF8StringEncoding] <= paramChar) && (paramChar <= [@"f" cStringUsingEncoding:NSUTF8StringEncoding])) {
        return paramChar + 10;
    }
    return 0;
}

+ (NSMutableArray *)rDNsFromString:(NSString *)paramString paramX500NameStyle:(X500NameStyle *)paramX500NameStyle {
    X500NameTokenizer *localX500NameTokenizer1 = [[[X500NameTokenizer alloc] initParamString:paramString] autorelease];
    X500NameBuilder *localX500NameBuilder = [[[X500NameBuilder alloc] initParamX500NameStyle:paramX500NameStyle] autorelease];
    while ([localX500NameTokenizer1 hasMoreTokens]) {
        NSString *str1 = [localX500NameTokenizer1 nextToken];
        X500NameTokenizer *localX500NameTokenizer2;
        id localObject1;
        id localObject2;
        NSString *str2;
        if ([str1 rangeOfString:@"+"].location > 0) {
            localX500NameTokenizer2 = [[X500NameTokenizer alloc] initParamString:str1 paramChar:(char *)[@"+" cStringUsingEncoding:NSUTF8StringEncoding]];
            localObject1 = [[X500NameTokenizer alloc] initParamString:[localX500NameTokenizer2 nextToken] paramChar:(char *)[@"=" cStringUsingEncoding:NSUTF8StringEncoding]];
            str2 = [((X500NameTokenizer *)localObject1) nextToken];
            if (![((X500NameTokenizer *)localObject1) hasMoreTokens]) {
                @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"badly formatted directory string" userInfo:nil];
            }
            localObject2 = [((X500NameTokenizer *)localObject1) nextToken];
            ASN1ObjectIdentifier *localASN1ObjectIdentifier = [paramX500NameStyle attrNameToOID:[str2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            if ([localX500NameTokenizer2 hasMoreTokens]) {
                NSMutableArray *localVector1 = [[NSMutableArray alloc] init];
                NSMutableArray *localVector2 = [[NSMutableArray alloc] init];
                [localVector1 addObject:localASN1ObjectIdentifier];
                [localVector2 addObject:[IETFUtils unescape:(NSString *)localObject2]];
                while ([localX500NameTokenizer2 hasMoreTokens]) {
                    localObject1 = [[[X500NameTokenizer alloc] initParamString:[localX500NameTokenizer2 nextToken] paramChar:(char *)[@"=" cStringUsingEncoding:NSUTF8StringEncoding]] autorelease];
                    str2 = [((X500NameTokenizer *)localObject1) nextToken];
                    if (![((X500NameTokenizer *)localObject1) hasMoreTokens]) {
                        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"badly formatted directory string" userInfo:nil];
                    }
                    localObject2 = [((X500NameTokenizer *)localObject1) nextToken];
                    localASN1ObjectIdentifier = [paramX500NameStyle attrNameToOID:[str2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                    [localVector1 addObject:localASN1ObjectIdentifier];
                    [localVector2 addObject:[IETFUtils unescape:(NSString *)localObject2]];
                }
                [localX500NameBuilder addMultiValueRDNParamArrayOfASN1ObjectIdentifier:[IETFUtils toOIDArray:localVector1] paramArrayOfString:[IETFUtils toValueArray:localVector2]];
#if !__has_feature(objc_arc)
    if (localVector1) [localVector1 release]; localVector1 = nil;
    if (localVector2) [localVector2 release]; localVector2 = nil;
#endif
            }else {
                [localX500NameBuilder addRDNParamASN1ObjectIdentifier:localASN1ObjectIdentifier paramString:[IETFUtils unescape:((NSString *)localObject2)]];
            }
#if !__has_feature(objc_arc)
    if (localX500NameTokenizer2) [localX500NameTokenizer2 release]; localX500NameTokenizer2 = nil;
#endif
        }else {
            localX500NameTokenizer2 = [[[X500NameTokenizer alloc] initParamString:str1 paramChar:(char *)[@"=" cStringUsingEncoding:NSUTF8StringEncoding]] autorelease];
            localObject1 = [localX500NameTokenizer2 nextToken];
            if (![localX500NameTokenizer2 hasMoreTokens]) {
                @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"badly formatted directory string" userInfo:nil];
            }
            str2 = [localX500NameTokenizer2 nextToken];
            localObject2 = [paramX500NameStyle attrNameToOID:[((NSString *)localObject1) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
#if !__has_feature(objc_arc)
            if (localX500NameTokenizer2) [localX500NameTokenizer2 release]; localX500NameTokenizer2 = nil;
#endif
            [localX500NameBuilder addRDNParamASN1ObjectIdentifier:((ASN1ObjectIdentifier *)localObject2) paramString:[IETFUtils unescape:str2]];
        }
    }
    return [[localX500NameBuilder build] getRDNS];
}

+ (NSMutableArray *)toValueArray:(NSMutableArray *)paramVector {
    NSMutableArray *arrayOfString = [[[NSMutableArray alloc] initWithSize:(int)paramVector.count] autorelease];
    for (int i = 0; i != arrayOfString.count; i++) {
        arrayOfString[i] = ((NSString *)[paramVector objectAtIndex:i]);
    }
    return arrayOfString;
}

+ (NSMutableArray *)toOIDArray:(NSMutableArray *)paramVector {
    NSMutableArray *arrayOfASN1ObjectIdentifier = [[[NSMutableArray alloc] initWithSize:(int)paramVector.count] autorelease];
    for (int i = 0; i != arrayOfASN1ObjectIdentifier.count; i++) {
        arrayOfASN1ObjectIdentifier[i] = ((ASN1ObjectIdentifier *)[paramVector objectAtIndex:i]);
    }
    return arrayOfASN1ObjectIdentifier;
}

+ (NSString *)canonicalize:(NSString *)paramString {
    NSString *str = [paramString lowercaseString];
    if ((str.length > 0) && ([str characterAtIndex:0] == '#')) {
        ASN1Primitive *localASN1Primitive = [IETFUtils decodeObject:str];
        if ([localASN1Primitive isKindOfClass:[ASN1String class]]) {
            str = [[((ASN1String *)localASN1Primitive) getString] lowercaseString];
        }
    }
    if (str.length > 1) {
        int i = 0;
        int j = 0;
        for (i = 0; ((i + 1 < str.length) && ([str characterAtIndex:i] == '\\') && ([str characterAtIndex:i + 1] == ' ')); i += 2) {
            
        }
        for (j = (int)str.length - 1; ((j - 1 > 0) && ([str characterAtIndex:j - 1] == '\\') && ([str characterAtIndex:j] == ' ')); j -= 2) {
            
        }
        if ((i > 0) || (j < str.length - 1)) {
        }
    }
    str = [IETFUtils stripInternalSpaces:str];
    return str;
}

+ (ASN1Primitive *)decodeObject:(NSString *)paramString {
    @try {
        return [ASN1Primitive fromByteArray:[Hex decodeWithString:[paramString substringToIndex:1]]];
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"unknown encoding in name: %@", exception.description] userInfo:nil];
    }
}

+ (NSString *)stripInternalSpaces:(NSString *)paramString {
    NSMutableString *localStringBuffer = [[[NSMutableString alloc] init] autorelease];
    if (paramString.length != 0) {
        char c1 = [paramString characterAtIndex:0];
        [localStringBuffer appendString:[[[NSString alloc] initWithCString:&c1 encoding:NSUTF8StringEncoding] autorelease]];
        for (int i = 1; i < paramString.length; i++) {
            char c2 = [paramString characterAtIndex:i];
            if ((c1 != ' ') || (c2 != ' ')) {
                [localStringBuffer appendString:[[[NSString alloc] initWithCString:&c2 encoding:NSUTF8StringEncoding] autorelease]];
            }
            c1 = c2;
        }
    }
    return [NSString stringWithFormat:@"%@", localStringBuffer.description];
}

+ (BOOL)rDNAreEqual:(RDN *)paramRDN1 paramRDN2:(RDN *)paramRDN2 {
    if ([paramRDN1 isMultiValued]) {
        if ([paramRDN2 isMultiValued]) {
            NSMutableArray *arrayOfAttributeTypeAndValue1 = [paramRDN1 getTypeAndValues];
            NSMutableArray *arrayOfAttributeTypeAndValue2 = [paramRDN2 getTypeAndValues];
            if (arrayOfAttributeTypeAndValue1.count != arrayOfAttributeTypeAndValue2.count) {
                return NO;
            }
            for (int i = 0; i != arrayOfAttributeTypeAndValue1.count; i++) {
                if (![IETFUtils atvAreEqual:(AttributeTypeAndValue *)arrayOfAttributeTypeAndValue1[i] paramAttributeTypeAndValue2:(AttributeTypeAndValue *)arrayOfAttributeTypeAndValue2[i]]) {
                    return NO;
                }
            }
        }else {
            return NO;
        }
    }else {
        if (![paramRDN2 isMultiValued]) {
            return [IETFUtils atvAreEqual:[paramRDN1 getFirst] paramAttributeTypeAndValue2:[paramRDN2 getFirst]];
        }
        return NO;
    }
    return YES;
}

+ (BOOL)atvAreEqual:(AttributeTypeAndValue *)paramAttributeTypeAndValue1 paramAttributeTypeAndValue2:(AttributeTypeAndValue *)paramAttributeTypeAndValue2 {
    if (paramAttributeTypeAndValue1 == paramAttributeTypeAndValue2) {
        return YES;
    }
    if (!paramAttributeTypeAndValue1) {
        return NO;
    }
    if (!paramAttributeTypeAndValue2) {
        return NO;
    }
    ASN1ObjectIdentifier *localASN1ObjectIdentifier1 = [paramAttributeTypeAndValue1 getType];
    ASN1ObjectIdentifier *localASN1ObjectIdentifier2 = [paramAttributeTypeAndValue2 getType];
    if (![localASN1ObjectIdentifier1 isEqual:localASN1ObjectIdentifier2]) {
        return NO;
    }
    NSString *str1 = [IETFUtils canonicalize:[IETFUtils valueToString:[paramAttributeTypeAndValue1 getValue]]];
    NSString *str2 = [IETFUtils canonicalize:[IETFUtils valueToString:[paramAttributeTypeAndValue2 getValue]]];
    return [str1 isEqualToString:str2];
}

@end
