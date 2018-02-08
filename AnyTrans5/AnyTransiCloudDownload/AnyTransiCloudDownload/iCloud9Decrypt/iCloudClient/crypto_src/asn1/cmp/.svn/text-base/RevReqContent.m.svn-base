//
//  RevReqContent.m
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RevReqContent.h"
#import "DERSequence.h"
#import "CategoryExtend.h"

@interface RevReqContent()

@property (nonatomic, readwrite, retain) ASN1Sequence *content;

@end

@implementation RevReqContent
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

+ (RevReqContent *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[RevReqContent class]]) {
        return (RevReqContent *)paramObject;
    }
    if (paramObject) {
        return [[[RevReqContent alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
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

- (instancetype)initParamRevDetails:(RevDetails *)paramRevDetails
{
    self = [super init];
    if (self) {
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1Encodable:paramRevDetails];
        self.content = sequence;
#if !__has_feature(objc_arc)
        if (sequence) [sequence release]; sequence = nil;
#endif
    }
    return self;
}

- (instancetype)initParamArrayOfRevDetails:(NSMutableArray *)paramArrayOfRevDetails
{
    self = [super init];
    if (self) {
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        for (int i = 0; i != paramArrayOfRevDetails.count; i++) {
            [localASN1EncodableVector add:paramArrayOfRevDetails[i]];
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

- (NSMutableArray *)toRevDetailsArray {
    NSMutableArray *arrayOfRevDetails = [[[NSMutableArray alloc] initWithSize:[self.content size]] autorelease];
    for (int i = 0; i != arrayOfRevDetails.count; i++) {
        arrayOfRevDetails[i] = [RevDetails getInstance:[self.content getObjectAt:i]];
    }
    return arrayOfRevDetails;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.content;
}

@end
