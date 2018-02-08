//
//  BidirectionalMap.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BidirectionalMap : NSMutableDictionary {
    NSMutableDictionary *_reverseMap;
}

@property (nonatomic, readwrite, retain) NSMutableDictionary *reverseMap;

- (id)getReverse:(id)paramObject;
- (id)putParamObject1:(id)paramObject1 paramObject2:(id)paramObject2;

@end
