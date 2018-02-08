//
//  PKIFreeText.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKIFreeText.h"
#import "DERSequence.h"

@implementation PKIFreeText
@synthesize strings = _strings;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_strings) {
        [_strings release];
        _strings = nil;
    }
    [super dealloc];
#endif
}

+ (PKIFreeText *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PKIFreeText class]]) {
        return (PKIFreeText *)paramObject;
    }
    if (paramObject) {
        return [[[PKIFreeText alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (PKIFreeText *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [PKIFreeText getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            if (![localObject isKindOfClass:[DERUTF8String class]]) {
                @throw [NSException exceptionWithName:NSGenericException reason:@"attempt to insert non UTF8 STRING into PKIFreeText" userInfo:nil];
            }
        }
        self.strings = paramASN1Sequence;
    }
    return self;
}

- (instancetype)initParamDERUTF8String:(DERUTF8String *)paramDERUTF8String
{
    self = [super init];
    if (self) {
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1Encodable:paramDERUTF8String];
        self.strings = sequence;
#if !__has_feature(objc_arc)
        if (sequence) [sequence release]; sequence = nil;
#endif
    }
    return self;
}

- (instancetype)initParamString:(NSString *)paramString
{
    self = [super init];
    if (self) {
        DERUTF8String *utf8String = [[DERUTF8String alloc] initParamString:paramString];
        [self initParamDERUTF8String:utf8String];
#if !__has_feature(objc_arc)
        if (utf8String) [utf8String release]; utf8String = nil;
#endif
    }
    return self;
}

- (instancetype)initParamArrayOfDERUTF8String:(NSMutableArray *)paramArrayOfDERUTF8String
{
    self = [super init];
    if (self) {
        ASN1Sequence *sequence = [[DERSequence alloc] initDERparamArrayOfASN1Encodable:paramArrayOfDERUTF8String];
        self.strings = sequence;
#if !__has_feature(objc_arc)
        if (sequence) [sequence release]; sequence = nil;
#endif
    }
    return self;
}

- (instancetype)initParamArrayOfString:(NSMutableArray *)paramArrayOfString
{
    self = [super init];
    if (self) {
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        for (int i = 0; i < paramArrayOfString.count; i++) {
            ASN1Encodable *encodable = [[DERUTF8String alloc] initParamString:paramArrayOfString[i]];
            [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
            if (encodable) [encodable release]; encodable = nil;
#endif
        }
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
        self.strings = sequence;
#if !__has_feature(objc_arc)
        if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
        if (sequence) [sequence release]; sequence = nil;
#endif
    }
    return self;
}

- (int)size {
    return (int)[self.strings size];
}

- (DERUTF8String *)getStringAt:(int)paramInt {
    return (DERUTF8String *)[self.strings getObjectAt:paramInt];
}

- (ASN1Primitive *)toASN1Primitive {
    return self.strings;
}

@end
