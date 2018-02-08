//
//  PolicyQualifierId.m
//  crypto
//
//  Created by JGehry on 7/12/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PolicyQualifierId.h"

@implementation PolicyQualifierId

+ (NSString *)id_qt {
    static NSString *_id_qt = nil;
    @synchronized(self) {
        if (!_id_qt) {
            _id_qt = @"1.3.6.1.5.5.7.2";
        }
    }
    return _id_qt;
}

+ (PolicyQualifierId *)id_qt_cps {
    static PolicyQualifierId *_id_qt_cps = nil;
    @synchronized(self) {
        if (!_id_qt_cps) {
            _id_qt_cps = [[PolicyQualifierId alloc] initParamString:@"1.3.6.1.5.5.7.2.1"];
        }
    }
    return _id_qt_cps;
}

+ (PolicyQualifierId *)id_qt_unotice {
    static PolicyQualifierId *_id_qt_unotice = nil;
    @synchronized(self) {
        if (!_id_qt_unotice) {
            _id_qt_unotice = [[PolicyQualifierId alloc] initParamString:@"1.3.6.1.5.5.7.2.2"];
        }
    }
    return _id_qt_unotice;
}

- (instancetype)initParamString:(NSString *)paramString
{
    self = [super initParamString:paramString];
    if (self) {
    }
    return self;
}

@end
