//
//  IMBMainWindowDevicesView.h
//  iOSFiles
//
//  Created by iMobie on 2018/3/21.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBMainWindowDevicesView : NSView
{
    @private
    IBOutlet NSTextField *_titleLabel;
    IBOutlet NSTextField *_messageLabel;
    IBOutlet NSImageView *_imageView;
    
}
@end
