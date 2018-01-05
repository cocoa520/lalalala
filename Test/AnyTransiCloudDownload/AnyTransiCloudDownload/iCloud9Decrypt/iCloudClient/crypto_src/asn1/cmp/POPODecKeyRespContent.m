//
//  POPODecKeyRespContent.m
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "POPODecKeyRespContent.h"
#import "ASN1Integer.h"
#import "CategoryExtend.h"

@interface POPODecKeyRespContent ()

@property (nonatomic, readwrite, retain) ASN1Sequence *content;

@end

@implementation POPODecKeyRespContent
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

+ (POPODecKeyRespContent *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[POPODecKeyRespContent class]]) {
        return (POPODecKeyRespContent *)paramObject;
    }
    if (paramObject) {
        return [[[POPODecKeyRespContent alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
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

- (NSMutableArray *)toASN1IntegerArray {
    NSMutableArray *arrayOfASN1Integer = [[[NSMutableArray alloc] initWithSize:[self.content size]] autorelease];
    for (int i = 0; i != arrayOfASN1Integer.count; i++) {
        arrayOfASN1Integer[i] = [ASN1Integer getInstance:[self.content getObjectAt:i]];
    }
    return arrayOfASN1Integer;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.content;
}

@end
