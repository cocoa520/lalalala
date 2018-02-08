//
//  SPUserNotice.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SPUserNotice.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface SPUserNotice ()

@property (nonatomic, readwrite, retain) NoticeReference *noticeRef;
@property (nonatomic, readwrite, retain) DisplayText *explicitText;

@end

@implementation SPUserNotice
@synthesize noticeRef = _noticeRef;
@synthesize explicitText = _explicitText;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_noticeRef) {
        [_noticeRef release];
        _noticeRef = nil;
    }
    if (_explicitText) {
        [_explicitText release];
        _explicitText = nil;
    }
    [super dealloc];
#endif
}

+ (SPUserNotice *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[SPUserNotice class]]) {
        return (SPUserNotice *)paramObject;
    }
    if (paramObject) {
        return [[[SPUserNotice alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        ASN1Encodable *localASN1Encodable = nil;
        while (localASN1Encodable = [localEnumeration nextObject]) {
            if ([localASN1Encodable isKindOfClass:[DisplayText class]] || [localASN1Encodable isKindOfClass:[ASN1String class]]) {
                self.explicitText = [DisplayText getInstance:localASN1Encodable];
            }else if ([localASN1Encodable isKindOfClass:[NoticeReference class]] || [localASN1Encodable isKindOfClass:[ASN1Sequence class]]) {
                self.noticeRef = [NoticeReference getInstance:localASN1Encodable];
            }else {
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"%s", object_getClassName(localASN1Encodable)] userInfo:nil];
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

- (instancetype)initParamNoticeReference:(NoticeReference *)paramNoticeReference paramDisplayText:(DisplayText *)paramDisplayText
{
    if (self = [super init]) {
        self.noticeRef = paramNoticeReference;
        self.explicitText = paramDisplayText;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NoticeReference *)getNoticeRef {
    return self.noticeRef;
}

- (DisplayText *)getExplicitText {
    return self.explicitText;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.noticeRef) {
        [localASN1EncodableVector add:self.noticeRef];
    }
    if (self.explicitText) {
        [localASN1EncodableVector add:self.explicitText];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
