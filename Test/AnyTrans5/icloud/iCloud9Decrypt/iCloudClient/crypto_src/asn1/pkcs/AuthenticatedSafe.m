//
//  AuthenticatedSafe.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "AuthenticatedSafe.h"
#import "ASN1Sequence.h"
#import "BERSequence.h"
#import "DLSequence.h"
#import "ContentInfo.h"

@interface AuthenticatedSafe ()

@property (nonatomic, readwrite, retain) NSMutableArray *info;
@property (nonatomic, assign) BOOL isBer;

@end

@implementation AuthenticatedSafe
@synthesize info = _info;
@synthesize isBer = _isBer;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_info) {
        [_info release];
        _info = nil;
    }
    [super dealloc];
#endif
}

- (void)setIsBer:(BOOL)isBer {
    if (_isBer != isBer) {
        _isBer = TRUE;
    }
}

+ (AuthenticatedSafe *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[AuthenticatedSafe class]]) {
        return (AuthenticatedSafe *)paramObject;
    }
    if (paramObject) {
        return [[[AuthenticatedSafe alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSMutableArray *infoAry = [[NSMutableArray alloc] initWithSize:(int)[paramASN1Sequence size]];
        self.info = infoAry;
#if !__has_feature(objc_arc)
    if (infoAry) [infoAry release]; infoAry = nil;
#endif
        
        for (int i = 0; i != self.info.count; i++) {
            self.info[i] = [ContentInfo getInstance:[paramASN1Sequence getObjectAt:i]];
        }
        self.isBer = [paramASN1Sequence isKindOfClass:[BERSequence class]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfContentInfo:(NSMutableArray *)paramArrayOfContentInfo
{
    if (self = [super init]) {
        self.info = paramArrayOfContentInfo;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableArray *)getContentInfo {
    return self.info;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    for (int i = 0; i != self.info.count; i++) {
        [localASN1EncodableVector add:self.info[i]];
    }
    if (self.isBer) {
        ASN1Primitive *primitive = [[[BERSequence alloc] initBERParamASn1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
        if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
        return primitive;
    }
    ASN1Primitive *primitive = [[[DLSequence alloc] initDLParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
