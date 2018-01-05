//
//  IMBSafariBookmarkEntity.m
//  ParseJsonData
//
//  Created by iMobie on 14-11-27.
//  Copyright (c) 2014年 iMobie. All rights reserved.
//

#import "IMBSafariBookmarkEntity.h"

@implementation IMBSafariBookmarkEntity
@synthesize webBookmarkType = _webBookmarkType;
//将对象与字典建立一个对应关系
- (NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapAtt = @{
                             @"url":@"URLString",
                             @"webBookmarkType":@"WebBookmarkType",
    };
    return mapAtt;
}

- (void)setWebBookmarkType:(NSString *)webBookmarkType
{
    if (_webBookmarkType != webBookmarkType) {
        [_webBookmarkType release];
        _webBookmarkType = [webBookmarkType retain];
        if ([_webBookmarkType isEqualToString:@"WebBookmarkTypeList"]) {
            self.isFolder = YES;
        }else if ([_webBookmarkType isEqualToString:@"WebBookmarkTypeLeaf"])
        {
            self.isFolder = NO;
        }
    }
}

- (void)dealloc
{
    [_webBookmarkType release],_webBookmarkType = nil;
    [super dealloc];
}
@end
