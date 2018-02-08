//
//  IMBBrowserBookMarkViewController.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBSegmentedControl.h"
#import "IMBBorderRectAndColorView.h"
#import "IMBWhiteView.h"
#import "IMBGeneralButton.h"
#import "customTextFiled.h"
#import "IMBCustomHeaderTableView.h"
@class IMBBookmarkEntity;
@class IMBSelectBrowserImageView;
typedef void(^ImportBookmarkBlock)(NSInteger tag,NSMutableArray  *bookmarkArray,NSInteger btag);

@interface IMBBrowserBookMarkViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate>
{
    IBOutlet NSImageView *_firefoxImageView;
    IBOutlet NSImageView *chromeImageView;
    IBOutlet NSImageView *_safariImageView;
    IBOutlet IMBBorderRectAndColorView *_browserBookMark;
    IBOutlet IMBWhiteView *_browserBgView;
    IBOutlet IMBSegmentedControl *_segController;
    IBOutlet IMBGeneralButton *_browerOkBtn;
    IBOutlet IMBGeneralButton *_browerCancelBtn;
    IBOutlet NSView *_browerCreateNewView;
    IBOutlet NSTextField *browerCreateNewTitle;
    IBOutlet IMBGeneralButton *_browerCreateNewAddBtn;
    IBOutlet IMBWhiteView *_browerCreateNewFirstBgView;
    IBOutlet customTextFiled *_browerCreateNewFirstInputTextFiled;
    IBOutlet IMBWhiteView *_browerCreateNewSecondBgView;
    IBOutlet customTextFiled *_browerCreateNewSecondInputTextFiled;
    IBOutlet IMBWhiteView *_browerCreateNewTableBgView;
    IBOutlet IMBCustomHeaderTableView *_browerCreateNewTableView;
    IBOutlet NSTextField *_browserCreatNewtipTitle;
    
    IBOutlet NSView *_importView;
    IBOutlet NSTextField *_importTitle;
    IBOutlet NSImageView *_importFirstImageView;
    IBOutlet NSImageView *_importSecondImageView;
    IBOutlet NSImageView *_importThirdImageView;
    IBOutlet IMBSelectBrowserImageView *_importFirstSelectImageView;
    IBOutlet IMBSelectBrowserImageView *_importSecondSelectImageView;
    IBOutlet IMBSelectBrowserImageView *_importThirdSelectImageView;
    
    NSView *_mainView;
    NSMutableArray *_allBookMarkArray;
    id _delegate;
    ImportBookmarkBlock _block;
    int _selectBrowserTag;
    int _segSelectTag;
}
@property (nonatomic ,retain) id delegate;
- (void)cancelBookMark:(IMBBookmarkEntity *)bookMark;
- (void)showBrowserWithAddButton:(NSString *)addText OkButton:(NSString *)OkText CancelButton:(NSString *)cancelText SuperView:(NSView *)superView ImportBookmarkBlock:(ImportBookmarkBlock)block;
- (void)cancelBtnClick:(id)sender;
@end
