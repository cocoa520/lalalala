//
//  IMBMsgDialog.m
//  iMobieTrans
//
//  Created by iMobie on 5/27/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBMsgDialog.h"
#import "IMBSMSChatDataEntity.h"
//#import "IMBHelper.h"
#import "StringHelper.h"
#import "IMBMsgImageInfo.h"

#define MINDIALOGWIDTH 60
@implementation IMBMsgDialog
@synthesize text = _text;
@synthesize displaySide = _displaySide;
@synthesize image = _image;
@synthesize msgData = _msgData;
@synthesize isiMessage = _isiMessage;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _displaySide = Left;
        if (self.text == nil) {
            [self setHidden:YES];
        }
    }
    return self;
}

- (id)init{
    if (self = [super init]) {
        _displaySide = Left;
    }
    return self;
}

- (void)setFrame:(NSRect)frameRect{
    [super setFrame:frameRect];
//    if (_displaySide != Right) {
//        _displaySide = Left;
//    }
//    if (self.text == nil) {
//        [self setHidden:YES];
//    }
}

- (void)setDisplaySide:(DisplaySide)displaySide{
    _displaySide = displaySide;
    [self setNeedsDisplay:YES];
}

- (void)viewWillMoveToSuperview:(NSView *)newSuperview{
    if (_imageArray != nil) {
        [_imageArray release];
        _imageArray = nil;
    }
    _imageArray = [[NSMutableArray alloc] init];
}

- (void)resizeRect{
    [self setHidden:NO];
    if (self.text == nil) {
        self.text = @"";
    }
    NSRect rect = self.frame;
    NSRect textRect = [self calcuTextBounds:self.text fontSize:12 width:rect.size.width];

    if (rect.size.height < textRect.size.height + 2*15 + 15) {
        rect.size.height = textRect.size.height + 2*15 + 15;
        [self setFrame:rect];
    }
    if (rect.size.width < MAX(textRect.size.width + 2*15,60)) {
        rect.size.width = textRect.size.width + 2*15;
        [self setFrame:rect];
    }
    [self setNeedsDisplay:YES];
}

- (void)setText:(NSString *)text{
    if (_text != text) {
        [_text release];
        _text = [text retain];
        [self resizeRect];
    }
}

- (void)setImage:(NSImage *)image {
    if (_image != image) {
        [_image release];
        _image = nil;
        _image = [image retain];
    }
   
   
    
}

- (void)setMsgData:(IMBMessageDataEntity *)msgData {
    if (_msgData != msgData) {
        [_msgData release];
        _msgData = nil;
        _msgData = [msgData retain];
        [self resizeSingleRect];
    }
   
}

