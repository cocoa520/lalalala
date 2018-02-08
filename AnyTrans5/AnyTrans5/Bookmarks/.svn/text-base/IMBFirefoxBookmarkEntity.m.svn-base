//
//  IMBFirefoxBookmarkEntity.m
//  ParseJsonData
//
//  Created by iMobie on 14-11-28.
//  Copyright (c) 2014年 iMobie. All rights reserved.
//

#import "IMBFirefoxBookmarkEntity.h"

@implementation IMBFirefoxBookmarkEntity
@synthesize type = _type;
//将对象与字典建立一个对应关系
- (NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapAtt = @{
                             @"name":@"title",
                             @"url":@"uri",
                             @"type":@"type",
                             };
    return mapAtt;
}

- (void)setType:(NSString *)type
{
    if (_type != type) {
        [_type release];
        _type = [type retain];
        if ([_type isEqualToString:@"text/x-moz-place-container"]) {
        
            self.isFolder = YES;
        }else if ([_type isEqualToString:@"text/x-moz-place"])
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
