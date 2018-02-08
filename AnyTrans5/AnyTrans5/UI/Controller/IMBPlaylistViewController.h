//
//  IMBPlaylistViewController.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBiTunes.h"
#import "IMBTabTableView.h"
@interface IMBPlaylistViewController : IMBBaseViewController
{
    IMBiTunes *_iTunes;
    IBOutlet IMBCustomHeaderTableView *_playlistTableView;
    IBOutlet IMBWhiteView *_topLevelLineView;
    IBOutlet IMBWhiteView *_bottomLevelLineView;
    IBOutlet IMBWhiteView *_verticalLineView;
    IBOutlet NSScrollView *_playlistScroView;
    IBOutlet NSScrollView *_scroView;
    IBOutlet NSBox *_rightMainBox;
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSView *_containTableView;
}

- (id)initWithCategory:(CategoryNodesEnum)category  withDelegate:(id)delegate;
- (void)reloadList:(int)sender;
@end
