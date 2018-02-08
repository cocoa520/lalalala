//
//  Pfx.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Pfx.h"
#import "ASN1Sequence.h"
#import "BERSequence.h"
#import "ASN1Integer.h"

@interface Pfx ()

@property (nonatomic, readwrite, retain) ContentInfoPKCS *contentInfo;
@property (nonatomic, readwrite, retain) MacData *macData;

@end

@implementation Pfx
@synthesize contentInfo = _contentInfo;
@synthesize macData = _macData;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_contentInfo) {
        [_contentInfo release];
        _contentInfo = nil;
    }
    if (_macData) {
        [_macData release];
        _macData = nil;
    }
    [super dealloc];
#endif
}

+ (Pfx *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[Pfx class]]) {
        return (Pfx *)paramObject;
    }
    if (paramObject) {
        return [[[Pfx alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        BigInteger *localBigInteger = [(ASN1Integer *)[paramASN1Sequence getObjectAt:0] getValue];
        if ([localBigInteger intValue] != 3) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"wrong version for PFX PDU" userInfo:nil];
        }
        self.contentInfo = [ContentInfoPKCS getInstance:[paramASN1Sequence getObjectAt:1]];
        if ([paramASN1Sequence size] == 3) {
            self.macData = [MacData getInstance:[paramASN1Sequence getObjectAt:2]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamContentInfo:(ContentInfoPKCS *)paramContentInfo paramMacData:(MacData *)paramMacData
{
    if (self = [super init]) {
        self.contentInfo = paramContentInfo;
        self.macData = paramMacData;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ContentInfoPKCS *)getAuthSafe {
    return self.contentInfo;
}

- (MacData *)getMacData {
    return self.macData;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    ASN1Encodable *encodable = [[ASN1Integer alloc] initLong:3];
    [localASN1EncodableVector add:encodable];
    [localASN1EncodableVector add:self.contentInfo];
    if (self.macData) {
        [localASN1EncodableVector add:self.macData];
    }
    ASN1Primitive *primitive = [[[BERSequence alloc] initBERParamASn1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (encodable) [encodable release]; encodable = nil;
#endif
    return primitive;
}

@end
