//
//  RecipientInfo.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RecipientInfo.h"
#import "KeyTransRecipientInfo.h"
#import "ASN1Sequence.h"
#import "ASN1TaggedObject.h"
#import "DERTaggedObject.h"

@implementation RecipientInfo
@synthesize info = _info;

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

+ (RecipientInfo *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[RecipientInfo class]]) {
        return (RecipientInfo *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[RecipientInfo alloc] initParamASN1Primitive:(ASN1Sequence *)paramObject] autorelease];
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        return [[[RecipientInfo alloc] initParamASN1Primitive:(ASN1TaggedObject *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown object in factory: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamKeyTransRecipientInfo:(KeyTransRecipientInfo *)paramKeyTransRecipientInfo
{
    self = [super init];
    if (self) {
        self.info = paramKeyTransRecipientInfo;
    }
    return self;
}

- (instancetype)initParamKeyAgreeRecipientInfo:(KeyAgreeRecipientInfo *)paramKeyAgreeRecipientInfo
{
    self = [super init];
    if (self) {
        self.info = [[[DERTaggedObject alloc] initParamBoolean:false paramInt:1 paramASN1Encodable:paramKeyAgreeRecipientInfo] autorelease];
    }
    return self;
}

- (instancetype)initParamKEKRecipientInfo:(KEKRecipientInfo *)paramKEKRecipientInfo
{
    self = [super init];
    if (self) {
        self.info = [[[DERTaggedObject alloc] initParamBoolean:false paramInt:2 paramASN1Encodable:paramKEKRecipientInfo] autorelease];
    }
    return self;
}

- (instancetype)initParamPasswordRecipientInfo:(PasswordRecipientInfo *)paramPasswordRecipientInfo
{
    self = [super init];
    if (self) {
        self.info = [[[DERTaggedObject alloc] initParamBoolean:false paramInt:3 paramASN1Encodable:paramPasswordRecipientInfo] autorelease];
    }
    return self;
}

- (instancetype)initParamOtherRecipientInfo:(OtherRecipientInfo *)paramOtherRecipientInfo
{
    self = [super init];
    if (self) {
        self.info = [[[DERTaggedObject alloc] initParamBoolean:false paramInt:4 paramASN1Encodable:paramOtherRecipientInfo] autorelease];
    }
    return self;
}

- (instancetype)initParamASN1Primitive:(ASN1Primitive *)paramASN1Primitive
{
    self = [super init];
    if (self) {
        self.info = paramASN1Primitive;
    }
    return self;
}

- (ASN1Integer *)getVersion {
    if ([self.info isKindOfClass:[ASN1TaggedObject class]]) {
        ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)self.info;
        switch ([localASN1TaggedObject getTagNo]) {
            case 1:
                return [[KeyAgreeRecipientInfo getInstance:localASN1TaggedObject paramBoolean:false] getVersion];
            case 2:
                return [[self getKEKInfo:localASN1TaggedObject] getVersion];
            case 3:
                return [[PasswordRecipientInfo getInstance:localASN1TaggedObject paramBoolean:false] getVersion];
            case 4:
                return [[[ASN1Integer alloc] initLong:0] autorelease];
            default:
                break;
        }
        @throw [NSException exceptionWithName:NSGenericException reason:@"unknown tag" userInfo:nil];
    }
    return [[KeyTransRecipientInfo getInstance:self.info] getVersion];
}

- (BOOL)isTagged {
    return [self.info isKindOfClass:[ASN1TaggedObject class]];
}

- (ASN1Encodable *)getInfo {
    if ([self.info isKindOfClass:[ASN1TaggedObject class]]) {
        ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)self.info;
        switch ([localASN1TaggedObject getTagNo]) {
            case 1:
                return [KeyAgreeRecipientInfo getInstance:localASN1TaggedObject paramBoolean:false];
            case 2:
                return [self getKEKInfo:localASN1TaggedObject];
            case 3:
                return [PasswordRecipientInfo getInstance:localASN1TaggedObject paramBoolean:false];
            case 4:
                return [OtherRecipientInfo getInstance:localASN1TaggedObject paramBoolean:false];
            default:
                break;
        }
        @throw [NSException exceptionWithName:NSGenericException reason:@"unknown tag" userInfo:nil];
    }
    return [KeyTransRecipientInfo getInstance:self.info];
}

- (ASN1Primitive *)toASN1Primitive {
    return [self.info toASN1Primitive];
}

- (KEKRecipientInfo *)getKEKInfo:(ASN1TaggedObject *)paramASN1TaggedObject {
    if ([paramASN1TaggedObject isExplicit]) {
        return [KEKRecipientInfo getInstance:paramASN1TaggedObject paramBoolean:TRUE];
    }
    return [KEKRecipientInfo getInstance:paramASN1TaggedObject paramBoolean:false];
}

@end
