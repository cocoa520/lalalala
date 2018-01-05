//
//  PKIConfirmContent.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKIConfirmContent.h"
#import "DERNull.h"

@interface PKIConfirmContent ()

@property (nonatomic, readwrite, retain) ASN1Null *val;

@end

@implementation PKIConfirmContent
@synthesize val = _val;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_val) {
        [_val release];
        _val = nil;
    }
    [super dealloc];
#endif
}

+ (PKIConfirmContent *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[PKIConfirmContent class]]) {
        return (PKIConfirmContent *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Null class]]) {
        return [[[PKIConfirmContent alloc] initParamASN1Null:(ASN1Null *)paramObject] autorelease];
    }
    return nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.val = [DERNull INSTANCE];
    }
    return self;
}

- (instancetype)initParamASN1Null:(ASN1Null *)paramASN1Null
{
    self = [super init];
    if (self) {
        self.val = paramASN1Null;
    }
    return self;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.val;
}

@end
