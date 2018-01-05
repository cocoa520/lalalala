//
//  PKIMessages.m
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKIMessages.h"
#import "DERSequence.h"
#import "PKIMessage.h"
#import "CategoryExtend.h"

@interface PKIMessages ()

@property (nonatomic, readwrite, retain) ASN1Sequence *content;

@end

@implementation PKIMessages
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

+ (PKIMessages *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PKIMessages class]]) {
        return (PKIMessages *)paramObject;
    }
    if (paramObject) {
        return [[[PKIMessages alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
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

- (instancetype)initParamPKIMessage:(PKIMessages *)paramPKIMessage
{
    self = [super init];
    if (self) {
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1Encodable:paramPKIMessage];
        self.content = sequence;
#if !__has_feature(objc_arc)
        if (sequence) [sequence release]; sequence = nil;
#endif
    }
    return self;
}

- (instancetype)initParamArrayOfPKIMessage:(NSMutableArray *)paramArrayOfPKIMessage
{
    self = [super init];
    if (self) {
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        for (int i = 0; i < paramArrayOfPKIMessage.count; i++) {
            [localASN1EncodableVector add:paramArrayOfPKIMessage[i]];
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

- (NSMutableArray *)toPKIMessageArray {
    NSMutableArray *arrayOfPKIMessage = [[[NSMutableArray alloc] initWithSize:[self.content size]] autorelease];
    for (int i = 0; i != arrayOfPKIMessage.count; i++) {
        arrayOfPKIMessage[i] = [PKIMessage getInstance:[self.content getObjectAt:i]];
    }
    return arrayOfPKIMessage;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.content;
}

@end