- (void)resizeSingleRect {
    [self setHidden:NO];
    NSRect rect = self.frame;
    
    if (_msgData.isSent) {
        self.displaySide = Right;
    }else {
        self.displaySide = Left;
    }
    if ([_msgData.msgText rangeOfString:@"￼"].location != NSNotFound) {//包含附件
        if ([_msgData.msgText isEqualToString:@"￼"]) {//只有附件
            if (_msgData.isAttachments && _msgData.attachmentList != nil && _msgData.attachmentList.count > 0) {
                for (IMBSMSAttachmentEntity *attachEntity in _msgData.attachmentList) {
                    @autoreleasepool {
                        IMBAttachDetailEntity *detailEntity = nil;
                        if (attachEntity.attachDetailList.count > 0) {
                            detailEntity = [attachEntity.attachDetailList objectAtIndex:0];
                            if ([attachEntity.mimeType rangeOfString:@"image"].location != NSNotFound) {//附件是图片
                                NSImage *image = [[NSImage alloc] initWithContentsOfFile:detailEntity.backUpFilePath];
                                NSData *data = [self scalingImage:image withLenght:210];
                                NSImage *pressImage = [[NSImage alloc] initWithData:data];
                                self.image = pressImage;
                                //                            self.image = [StringHelper imageNamed:@"photo_show"];
                                [image release];
                                [pressImage release];
                                //NSRect imageRect = NSMakeRect(0, 0, 186, 130);
                                NSRect imageRect = [self scalImageRect:self.image.size.width withHeight:self.image.size.height];
                                rect.size.height = imageRect.size.height + 2*15 + 15;
                                rect.size.width = MAX(imageRect.size.width + 2*15,60);
                                [self setFrame:rect];
                                [self setNeedsDisplay:YES];
                            }else if ([attachEntity.mimeType rangeOfString:@"audio"].location != NSNotFound) {//附件是录音
                                self.text = @"";
                                self.image = [StringHelper imageNamed:@"message_audio"];
                                NSRect textRect = [self calcuTextBounds:self.text fontSize:12 width:rect.size.width];
                                rect.size.height = MAX(textRect.size.height + 2*15 + 15, self.image.size.height + 2*15 + 15);
                                rect.size.width = MAX(textRect.size.width + self.image.size.width + 2*15,60);
                                [self setFrame:rect];
                                [self setNeedsDisplay:YES];
                            }else {//附件是文本文件
                                self.text = detailEntity.fileName;
                                self.image = [StringHelper imageNamed:@"message_pdf"];
                                NSRect textRect = [self calcuTextBounds:self.text fontSize:12 width:rect.size.width];
                                rect.size.height = MAX(textRect.size.height + 2*15 + 15, self.image.size.height + 2*15 + 15);
                                rect.size.width = MAX(textRect.size.width + self.image.size.width + 2*15,60);
                                [self setFrame:rect];
                                [self setNeedsDisplay:YES];
                            }
                        }
                    }
                }
            }
        }else {//既有文字又有附件
            if (drawArray != nil) {
                [drawArray release];
                drawArray = nil;
            }
            drawArray = [[NSMutableArray alloc] init];
            NSString *textStr = [_msgData.msgText stringByReplacingOccurrencesOfString:@"￼" withString:@"☼☆☼"];
            NSArray *stringArray = [textStr componentsSeparatedByString:@"☼"];
            NSRect bgRect = NSMakeRect(0, 0, 0, 0);
            int idx = 0;
            for (NSString *string in stringArray) {
                @autoreleasepool {
                    if ([string isEqualToString:@"☆"]) {
                        if (_msgData.isAttachments && _msgData.attachmentList!= nil && _msgData.attachmentList.count > 0) {
                            NSImage *attachImage = nil;
                            NSString *nameString = nil;
                            if (idx < _msgData.attachmentCount) {
                                IMBSMSAttachmentEntity *attachEntity = [_msgData.attachmentList objectAtIndex:idx];
                                idx += 1;
                                if (attachEntity.attachDetailList.count > 0) {
                                    IMBAttachDetailEntity *detailEntity = [attachEntity.attachDetailList objectAtIndex:0];
                                    if ([attachEntity.mimeType rangeOfString:@"image"].location != NSNotFound) {//附件是图片
                                        NSImage *sourceImage = [[NSImage alloc] initWithContentsOfFile:detailEntity.backUpFilePath];
                                        // NSRect imageRect = NSMakeRect(0, 0, 186, 130);
                                        NSData *data = [self scalingImage:sourceImage withLenght:210];
                                        attachImage = [[NSImage alloc] initWithData:data];
                                        //                                    attachImage = [[StringHelper imageNamed:@"photo_show"] retain];
                                        [sourceImage release];
                                        NSRect imageRect = [self scalImageRect:attachImage.size.width withHeight:attachImage.size.height];
                                        bgRect.size.height = bgRect.size.height + imageRect.size.height + 2;
                                        if (bgRect.size.width < MAX(imageRect.size.width + 2*15,60)) {
                                            bgRect.size.width = MAX(imageRect.size.width + 2*15,60);
                                        }
                                    }else if ([attachEntity.mimeType rangeOfString:@"audio"].location != NSNotFound) {//附件是录音
                                        nameString = [@"00:00" stringByAppendingString:@"☼"];
                                        attachImage = [[StringHelper imageNamed:@"message_audio"] retain];
                                        NSRect textRect = [self calcuTextBounds:nameString fontSize:12 width:rect.size.width];
                                        bgRect.size.height = bgRect.size.height + MAX(textRect.size.height, attachImage.size.height) + 2;
                                        if (bgRect.size.width < MAX(textRect.size.width + attachImage.size.width + 2*15,60)) {
                                            bgRect.size.width = MAX(textRect.size.width + attachImage.size.width + 2*15,60);
                                        }
                                    }else {//附件是文本文件
                                        nameString = [detailEntity.fileName stringByAppendingString:@"☼"];
                                        attachImage = [[StringHelper imageNamed:@"message_pdf"] retain];
                                        NSRect textRect = [self calcuTextBounds:nameString fontSize:12 width:rect.size.width];
                                        bgRect.size.height = bgRect.size.height + MAX(textRect.size.height, attachImage.size.height) + 2;
                                        if (bgRect.size.width < MAX(textRect.size.width + attachImage.size.width + 2*15,60)) {
                                            bgRect.size.width = MAX(textRect.size.width + attachImage.size.width + 2*15,60);
                                        }
                                    }
                                    
                                    if (![StringHelper stringIsNilOrEmpty:nameString]) {
                                        [drawArray addObject:nameString];
                                        nameString = @"";
                                    }
                                    if (attachImage != nil) {
                                        [drawArray addObject:attachImage];
                                        [attachImage release];
                                    }
                                }
                            }
                        }
                    }else {
                        if (![StringHelper stringIsNilOrEmpty:string]) {
                            NSRect textRect = [self calcuTextBounds:string fontSize:12 width:rect.size.width];
                            bgRect.size.height = bgRect.size.height + textRect.size.height + 2;
                            if (bgRect.size.width < MAX(textRect.size.width + 2*15,60)) {
                                bgRect.size.width = MAX(textRect.size.width + 2*15,60);
                            }
                            [drawArray addObject:string];
                        }
                    }
                }
            }
            rect.size.height = bgRect.size.height + 2*15 + 15;
            rect.size.width = MAX(bgRect.size.width + 2*15,60);
            [self setFrame:rect];
            [self setNeedsDisplay:YES];
        }
    }else {//不包含附件
        if (![StringHelper stringIsNilOrEmpty:_msgData.msgText]) {
            self.text = _msgData.msgText;
            NSRect textRect = [self calcuTextBounds:self.text fontSize:12 width:rect.size.width];
            rect.size.height = textRect.size.height + 2*15 + 15;
            rect.size.width = MAX(textRect.size.width + 2*15,60);
            [self setFrame:rect];
            [self setNeedsDisplay:YES];
        }
    }
}

