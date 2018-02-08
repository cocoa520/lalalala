//
//  DirectoryString.m
//  crypto
//
//  Created by JGehry on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DirectoryString.h"

@interface DirectoryString ()

@property (nonatomic, readwrite, retain) ASN1String *string;

@end

@implementation DirectoryString
@synthesize string = _string;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_string) {
        [_string release];
        _string = nil;
    }
    [super dealloc];
#endif
}

+ (DirectoryString *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DirectoryString class]]) {
        return (DirectoryString *)paramObject;
    }
    if ([paramObject isKindOfClass:[DERT61String class]]) {
        return [[[DirectoryString alloc] initParamDERT61String:(DERT61String *)paramObject] autorelease];
    }
    if ([paramObject isKindOfClass:[DERPrintableString class]]) {
        return [[[DirectoryString alloc] initParamDERPrintableString:(DERPrintableString *)paramObject] autorelease];
    }
    if ([paramObject isKindOfClass:[DERUniversalString class]]) {
        return [[[DirectoryString alloc] initParamDERUniversalString:(DERUniversalString *)paramObject] autorelease];
    }
    if ([paramObject isKindOfClass:[DERUTF8String class]]) {
        return [[[DirectoryString alloc] initParamDERUTF8String:(DERUTF8String *)paramObject] autorelease];
    }
    if ([paramObject isKindOfClass:[DERBMPString class]]) {
        return [[[DirectoryString alloc] initParamDERBMPString:(DERBMPString *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (DirectoryString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    if (!paramBoolean) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"choice item must be explicitly tagged" userInfo:nil];
    }
    return [DirectoryString getInstance:[paramASN1TaggedObject getObject]];
}

- (instancetype)initParamDERT61String:(DERT61String *)paramDERT61String
{
    if (self = [super init]) {
        self.string = paramDERT61String;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamDERPrintableString:(DERPrintableString *)paramDERPrintableString
{
    if (self = [super init]) {
        self.string = paramDERPrintableString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamDERUniversalString:(DERUniversalString *)paramDERUniversalString
{
    if (self = [super init]) {
        self.string = paramDERUniversalString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamDERUTF8String:(DERUTF8String *)paramDERUTF8String
{
    if (self = [super init]) {
        self.string = paramDERUTF8String;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamDERBMPString:(DERBMPString *)paramDERBMPString
{
    if (self = [super init]) {
        self.string = paramDERBMPString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString
{
    if (self = [super init]) {
        ASN1String *str = [[DERUTF8String alloc] initParamString:paramString];
        self.string = str;
#if !__has_feature(objc_arc)
    if (str) [str release]; str = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSString *)getString {
    return self.string.getString;
}

- (NSString *)toString {
    return self.string.getString;
}

- (ASN1Primitive *)toASN1Primitive {
    return [((ASN1Encodable *)self.string) toASN1Primitive];
}

@end
