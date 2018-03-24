//
//  IMBMainWindowLoginSuccessView.h
//  iOSFiles
//
//  Created by iMobie on 2018/3/20.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBHoverChangeImageBtn.h"


@interface IMBMainWindowLoginSuccessView : NSViewController
{
    @private
    
    IBOutlet NSImageView *_imageView;
    IBOutlet NSTextField *_sizeLabel;
    IBOutlet NSTextField *_nameLabel;
    
    IBOutlet IMBHoverChangeImageBtn *_logoutBtn;
}

@property(nonatomic, retain)NSImageView *imageView;
@property(nonatomic, retain)NSTextField *sizeLabel;
@property(nonatomic, retain)NSTextField *nameLabel;
@property(nonatomic, retain)NSButton *logoutBtn;

@property(nonatomic, copy)void(^quitBtnClicked)(void);

@end
