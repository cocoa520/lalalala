//
//  DVCSTime.m
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DVCSTime.h"

@interface DVCSTime ()

@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *genTime;
@property (nonatomic, readwrite, retain) ContentInfo *timeStampToken;
@property (nonatomic, readwrite, retain) NSDate *time;

@end

@implementation DVCSTime
@synthesize genTime = _genTime;
@synthesize timeStampToken = _timeStampToken;
@synthesize time = _time;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_genTime) {
        [_genTime release];
        _genTime = nil;
    }
    if (_timeStampToken) {
        [_timeStampToken release];
        _timeStampToken = nil;
    }
    if (_time) {
        [_time release];
        _time = nil;
    }
    [super dealloc];
#endif
}

+ (DVCSTime *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[DVCSTime class]]) {
        return (DVCSTime *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1GeneralizedTime class]]) {
        return [[[DVCSTime alloc] initParamASN1GeneralizedTime:[ASN1GeneralizedTime getInstance:paramObject]] autorelease];
    }
    if (paramObject) {
        return [[[DVCSTime alloc] initParamContentInfo:[ContentInfo getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (DVCSTime *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [DVCSTime getInstance:[paramASN1TaggedObject getObject]];
}

- (instancetype)initParamDate:(NSDate *)paramDate
{
    if (self = [super init]) {
        ASN1GeneralizedTime *time = [[ASN1GeneralizedTime alloc] initParamDate:paramDate];
        [self initParamASN1GeneralizedTime:time];
#if !__has_feature(objc_arc)
    if (time) [time release]; time = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime
{
    if (self = [super init]) {
        self.genTime = paramASN1GeneralizedTime;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamContentInfo:(ContentInfo *)paramContentInfo
{
    if (self = [super init]) {
        self.timeStampToken = paramContentInfo;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (ASN1GeneralizedTime *)getGenTime {
    return self.genTime;
}

- (ContentInfo *)getTimeStampToken {
    return self.timeStampToken;
}

- (ASN1Primitive *)toASN1Primitive {
    if (self.genTime) {
        return self.genTime;
    }
    if (self.timeStampToken) {
        return [self.timeStampToken toASN1Primitive];
    }
    return nil;
}

- (NSString *)toString {
    if (self.genTime) {
        return [NSString stringWithFormat:@"%@", self.genTime];
    }
    if (self.timeStampToken) {
        return [NSString stringWithFormat:@"%@", self.timeStampToken];
    }
    return nil;
}

@end
