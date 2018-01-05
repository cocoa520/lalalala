//
//  IMBSubBookmarkEntity.m
//  ParseJsonData
//
//  Created by iMobie on 14-11-27.
//  Copyright (c) 2014年 iMobie. All rights reserved.
//

#import "IMBChromeBookmarkEntity.h"

@implementation IMBChromeBookmarkEntity
@synthesize type = _type;
//将对象与字典建立一个对应关系
- (NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapAtt = @{
                             @"name":@"name",
                             @"url":@"url",
                             @"type":@"type",
                            };
    return mapAtt;
}

- (void)setType:(NSString *)type
{
    if (_type != type) {
        [_type release];
        _type = [type retain];
        if ([_type isEqualToString:@"folder"]) {
            self.isFolder = YES;
        }else if ([_type isEqualToString:@"url"])
        {
            self.isFolder = NO;
        }
    }
}

- (void)dealloc
{
    [_type release],_type = nil;
    [super dealloc];
}
@end