- (NSRect)scalImageRect:(float)imageW withHeight:(float)imageH {
    NSSize size = NSMakeSize(0, 0);
    if (imageW != 0 && imageH != 0) {
        size.width = 210;
        size.height = 210 * (imageH / imageW);
    }
    return NSMakeRect(0, 0, size.width, size.height);
}

- (void)dealloc{
    if (_text) {
        [_text release];
        _text = nil;
    }
    if (drawArray != nil) {
        [drawArray release];
        drawArray = nil;
    }
    if (_image) {
        [_image release];
        _image = nil;
    }
    if (_msgData) {
        [_msgData release];
        _msgData = nil;
    }
    if (_imageArray != nil) {
        [_imageArray release];
        _imageArray = nil;
    }
    [super dealloc];
}

- (BOOL)isFlipped{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
//    if (_imageArray != nil) {
//        [_imageArray release];
//        _imageArray = nil;
//    }
//    _imageArray = [[NSMutableArray alloc] init];
    
    NSRect textRect = self.frame;
    NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(0, 0, dirtyRect.size.width, textRect.size.height - 15) xRadius:10 yRadius:10];
    CGFloat originY = textRect.size.height - 15;
    
    if (_displaySide == Left) {
        [[NSColor colorWithDeviceRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:1.0] set];
        [bezierPath moveToPoint:NSMakePoint(10, originY)];
        [bezierPath curveToPoint:NSMakePoint(8, originY + 13) controlPoint1:NSMakePoint(13, originY + 6) controlPoint2:NSMakePoint(15, originY + 6)];
        [bezierPath curveToPoint:NSMakePoint(25, originY) controlPoint1:NSMakePoint(15, originY + 9) controlPoint2:NSMakePoint(15, originY + 9)];
        [bezierPath fill];
        
        NSRect drawingRect = NSMakeRect(15, 15, 0, 0);
        if (self.image != nil) {
            NSRect imageRect;
            imageRect.origin = NSZeroPoint;
            imageRect.size = self.image.size;
            drawingRect.origin = NSMakePoint(15, 15);
            if (self.image.size.width > 100 || self.image.size.height > 50) {
//                drawingRect.size = NSMakeSize(186, 130);
                drawingRect.size = [self scalImageRect:self.image.size.width withHeight:self.image.size.height].size;
            }else {
                drawingRect.size = self.image.size;
            }
            
            IMBMsgImageInfo *info = [[IMBMsgImageInfo alloc] init];
            info.msgRect = drawingRect;
            info.msgImage = self.image;
            [_imageArray addObject:info];
            [info release];
            
            [self.image drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        }
        
        if (self.text != nil) {
            NSRect textRect = [self calcuTextBounds:self.text fontSize:12 width:dirtyRect.size.width];
            float y = 0;
            NSRect rt;
            if (self.image != nil) {
                y = drawingRect.size.height + 15 - textRect.size.height;
                rt = NSMakeRect(drawingRect.origin.x + drawingRect.size.width + 2 , y, 290 - 2*15, textRect.size.height);
            }else {
                y = 15;
                rt = NSMakeRect(drawingRect.origin.x + drawingRect.size.width , y, 290 - 2*15, textRect.size.height);
            }
            [self drawText:self.text withFrame:rt withFontSize:12.0 withColor:[NSColor blackColor]];
        }
        
        if (drawArray != nil && drawArray.count > 0) {
            NSRect saveRect = NSMakeRect(15, 15, 0, 0);
            for (int i = 0; i < drawArray.count; i++) {
                id item = [drawArray objectAtIndex:i];
                if ([item isKindOfClass:[NSString class]]) {
                    if ([item rangeOfString:@"☼"].location != NSNotFound) {
                        id item1 = [drawArray objectAtIndex:i+1];
                        if ([item1 isKindOfClass:[NSImage class]]) {
                            NSRect imageRect;
                            imageRect.origin = NSZeroPoint;
                            imageRect.size = [(NSImage *)item1 size];
                            NSRect drRect;
                            drRect.origin = NSMakePoint(saveRect.origin.x, saveRect.origin.y);
                            if ([(NSImage *)item1 size].width > 100 || [(NSImage *)item1 size].height > 50) {
//                                drRect.size = NSMakeSize(186, 130);
                                drRect.size = [self scalImageRect:[(NSImage *)item1 size].width withHeight:[(NSImage *)item1 size].height].size;
                            }else {
                                drRect.size = [item1 size];
                            }
                            
                            IMBMsgImageInfo *info = [[IMBMsgImageInfo alloc] init];
                            info.msgRect = drRect;
                            info.msgImage = (NSImage *)item1;
                            [_imageArray addObject:info];
                            [info release];
                            
                            [(NSImage *)item1 drawInRect:drRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                            
                            NSString *textString = [item stringByReplacingOccurrencesOfString:@"☼" withString:@""];
                            NSRect textRect = [self calcuTextBounds:textString fontSize:12 width:dirtyRect.size.width];
                            [self drawText:textString withFrame:NSMakeRect(saveRect.origin.x + drRect.size.width, saveRect.origin.y + (drRect.size.height - textRect.size.height)/2, 290 - 2*15, textRect.size.height) withFontSize:12.0 withColor:[NSColor blackColor]];
                            saveRect.origin.y += [item1 size].height + 2;
                            i += 1;
                        } else {
                            NSRect textRect = [self calcuTextBounds:item fontSize:12 width:dirtyRect.size.width];
                            [self drawText:item withFrame:NSMakeRect(saveRect.origin.x, saveRect.origin.y, 290 - 2*15, textRect.size.height) withFontSize:12.0 withColor:[NSColor blackColor]];
                            saveRect.origin.y += [item1 size].height + 2;
                        }
                    }else {
                        NSRect textRect = [self calcuTextBounds:item fontSize:12 width:dirtyRect.size.width];
                        [self drawText:item withFrame:NSMakeRect(saveRect.origin.x, saveRect.origin.y, 290 - 2*15, textRect.size.height) withFontSize:12.0 withColor:[NSColor blackColor]];
                        saveRect.origin.y += textRect.size.height + 2;
                    }
                }else if ([item isKindOfClass:[NSImage class]]) {
                    NSRect imageRect;
                    imageRect.origin = NSZeroPoint;
                    imageRect.size = [(NSImage *)item size];
                    NSRect drRect;
                    drRect.origin = NSMakePoint(saveRect.origin.x, saveRect.origin.y);
                    if ([(NSImage *)item size].width > 100 || [(NSImage *)item size].height > 50) {
//                        drRect.size = NSMakeSize(186, 130);
                        drRect.size = [self scalImageRect:[(NSImage *)item size].width withHeight:[(NSImage *)item size].height].size;
                    }else {
                        drRect.size = [item size];
                    }
                    
                    IMBMsgImageInfo *info = [[IMBMsgImageInfo alloc] init];
                    info.msgRect = drRect;
                    info.msgImage = (NSImage *)item;
                    [_imageArray addObject:info];
                    [info release];
                    
                    [(NSImage *)item drawInRect:drRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                    saveRect.origin.y += drRect.size.height + 2;
                }
            }
        }
    }else {
        if (_isiMessage) {
            [[NSColor colorWithDeviceRed:32.0/255 green:168.0/255 blue:254.0/255 alpha:1.0] set];
            int originX = self.frame.size.width - 32;
            [bezierPath moveToPoint:NSMakePoint(originX+5, originY)];
            [bezierPath curveToPoint:NSMakePoint(originX + 22, originY + 13) controlPoint1:NSMakePoint(13 + originX, originY + 9) controlPoint2:NSMakePoint(originX + 13, originY + 9)];
            [bezierPath curveToPoint:NSMakePoint(20 + originX, originY) controlPoint1:NSMakePoint(19 + originX, originY + 7) controlPoint2:NSMakePoint(12 + originX, originY + 7)];
            [bezierPath fill];
        }else {
            [[NSColor colorWithDeviceRed:91.0/255 green:218.0/255 blue:42.0/255 alpha:1.0] set];
            int originX = self.frame.size.width - 32;
            [bezierPath moveToPoint:NSMakePoint(originX+5, originY)];
            [bezierPath curveToPoint:NSMakePoint(originX + 22, originY + 13) controlPoint1:NSMakePoint(13 + originX, originY + 9) controlPoint2:NSMakePoint(originX + 13, originY + 9)];
            [bezierPath curveToPoint:NSMakePoint(20 + originX, originY) controlPoint1:NSMakePoint(19 + originX, originY + 7) controlPoint2:NSMakePoint(12 + originX, originY + 7)];
            [bezierPath fill];
        }
        
        NSRect drawingRect = NSMakeRect(15, 15, 0, 0);
        if (self.image != nil) {
            NSRect imageRect;
            imageRect.origin = NSZeroPoint;
            imageRect.size = self.image.size;
            NSRect drawingRect;
            drawingRect.origin = NSMakePoint(15, 15);
            if (self.image.size.width > 100 || self.image.size.height > 50) {
//                drawingRect.size = NSMakeSize(186, 130);
                drawingRect.size = [self scalImageRect:self.image.size.width withHeight:self.image.size.height].size;
            }else {
                drawingRect.size = self.image.size;
            }
            
            IMBMsgImageInfo *info = [[IMBMsgImageInfo alloc] init];
            info.msgRect = drawingRect;
            info.msgImage = self.image;
            [_imageArray addObject:info];
            [info release];
            
            [self.image drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        }
        
        if (self.text != nil) {
            NSRect textRect = [self calcuTextBounds:self.text fontSize:12 width:dirtyRect.size.width];
            float y = 0;
            NSRect rt;
            if (self.image != nil) {
                y = drawingRect.size.height + 15 - textRect.size.height;
                rt = NSMakeRect(drawingRect.origin.x + drawingRect.size.width + 2 , y, 290 - 2*15, textRect.size.height);
            }else {
                y = 15;
                rt = NSMakeRect(drawingRect.origin.x + drawingRect.size.width , y, 290 - 2*15, textRect.size.height);
            }
            [self drawText:self.text withFrame:rt withFontSize:12.0 withColor:[NSColor whiteColor]];
        }
        
        if (drawArray != nil && drawArray.count > 0) {
            NSRect saveRect = NSMakeRect(15, 15, 0, 0);
            for (int i = 0; i < drawArray.count; i++) {
                id item = [drawArray objectAtIndex:i];
                if ([item isKindOfClass:[NSString class]]) {
                    if ([item rangeOfString:@"☼"].location != NSNotFound) {
                        id item1 = [drawArray objectAtIndex:i+1];
                        if ([item1 isKindOfClass:[NSImage class]]) {
                            NSRect imageRect;
                            imageRect.origin = NSZeroPoint;
                            imageRect.size = [(NSImage *)item1 size];
                            NSRect drRect;
                            drRect.origin = NSMakePoint(saveRect.origin.x, saveRect.origin.y);
                            if ([(NSImage *)item1 size].width > 100 || [(NSImage *)item1 size].height > 50) {
//                                drRect.size = NSMakeSize(186, 130);
                                drRect.size = [self scalImageRect:[(NSImage *)item1 size].width withHeight:[(NSImage *)item1 size].height].size;
                            }else {
                                drRect.size = [item1 size];
                            }
                            
                            IMBMsgImageInfo *info = [[IMBMsgImageInfo alloc] init];
                            info.msgRect = drRect;
                            info.msgImage = (NSImage *)item1;
                            [_imageArray addObject:info];
                            [info release];
                            
                            [(NSImage *)item1 drawInRect:drRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                            
                            NSString *textString = [item stringByReplacingOccurrencesOfString:@"☼" withString:@""];
                            NSRect textRect = [self calcuTextBounds:textString fontSize:12.0 width:dirtyRect.size.width];
                            [self drawText:textString withFrame:NSMakeRect(saveRect.origin.x + drRect.size.width, saveRect.origin.y + (drRect.size.height - textRect.size.height)/2, 290 - 2*15, textRect.size.height) withFontSize:12.0 withColor:[NSColor whiteColor]];
                            saveRect.origin.y += [item1 size].height + 2;
                            i += 1;
                        } else {
                            NSRect textRect = [self calcuTextBounds:item fontSize:12.0 width:dirtyRect.size.width];
                            [self drawText:item withFrame:NSMakeRect(saveRect.origin.x, saveRect.origin.y, 290 - 2*15, textRect.size.height) withFontSize:12.0 withColor:[NSColor whiteColor]];
                            saveRect.origin.y += [item1 size].height + 2;
                        }
                    }else {
                        NSRect textRect = [self calcuTextBounds:item fontSize:12.0 width:dirtyRect.size.width];
                        [self drawText:item withFrame:NSMakeRect(saveRect.origin.x, saveRect.origin.y, 290 - 2*15.0, textRect.size.height) withFontSize:12.0 withColor:[NSColor whiteColor]];
                        saveRect.origin.y += textRect.size.height + 2;
                    }
                }else if ([item isKindOfClass:[NSImage class]]) {
                    NSRect imageRect;
                    imageRect.origin = NSZeroPoint;
                    imageRect.size = [(NSImage *)item size];
                    NSRect drRect;
                    drRect.origin = NSMakePoint(saveRect.origin.x, saveRect.origin.y);
                    if ([(NSImage *)item size].width > 100 || [(NSImage *)item size].height > 50) {
//                        drRect.size = NSMakeSize(186.0, 130.0);
                        drRect.size = [self scalImageRect:[(NSImage *)item size].width withHeight:[(NSImage *)item size].height].size;
                    }else {
                        drRect.size = [item size];
                    }
                    
                    IMBMsgImageInfo *info = [[IMBMsgImageInfo alloc] init];
                    info.msgRect = drRect;
                    info.msgImage = item;
                    [_imageArray addObject:info];
                    [info release];
                    
                    [(NSImage *)item drawInRect:drRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                    saveRect.origin.y += drRect.size.height + 2;
                }
            }
        }
    }
}

- (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize width:(CGFloat)width{
    NSRect textBounds = NSMakeRect(0, 0, 0, 0);
    if (text) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        [paragraphStyle setAlignment:NSLeftTextAlignment];
        [paragraphStyle setLineSpacing:5];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSFont fontWithName:@"Helvetica Neue" size:fontSize], NSFontAttributeName,
                                    paragraphStyle, NSParagraphStyleAttributeName,
                                    nil];
        NSSize textSize = [as.string sizeWithAttributes:attributes];
        
        width = textSize.width;
        float height = textSize.height;
        if (width > 290 - 2*15) {
            width = 290 - 2*15;
            height = [self getstringHeighInWidth:width byString:text].size.height;
        }
        
        textBounds = NSMakeRect(0, 0, width, height);
        [as release];
    }
    return textBounds;
}

- (float)heightForStringDrawing:(NSString *)myString fontSize:(float)fontSize myWidth:(float) myWidth {
    
    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:myString] autorelease];
    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(myWidth, FLT_MAX)] autorelease];
    
    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setAlignment:NSLeftTextAlignment];
    [textParagraph setLineSpacing:5];
    [textParagraph setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:fontSize],NSFontAttributeName,nil];
    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    return [layoutManager
            usedRectForTextContainer:textContainer].size.height;
}

