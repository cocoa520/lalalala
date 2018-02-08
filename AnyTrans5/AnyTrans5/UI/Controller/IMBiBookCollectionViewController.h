//
//  IMBiBookCollectionViewController.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/30.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
@class IMBBGColoerView;
@class LoadingView;
@interface IMBiBookCollectionViewController : IMBBaseViewController
{
    IBOutlet IMBBGColoerView *_bgView;
    IBOutlet NSTextField *_mainTitle;
    IBOutlet NSBox *_mainBox;
    IBOutlet IMBWhiteView *_detailView;
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet IMBCustomHeaderTableView *_playlistTableView;
    IBOutlet IMBWhiteView *_lineView;
    
    IBOutlet NSView *_loadingView;
    IBOutlet LoadingView *_animationView;
    
    IBOutlet NSImageView *_bookBackImageView;
    IBOutlet NSImageView *_selectImageView;
    
    IMBAlertViewController *_alertView;
    NSOperationQueue *queue;
    BOOL loadFinished;
    NSMutableArray *_itemArry;
}
@property (nonatomic, retain)NSMutableArray *itemArry;

@end

@interface IMBiBookCollectionViewItem : NSCollectionViewItem


@end
