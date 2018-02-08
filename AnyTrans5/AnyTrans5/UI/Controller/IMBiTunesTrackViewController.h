//
//  IMBiTunesTrackViewController.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBiTunes.h"
#import "LoadingView.h"
#import "IMBBackgroundBorderView.h"
@interface IMBiTunesTrackViewController : IMBBaseViewController
{
    IBOutlet IMBBackgroundBorderView *_nodataBgVIew;
    IMBiTunes *_iTunes;
    int _distinguishedKindId;
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSView *_containTableView;
    IBOutlet NSScrollView *_scroView;
    IBOutlet NSBox *_mainBox;
    IBOutlet NSView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
}
- (id)initWithDistinguishedKindId:(int)distingushedID withCategory:(CategoryNodesEnum)category withDelegate:(id)delegate;
- (void)reloadList:(int)sender;
@end
