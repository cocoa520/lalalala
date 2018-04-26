//
//  IMBMainPageWindowBackBtn.h
//  iOSFiles
//
//  Created by iMobie on 2018/3/21.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBMainPageWindowBackBtn : NSButton
{
    @private
    BOOL _enable;
}

/**
 *  设置按钮是否有效，YES为有效 能使用  NO为失效 不能使用
 */
@property(nonatomic, assign)BOOL enable;

@end
