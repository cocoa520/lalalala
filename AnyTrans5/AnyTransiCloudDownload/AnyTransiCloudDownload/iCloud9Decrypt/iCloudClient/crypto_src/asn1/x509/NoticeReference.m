//
//  NoticeReference.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "NoticeReference.h"
#import "ASN1Integer.h"
#import "DERSequence.h"

@interface NoticeReference ()

@property (nonatomic, readwrite, retain) DisplayText *organization;
@property (nonatomic, readwrite, retain) ASN1Sequence *noticeNumbers;

@end

@implementation NoticeReference
@synthesize organization = _organization;
@synthesize noticeNumbers = _noticeNumbers;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_organization) {
        [_organization release];
        _organization = nil;
    }
    if (_noticeNumbers) {
        [_noticeNumbers release];
        _noticeNumbers = nil;
    }
    [super dealloc];
#endif
}

+ (NoticeReference *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[NoticeReference class]]) {
        return (NoticeReference *)paramObject;
    }
    if (paramObject) {
        return [[[NoticeReference alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (ASN1EncodableVector *)convertVector:(NSMutableArray *)paramVector {
    ASN1EncodableVector *localASN1EncodableVector = [[[ASN1EncodableVector alloc] init] autorelease];
    NSEnumerator *localEnumeration = [paramVector objectEnumerator];
    id localObject = nil;
    while (localObject = [localEnumeration nextObject]) {
        ASN1Integer *localASN1Integer;
        if ([localObject isKindOfClass:[BigInteger class]]) {
            localASN1Integer = [[ASN1Integer alloc] initBI:(BigInteger *)localObject];
        }else if ([localObject isKindOfClass:[ASN1Integer class]]) {
#pragma mark -- Integer
        }else {
            @throw [NSException exceptionWithName:NSGenericException reason:@"" userInfo:nil];
        }
        [localASN1EncodableVector add:localASN1Integer];
#if !__has_feature(objc_arc)
        if (localASN1Integer) [localASN1Integer release]; localASN1Integer = nil;
#endif
    }
    return localASN1EncodableVector;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] != 2) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.organization = [DisplayText getInstance:[paramASN1Sequence getObjectAt:0]];
        self.noticeNumbers = [ASN1Sequence getInstance:[paramASN1Sequence getObjectAt:1]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString paramVector:(NSMutableArray *)paramVector
{
    if (self = [super init]) {
        [self initParamString:paramString paramASN1EncodableVector:[NoticeReference convertVector:paramVector]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString paramASN1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVector
{
    if (self = [super init]) {
        DisplayText *displayText = [[DisplayText alloc] initParamString:paramString];
        [self initpParamDisplayText:displayText paramASN1EncodableVector:paramASN1EncodableVector];
#if !__has_feature(objc_arc)
    if (displayText) [displayText release]; displayText = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initpParamDisplayText:(DisplayText *)paramDisplayText paramASN1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVector
{
    if (self = [super init]) {
        self.organization = paramDisplayText;
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:paramASN1EncodableVector];
        self.noticeNumbers = sequence;
#if !__has_feature(objc_arc)
    if (sequence) [sequence release]; sequence = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (DisplayText *)getOrganization {
    return self.organization;
}

- (NSMutableArray *)getNoticeNumbers {
    NSMutableArray *arrayOfASN1Integer = [[[NSMutableArray alloc] initWithSize:(int)[self.noticeNumbers size]] autorelease];
    for (int i = 0; i != [self.noticeNumbers size]; i++) {
        arrayOfASN1Integer[i] = [ASN1Integer getInstance:[self.noticeNumbers getObjectAt:i]];
    }
    return arrayOfASN1Integer;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.organization];
    [localASN1EncodableVector add:self.noticeNumbers];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
