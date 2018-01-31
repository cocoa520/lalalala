//
//  NSString+Compare.m
//  BackupTool_Mac
//
//  Created by Pallas on 1/13/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "NSString+Compare.h"

@implementation NSString (Compare)

// verStr比self版本大的时候返回YES,否则返回NO
- (BOOL)isVersionAscending:(NSString*)verStr {
    if (verStr == nil || [verStr isEqualToString:@""]) {
        return NO;
    }
    return ([self compare:verStr options:NSNumericSearch] == NSOrderedAscending);
}

- (BOOL)isVersionAscendingEqual:(NSString*)verStr {
    if (verStr == nil || [verStr isEqualToString:@""]) {
        return NO;
    }
    return ([self compare:verStr options:NSNumericSearch] == NSOrderedAscending) || ([self compare:verStr options:NSNumericSearch] == NSOrderedSame);
}

- (BOOL)isVersionLessEqual:(NSString *)verStr {
    if (verStr == nil || [verStr isEqualToString:@""]) {
        return NO;
    }
    return ([self compare:verStr options:NSNumericSearch] == NSOrderedAscending) || ([self compare:verStr options:NSNumericSearch] == NSOrderedSame);
}

- (BOOL)isVersionLess:(NSString *)verStr {
    if (verStr == nil || [verStr isEqualToString:@""]) {
        return NO;
    }
    return ([self compare:verStr options:NSNumericSearch] == NSOrderedAscending);
}

- (BOOL)isVersionMajorEqual:(NSString *)verStr {
    if (verStr == nil || [verStr isEqualToString:@""]) {
        return NO;
    }
    return ([self compare:verStr options:NSNumericSearch] == NSOrderedDescending) || ([self compare:verStr options:NSNumericSearch] == NSOrderedSame);
}

- (BOOL)isVersionEqual:(NSString *)verStr {
    if (verStr == nil || [verStr isEqualToString:@""]) {
        return NO;
    }
    return ([self compare:verStr options:NSNumericSearch] == NSOrderedSame);
}


- (BOOL)isVersionMajor:(NSString *)verStr {
    if (verStr == nil || [verStr isEqualToString:@""]) {
        return NO;
    }
    return ([self compare:verStr options:NSNumericSearch] == NSOrderedDescending);
}


- (BOOL)isNilOrEmptyString {
    if (self == nil || [self isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)contains:(NSString *)value {
    if (value == nil || [value isEqualToString:@""]) {
        return NO;
    }
    if ([self rangeOfString:value].location != NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}

@end
