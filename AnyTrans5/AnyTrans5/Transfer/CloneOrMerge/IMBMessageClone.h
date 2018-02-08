//
//  IMBMessageClone.h
//  iMobieTrans
//
//  Created by iMobie on 14-12-16.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBaseClone.h"

@interface IMBMessageClone : IMBBaseClone
{
    NSMutableArray *attachfileNameArray;
    NSMutableArray *_allMessage;
}
- (void)merge:(NSArray *)messageArray;
@end
