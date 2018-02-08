//
//  GenRepContent.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "GenRepContent.h"
#import "DERSequence.h"
#import "CategoryExtend.h"

@interface GenRepContent ()

@property (nonatomic, readwrite, retain) ASN1Sequence *content;

@end

@implementation GenRepContent
@synthesize content = _content;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_content) {
        [_content release];
        _content = nil;
    }
    [super dealloc];
#endif
}

+ (GenRepContent *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[GenRepContent class]]) {
        return (GenRepContent *)paramObject;
    }
    if (paramObject) {
        return [[[GenRepContent alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.content = paramASN1Sequence;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInfoTypeAndValue:(InfoTypeAndValue *)paramInfoTypeAndValue
{
    if (self = [super init]) {
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1Encodable:paramInfoTypeAndValue];
        self.content = sequence;
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

- (instancetype)initParamArrayOfInfoTypeAndValue:(NSMutableArray *)paramArrayOfInfoTypeAndValue
{
    if (self = [super init]) {
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        for (int i = 0; i != paramArrayOfInfoTypeAndValue.count; i++) {
            [localASN1EncodableVector add:paramArrayOfInfoTypeAndValue[i]];
        }
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
        self.content = sequence;
#if !__has_feature(objc_arc)
        if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
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

- (NSMutableArray *)toInfoTypeAndValueArray {
    NSMutableArray *arrayOfInfoTypeAndValue = [[[NSMutableArray alloc] initWithSize:[self.content size]] autorelease];
    for (int i = 0; i != arrayOfInfoTypeAndValue.count; i++) {
        arrayOfInfoTypeAndValue[i] = [InfoTypeAndValue getInstance:[self.content getObjectAt:i]];
    }
    return arrayOfInfoTypeAndValue;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.content;
}

@end