- (void)drawText:(NSString *)text withFrame:(NSRect)frame withFontSize:(float)withFontSize withColor:(NSColor *)color {
    if (text) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        NSFont *sysFont = [NSFont fontWithName:@"Helvetica Neue" size:withFontSize];
        NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        [paragraphStyle setAlignment:NSLeftTextAlignment];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        [paragraphStyle setLineSpacing:5];
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    sysFont, NSFontAttributeName,
                                    color, NSForegroundColorAttributeName,
                                    paragraphStyle, NSParagraphStyleAttributeName,
                                    nil];
        
        NSSize textSize = [as.string sizeWithAttributes:attributes];
        float width = 0;
        float height = 0;
        if (textSize.width <= 290 - 2*15) {
            width = textSize.width;
            height = textSize.height;
        }
        else{
            width =290 - 2*15;
            height = [self getstringHeighInWidth:width byString:text].size.height;
        }
        
        NSRect f = NSMakeRect(frame.origin.x , frame.origin.y, width, height);
        [text drawInRect:f withAttributes:attributes];
        [as release];
    }
}

- (NSRect)getstringHeighInWidth:(float)width byString:(NSString *)string{
    NSColor *color = [NSColor colorWithDeviceRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:1.0];
    NSFont *sysFont = [NSFont fontWithName:@"Helvetica Neue" size:12.0];
    NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle setAlignment:NSLeftTextAlignment];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setLineSpacing:5];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                sysFont, NSFontAttributeName,
                                color, NSForegroundColorAttributeName,
                                paragraphStyle, NSParagraphStyleAttributeName,
                                nil];
    NSRect rect = [string boundingRectWithSize:NSMakeSize(width, 8000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes];
//    rect.size.height -= 23;
    return rect;
}

