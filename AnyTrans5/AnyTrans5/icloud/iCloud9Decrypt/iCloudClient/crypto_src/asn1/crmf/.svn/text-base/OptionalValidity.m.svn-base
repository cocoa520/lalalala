//
//  OptionalValidity.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OptionalValidity.h"
#import "ASN1Sequence.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface OptionalValidity ()

@property (nonatomic, readwrite, retain) Time *notBefore;
@property (nonatomic, readwrite, retain) Time *notAfter;

@end

@implementation OptionalValidity
@synthesize notBefore = _notBefore;
@synthesize notAfter = _notAfter;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_notBefore) {
        [_notBefore release];
        _notBefore = nil;
    }
    if (_notAfter) {
        [_notAfter release];
        _notAfter = nil;
    }
    [super dealloc];
#endif
}

+ (OptionalValidity *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OptionalValidity class]]) {
        return (OptionalValidity *)paramObject;
    }
    if (paramObject) {
        return [[[OptionalValidity alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        ASN1TaggedObject *localASN1TaggedObject = nil;
        while (localASN1TaggedObject = [localEnumeration nextObject]) {
            if ([localASN1TaggedObject getTagNo] == 0) {
                self.notBefore = [Time getInstance:localASN1TaggedObject paramBoolean:YES];
            }else {
                self.notAfter = [Time getInstance:localASN1TaggedObject paramBoolean:YES];
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

- (instancetype)initParamTime1:(Time *)paramTime1 paramTime2:(Time *)paramTime2
{
    if (self = [super init]) {
        if (!paramTime1 && !paramTime2) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"at least one of notBefore/notAfter must not be null." userInfo:nil];
        }
        self.notBefore = paramTime1;
        self.notAfter = paramTime2;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (Time *)getNotBefore {
    return self.notBefore;
}

- (Time *)getNotAfter {
    return self.notAfter;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.notBefore) {
        ASN1Encodable *beforeEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.notBefore];
        [localASN1EncodableVector add:beforeEncodable];
#if !__has_feature(objc_arc)
        if (beforeEncodable) [beforeEncodable release]; beforeEncodable = nil;
#endif
    }
    if (self.notAfter) {
        ASN1Encodable *afterEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:self.notAfter];
        [localASN1EncodableVector add:afterEncodable];
#if !__has_feature(objc_arc)
        if (afterEncodable) [afterEncodable release]; afterEncodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
