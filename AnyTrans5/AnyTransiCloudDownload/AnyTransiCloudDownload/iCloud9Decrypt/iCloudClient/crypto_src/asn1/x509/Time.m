//
//  Time.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Time.h"
#import "ASN1UTCTime.h"
#import "ASN1GeneralizedTime.h"

@implementation Time
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

+ (Time *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[Time class]]) {
        return (Time *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1UTCTime class]]) {
        return [[[Time alloc] initParamASN1Primitive:(ASN1UTCTime *)paramObject] autorelease];
    }
    if ([paramObject isKindOfClass:[ASN1GeneralizedTime class]]) {
        return [[[Time alloc] initParamASN1Primitive:(ASN1GeneralizedTime *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown object in factory: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (Time *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [Time getInstance:[paramASN1TaggedObject getObject]];
}

- (instancetype)initParamASN1Primitive:(ASN1Primitive *)paramASN1Primitive
{
    if (self = [super init]) {
        if (![paramASN1Primitive isKindOfClass:[ASN1UTCTime class]] && ![paramASN1Primitive isKindOfClass:[ASN1GeneralizedTime class]]) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"unknown object passed to Time" userInfo:nil];
        }
        self.time = paramASN1Primitive;
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
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (NSString *)getTime {
    if ([self.time isKindOfClass:[ASN1UTCTime class]]) {
        return [((ASN1UTCTime *)self.time) getAdjustedTime];
    }
    return [((ASN1GeneralizedTime *)self.time) getTime];
}

- (NSDate *)getDate {
    @try {
        if ([self.time isKindOfClass:[ASN1UTCTime class]]) {
            return [((ASN1UTCTime *)self.time) getAdjustedDate];
        }
        return [((ASN1GeneralizedTime *)self.time) getDate];
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"invalid date string: %@", exception.description] userInfo:nil];
    }
}

- (ASN1Primitive *)toASN1Primitive {
    return self.time;
}

- (NSString *)toString {
    return [self getTime];
}

@end