//- (void)mouseDown:(NSEvent *)theEvent {
//    [super mouseDown:theEvent];
//    NSPoint point = [theEvent locationInWindow];
//    NSPoint mousePt = [self convertPoint:point fromView:nil];
//    
//    if (theEvent.clickCount == 2) {
//        for (IMBMsgImageInfo *info in _imageArray) {
//            BOOL inRect = NSMouseInRect(mousePt, info.msgRect, [self isFlipped]);
//            if (inRect) {
//                if (self.image != nil) {
//                    if ([_image isKindOfClass:[NSImage class]] && [_image isEqualTo:info.msgImage]) {
//                        IMBPhotosPreviewWindowController *photoController = [[IMBPhotosPreviewWindowController alloc] initWithPicture:_image];
//                        [NSApp runModalForWindow:[photoController window]];
//                        [photoController release];
//                        return;
//                    }
//                }else {
//                    for (id item in drawArray) {
//                        if ([item isKindOfClass:[NSImage class]] && [item isEqualTo:info.msgImage]) {
//                            IMBPhotosPreviewWindowController *photoController = [[IMBPhotosPreviewWindowController alloc] initWithPicture:(NSImage *)item];
//                            [NSApp runModalForWindow:[photoController window]];
//                            [photoController release];
//                            return;
//                        }
//                    }
//                }
//            }
//        }
//    }
//}


