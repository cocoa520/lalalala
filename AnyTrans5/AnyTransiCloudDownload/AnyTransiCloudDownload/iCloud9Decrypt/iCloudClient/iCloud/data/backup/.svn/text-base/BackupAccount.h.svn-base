//
//  BackupAccount.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import <Foundation/Foundation.h>

@interface BackupAccount : NSObject {
@private
    NSMutableData *_hmacKey;
    NSMutableArray *_devices;
}

- (instancetype)initWithHmacKey:(NSMutableData *)hmacKey devices:(NSMutableArray *)devices;
- (NSMutableData *)getHmacKey;
- (NSMutableArray *)devices;

@end
