//
//  IMBTransferPopoverController.h
//  AnyTransforCloud
//
//  Created by hym on 09/05/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMBSelectedButton;

@interface IMBTransferPopoverController : NSViewController
{
    IBOutlet NSTextField *_mainTitle;
    IBOutlet IMBSelectedButton *_cancelBtn;
    IBOutlet IMBSelectedButton *_okBtn;
    
    id _delegate;
}
@property (nonatomic, assign) id delegate;
@end
