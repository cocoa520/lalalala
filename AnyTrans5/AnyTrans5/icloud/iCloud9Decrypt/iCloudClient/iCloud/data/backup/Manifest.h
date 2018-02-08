//
//  Manifest.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import <Foundation/Foundation.h>

@interface Manifest : NSObject {
@private
    int _count;
    int _checksum;
    NSString *_iD;
}

- (int)count;
- (int)checksum;
- (NSString*)iD;

- (id)initWithCount:(int)count withChecksum:(int)checksum withID:(NSString*)iD;


@end
