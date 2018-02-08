//
//  IMBToolTipViewController.h
//  iMobieTrans
//
//  Created by Pallas on 7/30/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMBToolTipView;
@interface IMBToolTipViewController : NSViewController {
    NSString *_category;
    @private
    NSString *_toolTipStr;
    IBOutlet NSTextField *tbToolTip;
    
    IBOutlet IMBToolTipView *_toolTipView;
}
@property (nonatomic,retain) NSString *category;
- (id)initWithToolTip:(NSString*)toolTipStr;

@end
