//
//  IMBTwoBtnsAlertController.h
//  iOSFiles
//
//  Created by iMobie on 2018/3/22.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBMyDrawCommonly.h"
#import "IMBBorderRectAndColorView.h"


@interface IMBTwoBtnsAlertController : NSViewController
{
    
    IMBBorderRectAndColorView *_twoBtnsView;
    IBOutlet NSTextField *_twoBtnsViewMsgView;
    IBOutlet IMBMyDrawCommonly *_twoBtnsViewCancelBtn;
    IBOutlet IMBMyDrawCommonly *_twoBtnsViewOKBtn;
    
}

@property(nonatomic, retain)IMBBorderRectAndColorView *twoBtnsView;
@property(nonatomic, retain)NSTextField *twoBtnsViewMsgView;
@property(nonatomic, retain)IMBMyDrawCommonly *twoBtnsViewCancelBtn;
@property(nonatomic, retain)IMBMyDrawCommonly *twoBtnsViewOKBtn;


@property(nonatomic, copy)void(^twoBtnsViewOKClicked)(void);
@property(nonatomic, copy)void(^twoBtnsViewCancelClicked)(void);
@end
