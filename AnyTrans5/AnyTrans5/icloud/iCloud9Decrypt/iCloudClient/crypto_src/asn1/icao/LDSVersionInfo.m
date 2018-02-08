//
//  LDSVersionInfo.m
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "LDSVersionInfo.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface LDSVersionInfo ()

@property (nonatomic, readwrite, retain) DERPrintableString *ldsVersion;
@property (nonatomic, readwrite, retain) DERPrintableString *unicodeVersion;

@end

@implementation LDSVersionInfo
@synthesize ldsVersion = _ldsVersion;
@synthesize unicodeVersion = _unicodeVersion;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_ldsVersion) {
        [_ldsVersion release];
        _ldsVersion = nil;
    }
    if (_unicodeVersion) {
        [_unicodeVersion release];
        _unicodeVersion = nil;
    }
    [super dealloc];
#endif
}

+ (LDSVersionInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[LDSVersionInfo class]]) {
        return (LDSVersionInfo *)paramObject;
    }
    if (paramObject) {
        return [[[LDSVersionInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamString1:(NSString *)paramString1 paramString2:(NSString *)paramString2
{
    if (self = [super init]) {
        DERPrintableString *idsV = [[DERPrintableString alloc] initParamString:paramString1];
        DERPrintableString *unicodeV = [[DERPrintableString alloc] initParamString:paramString2];
        self.ldsVersion = idsV;
        self.unicodeVersion = unicodeV;
#if !__has_feature(objc_arc)
    if (idsV) [idsV release]; idsV = nil;
    if (unicodeV) [unicodeV release]; unicodeV = nil;
#endif
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
        if ([paramASN1Sequence size] != 2) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"sequence wrong size for LDSVersionInfo" userInfo:nil];
        }
        self.ldsVersion = [DERPrintableString getInstance:[paramASN1Sequence getObjectAt:0]];
        self.unicodeVersion = [DERPrintableString getInstance:[paramASN1Sequence getObjectAt:1]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSString *)getLdsVersion {
    return self.ldsVersion.getString;
}

- (NSString *)getUnicodeVersion {
    return self.unicodeVersion.getString;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.ldsVersion];
    [localASN1EncodableVector add:self.unicodeVersion];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
