//
//  IMBPurchaseOrAnnoyController.m
//  AllFiles
//
//  Created by iMobie on 2018/4/19.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBPurchaseOrAnnoyController.h"
#import "IMBHoverChangeImageBtn.h"
#import "IMBPurchaseMiddleController.h"
#import "IMBPurchaseLeftNumController.h"
#import "IMBPurchaseTopVerifyController.h"
#import "IMBPurchaseBottomButtonController.h"
#import "IMBPurchaseBottomVerifyController.h"


#import "IMBViewAnimation.h"


@interface IMBPurchaseOrAnnoyController ()

@end

@implementation IMBPurchaseOrAnnoyController
@synthesize whiteView = _whiteView;
#pragma mark - 工厂方法
+ (instancetype)purchase {
    CGFloat viewX = 76.f;
    
    IMBPurchaseOrAnnoyController *vc = [[IMBPurchaseOrAnnoyController alloc] initWithNibName:@"IMBPurchaseOrAnnoyController" bundle:nil];
    
    IMBPurchaseBottomButtonController *bottomVc = [[IMBPurchaseBottomButtonController alloc] initWithNibName:@"IMBPurchaseBottomButtonController" bundle:nil];
    bottomVc.view.imb_origin = NSMakePoint(viewX, 20.f);
    bottomVc.purchaseButtonTitle = CustomLocalizedString(@"Purchase_in_website", nil);
    bottomVc.messageLabel.hidden = YES;
    bottomVc.toActiveViewBtn.hidden = YES;
    bottomVc.btnClicked = ^ {
        //按钮点击
        //http://iphone-utility.com/go/store.php?product=af&os=win&v=1.0.0&id=0
        NSString *hoStr = CustomLocalizedString(@"click_to_purchase_url", nil);
        NSURL *url = [NSURL URLWithString:hoStr];
        NSWorkspace *ws = [NSWorkspace sharedWorkspace];
        [ws openURL:url];
    };
    [vc.view addSubview:bottomVc.view];
    
    IMBPurchaseMiddleController *middleVc = [[IMBPurchaseMiddleController alloc] initWithNibName:@"IMBPurchaseMiddleController" bundle:nil];
    middleVc.view.imb_origin = NSMakePoint(viewX, 182.f);
    
    middleVc.firstImage.image = [NSImage imageNamed:@"buy_icon01"];
    middleVc.secondImage.image = [NSImage imageNamed:@"buy_icon02"];
    middleVc.thirdImage.image = [NSImage imageNamed:@"buy_icon03"];
    middleVc.forthImage.image = [NSImage imageNamed:@"buy_icon07"];
    middleVc.fifthImage.image = [NSImage imageNamed:@"buy_icon06"];
    middleVc.sixthImage.image = [NSImage imageNamed:@"buy_icon08"];
    
    middleVc.firstLabel.stringValue = CustomLocalizedString(@"Purchase_text_001", nil);
    middleVc.secondLabel.stringValue = CustomLocalizedString(@"Purchase_text_002", nil);
    middleVc.thirdLabel.stringValue = CustomLocalizedString(@"Purchase_text_003", nil);
    middleVc.forthLabel.stringValue = CustomLocalizedString(@"Purchase_text_007", nil);
    middleVc.fifthLabel.stringValue = CustomLocalizedString(@"Purchase_text_006", nil);
    middleVc.sixthLabel.stringValue = CustomLocalizedString(@"Purchase_text_008", nil);
    
    middleVc.leftMsgLabel.hidden = YES;
    middleVc.rightMsgLabel.hidden = YES;
    
    middleVc.titleLabel.stringValue = CustomLocalizedString(@"Purchase_OfficialVersion_Welfare", nil);
    
    [vc.view addSubview:middleVc.view];
    
    IMBPurchaseTopVerifyController *topVc = [[IMBPurchaseTopVerifyController alloc] initWithNibName:@"IMBPurchaseTopVerifyController" bundle:nil];
    topVc.view.imb_origin = NSMakePoint(viewX, 475.f);
    [vc.view addSubview:topVc.view];
    
    
//    [bottomVc release];
//    bottomVc = nil;
    [middleVc release];
    middleVc = nil;
    [topVc release];
    topVc = nil;
    
    return vc;
}

