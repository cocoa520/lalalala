//
//  NSString+Compare.h
//  BackupTool_Mac
//
//  Created by Pallas on 1/13/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Compare)

- (BOOL)isVersionAscending:(NSString*)verStr;
- (BOOL)isVersionAscendingEqual:(NSString*)verStr;
- (BOOL)isVersionLessEqual:(NSString*)verStr;
- (BOOL)isVersionLess:(NSString *)verStr;
- (BOOL)isVersionMajorEqual:(NSString *)verStr;
- (BOOL)isVersionMajor:(NSString *)verStr;
- (BOOL)isNilOrEmptyString;
- (BOOL)contains:(NSString *)value;
- (BOOL)isVersionEqual:(NSString *)verStr;
@end
