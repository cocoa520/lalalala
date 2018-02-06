//
//  IMBCloneOrMergeManager.h
//  AnyTrans
//
//  Created by LuoLei on 16-8-15.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"
#import "IMBBaseTransfer.h"
@interface IMBCloneOrMergeManager : NSObject
{
    IMBiPod *_sourceIpod;//源设备
    IMBiPod *_targetIpod;//目标设备
    NSMutableArray *_categoryArr; //类别
    NSString *_errorCode;
    BOOL _hasError;
    IMBLogManager *_logManager;
    id <TransferDelegate> _tranferDelegate;
    __block BOOL _retry;
}
- (id)initWithiPod:(IMBiPod *)sourceiPod targetPod:(IMBiPod *)targetiPod categoryArray:(NSMutableArray *)categoryArray transferDelegate:(id<TransferDelegate>)tranferDelegate;
- (void)clone;
- (void)merge;
@end
