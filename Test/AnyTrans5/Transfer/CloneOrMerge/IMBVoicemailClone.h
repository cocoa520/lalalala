//
//  IMBVoicemailClone.h
//  iMobieTrans
//
//  Created by iMobie on 14-12-22.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBaseClone.h"

@interface IMBVoicemailClone : IMBBaseClone
{
    NSMutableArray *voicemailIDArray;
}

- (void)merge:(NSArray *)voicemailArray;
@end
