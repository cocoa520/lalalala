//
//  GenMsgContent.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "GenMsgContent.h"
#import "DERSequence.h"
#import "CategoryExtend.h"

@interface GenMsgContent ()

@property (nonatomic, readwrite, retain) ASN1Sequence *content;

@end

@implementation GenMsgContent
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

+ (GenMsgContent *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[GenMsgContent class]]) {
        return (GenMsgContent *)paramObject;
    }
    if (paramObject) {
        return [[[GenMsgContent alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        self.content = paramASN1Sequence;
    }
    return self;
}

- (instancetype)initParamInfoTypeAndValue:(InfoTypeAndValue *)paramInfoTypeAndValue
{
    self = [super init];
    if (self) {
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1Encodable:paramInfoTypeAndValue];
        self.content = sequence;
#if !__has_feature(objc_arc)
        if (sequence) [sequence release]; sequence = nil;
#endif
    }
    return self;
}

- (instancetype)initParamArrayOfInfoTypeAndValue:(NSMutableArray *)paramArrayOfInfoTypeAndValue
{
    self = [super init];
    if (self) {
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
    }
    return self;
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
