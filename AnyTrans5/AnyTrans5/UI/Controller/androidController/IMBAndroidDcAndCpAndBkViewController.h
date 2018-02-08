//
//  IMBAndroidDcAndCpAndBkViewController.h
//  AnyTrans
//
//  Created by smz on 17/7/18.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "LoadingView.h"
@interface IMBAndroidDcAndCpAndBkViewController : IMBBaseViewController<NSTableViewDelegate,NSTableViewDataSource,IMBImageRefreshListListener> {
    
    IBOutlet NSBox *_mainBox;
    IBOutlet IMBCustomHeaderTableView *_listTableView;
    
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImage;
    IBOutlet NSTextView *_noDataText;
    IBOutlet NSTextView *_noDataTextTwo;
    IBOutlet NSView *_detailView;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAniamtionView;
    
}

@end
