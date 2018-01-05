//
//  IMBMusicListViewController.h
//  iMobieTrans
//
//  Created by iMobie on 14-5-9.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
#import "LoadingView.h"
@interface IMBTracksListViewController : IMBBaseViewController
{
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSView *_contentView;
    IBOutlet NSBox *_mainBox;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    IBOutlet NSBox *_loadingBox;
    IMBLogManager *_logManger;
    NSNotificationCenter *_nc;
}

@end
