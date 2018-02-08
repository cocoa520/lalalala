//
//  Iso4217CurrencyCode.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Iso4217CurrencyCode.h"
#import "DERPrintableString.h"
#import "ASN1Integer.h"

@implementation Iso4217CurrencyCode
@synthesize obj = _obj;
@synthesize numeric = _numeric;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_obj) {
        [_obj release];
        _obj = nil;
    }
    [super dealloc];
#endif
}

+ (int)ALPHABETIC_MAXSIZE {
    static int _ALPHABETIC_MAXSIZE = 0;
    @synchronized(self) {
        if (!_ALPHABETIC_MAXSIZE) {
            _ALPHABETIC_MAXSIZE = 3;
        }
    }
    return _ALPHABETIC_MAXSIZE;
}

+ (int)NUMERIC_MINSIZE {
    static int _NUMERIC_MINSIZE = 0;
    @synchronized(self) {
        if (!_NUMERIC_MINSIZE) {
            _NUMERIC_MINSIZE = 1;
        }
    }
    return _NUMERIC_MINSIZE;
}

+ (int)NUMERIC_MAXSIZE {
    static int _NUMERIC_MAXSIZE = 0;
    @synchronized(self) {
        if (!_NUMERIC_MAXSIZE) {
            _NUMERIC_MAXSIZE = 999;
        }
    }
    return _NUMERIC_MAXSIZE;
}

+ (Iso4217CurrencyCode *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[Iso4217CurrencyCode class]]) {
        return (Iso4217CurrencyCode *)paramObject;
    }
    id localObject;
    if ([paramObject isKindOfClass:[ASN1Integer class]]) {
        localObject = [ASN1Integer getInstance:paramObject];
        int i = [[((ASN1Integer *)localObject) getValue] intValue];
        return [[[Iso4217CurrencyCode alloc] initParamInt:i] autorelease];
    }
    if ([paramObject isKindOfClass:[DERPrintableString class]]) {
        localObject = [DERPrintableString getInstance:paramObject];
        return [[[Iso4217CurrencyCode alloc] initParamString:[((DERPrintableString *)localObject) getString]] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:@"unknown object in getInstance" userInfo:nil];
}

- (instancetype)initParamInt:(int)paramInt
{
    if (self = [super init]) {
        if ((paramInt > 999) || (paramInt < 1)) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"wrong size in numeric code : not in (1..999)" userInfo:nil];
        }
        ASN1Encodable *encodable = [[ASN1Integer alloc] initLong:paramInt];
        self.obj = encodable;
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
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
        if ([paramString length] > 3) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"wrong size in alphabetic code : max size is 3" userInfo:nil];
        }
        ASN1Encodable *encodable = [[DERPrintableString alloc] initParamString:paramString];
        self.obj = encodable;
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BOOL)isAlphabetic {
    return [self.obj isKindOfClass:[DERPrintableString class]];
}

- (NSString *)getAlphabetic {
    return [((DERPrintableString *)self.obj) getString];
}

- (int)getNumeric {
    return [[((ASN1Integer *)self.obj) getValue] intValue];
}

- (ASN1Primitive *)toASN1Primitive {
    return [self.obj toASN1Primitive];
}

@end
