//
//  StringJoiner.m
//  crypto
//
//  Created by JGehry on 7/5/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "StringJoiner.h"

@implementation StringJoiner
@synthesize mSeparator = _mSeparator;
@synthesize First = _First;
@synthesize b = _b;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_mSeparator) {
        [_mSeparator release];
        _mSeparator = nil;
    }
    if (_b) {
        [_b release];
        _b = nil;
    }
    [super dealloc];
#endif
}

- (void)setFirst:(BOOL)First {
    if (_First != First) {
        _First = TRUE;
    }
}

- (void)setB:(NSMutableString *)b {
    if (_b != b) {
        _b = [[[NSMutableString alloc] init] autorelease];
    }
}

- (instancetype)initParamString:(NSString *)paramString
{
    self = [super init];
    if (self) {
        self.mSeparator = paramString;
    }
    return self;
}

- (void)add:(NSString *)paramString {
    if (self.First) {
        self.First = false;
    }else {
        [self.b appendString:self.mSeparator];
    }
    [self.b appendString:paramString];
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"%@", self.b];
}

@end
