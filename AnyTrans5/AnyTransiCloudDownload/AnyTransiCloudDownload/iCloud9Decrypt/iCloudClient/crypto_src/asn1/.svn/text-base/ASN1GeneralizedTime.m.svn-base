//
//  ASN1GeneralizedTime.m
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1GeneralizedTime.h"
#import "StringsEx.h"
#import "ASN1OctetString.h"
#import "StreamUtil.h"
#import "Arrays.h"

@interface ASN1GeneralizedTime ()

@property (nonatomic, readwrite, retain) NSMutableData *time;

@end

@implementation ASN1GeneralizedTime
@synthesize time = _time;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_time) {
        [_time release];
        _time = nil;
    }
    [super dealloc];
#endif
}

+ (ASN1GeneralizedTime *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[ASN1GeneralizedTime class]]) {
        return (ASN1GeneralizedTime *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return (ASN1GeneralizedTime *)([self fromByteArray:(NSMutableData *)paramObject]);
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"encoding error in getInstance: %@", [exception description]] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (ASN1GeneralizedTime *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localASN1Primitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localASN1Primitive isKindOfClass:[ASN1GeneralizedTime class]]) {
        return [ASN1GeneralizedTime getInstance:localASN1Primitive];
    }
    return [[[ASN1GeneralizedTime alloc] initParamArrayOfByte:[((ASN1OctetString *)localASN1Primitive) getOctets]] autorelease];
}

