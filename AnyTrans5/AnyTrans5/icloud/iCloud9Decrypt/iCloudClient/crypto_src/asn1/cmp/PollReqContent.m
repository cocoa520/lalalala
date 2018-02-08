//
//  PollReqContent.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PollReqContent.h"
#import "DERSequence.h"
#import "CategoryExtend.h"

@interface PollReqContent ()

@property (nonatomic, readwrite, retain) ASN1Sequence *content;

@end

@implementation PollReqContent
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

+ (NSMutableArray *)sequenceToASN1IntegerArray:(ASN1Sequence *)paramASN1Sequence {
    NSMutableArray *arrayOfASN1Integer = [[[NSMutableArray alloc] initWithSize:(int)[paramASN1Sequence size]] autorelease];
    for (int i = 0; i != arrayOfASN1Integer.count; i++) {
        arrayOfASN1Integer[i] = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:i]];
    }
    return arrayOfASN1Integer;
}

+ (PollReqContent *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PollReqContent class]]) {
        return (PollReqContent *)paramObject;
    }
    if (paramObject) {
        return [[[PollReqContent alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
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

- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer
{
    self = [super init];
    if (self) {
        DERSequence *derSequence = [[DERSequence alloc] initDERParamASN1Encodable:paramASN1Integer];
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1Encodable:derSequence];
        [self initParamASN1Sequence:sequence];
#if !__has_feature(objc_arc)
        if (derSequence) [derSequence release]; derSequence = nil;
        if (sequence) [sequence release]; sequence = nil;
#endif
    }
    return self;
}

- (NSMutableArray *)getCertReqIds {
    NSMutableArray *arrayOfASN1Integers = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *arrayOfASN1Integer = [[NSMutableArray alloc] initWithSize:[self.content size]];
    [arrayOfASN1Integers addObject:arrayOfASN1Integer];
    for (int i = 0; i != arrayOfASN1Integer.count; i++) {
        arrayOfASN1Integers[i] = [PollReqContent sequenceToASN1IntegerArray:(ASN1Sequence *)[self.content getObjectAt:i]];
    }
#if !__has_feature(objc_arc)
    if (arrayOfASN1Integer) [arrayOfASN1Integer release]; arrayOfASN1Integer = nil;
#endif
    
    return arrayOfASN1Integers;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.content;
}

@end
