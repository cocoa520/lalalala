//
//  ASN1UTCTime.m
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1UTCTime.h"
#import "StringsEx.h"
#import "Arrays.h"
#import "StreamUtil.h"
#import "ASN1OctetString.h"

@interface ASN1UTCTime ()

@property (nonatomic, readwrite, retain) NSMutableData *time;

@end

@implementation ASN1UTCTime
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

+ (ASN1UTCTime *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[ASN1UTCTime class]]) {
        return (ASN1UTCTime *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return (ASN1UTCTime *)[self fromByteArray:(NSMutableData *)paramObject];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"encoding error in getInstance: %@", exception.description] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (ASN1UTCTime *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localASN1Primitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localASN1Primitive isKindOfClass:[ASN1UTCTime class]]) {
        return [ASN1UTCTime getInstance:localASN1Primitive];
    }
    return [[[ASN1UTCTime alloc] initParamArrayOfByte:[((ASN1OctetString *)localASN1Primitive) getOctets]] autorelease];
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
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"invalid date string: %@", exception.description] userInfo:nil];
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
        [localSimpleDateFormat setDateFormat:@"yyMMddHHmmss'Z'"];
        [localSimpleDateFormat setTimeZone:[[NSTimeZone alloc] initWithName:@"Z" data:0]];
        @autoreleasepool {
            self.time = [StringsEx toByteArrayWithString:[localSimpleDateFormat stringFromDate:paramDate]];
        }
#if !__has_feature(objc_arc)
    if (localSimpleDateFormat) [localSimpleDateFormat release]; localSimpleDateFormat = nil;
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
        [localSimpleDateFormat setDateFormat:@"yyMMddHHmmss'Z'"];
        [localSimpleDateFormat setLocale:paramLocale];
        [localSimpleDateFormat setTimeZone:[[NSTimeZone alloc] initWithName:@"Z" data:0]];
        @autoreleasepool {
            self.time = [StringsEx toByteArrayWithString:[localSimpleDateFormat stringFromDate:paramDate]];
        }
#if !__has_feature(objc_arc)
        if (localSimpleDateFormat) [localSimpleDateFormat release]; localSimpleDateFormat = nil;
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

- (NSDate *)getDate {
    NSDateFormatter *localSimpleDateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [localSimpleDateFormat setDateFormat:@"yyMMddHHmmssz"];
    return [localSimpleDateFormat dateFromString:[self getTime]];
}

- (NSDate *)getAdjustedDate {
    NSDateFormatter *localSimpleDateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [localSimpleDateFormat setDateFormat:@"yyyyMMddHHmmssz"];
    [localSimpleDateFormat setTimeZone:[[NSTimeZone alloc] initWithName:@"Z" data:0]];
    return [localSimpleDateFormat dateFromString:[self getAdjustedTime]];
}

- (NSString *)getTime {
    NSString *str1 = [StringsEx fromByteArray:self.time];
    if (((int)[str1 rangeOfString:@"-"].location < 0) && ((int)[str1 rangeOfString:@"+"].location < 0)) {
        if (str1.length == 11) {
            return [NSString stringWithFormat:@"%@00GMT+00:00", [str1 substringWithRange:NSMakeRange(0, 10)]];
        }
        return [NSString stringWithFormat:@"%@GMT+00:00", [str1 substringWithRange:NSMakeRange(0, 12)]];
    }
    int i = (int)[str1 rangeOfString:@"-"].location;
    if (i < 0) {
        i = (int)[str1 rangeOfString:@"+"].location;
    }
    NSString *str2 = str1;
    if (i == str1.length - 3) {
        str2 = [NSString stringWithFormat:@"%@00", str2];
    }
    if (i == 10) {
        return [NSString stringWithFormat:@"%@00GMT%@:%@", [str2 substringWithRange:NSMakeRange(0, 10)], [str2 substringWithRange:NSMakeRange(10, 3)], [str2 substringWithRange:NSMakeRange(13, 2)]];
    }
    return [NSString stringWithFormat:@"%@GMT%@:%@", [str2 substringWithRange:NSMakeRange(0, 12)], [str2 substringWithRange:NSMakeRange(12, 3)], [str2 substringWithRange:NSMakeRange(15, 2)]];
}

- (NSString *)getAdjustedTime {
    NSString *str = [self getTime];
    if ([str characterAtIndex:0] < '5') {
        return [NSString stringWithFormat:@"20%@", str];
    }
    return [NSString stringWithFormat:@"19%@", str];
}

- (BOOL)isConstructed {
    return NO;
}

- (int)encodedLength {
    int i = (int)[self.time length];
    return 1 + [StreamUtil calculateBodyLength:i] + i;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    [paramASN1OutputStream write:23];
    int i = (int)[self.time length];
    [paramASN1OutputStream writeLength:i];
    for (int j = 0; j != i; j++) {
        [paramASN1OutputStream write:((Byte *)[self.time bytes])[j]];
    }
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[ASN1UTCTime class]]) {
        return NO;
    }
    return [Arrays areEqualWithByteArray:self.time withB:[((ASN1UTCTime *)paramASN1Primitive) time]];
}

- (NSString *)toString {
    return [StringsEx fromByteArray:self.time];
}

- (NSUInteger)hash {
    return [Arrays getHashCodeWithByteArray:self.time];
}

@end