- (instancetype)initParamString:(NSString *)paramString
{
    if (self = [super init]) {
        @autoreleasepool {
            self.time = [StringsEx toByteArrayWithString:paramString];
        }
        @try {
            [self getDate];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"invalid date string: %@", [exception description]] userInfo:nil];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamDate:(NSDate *)paramDate
{
    if (self = [super init]) {
        NSDateFormatter *localSimpleDateFormat = [[NSDateFormatter alloc] init];
        [localSimpleDateFormat setDateFormat:@"yyyyMMddHHmmss'Z'"];
        NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Z" data:0];
        [localSimpleDateFormat setTimeZone:timeZone];
        @autoreleasepool {
            self.time = [StringsEx toByteArrayWithString:[NSString stringWithFormat:@"%@", [localSimpleDateFormat dateFormat]]];
        }
#if !__has_feature(objc_arc)
    if (localSimpleDateFormat) [localSimpleDateFormat release]; localSimpleDateFormat = nil;
    if (timeZone) [timeZone release]; timeZone = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamDate:(NSDate *)paramDate paramLocale:(NSLocale *)paramLocale
{
    if (self = [super init]) {
        NSDateFormatter *localSimpleDateFormat = [[NSDateFormatter alloc] init];
        [localSimpleDateFormat setDateFormat:@"yyyyMMddHHmmss'Z'"];
        NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Z" data:0];
        [localSimpleDateFormat setTimeZone:timeZone];
        @autoreleasepool {
            self.time = [StringsEx toByteArrayWithString:[NSString stringWithFormat:@"%@", [localSimpleDateFormat dateFormat]]];
        }
#if !__has_feature(objc_arc)
    if (localSimpleDateFormat) [localSimpleDateFormat release]; localSimpleDateFormat = nil;
    if (timeZone) [timeZone release]; timeZone = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        self.time = paramArrayOfByte;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSString *)getTimeString {
    return [StringsEx fromByteArray:self.time];
}

- (NSString *)getTime {
    NSString *str = [StringsEx fromByteArray:self.time];
    if ([str characterAtIndex:str.length - 1] == 'Z') {
        return [NSString stringWithFormat:@"%@GMT+00:00", [str substringWithRange:NSMakeRange(0, str.length - 1)]];
    }
    int i = (int)str.length - 5;
    int j = [str characterAtIndex:i];
    if ((j == 45) || (j == 43)) {
        return [NSString stringWithFormat:@"%@GMT%@:%@", [str substringWithRange:NSMakeRange(0, i)], [str substringWithRange:NSMakeRange(i, i + 3)], [str substringFromIndex:i + 3]];
    }
    i = (int)str.length - 3;
    j = [str characterAtIndex:i];
    if ((j == 45) || (j == 43)) {
        return [NSString stringWithFormat:@"%@GMT%@:00", [str substringWithRange:NSMakeRange(0, i)], [str substringFromIndex:i]];
    }
    return [NSString stringWithFormat:@"%@%@", str, [self calculateGMTOffset]];
}

- (NSString *)calculateGMTOffset {
    NSDate *date = [NSDate date];
    NSString *str = @"+";
    NSTimeZone *localTimeZone = [NSTimeZone defaultTimeZone];
    int i = (int)[localTimeZone secondsFromGMTForDate:date];
    if (i < 0) {
        str = @"-";
        i = -i;
    }
    int j = i / 3600000;
    int k = (i - j * 60 * 60 * 1000) / 60000;
    @try {
        if ([localTimeZone isDaylightSavingTime] && [localTimeZone isDaylightSavingTimeForDate:[self getDate]]) {
            j += ([str isEqualToString:@"+"] ? 1 : -1);
        }
    }
    @catch (NSException *exception) {
    }
    return [NSString stringWithFormat:@"GMT%@%@:%@", str, [self convert:j], [self convert:k]];
}

- (NSString *)convert:(int)paramInt {
    if (paramInt < 10) {
        return [NSString stringWithFormat:@"0%d", paramInt];
    }
    return [NSString stringWithFormat:@"%d", paramInt];
}

- (NSDate *)getDate {
    NSString *str1 = [StringsEx fromByteArray:self.time];
    NSString *str2 = str1;
    NSDateFormatter *localSimpleDateFormat;
    if ([str1 hasSuffix:@"Z"]) {
        if ([self hasFractionalSeconds]) {
            localSimpleDateFormat = [[NSDateFormatter alloc] initWithDateFormat:@"yyyyMMddHHmmss.SSS'Z'" allowNaturalLanguage:YES];
        }else {
            localSimpleDateFormat = [[NSDateFormatter alloc] initWithDateFormat:@"yyyyMMddHHmmss'Z''" allowNaturalLanguage:YES];
        }
        NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Z" data:0];
        [localSimpleDateFormat setTimeZone:timeZone];
#if !__has_feature(objc_arc)
        if (timeZone) [timeZone release]; timeZone = nil;
#endif
    }else if (([str1 rangeOfString:@"-"].location > 0) || ([str1 rangeOfString:@"+"].location > 0)) {
        str2 = [self getTime];
        if ([self hasFractionalSeconds]) {
            localSimpleDateFormat = [[NSDateFormatter alloc] initWithDateFormat:@"yyyyMMddHHmmss.SSSz" allowNaturalLanguage:YES];
        }else {
            localSimpleDateFormat = [[NSDateFormatter alloc] initWithDateFormat:@"yyyyMMddHHmmssz" allowNaturalLanguage:YES];
        }
        NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Z" data:0];
        [localSimpleDateFormat setTimeZone:timeZone];
#if !__has_feature(objc_arc)
        if (timeZone) [timeZone release]; timeZone = nil;
#endif
    }else {
        if ([self hasFractionalSeconds]) {
            localSimpleDateFormat = [[NSDateFormatter alloc] initWithDateFormat:@"yyyyMMddHHmmss.SSS" allowNaturalLanguage:YES];
        }else {
            localSimpleDateFormat = [[NSDateFormatter alloc] initWithDateFormat:@"yyyyMMddHHmmss" allowNaturalLanguage:YES];
        }
        NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:[NSString stringWithFormat:@"%@", [NSTimeZone defaultTimeZone]] data:0];
        [localSimpleDateFormat setTimeZone:timeZone];
#if !__has_feature(objc_arc)
        if (timeZone) [timeZone release]; timeZone = nil;
#endif
    }
    if ([self hasFractionalSeconds]) {
        NSString *str3 = [str2 substringToIndex:14];
        for (int i = 1; i < [str3 length]; i++) {
            int j = [str3 characterAtIndex:i];
            if ((j < 48) || (j > 57)) {
                break;
            }
            if (i - 1 > 3) {
                str3 = [NSString stringWithFormat:@"%@%@", [str3 substringWithRange:NSMakeRange(0, 4)], [str3 substringToIndex:i]];
                str2 = [NSString stringWithFormat:@"%@%@", [str2 substringWithRange:NSMakeRange(0, 14)], str3];
            }else if (i - 1 == 1) {
                str3 = [NSString stringWithFormat:@"%@00%@", [str3 substringWithRange:NSMakeRange(0, i)], [str3 substringToIndex:i]];
                str2 = [NSString stringWithFormat:@"%@%@", [str2 substringWithRange:NSMakeRange(0, 14)], str3];
            }else if (i - 1 == 2) {
                str3 = [NSString stringWithFormat:@"%@0%@", [str3 substringWithRange:NSMakeRange(0, i)], [str3 substringToIndex:i]];
                str2 = [NSString stringWithFormat:@"%@%@", [str2 substringWithRange:NSMakeRange(0, 14)], str3];
            }
        }
    }
    NSDate *date = [localSimpleDateFormat dateFromString:str2];
#if !__has_feature(objc_arc)
    if (localSimpleDateFormat) [localSimpleDateFormat release]; localSimpleDateFormat = nil;
#endif
    return date;
}

- (BOOL)hasFractionalSeconds {
    for (int i = 0; i != [self.time length]; i++) {
        if ((((Byte *)[self.time bytes])[i] == 46) && (i == 14)) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isConstructed {
    return NO;
}

- (int)encodedLength {
    int i = (int)[self.time length];
    return 1 + [StreamUtil calculateBodyLength:i] + i;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    [paramASN1OutputStream writeEncoded:24 paramArrayOfByte:self.time];
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[ASN1GeneralizedTime class]]) {
        return NO;
    }
    return [Arrays areEqualWithByteArray:self.time withB:[((ASN1GeneralizedTime *)paramASN1Primitive) time]];
}

- (NSUInteger)hash {
    return [Arrays getHashCodeWithByteArray:self.time];
}

@end
