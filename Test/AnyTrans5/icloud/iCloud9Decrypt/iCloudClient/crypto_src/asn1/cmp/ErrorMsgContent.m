//
//  ErrorMsgContent.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ErrorMsgContent.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface ErrorMsgContent ()

@property (nonatomic, readwrite, retain) PKIStatusInfo *pkiStatusInfo;
@property (nonatomic, readwrite, retain) ASN1Integer *errorCode;
@property (nonatomic, readwrite, retain) PKIFreeText *errorDetails;

@end

@implementation ErrorMsgContent
@synthesize pkiStatusInfo = _pkiStatusInfo;
@synthesize errorCode = _errorCode;
@synthesize errorDetails = _errorDetails;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_pkiStatusInfo) {
        [_pkiStatusInfo release];
        _pkiStatusInfo = nil;
    }
    if (_errorCode) {
        [_errorCode release];
        _errorCode = nil;
    }
    if (_errorDetails) {
        [_errorDetails release];
        _errorDetails = nil;
    }
    [super dealloc];
#endif
}

+ (ErrorMsgContent *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ErrorMsgContent class]]) {
        return (ErrorMsgContent *)paramObject;
    }
    if (paramObject) {
        return [[[ErrorMsgContent alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.pkiStatusInfo = [PKIStatusInfo getInstance:[localEnumeration nextObject]];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            if ([localObject isKindOfClass:[ASN1Integer class]]) {
                self.errorCode = [ASN1Integer getInstance:localObject];
            }else {
                self.errorDetails = [PKIFreeText getInstance:localObject];
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

- (instancetype)initParamPKIStatusInfo:(PKIStatusInfo *)paramPKIStatusInfo
{
    if (self = [super init]) {
        [self initParamPKIStatusInfo:paramPKIStatusInfo paramASN1Integer:nil paramPKIFreeText:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamPKIStatusInfo:(PKIStatusInfo *)paramPKIStatusInfo paramASN1Integer:(ASN1Integer *)paramASN1Integer paramPKIFreeText:(PKIFreeText *)paramPKIFreeText
{
    if (self = [super init]) {
        if (!paramPKIStatusInfo) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"'pkiStatusInfo' cannot be null" userInfo:nil];
        }
        self.pkiStatusInfo = paramPKIStatusInfo;
        self.errorCode = paramASN1Integer;
        self.errorDetails = paramPKIFreeText;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (PKIStatusInfo *)getPKIStatusInfo {
    return self.pkiStatusInfo;
}

- (ASN1Integer *)getErrorCode {
    return self.errorCode;
}

- (PKIFreeText *)getErrorDetails {
    return self.errorDetails;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.pkiStatusInfo];
    [self addOptional:localASN1EncodableVector paramASN1Encodable:self.errorCode];
    [self addOptional:localASN1EncodableVector paramASN1Encodable:self.errorDetails];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (void)addOptional:(ASN1EncodableVector *)paramASN1EncodableVector paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable {
    if (paramASN1Encodable) {
        [paramASN1EncodableVector add:paramASN1Encodable];
    }
}

@end
