//
//  IMBGuideViewController.m
//  
//
//  Created by ding ming on 16/10/22.
//
//

#import "IMBGuideViewController.h"
#import "IMBNotificationDefine.h"
#import "IMBSoftWareInfo.h"
@interface IMBGuideViewController ()

@end

@implementation IMBGuideViewController
@synthesize addBtnView = _addBtnView;
@synthesize guideView = _guideView;
@synthesize middleView = _middleView;

-(void)dealloc{
    [super dealloc];
    [[NSNotificationCenter defaultCenter]removeObserver:nil name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    
}

- (id)initWithDeviceWide:(int)wide
{
    if (self = [super initWithNibName:@"IMBGuideViewController" bundle:nil]) {
        _wide = wide;
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_isDownNextBtn){
            int  count = i -1;
            if (count == 0) {
                [_guideTextField setStringValue:CustomLocalizedString(@"Guide_View_id2", nil)];
            }else if (count == 1) {
                [_guideTextField setStringValue:CustomLocalizedString(@"Guide_View_id3", nil)];
            }else if (count == 2) {
                [_guideTextField setStringValue:CustomLocalizedString(@"Guide_View_id4", nil)];
            }
        }else{
            [_guideTextField setStringValue:CustomLocalizedString(@"Guide_View_id1", nil)];
        }
        [_guideNextBtn setButtonName:CustomLocalizedString(@"Guide_View_Btn1", nil)];
        [_guideSkipBtn setButtonName:CustomLocalizedString(@"Guide_View_Btn2", nil)];
    });
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name: NOTIFY_CHANGE_ALLANGUAGE object:nil];
    i = 0;
    [_guideTextField setStringValue:CustomLocalizedString(@"Guide_View_id1", nil)];
 
    
    [_guideArrowView setImage:[StringHelper imageNamed:@"guide_arrow1"]];
    [_guideNextBtn reSetInit:CustomLocalizedString(@"Guide_View_Btn1", nil) isChange:NO];
    [_guideSkipBtn reSetInit:CustomLocalizedString(@"Guide_View_Btn2", nil) isChange:YES];
    [_guideNextBtn mouseDownImg:[StringHelper imageNamed:@"nextbtn3"] mouseEnterImg:[StringHelper imageNamed:@"nextbtn2"] mouseExiteImg:[StringHelper imageNamed:@"nextbtn"]];
    
    [_guideNextBtn setTarget:self];
    [_guideNextBtn setAction:@selector(doNext:)];
    [_guideSkipBtn setTarget:self];
    [_guideSkipBtn setAction:@selector(doSkip:)];

    NSString *pdfFilePath1 = [[TempHelper getAppiMobieConfigPath] stringByAppendingPathComponent:@"device.pdf"];
    //    NSData *data  =  [NSData dataWithContentsOfFile:pdfFilePath];
    //    NSImage *sourceImage = [[NSImage alloc] initWithData:data];
    [_leftRroundWtImg setImage:[StringHelper imageNamed:@"bg4"]];
    [_leftTopImg setImage:[StringHelper imageNamed:@"mainFrame_tool2"]];
    [_leftBommotImg setImage:[StringHelper imageNamed:@"mainFrame_switch1"]];
    [_deviceGroundWhiteView setImage:[StringHelper imageNamed:@"bg2"]];
    [_backGroundWhiteView setHidden:YES];
    if ([IMBSoftWareInfo singleton].isRegistered){
        [_backGroundWhiteView setImage:[StringHelper imageNamed:@"bg1"]];
    }else{
        [_backGroundWhiteView setFrame:NSMakeRect(_backGroundWhiteView.frame.origin.x , _backGroundWhiteView.frame.origin.y, 226, 34 )];
        [_topFourBtnImgView setFrame:NSMakeRect(_topFourBtnImgView.frame.origin.x +20 +300, _topFourBtnImgView.frame.origin.y, _topFourBtnImgView.frame.size.width, _topFourBtnImgView.frame.size.height)];
        [_backGroundWhiteView setImage:[StringHelper imageNamed:@"bg5"]];
    }
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"blackSkin"]) {
        [_backGroundWhiteView setHidden:YES];
    }
    
    
    [_middleRoundImgView setImage:[StringHelper imageNamed:@"bg3"]];
    NSData *data1  =  [NSData dataWithContentsOfFile:pdfFilePath1];
    NSImage *sourceImage1 = [[NSImage alloc] initWithData:data1];
    [_deviceImageView setImage:sourceImage1];
    [sourceImage1 release];
    [_deviceImageView setHidden:YES];
    [_toolBarView setHidden:YES];
    [_middleRoundImgView setHidden:YES];
    [_deviceGroundWhiteView setHidden:YES];

}
- (IBAction)doNext:(id)sender {
    _isDownNextBtn = YES;
    if (i == 0) {
        i++;
        [_guideTextField setStringValue:CustomLocalizedString(@"Guide_View_id2", nil)];
        [_guideArrowView setFrame:NSMakeRect(_deviceGroundWhiteView.frame.origin.x + _deviceGroundWhiteView.frame.size.width/2 - 6, _deviceGroundWhiteView.frame.origin.y - _guideArrowView.frame.size.height - 6, _guideArrowView.frame.size.width, _guideArrowView.frame.size.height)];
        [_guideTextField setFrame:NSMakeRect(30, _guideArrowView.frame.origin.y - 4 - _guideTextField.frame.size.height, 340, _guideTextField.frame.size.height)];
        [_guideNextBtn setFrame:NSMakeRect(_deviceGroundWhiteView.frame.origin.x +(_deviceGroundWhiteView.frame.size.width - _guideNextBtn.frame.size.width)/2, _guideTextField.frame.origin.y - _guideNextBtn.frame.size.height +20 -10, _guideNextBtn.frame.size.width, _guideNextBtn.frame.size.height)];
        [_backGroundWhiteView setHidden:YES];
        [_topFourBtnImgView setHidden:YES];
        [_toolBarButtonImageView setHidden:YES];
        [_deviceImageView setHidden:NO];
        [_deviceGroundWhiteView setHidden:NO];
        [_guideArrowView setAutoresizingMask: NSViewMaxXMargin|NSViewMinYMargin];
        [_guideTextField setAutoresizingMask: NSViewMaxXMargin|NSViewMinYMargin];
        [_guideNextBtn setAutoresizingMask: NSViewMaxXMargin|NSViewMinYMargin];
    }else if (i == 1) {
        i ++;
        [_guideTextField setStringValue:CustomLocalizedString(@"Guide_View_id3", nil)];
        [_guideArrowView setFrame:NSMakeRect(_middleRoundImgView.frame.origin.x +60 +10 +10, _middleRoundImgView.frame.origin.y - _guideArrowView.frame.size.height - 4 +10, _guideArrowView.frame.size.width, _guideArrowView.frame.size.height)];
        [_guideTextField setFrame:NSMakeRect(_guideArrowView.frame.origin.x - _guideTextField.frame.size.width/2 +20, _guideArrowView.frame.origin.y - 4 - _guideTextField.frame.size.height +4, _guideTextField.frame.size.width, _guideTextField.frame.size.height)];
        [_guideNextBtn setFrame:NSMakeRect(_guideTextField.frame.origin.x +(_guideTextField.frame.size.width - _guideNextBtn.frame.size.width)/2, _guideTextField.frame.origin.y  +16 +10 - _guideNextBtn.frame.size.height, _guideNextBtn.frame.size.width, _guideNextBtn.frame.size.height)];
        [_middleView addSubview:_guideArrowView];
        [_middleView addSubview:_guideTextField];
        [_middleView addSubview:_guideNextBtn];
        [_deviceImageView setHidden:YES];
        [_middleRoundImgView setHidden:NO];
        [_deviceGroundWhiteView setHidden:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GUIDEVIEW_MAIN_DOWN object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GUIDEVIEW_ADDBUTTON object:self];
        [_guideArrowView setAutoresizingMask: NSViewNotSizable];
        [_guideTextField setAutoresizingMask: NSViewNotSizable];
        [_guideNextBtn setAutoresizingMask: NSViewNotSizable];
    }else if (i == 2) {
        i ++;
        [_guideTextField setStringValue:CustomLocalizedString(@"Guide_View_id4", nil)];
        [_guideArrowView setImage:[StringHelper imageNamed:@"guide_arrow2"]];
        [_guideArrowView setFrame:NSMakeRect(_toolBarView.frame.origin.x - _guideArrowView.frame.size.width , _toolBarView.frame.origin.y + (_toolBarView.frame.origin.y - _guideArrowView.frame.size.height)/2 , _guideArrowView.frame.size.width, _guideArrowView.frame.size.height)];
        [_guideTextField setFrame:NSMakeRect(_guideArrowView.frame.origin.x - _guideTextField.frame.size.width -10, _guideArrowView.frame.origin.y - 40 , _guideTextField.frame.size.width, _guideTextField.frame.size.height)];
        [_guideNextBtn setFrame:NSMakeRect(_guideTextField.frame.origin.x +(_guideTextField.frame.size.width - _guideNextBtn.frame.size.width)/2, _guideTextField.frame.origin.y +10 - _guideNextBtn.frame.size.height, _guideNextBtn.frame.size.width, _guideNextBtn.frame.size.height)];
        [_toolBarView setHidden:NO];
        [_middleRoundImgView setHidden:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GUIDEVIEW_REMOVEADDBUTTON object:self];
        [_guideArrowView removeFromSuperview];
        [_guideTextField removeFromSuperview];
        [_guideNextBtn removeFromSuperview];
        [_guideView addSubview:_guideArrowView];
        [_guideView addSubview:_guideTextField];
        [_guideView addSubview:_guideNextBtn];
        [_guideArrowView setAutoresizingMask: NSViewMinXMargin];
        [_guideTextField setAutoresizingMask: NSViewMinXMargin];
        [_guideNextBtn setAutoresizingMask: NSViewMinXMargin];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GUIDEVIEW_CLOSE object:nil];
        [self doSkip:nil];
    }
}

- (IBAction)doSkip:(id)sender {
    [self.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GUIDEVIEW_CLOSE object:nil];
}

@end
