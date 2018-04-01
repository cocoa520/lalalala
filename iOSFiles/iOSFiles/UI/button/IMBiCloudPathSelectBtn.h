//
//  IMBiCloudPathSelectBtn.h
//  iOSFiles
//
//  Created by smz on 18/3/16.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBiCloudPathSelectBtn : NSButton {
    NSTrackingArea *_trackingArea;
    NSString *_buttonName;
    NSImage *_leftImage;
    BOOL _isHomePage;
    MouseStatusEnum _buttonType;
}
@property (nonatomic, retain) NSString *buttonName;

@end
