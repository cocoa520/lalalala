//
//  IMBFirefoxBookmarkEntity.h
//  ParseJsonData
//
//  Created by iMobie on 14-11-28.
//  Copyright (c) 2014年 iMobie. All rights reserved.
//

#import "IMBBookmarkEntity.h"

@interface IMBFirefoxBookmarkEntity : IMBBookmarkEntity
{
    NSString *_type;
}
@property(nonatomic,retain)NSString *type;
@end
