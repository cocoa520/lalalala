//
//  StringHelper.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "StringHelper.h"
@implementation StringHelper

+ (BOOL)stringIsNilOrEmpty:(NSString*)string {
    if ([string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if (string == nil || [string isEqualToString:@""]  ) {
        return YES;
    } else {
        return NO;
    }
}
@end
