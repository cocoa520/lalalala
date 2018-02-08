//
//  POPODecKeyChallContent.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "POPODecKeyChallContent.h"
#import "Challenge.h"
#import "CategoryExtend.h"

@interface POPODecKeyChallContent ()

@property (nonatomic, readwrite, retain) ASN1Sequence *content;

@end

@implementation POPODecKeyChallContent
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

+ (POPODecKeyChallContent *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[POPODecKeyChallContent class]]) {
        return (POPODecKeyChallContent *)paramObject;
    }
    if (paramObject) {
        return [[[POPODecKeyChallContent alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
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

- (NSMutableArray *)toChallengeArray {
    NSMutableArray *arrayOfChallenge = [[[NSMutableArray alloc] initWithSize:[self.content size]] autorelease];
    for (int i = 0; i != arrayOfChallenge.count; i++) {
        arrayOfChallenge[i] = [Challenge getInstance:[self.content getObjectAt:i]];
    }
    return arrayOfChallenge;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.content;
}

@end
