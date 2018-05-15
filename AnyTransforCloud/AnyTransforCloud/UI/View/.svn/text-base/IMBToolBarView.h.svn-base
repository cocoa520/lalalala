//
//  IMBToolBarView.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/25.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
#import "IMBToolBarButton.h"

@interface IMBToolBarView : NSView {
    IMBToolBarButton *_reload;
    IMBToolBarButton *_sync;
    IMBToolBarButton *_share;
    IMBToolBarButton *_star;
    IMBToolBarButton *_rename;
    IMBToolBarButton *_copy;
    IMBToolBarButton *_move;
    IMBToolBarButton *_refresh;
    IMBToolBarButton *_download;
    IMBToolBarButton *_info;
    IMBToolBarButton *_delete;
    IMBToolBarButton *_sort;
    IMBToolBarButton *_switch;
    IMBToolBarButton *_upload;
    IMBToolBarButton *_createFolder;
     IMBToolBarButton *_preView;
}
/**
 *  //屏蔽 toolBar 上button点击按钮
 *
 *  @param isEnabled NO为禁用
 */
- (void)toolBarButtonIsEnabled:(BOOL)isEnabled;

/**
 *  加载功能按钮
 *
 *  @param FunctionTypeArray 需要加的功能枚举数组
 *  @param Target            目标类
 *  @param displayMode       YES代表显示集合形式，NO代表显示列表形式
 */
- (void)loadButtons:(NSArray *)FunctionTypeArray Target:(id)Target DisplayMode:(BOOL)displayMode;

@end
