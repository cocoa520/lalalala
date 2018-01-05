//
//  NSMutableDictionary+Convert.m
//  BackupTool_Mac
//
//  Created by Pallas on 1/15/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "NSMutableDictionary+Convert.h"

@implementation NSMutableDictionary (Convert)

+ (NSMutableDictionary *)dictionaryWithContentsOfNSData:(NSData *)data {
    NSString *error;
    NSPropertyListFormat format;
    NSMutableDictionary *dict = [NSPropertyListSerialization
                                 propertyListFromData:data
                                 mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                 format:&format
                                 errorDescription:&error];
    if(!dict){
        [error release];
    }
    return dict;
}

- (NSData *)dictionaryToNSMutableData {
    NSString *error;
    
    NSData *data = [NSPropertyListSerialization dataFromPropertyList:self format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    if(!data){
        [error release];
    }
    return data;
}

@end
