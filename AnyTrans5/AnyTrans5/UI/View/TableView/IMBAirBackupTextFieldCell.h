//
//  IMBAirBackupTextFieldCell.h
//  AnyTrans
//
//  Created by smz on 17/10/27.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBSignOutButton.h"

@interface IMBAirBackupTextFieldCell : NSTextFieldCell {
    NSImage *_deviceImage;
    NSString *_backupDate;
    NSString *_backupSize;
    IMBSignOutButton *_watchButton;
    NSColor *_dateColor;
    NSColor *_sizeColor;
    NSColor *_highLightColor;
    float _fontSize;
    NSRect _imageRect;
    NSRect _dateRect;
    NSRect _sizeRect;
    NSRect _btnRect;
}
@property (nonatomic,retain) NSImage *devcieImage;
@property (nonatomic,retain) NSString *backupDate;
@property (nonatomic,retain) NSString *backupSize;
@property (nonatomic,retain) NSColor *dateColor;
@property (nonatomic,retain) NSColor *sizeColor;
@property (nonatomic,retain) NSColor *highLightColor;
@property (nonatomic,assign) float fontSize;

@end
