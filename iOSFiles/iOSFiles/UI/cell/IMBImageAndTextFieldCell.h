//
//  IMBImageAndTextFieldCell.h
//  iOSFiles
//
//  Created by JGehry on 3/8/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBCenterTextFieldCell.h"

@interface IMBImageAndTextFieldCell : IMBCenterTextFieldCell
{
@private
    NSImage *_image;
    NSSize _imageSize;
    int _marginX;
    int _paddingX;
    CGFloat _reserveWidth;
    BOOL _isDownloadComplete;
    //扩展
    NSImage *_rightImage; //文字右边图
    NSSize _rightSize;
    NSImage *_encryptedImg;
    NSImage *_damageImg;
    BOOL _isOneRow;
    BOOL _isDrawBgImg;
    NSImage *_deleteImage;
    NSInteger _messageCount;
    BOOL _isShowMessageCount;
    
}
@property(readwrite, retain) NSImage *deleteImage;
@property(readwrite, retain) NSImage *image;
@property(nonatomic,retain) NSImage *rightImage;
@property(assign) NSSize imageSize;
@property(assign) NSSize rightSize;
@property(assign) int marginX;
@property(assign) int paddingX;
@property(assign) CGFloat reserveWidth;
@property(nonatomic, readwrite) BOOL isDownloadComplete;
@property(nonatomic, retain) NSImage *encrytedImg;
@property(nonatomic, retain) NSImage *damageImg;
@property(nonatomic, assign) BOOL isOneRow;
@property(nonatomic, assign) BOOL isDrawBgImg;
@property(nonatomic, assign) NSInteger messageCount;
@property(nonatomic, assign) BOOL isShowMessageCount;

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
- (NSSize)cellSize;
@end
