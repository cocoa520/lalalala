//
//  Controls.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Controls.h"
#import "DERSequence.h"
#import "CategoryExtend.h"

@interface Controls ()

@property (nonatomic, readwrite, retain) ASN1Sequence *content;

@end

@implementation Controls
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

+ (Controls *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[Controls class]]) {
        return (Controls *)paramObject;
    }
    if (paramObject) {
        return [[[Controls alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
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

- (instancetype)initParamAttributeTypeAndValue:(AttributeTypeAndValueCRMF *)paramAttributeTypeAndValue
{
    if (self = [super init]) {
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1Encodable:paramAttributeTypeAndValue];
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

- (instancetype)initParamArrayOfAttributeTypeAndValue:(NSMutableArray *)paramArrayOfAttributeTypeAndValue
{
    if (self = [super init]) {
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        for (int i = 0; i < paramArrayOfAttributeTypeAndValue.count; i++) {
            [localASN1EncodableVector add:paramArrayOfAttributeTypeAndValue[i]];
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

- (NSMutableArray *)toAttributeTypeAndValueArray {
    NSMutableArray *arrayOfAttributeTypeAndValue = [[[NSMutableArray alloc] initWithSize:[self.content size]] autorelease];
    for (int i = 0; i != arrayOfAttributeTypeAndValue.count; i++) {
        arrayOfAttributeTypeAndValue[i] = [AttributeTypeAndValueCRMF getInstance:[self.content getObjectAt:i]];
    }
    return arrayOfAttributeTypeAndValue;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.content;
}

@end
