//
//  IMBAllMediaViewController.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBiTunes.h"
#import "IMBLackCornerView.h"
@class LoadingView;
@interface IMBAllMediaViewController : IMBBaseViewController
{
     IMBiTunes *_iTunes;
    NSArray *_bindingArray;
//    NSMutableArray *_itemArray;
    int _distinguishedKindId;
    
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet IMBWhiteView *_containTableView;
    IBOutlet NSScrollView *_scroView;
    IBOutlet NSBox *_mainBox;
    IBOutlet IMBWhiteView *_animationView;
    IBOutlet LoadingView *_loadingView;
}
- (id)initWithDistinguishedKindId:(int)distingushedID withDelegate:(id)delegate;;
- (void)reloadList:(int)sender;
@end
