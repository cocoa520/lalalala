//
//  BidirectionalMap.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BidirectionalMap.h"

@implementation BidirectionalMap
@synthesize reverseMap = _reverseMap;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_reverseMap) {
        [_reverseMap release];
        _reverseMap = nil;
    }
    [super dealloc];
#endif
}

+ (uint64_t)serialVersionUID {
    static uint64_t _serialVersionUID = 0;
    @synchronized(self) {
        if (!_serialVersionUID) {
            _serialVersionUID = -7457289971962812909L;
        }
    }
    return _serialVersionUID;
}

- (void)setReverseMap:(NSMutableDictionary *)reverseMap {
    if (_reverseMap != reverseMap) {
        _reverseMap = [[[NSMutableDictionary alloc] init] autorelease];
    }
}

- (id)getReverse:(id)paramObject {
    return [self.reverseMap objectForKey:paramObject];
}

- (id)putParamObject1:(id)paramObject1 paramObject2:(id)paramObject2 {
    [self.reverseMap setValue:paramObject1 forKey:paramObject2];
    return [super self];
}

@end
