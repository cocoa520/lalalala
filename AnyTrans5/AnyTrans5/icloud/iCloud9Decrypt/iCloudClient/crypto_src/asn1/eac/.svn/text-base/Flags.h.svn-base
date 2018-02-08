//
//  Flags.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flags : NSObject {
    int _value;
}

@property (nonatomic, assign) int value;

- (instancetype)init;
- (instancetype)initParamInt:(int)paramInt;
- (void)set:(int)paramInt;
- (BOOL)isSet:(int)paramInt;
- (int)getFlags;
- (NSString *)decode:(NSMutableDictionary *)paramHashtable;

@end
