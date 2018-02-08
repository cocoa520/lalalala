//
//  ASN1Generator.m
//  crypto
//
//  Created by JGehry on 7/25/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Generator.h"

@implementation ASN1Generator
@synthesize oUT = _oUT;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_oUT) {
        [_oUT release];
        _oUT = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream
{
    if (self = [super init]) {
        self.oUT = paramOutputStream;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (Stream *)getRawOutputStream {
    return nil;
}

@end
