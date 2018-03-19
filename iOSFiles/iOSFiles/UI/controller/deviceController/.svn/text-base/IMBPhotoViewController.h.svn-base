//
//  IMBPhotoViewController.h
//  iOSFiles
//
//  Created by 龙凡 on 2018/3/16.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
#import "CNGridView.h"
#import "IMBInformationManager.h"
#import "IMBInformation.h"
@interface IMBPhotoViewController : IMBBaseViewController<CNGridViewDelegate,CNGridViewDataSource>
{
    IBOutlet CNGridView *_gridView;
    CategoryNodesEnum _categoryNodeEunm;
    IBOutlet NSView *_contentView;
}
- (id)initWithCategoryNodesEnum:(CategoryNodesEnum )nodeEnum withiPod:(IMBiPod *)iPod;
@end
