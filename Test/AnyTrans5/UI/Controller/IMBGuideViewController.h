//
//  IMBGuideViewController.h
//  
//
//  Created by ding ming on 16/10/22.
//
//

#import "IMBBaseViewController.h"
#import "IMBGuideButton.h"
#import "IMBGuideView.h"
@interface IMBGuideViewController : IMBBaseViewController {
    
    IBOutlet NSImageView *_guideImageView;
    IBOutlet NSImageView *_guideArrowView;
    IBOutlet NSTextField *_guideTextField;
    IBOutlet IMBGuideButton *_guideNextBtn;
    IBOutlet IMBGuideButton *_guideSkipBtn;
    
//    IBOutlet IMBGuideView *_guideView;
    int i;

    IBOutlet NSImageView *_backGroundWhiteView;
    IBOutlet NSImageView *_topFourBtnImgView;
    IBOutlet NSImageView *_deviceImageView;
    IBOutlet NSImageView *_deviceGroundWhiteView;
    IBOutlet NSView *_toolBarView;

    IBOutlet NSImageView *_middleRoundImgView;

    IBOutlet NSImageView *_toolBarButtonImageView;

    IMBGuideView *_guideView;
    NSView *_middleView;
    NSView *_addBtnView;
    BOOL _isDownNextBtn;
    IBOutlet NSImageView *_leftRroundWtImg;
    IBOutlet NSImageView *_leftTopImg;
    IBOutlet NSImageView *_leftBommotImg;
    int _wide;
}
- (id)initWithDeviceWide:(int)wide;
@property (assign) IBOutlet NSView *addBtnView;
@property (assign) IBOutlet IMBGuideView *guideView;
@property (assign) IBOutlet NSView *middleView;

@end
