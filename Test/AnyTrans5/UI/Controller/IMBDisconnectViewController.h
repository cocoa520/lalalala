//
//  IMBDisconnectViewController.h
//  
//
//  Created by ding ming on 16/7/19.
//
//

#import "IMBBaseViewController.h"

@interface IMBDisconnectViewController : IMBBaseViewController {
    IBOutlet NSTextField *_titleTextField;
    IBOutlet NSTextField *_promptTextField;
    IBOutlet NSView *_noconnectView;
    IBOutlet NSImageView *_nonectimageView1;
    NSTimer *_timer;
    int count;
}

- (void)setPromptTextString:(NSString *)textStr;

- (void)addTimer;
- (void)killTimer;
- (void)setTimerNil;

@end
