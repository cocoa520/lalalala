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
    NSImage *_lockImg;
    NSImage *_iCloudImg;
    //扩展
    NSImage *_rightImage; //文字右边图
    NSSize _rightSize;
    NSString *_imageStrName;
    NSString *_imageName;
    BOOL _isDataImage;//从data中获取的Image
    
}
@property (nonatomic, retain) NSString *imageName;
@property(readwrite, retain) NSImage *lockImg;
@property(readwrite, retain) NSImage *iCloudImg;
@property(readwrite, retain) NSImage *image;
@property(nonatomic,retain)NSImage *rightImage;
@property(assign) NSSize imageSize;
@property(assign) NSSize rightSize;
@property(assign) int marginX;
@property(assign) int paddingX;
@property(assign) CGFloat reserveWidth;
@property(readwrite, retain) NSString *imageStrName;
@property(nonatomic, assign) BOOL isDataImage;
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
- (NSSize)cellSize;
@end
