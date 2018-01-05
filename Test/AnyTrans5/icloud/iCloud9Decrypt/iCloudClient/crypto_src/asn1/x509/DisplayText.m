//
//  DisplayText.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DisplayText.h"
#import "DERIA5String.h"
#import "DERUTF8String.h"
#import "DERVideotexString.h"
#import "DERBMPString.h"

@implementation DisplayText
@synthesize contentType = _contentType;
@synthesize contents = _contents;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_contents) {
        [_contents release];
        _contents = nil;
    }
    [super dealloc];
#endif
}

+ (int)CONTENT_TYPE_IA5STRING {
    static int _CONTENT_TYPE_IA5STRING = 0;
    @synchronized(self) {
        if (!_CONTENT_TYPE_IA5STRING) {
            _CONTENT_TYPE_IA5STRING = 0;
        }
    }
    return _CONTENT_TYPE_IA5STRING;
}

+ (int)CONTENT_TYPE_BMPSTRING {
    static int _CONTENT_TYPE_BMPSTRING = 0;
    @synchronized(self) {
        if (!_CONTENT_TYPE_BMPSTRING) {
            _CONTENT_TYPE_BMPSTRING = 1;
        }
    }
    return _CONTENT_TYPE_BMPSTRING;
}

+ (int)CONTENT_TYPE_UTF8STRING {
    static int _CONTENT_TYPE_UTF8STRING = 0;
    @synchronized(self) {
        if (!_CONTENT_TYPE_UTF8STRING) {
            _CONTENT_TYPE_UTF8STRING = 2;
        }
    }
    return _CONTENT_TYPE_UTF8STRING;
}

+ (int)CONTENT_TYPE_VISIBLESTRING {
    static int _CONTENT_TYPE_VISIBLESTRING = 0;
    @synchronized(self) {
        if (!_CONTENT_TYPE_VISIBLESTRING) {
            _CONTENT_TYPE_VISIBLESTRING = 3;
        }
    }
    return _CONTENT_TYPE_VISIBLESTRING;
}

+ (int)DISPLAY_TEXT_MAXIMUM_SIZE {
    static int _DISPLAY_TEXT_MAXIMUM_SIZE = 0;
    @synchronized(self) {
        if (!_DISPLAY_TEXT_MAXIMUM_SIZE) {
            _DISPLAY_TEXT_MAXIMUM_SIZE = 200;
        }
    }
    return _DISPLAY_TEXT_MAXIMUM_SIZE;
}

+ (DisplayText *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DisplayText class]]) {
        return (DisplayText *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1String class]]) {
        return [[[DisplayText alloc] initparamASN1String:(ASN1String *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (DisplayText *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [DisplayText getInstance:[paramASN1TaggedObject getObject]];
}

- (instancetype)initParamInt:(int)paramInt paramString:(NSString *)paramString
{
    if (self = [super init]) {
        if ([paramString length] > 200) {
            paramString = [paramString substringToIndex:200];
        }
        self.contentType = paramInt;
        switch (paramInt) {
            case 0: {
                ASN1String *str = [[DERIA5String alloc] initParamString:paramString];
                self.contents = str;
#if !__has_feature(objc_arc)
    if (str) [str release]; str = nil;
#endif
            }
                break;
            case 2: {
                ASN1String *str = [[DERUTF8String alloc] initParamString:paramString];
                self.contents = str;
#if !__has_feature(objc_arc)
    if (str) [str release]; str = nil;
#endif
            }
                break;
            case 3: {
                ASN1String *str = [[DERVideotexString alloc] initParamString:paramString];
                self.contents = str;
#if !__has_feature(objc_arc)
    if (str) [str release]; str = nil;
#endif
            }
                break;
            case 1: {
                ASN1String *str = [[DERBMPString alloc] initParamString:paramString];
                self.contents = str;
#if !__has_feature(objc_arc)
    if (str) [str release]; str = nil;
#endif
            }
                break;
            default: {
                ASN1String *str = [[DERUTF8String alloc] initParamString:paramString];
                self.contents = str;
#if !__has_feature(objc_arc)
    if (str) [str release]; str = nil;
#endif
            }
                break;
        }
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
        if ([paramString length] > 200) {
            paramString = [paramString substringToIndex:200];
        }
        self.contentType = 2;
        ASN1String *str = [[DERUTF8String alloc] initParamString:paramString];
        self.contents = str;
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

- (instancetype)initparamASN1String:(ASN1String *)paramASN1String
{
    if (self = [super init]) {
        self.contents = paramASN1String;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Primitive *)toASN1Primitive {
    return (ASN1Primitive *)self.contents;
}

- (NSString *)getString {
    return [self.contents getString];
}

@end