- (NSData *)scalingImage:(NSImage *)image withLenght:(int)lenght{
    NSData *compressImageData = nil;
    if (image != nil) {
        if (image.size.width >= image.size.height && image.size.height > 0) {
            //按宽=lenght压缩
            int w = image.size.width;
            int h = image.size.height;
            int W = lenght;
            int H = (int)(((double)h / w) * W);
            if (((double)h / w) * W < 1.0) {
                H = 1;
            }
            compressImageData = [self suchAsScalingImage:image width:W height:H];
        }else if (image.size.height > image.size.width && image.size.width > 0) {
            //按高=lenght压缩
            int w = image.size.width;
            int h = image.size.height;
            int H = lenght;
            int W = (int)(((double)w / h) * H);
            if (((double)w / h) * H < 1.0) {
                W = 1;
            }
            compressImageData = [self suchAsScalingImage:image width:W height:H];
        }
    }
    return compressImageData;
}

//等比例压缩图片
-(NSData *) suchAsScalingImage:(NSImage *)image width:(int)scalWidth height:(int)scalHeight{
    NSImage *scalingimage = [[NSImage alloc] initWithSize:NSMakeSize(scalWidth, scalHeight)];
    [scalingimage lockFocus];
    NSRectFill(NSMakeRect(0, 0, scalWidth, scalHeight));
    [[NSGraphicsContext currentContext]setImageInterpolation:NSImageInterpolationHigh];
    [image drawInRect:NSMakeRect(0, 0, scalWidth, scalHeight) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    
    NSData *tempdata = nil;
    NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect: NSMakeRect(0, 0, scalWidth, scalHeight)];
    tempdata = [bitmap representationUsingType:NSPNGFileType properties:nil];
    [bitmap release];
    [scalingimage unlockFocus];
    [scalingimage release];
    
    return tempdata;
}


@end
