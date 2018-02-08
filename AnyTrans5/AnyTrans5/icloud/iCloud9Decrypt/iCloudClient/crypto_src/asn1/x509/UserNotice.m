//
//  UserNotice.m
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "UserNotice.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface UserNotice ()

@property (nonatomic, readwrite, retain) NoticeReference *noticeRef;
@property (nonatomic, readwrite, retain) DisplayText *explicitText;

@end

@implementation UserNotice
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

+ (UserNotice *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[UserNotice class]]) {
        return (UserNotice *)paramObject;
    }
    if (paramObject) {
        return [[[UserNotice alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] == 2) {
            self.noticeRef = [NoticeReference getInstance:[paramASN1Sequence getObjectAt:0]];
            self.explicitText = [DisplayText getInstance:[paramASN1Sequence getObjectAt:1]];
        }else if ([paramASN1Sequence size] == 1) {
            if ([[[paramASN1Sequence getObjectAt:0] toASN1Primitive] isKindOfClass:[ASN1Sequence class]]) {
                self.noticeRef = [NoticeReference getInstance:[paramASN1Sequence getObjectAt:0]];
            }else {
                self.explicitText = [DisplayText getInstance:[paramASN1Sequence getObjectAt:0]];
            }
        }else {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamNoticeReference:(NoticeReference *)paramNoticeReference paramString:(NSString *)paramString
{
    if (self = [super init]) {
        DisplayText *text = [[DisplayText alloc] initParamString:paramString];
        [self initParamNoticeReference:paramNoticeReference paramDisplayText:text];
#if !__has_feature(objc_arc)
    if (text) [text release]; text = nil;
#endif
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
