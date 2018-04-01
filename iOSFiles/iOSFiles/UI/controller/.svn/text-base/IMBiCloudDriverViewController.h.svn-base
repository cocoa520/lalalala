//
//  IMBiCloudDriverViewController.h
//  iOSFiles
//
//  Created by smz on 18/3/14.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "CNGridView.h"
#import "IMBDriveBaseManage.h"
#import "LoadingView.h"
#import "IMBToolButtonView.h"
#import "DriveItem.h"
#import "IMBDriveEntity.h"
#import "IMBCommonEnum.h"
@interface IMBiCloudDriverViewController : IMBBaseViewController<CNGridViewDelegate,CNGridViewDataSource> {
    
    IBOutlet IMBWhiteView *_topView;
    
    IBOutlet NSBox *_contentBox;
    
    IBOutlet IMBWhiteView *_gridBgView;
    IBOutlet CNGridView *_gridView;
    
    IBOutlet IMBWhiteView *_tableViewBgView;
    
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadAnimationView;
    
    IBOutlet IMBBackgroundBorderView *_topLineView;
    
    IBOutlet IMBWhiteView *_nodataView;
    IBOutlet NSImageView *_nodataImageView;
    IBOutlet NSTextView *_nodataTextView;
    
    IBOutlet IMBWhiteView *_leftContentView;
    IBOutlet IMBWhiteView *_rightContentView;
    IBOutlet IMBBackgroundBorderView *_rightLineView;
    
    //点击详细显示
    IBOutlet NSImageView *_detailImageView;
    IBOutlet NSTextField *_detailTitle;
    
    IBOutlet NSTextField *_detailSize;
    IBOutlet NSTextField *_detailCount;
    IBOutlet NSTextField *_detailLastTime;
    IBOutlet NSTextField *_detailCreateTime;
    
    IBOutlet NSTextField *_detailSizeContent;
    IBOutlet NSTextField *_detailCountContent;
    IBOutlet NSTextField *_detailLastTimeContent;
    IBOutlet NSTextField *_detailCreateTimeContent;
    
    IMBDriveBaseManage *_driveBaseManage;
    NSString *_currentDevicePath;
    
    NSMutableDictionary *_tempDic;
    int _doubleclickCount;
    BOOL _doubleClick;
    NSMutableDictionary *_oldWidthDic;
    NSMutableDictionary *_oldDocwsidDic;
    
    BOOL _isShow;
    IMBDriveEntity *_curEntity;
    BOOL _isShowTranfer;
    ChooseLoginModelEnum _chooseLogModelEnmu;
//    BOOL _isEdit;
    BOOL _isTableViewEdit;
    NSTextField *_editTextField;
}
- (id)initWithDrivemanage:(IMBDriveBaseManage *)driveManage withDelegete:(id)delegete withChooseLoginModelEnum:(ChooseLoginModelEnum) chooseLogModelEnum;

@end
