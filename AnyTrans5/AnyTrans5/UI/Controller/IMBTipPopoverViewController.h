//
//  IMBTipPopoverViewController.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/31.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PopoverRootView.h"


@interface IMBTipPopoverViewController : NSViewController<NSTextViewDelegate>

{
    IBOutlet PopoverRootView *_bgView;
    IBOutlet NSTextField *_tipTitle;
    IBOutlet NSTextView *_textView;
}
@end
