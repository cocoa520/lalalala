//
//  IMBSingleBtnAlertController.h
//  iOSFiles
//
//  Created by iMobie on 2018/3/22.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBGeneralButton.h"
#import "IMBBorderRectAndColorView.h"



@interface IMBSingleBtnAlertController : NSViewController
{
    
    IMBBorderRectAndColorView *_singleBtnView;
    IBOutlet NSTextField *_singleBtnViewMsgLabel;
    IBOutlet IMBGeneralButton *_singleBtnViewOKBtn;
    
}

@property(nonatomic, retain)IMBBorderRectAndColorView *singleBtnView;
@property(nonatomic, retain)NSTextField *singleBtnViewMsgLabel;
@property(nonatomic, retain)IMBGeneralButton *singleBtnViewOKBtn;


@property(nonatomic, copy)void(^singleBtnOKClicked)(void);

@end