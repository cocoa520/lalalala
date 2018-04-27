//
//  IMBProgressCounter.h
//  iMobieTrans
//
//  Created by iMobie on 8/14/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBProgressCounter : NSObject{
    //准备阶段会使用到的计数器
    int _prepareCurrentIndex;
    //加限制专用
    int _prepareAnalysisSuccessCount;
    //超出分析个数
    BOOL _prepareAnalysisOutOfCount;
    int _prepareTotalCount;
    //传输阶段会使用到的计数器
    int _copyingCurrentIndex;
    int _copyingTotalCount;
    int _prepareTotalMediaCount;
    BOOL _isOutOfStorage;
}
@property (nonatomic,assign) int prepareCurrentIndex;
@property (nonatomic,assign) int prepareAnalysisSuccessCount;
@property (nonatomic,assign) int prepareTotalCount;
@property (nonatomic,assign) int prepareTotalMediaCount;
@property (nonatomic,assign) int copyingCurrentIndex;
@property (nonatomic,assign) int copyingTotalCount;
@property (nonatomic,assign) BOOL prepareAnalysisOutOfCount;
@property (nonatomic,assign) BOOL isOutOfStorage;

+ (IMBProgressCounter *)singleton;
- (void)setMediaCopyingTotalCount:(int)count;
- (void)reInit;

@end
