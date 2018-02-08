//
//  PackedDate.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PackedDate.h"
#import "Arrays.h"
#import "CategoryExtend.h"

@interface PackedDate ()

@property (nonatomic, readwrite, retain) NSMutableData *time;

@end

@implementation PackedDate
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

- (instancetype)initParamString:(NSString *)paramString
{
    self = [super init];
    if (self) {
        self.time = [self convert:paramString];
    }
    return self;
}

- (instancetype)initParamDate:(NSDate *)paramDate
{
    self = [super init];
    if (self) {
        NSDateFormatter *localSimpleDateFormat = [[[NSDateFormatter alloc] init] autorelease];
        [localSimpleDateFormat setDateFormat:@"yyMMdd'Z'"];
        self.time = [self convert:[localSimpleDateFormat stringFromDate:paramDate]];
    }
    return self;
}

- (instancetype)initParamDate:(NSDate *)paramDate paramLocale:(NSLocale *)paramLocale
{
    self = [super init];
    if (self) {
        NSDateFormatter *localSimpleDateFormat = [[[NSDateFormatter alloc] init] autorelease];
        [localSimpleDateFormat setDateFormat:@"yyMMdd'Z'"];
        [localSimpleDateFormat setLocale:paramLocale];
        self.time = [self convert:[localSimpleDateFormat stringFromDate:paramDate]];
    }
    return self;
}

- (NSMutableData *)convert:(NSString *)paramString {
//    NSMutableData *data = [[paramString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
//    [Arrays copyOfWithData:data withNewLength:(int)[data length]];
    NSMutableData *arrayOfByte = [[[NSMutableData alloc] initWithSize:6] autorelease];
    for (int i = 0; i != 6; i++) {
    }
    return arrayOfByte;
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    self = [super init];
    if (self) {
        self.time = paramArrayOfByte;
    }
    return self;
}

- (NSDate *)getDate {
    NSDateFormatter *localSimpleDateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [localSimpleDateFormat setDateFormat:@"yyyyMMdd"];
    return [localSimpleDateFormat dateFromString:[NSString stringWithFormat:@"20%@", [self toString]]];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[PackedDate class]]) {
        return NO;
    }
    PackedDate *localPackedDate = (PackedDate *)object;
    return [Arrays areEqualWithByteArray:self.time withB:localPackedDate.time];
}

- (NSString *)toString {
    NSMutableString *arrayOfChar = [[[NSMutableString alloc] initWithCapacity:[self.time length]] autorelease];
    for (int i = 0; i != arrayOfChar.length; i++) {
    }
    return [[[NSString alloc] initWithString:arrayOfChar] autorelease];
}

- (NSMutableData *)getEncoding {
    return self.time;
}

- (NSUInteger)hash {
    return [Arrays getHashCodeWithByteArray:self.time];
}

@end
