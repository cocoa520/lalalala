//
//  Accuracy.m
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Accuracy.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@implementation Accuracy
@synthesize seconds = _seconds;
@synthesize millis = _millis;
@synthesize micros = _micros;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_seconds) {
        [_seconds release];
        _seconds = nil;
    }
    if (_millis) {
        [_millis release];
        _millis = nil;
    }
    if (_micros) {
        [_micros release];
        _micros = nil;
    }
    [super dealloc];
#endif
}

+ (int)MIN_MILLIS {
    static int _MIN_MILLIS = 0;
    @synchronized(self) {
        if (!_MIN_MILLIS) {
            _MIN_MILLIS = 1;
        }
    }
    return _MIN_MILLIS;
}

+ (int)MAX_MILLIS {
    static int _MAX_MILLIS = 0;
    @synchronized(self) {
        if (!_MAX_MILLIS) {
            _MAX_MILLIS = 999;
        }
    }
    return _MAX_MILLIS;
}

+ (int)MIN_MICROS {
    static int _MIN_MICROS = 0;
    @synchronized(self) {
        if (!_MIN_MICROS) {
            _MIN_MICROS = 1;
        }
    }
    return _MIN_MICROS;
}

+ (int)MAX_MICROS {
    static int _MAX_MICROS = 0;
    @synchronized(self) {
        if (!_MAX_MICROS) {
            _MAX_MICROS = 999;
        }
    }
    return _MAX_MICROS;
}

+ (Accuracy *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[Accuracy class]]) {
        return (Accuracy *)paramObject;
    }
    if (paramObject) {
        return [[[Accuracy alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
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
        self.seconds = nil;
        self.millis = nil;
        self.micros = nil;
        for (int i = 0; i < [paramASN1Sequence size]; i++) {
            if ([[paramASN1Sequence getObjectAt:1] isKindOfClass:[ASN1Integer class]]) {
                self.seconds = (ASN1Integer *)[paramASN1Sequence getObjectAt:i];
            }else if ([[paramASN1Sequence getObjectAt:i] isKindOfClass:[DERTaggedObject class]]) {
                DERTaggedObject *localDERTaggedObject = (DERTaggedObject *)[paramASN1Sequence getObjectAt:i];
                switch ([localDERTaggedObject getTagNo]) {
                    case 0: {
                        self.millis = [ASN1Integer getInstance:localDERTaggedObject paramBoolean:false];
                        if (([[self.millis getValue] intValue] < 1) || ([[self.millis getValue] intValue] > 999)) {
                            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid millis field : not in (1..999)." userInfo:nil];
                        }
                    }
                        break;
                    case 1: {
                        self.micros = [ASN1Integer getInstance:localDERTaggedObject paramBoolean:false];
                        if (([[self.micros getValue] intValue] < 1) || ([[self.micros getValue] intValue] > 999)) {
                            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid micros field : not in (1..999)." userInfo:nil];
                        }
                    }
                        break;
                    default:
                        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalig tag number" userInfo:nil];
                        break;
                }
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

- (instancetype)initParamASN1Integer1:(ASN1Integer *)paramASN1Integer1 paramASN1Integer2:(ASN1Integer *)paramASN1Integer2 paramASN1Integer3:(ASN1Integer *)paramASN1Integer3
{
    if (self = [super init]) {
        self.seconds = paramASN1Integer1;
        if (paramASN1Integer2 && (([[paramASN1Integer2 getValue] intValue] < 1) || ([[paramASN1Integer2 getValue] intValue] > 999))) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid millis field : not in (1..999)" userInfo:nil];
        }
        self.millis = paramASN1Integer2;
        if (paramASN1Integer3 && (([[paramASN1Integer3 getValue] intValue] < 1) || ([[paramASN1Integer3 getValue] intValue] > 999))) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid micros field : not in (1..999)" userInfo:nil];
        }
        self.micros = paramASN1Integer3;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Integer *)getSeconds {
    return self.seconds;
}

- (ASN1Integer *)getMillis {
    return self.millis;
}

- (ASN1Integer *)getMicros {
    return self.micros;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.seconds) {
        [localASN1EncodableVector add:self.seconds];
    }
    if (self.millis) {
        ASN1Encodable *millesEncodable = [[DERTaggedObject alloc] initParamBoolean:false paramInt:0 paramASN1Encodable:self.millis];
        [localASN1EncodableVector add:millesEncodable];
#if !__has_feature(objc_arc)
        if (millesEncodable) [millesEncodable release]; millesEncodable = nil;
#endif
    }
    if (self.micros) {
        ASN1Encodable *microsEncodable = [[DERTaggedObject alloc] initParamBoolean:false paramInt:1 paramASN1Encodable:self.micros];
        [localASN1EncodableVector add:microsEncodable];
#if !__has_feature(objc_arc)
        if (microsEncodable) [microsEncodable release]; microsEncodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
