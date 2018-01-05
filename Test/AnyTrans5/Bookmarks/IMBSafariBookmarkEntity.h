//
//  IMBSafariBookmarkEntity.h
//  ParseJsonData
//
//  Created by iMobie on 14-11-27.
//  Copyright (c) 2014年 iMobie. All rights reserved.
//

#import "IMBBookmarkEntity.h"

@interface IMBSafariBookmarkEntity : IMBBookmarkEntity
{
    NSString *_webBookmarkType;
}

@property(nonatomic,retain)NSString *webBookmarkType;
@end
