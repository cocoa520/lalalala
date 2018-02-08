//
//  IMBCallHistoryExport.h
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-7.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBBaseTransfer.h"
#import "IMBCallHistoryDataEntity.h"
@interface IMBCallHistoryExport : IMBBaseTransfer
{
    IMBCallContactModel *_callhistory;
}
@end
