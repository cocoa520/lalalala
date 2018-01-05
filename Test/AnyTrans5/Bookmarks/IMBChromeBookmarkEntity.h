//
//  IMBSubBookmarkEntity.h
//  ParseJsonData
//
//  Created by iMobie on 14-11-27.
//  Copyright (c) 2014年 iMobie. All rights reserved.
//

#import "IMBBookmarkEntity.h"

@interface IMBChromeBookmarkEntity : IMBBookmarkEntity
{
    NSString *_type;
}
@property(nonatomic,retain)NSString *type;
@end