+ (instancetype)annoyWithToMacLeftNum:(NSInteger)toMacLeftNum toDeviceLeftNum:(NSInteger)toDeviceLeftNum toCloudLeftNum:(NSInteger)toCloudLeftNum {
    CGFloat viewX = 76.f;
    IMBPurchaseBottomVerifyController *bottomVerifyVc = [[IMBPurchaseBottomVerifyController alloc] initWithNibName:@"IMBPurchaseBottomVerifyController" bundle:nil];
    IMBPurchaseOrAnnoyController *vc = [[IMBPurchaseOrAnnoyController alloc] initWithNibName:@"IMBPurchaseOrAnnoyController" bundle:nil];
    IMBPurchaseBottomButtonController *bottomVc = [[IMBPurchaseBottomButtonController alloc] initWithNibName:@"IMBPurchaseBottomButtonController" bundle:nil];
    vc.mouseClicked = ^{
        bottomVc.view.hidden = NO;
        [IMBViewAnimation animationPositionYWithView:bottomVc.view toY:20.f timeInterval:0.35f completion:^{
            
        }];
        
        [IMBViewAnimation animationPositionYWithView:bottomVerifyVc.view toY:-bottomVc.view.imb_height timeInterval:0.2f completion:^{
            bottomVerifyVc.view.hidden = YES;
        }];
    };
    
    [vc.view addSubview:bottomVc.view];
    bottomVc.view.imb_origin = NSMakePoint(viewX, 20.f);
    bottomVc.topView.hidden = YES;
    bottomVc.purchaseButtonTitle = CustomLocalizedString(@"Purchase_with_halfPrice", nil);
    bottomVc.msgLabel.hidden = YES;
    
    
    bottomVc.toActiveViewBtnClicked = ^{
        //toActiveViewBtnClicked
        bottomVerifyVc.view.hidden = NO;
        [vc.view addSubview:bottomVerifyVc.view];
        bottomVerifyVc.view.frame = NSMakeRect(viewX, - bottomVc.view.imb_height, 928.f, 100.f);
        
        [IMBViewAnimation animationPositionYWithView:bottomVc.view toY:80.f timeInterval:0.15f completion:^{
            bottomVc.view.hidden = YES;
        }];
        
        [IMBViewAnimation animationPositionYWithView:bottomVerifyVc.view toY:20.f timeInterval:0.35f completion:^{
            
        }];
    };
    bottomVc.btnClicked = ^ {
        //按钮点击
        //http://iphone-utility.com/go/store.php?product=af&os=win&v=1.0.0&id=1
        NSString *hoStr = CustomLocalizedString(@"click_to_half_purchase_url", nil);
        NSURL *url = [NSURL URLWithString:hoStr];
        NSWorkspace *ws = [NSWorkspace sharedWorkspace];
        [ws openURL:url];
        
        
    };
    
    IMBPurchaseMiddleController *middleVc = [[IMBPurchaseMiddleController alloc] initWithNibName:@"IMBPurchaseMiddleController" bundle:nil];
    [vc.view addSubview:middleVc.view];
    middleVc.firstImage.image = [NSImage imageNamed:@"buy_icon01"];
    middleVc.secondImage.image = [NSImage imageNamed:@"buy_icon02"];
    middleVc.thirdImage.image = [NSImage imageNamed:@"buy_icon03"];
    middleVc.forthImage.image = [NSImage imageNamed:@"buy_icon04"];
    middleVc.fifthImage.image = [NSImage imageNamed:@"buy_icon05"];
    middleVc.sixthImage.image = [NSImage imageNamed:@"buy_icon08"];
    
    middleVc.firstLabel.stringValue = CustomLocalizedString(@"Purchase_text_001", nil);
    middleVc.secondLabel.stringValue = CustomLocalizedString(@"Purchase_text_002", nil);
    middleVc.thirdLabel.stringValue = CustomLocalizedString(@"Purchase_text_003", nil);
    middleVc.forthLabel.stringValue = CustomLocalizedString(@"Purchase_text_004", nil);
    middleVc.fifthLabel.stringValue = CustomLocalizedString(@"Purchase_text_005", nil);
    middleVc.sixthLabel.stringValue = CustomLocalizedString(@"Purchase_text_008", nil);
    
    
    middleVc.view.imb_origin = NSMakePoint(viewX, 182.f);
    
    
    IMBPurchaseLeftNumController *topVc = [[IMBPurchaseLeftNumController alloc] initWithNibName:@"IMBPurchaseLeftNumController" bundle:nil];
    topVc.view.imb_origin = NSMakePoint(viewX, 475.f);
    topVc.leftNums = @[@(toMacLeftNum),@(toDeviceLeftNum),@(toCloudLeftNum)];
    [vc.view addSubview:topVc.view];
    
    
//    [bottomVc release];
//    bottomVc = nil;
    [middleVc release];
    middleVc = nil;
    [topVc release];
    topVc = nil;
    
    return vc;
}


#pragma mark - setup view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
}

- (void)setupView {
    [_closeWindowBtn setHoverImage:@"transferlist_history_icon_close_hover" withSelfImage:[NSImage imageNamed:@"transferlist_history_icon_close"]];
}



#pragma mark - 按钮点击
- (IBAction)closeWindowClicked:(id)sender {
    if (self.closeClicked) {
        self.closeClicked();
    }
}

#pragma mark - mouse event
- (void)mouseDown:(NSEvent *)theEvent {
    
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (self.mouseClicked) {
        self.mouseClicked();
    }
}

-(void)mouseMoved:(NSEvent *)theEvent {
    
}

- (void)mouseExited:(NSEvent *)theEvent {

}

-(void)mouseEntered:(NSEvent *)theEvent {

}

#pragma mark - dealloc

- (void)dealloc {
    [super dealloc];
    
}
@end
