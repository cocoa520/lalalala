//
//  IMBPaseBookmark.h
//  iMobieTrans
//
//  Created by iMobie on 14-11-27.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface IMBParseBookmark : NSObject
{
    FMDatabase *_SQLiteConnection;
}
//解析json格式的bookmark 谷歌浏览器
+ (NSMutableArray *)parseChromeBookmarkByJSON;
//解析火狐浏览器中的bookmark
+ (NSMutableArray *)parseFirefoxBookmarkByJSON;
//解析safari浏览器中的bookmark
+ (NSMutableArray *)parseSafariBookmarkByPlist;
- (NSMutableArray *)parseFirefoxBookmarkByDB;
@end
