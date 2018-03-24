//
//  IMBMainBigSizeDropboxView.h
//  iOSFiles
//
//  Created by iMobie on 2018/3/20.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBMainBigSizeDropboxView : NSView
{
    @private
    
    IBOutlet NSTextField *_titleLabel;
    IBOutlet NSImageView *_imageView;
    IBOutlet NSTextField *_messageLabel;
    IBOutlet NSButton *_goNowBtn;
}
@end
