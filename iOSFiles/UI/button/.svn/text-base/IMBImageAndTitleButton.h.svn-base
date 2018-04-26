//
//  IMBImageAndTitleButton.h
//  AnyTrans
//
//  Created by iMobie on 8/6/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBImageAndTitleButton : NSButton {
    NSTrackingArea *_trackingArea;
    int _buttonType;
    NSImage *_mouseDownImage;
    NSImage *_mouseUpImage;
    NSImage *_mouseExitedImage;
    NSImage *_mouseEnteredImage;
    NSString *_titleName;
}
@property (nonatomic, retain) NSString *titleName;
-(void)mouseDownImage:(NSImage*) mouseDownImg withMouseUpImg:(NSImage *) mouseUpImg withMouseExitedImg:(NSImage *) mouseExiteImg mouseEnterImg:(NSImage *) mouseEnterImg withButtonName:(NSString *)buttonName;

@end
