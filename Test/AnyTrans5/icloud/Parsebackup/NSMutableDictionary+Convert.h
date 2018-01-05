//
//  NSMutableDictionary+Convert.h
//  BackupTool_Mac
//
//  Created by Pallas on 1/15/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Convert)

+ (NSMutableDictionary *)dictionaryWithContentsOfNSData:(NSData *)data;

- (NSData *)dictionaryToNSMutableData;

@end
