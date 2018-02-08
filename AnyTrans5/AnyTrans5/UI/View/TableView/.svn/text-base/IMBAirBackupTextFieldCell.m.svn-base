//
//  IMBAirBackupTextFieldCell.m
//  AnyTrans
//
//  Created by smz on 17/10/27.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBAirBackupTextFieldCell.h"
#import "StringHelper.h"

@implementation IMBAirBackupTextFieldCell
@synthesize devcieImage = _deviceImage;
@synthesize backupDate = _backupDate;
@synthesize backupSize = _backupSize;
@synthesize dateColor = _dateColor;
@synthesize sizeColor = _sizeColor;
@synthesize highLightColor = _highLightColor;
@synthesize fontSize = _fontSize;

- (void)dealloc
{
    if (_deviceImage != nil) {
        [_deviceImage release];
        _deviceImage = nil;
    }
    if (_backupDate != nil) {
        [_backupDate release];
        _backupDate = nil;
    }
    if (_backupSize != nil) {
        [_backupSize release];
        _backupSize = nil;
    }
    if (_dateColor != nil) {
        [_dateColor release];
        _dateColor = nil;
    }
    if (_sizeColor != nil) {
        [_sizeColor release];
        _sizeColor = nil;
    }
    if (_highLightColor != nil) {
        [_highLightColor release];
        _highLightColor = nil;
    }
    [super dealloc];
}

- (void)awakeFromNib
{
    _watchButton = [[IMBSignOutButton alloc] initWithFrame:NSMakeRect(266 + 5 + 18, 12, 18, 12)];
    [_watchButton setToolTip:CustomLocalizedString(@"AirBackupDeviceInfo_Forget", nil)];
    _watchButton.mouseEnteredImage = [StringHelper imageNamed:@"airbackup_view"];
    _watchButton.mouseDownImage = [StringHelper imageNamed:@"airbackup_view2"];
    _watchButton.mouseExitedImage = [StringHelper imageNamed:@"airbackup_view3"];
    [_watchButton setTarget:self];
    [_watchButton setAction:@selector(watchBtnClick)];
    _btnRect = _watchButton.frame;
    [self initProperties];
}

#pragma mark - 查看按钮点击
- (void)watchBtnClick {
    
}

- (void)initProperties
{
    _dateColor = [[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] retain];
    _sizeColor = [[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] retain];
    _highLightColor = [[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)] retain];
    _fontSize = 12.0f;
}

-(id)copyWithZone:(NSZone *)zone {
    IMBAirBackupTextFieldCell *cell = (IMBAirBackupTextFieldCell *)[super copyWithZone:zone];
    cell->_deviceImage = [_deviceImage retain];
    cell->_backupDate = [_backupDate retain];
    cell->_backupSize = [_backupSize retain];
    cell->_dateColor = [_dateColor retain];
    cell->_sizeColor = [_sizeColor retain];
    cell->_highLightColor = [_highLightColor retain];
    
    return cell;
}

-(void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView{
    if (_deviceImage != nil) {
        _imageRect.origin.x = 12;
        _imageRect.origin.y = (36 - _deviceImage.size.height)/2.0;
        _imageRect.size = _deviceImage.size;
        [_deviceImage drawInRect:_imageRect];
    }
    if (_backupDate != nil) {
        NSRect rect = [StringHelper calcuTextBounds:_backupDate fontSize:12.0];
        _dateRect.origin.x = _imageRect.origin.x + _deviceImage.size.width + 10;
        _dateRect.origin.y = (36 - rect.size.height)/2.0;
        _dateRect.size = rect.size;
        NSColor *color;
        if (self.isHighlighted) {
            color = _highLightColor;
        } else {
            color = _dateColor;
        }
        NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:_fontSize];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[font, color] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName]];
        [_backupDate drawInRect:_dateRect withAttributes:dic];
    }
    
    if (_backupSize != nil) {
        NSRect rect = [StringHelper calcuTextBounds:_backupSize fontSize:12.0];
        _sizeRect.origin.x = 266 - 8 - rect.size.width;
        _sizeRect.origin.y = (36 - rect.size.height)/2.0;
        _sizeRect.size = rect.size;
        NSColor *color;
        if (self.isHighlighted) {
            color = _highLightColor;
        } else {
            color = _sizeColor;
        }
        NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:_fontSize];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[font, color] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName]];
        [_backupSize drawInRect:_sizeRect withAttributes:dic];
    }
    if (_watchButton != nil) {
        [_watchButton drawRect:_btnRect];
    }
}

@end
