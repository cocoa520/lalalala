//
//  CrlID.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CrlID.h"
#import "ASN1Sequence.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface CrlID ()

@property (nonatomic, readwrite, retain) DERIA5String *crlUrl;
@property (nonatomic, readwrite, retain) ASN1Integer *crlNum;
@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *crlTime;

@end

@implementation CrlID
@synthesize crlUrl = _crlUrl;
@synthesize crlNum = _crlNum;
@synthesize crlTime = _crlTime;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_crlUrl) {
        [_crlUrl release];
        _crlUrl = nil;
    }
    if (_crlNum) {
        [_crlNum release];
        _crlNum = nil;
    }
    if (_crlTime) {
        [_crlTime release];
        _crlTime = nil;
    }
    [super dealloc];
#endif
}

+ (CrlID *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CrlID class]]) {
        return (CrlID *)paramObject;
    }
    if (paramObject) {
        return [[[CrlID alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        ASN1TaggedObject *localASN1TaggedObject = nil;
        while (localASN1TaggedObject = [localEnumeration nextObject]) {
            switch ([localASN1TaggedObject getTagNo]) {
                case 0:
                    self.crlUrl = [DERIA5String getInstance:localASN1TaggedObject paramBoolean:TRUE];
                    break;
                case 1:
                    self.crlNum = [ASN1Integer getInstance:localASN1TaggedObject paramBoolean:TRUE];
                    break;
                case 2:
                    self.crlTime = [ASN1GeneralizedTime getInstance:localASN1TaggedObject paramBoolean:TRUE];
                    break;
                default:
                    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown tag number: %d", [localASN1TaggedObject getTagNo]] userInfo:nil];
                    break;
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

- (DERIA5String *)getCrlUrl {
    return self.crlUrl;
}

- (ASN1Integer *)getCrlNum {
    return self.crlNum;
}

- (ASN1GeneralizedTime *)getCrlTime {
    return self.crlTime;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.crlUrl) {
        ASN1Encodable *crlUrlEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.crlUrl];
        [localASN1EncodableVector add:crlUrlEncodable];
#if !__has_feature(objc_arc)
        if (crlUrlEncodable) [crlUrlEncodable release]; crlUrlEncodable = nil;
#endif
    }
    if (self.crlNum) {
        ASN1Encodable *crlNumEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:self.crlNum];
        [localASN1EncodableVector add:crlNumEncodable];
#if !__has_feature(objc_arc)
        if (crlNumEncodable) [crlNumEncodable release]; crlNumEncodable = nil;
#endif
    }
    if (self.crlTime) {
        ASN1Encodable *crlTimeEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:2 paramASN1Encodable:self.crlTime];
        [localASN1EncodableVector add:crlTimeEncodable];
#if !__has_feature(objc_arc)
        if (crlTimeEncodable) [crlTimeEncodable release]; crlTimeEncodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
