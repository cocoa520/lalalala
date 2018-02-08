//
//  ASN1ParsingException.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1ParsingException.h"

@interface ASN1ParsingException ()

@property (nonatomic, readwrite, retain) NSException *cause;

@end

@implementation ASN1ParsingException
@synthesize cause = _cause;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_cause) {
        [_cause release];
        _cause = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initParamString:(NSString *)paramString
{
    if (self = [super init]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString paramThrowable:(NSException *)paramThrowable
{
    if (self = [super init]) {
        self.cause = paramThrowable;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSException *)getCause {
    return self.cause;
}

@end
