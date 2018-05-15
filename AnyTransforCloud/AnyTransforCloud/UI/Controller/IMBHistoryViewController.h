//
//  IMBHistoryViewController.h
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/24.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
#import "IMBAllCloudViewController.h"

@interface IMBHistoryViewController : IMBBaseViewController {
    IMBAllCloudViewController *_historyViewController;
}

/**
 *  加载数据
 */
- (void)loadFileHistoryRecords;

@end
