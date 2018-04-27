//
//  CNGridViewItem.m
//
//  Created by cocoa:naut on 06.10.12.
//  Copyright (c) 2012 cocoa:naut. All rights reserved.
//

/*
 The MIT License (MIT)
 Copyright © 2012 Frank Gregor, <phranck@cocoanaut.com>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the “Software”), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "CNGridViewItem.h"
#import "NSColor+CNGridViewPalette.h"
#import "CNGridViewItemLayout.h"
#import "TempHelper.h"
//#import "CNGridView.h"

//#if !__has_feature(objc_arc)
//#error "Please use ARC for compiling this file."
//#endif

@class CNGridView;
NSString *const kCNDefaultItemIdentifier = @"CNGridViewItem";

/// Notifications
extern NSString *CNGridViewSelectAllItemsNotification;
extern NSString *CNGridViewDeSelectAllItemsNotification;

@implementation CNGridViewItemBase
@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize isReuseable = _isReuseable;
@synthesize index = _index;
@synthesize representedObject = _representedObject;
@synthesize selected = _selected;
@synthesize selectable = _selectable;
@synthesize hovered = _hovered;

+ (NSSize)defaultItemSize {
	return NSMakeSize(310, 500);
}

- (void)dealloc {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self name:CNGridViewSelectAllItemsNotification object:nil];
	[nc removeObserver:self name:CNGridViewDeSelectAllItemsNotification object:nil];
    [super dealloc];
}

- (id)init {
	self = [super init];
	if (self) {
		[self initProperties];
	}
	return self;
}

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	if (self) {
		[self initProperties];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initProperties];
	}
	return self;
}

- (void)initProperties {
	/// Reusing Grid View Items
	self.reuseIdentifier = kCNDefaultItemIdentifier;
	self.index = CNItemIndexUndefined;

    //    /// Selection and Hovering
    //    _selected = NO;
    //    _selectable = YES;
    //    _hovered = NO;

	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(selectAll:) name:CNGridViewSelectAllItemsNotification object:nil];
	[nc addObserver:self selector:@selector(deSelectAll:) name:CNGridViewDeSelectAllItemsNotification object:nil];
}

- (void)prepareForReuse {
	self.index = CNItemIndexUndefined;
	self.selected = NO;
	self.selectable = YES;
	self.hovered = NO;
}

- (BOOL)isReuseable {
	return (self.selected ? NO : YES);
}

- (void)selectAll:(NSNotification *)notification {
//    NSArray *ary = notification.object;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        for (CNGridViewItem *item in ary) {
//            item.selected = YES;
//        }
//    });
   
//    item.ite = YES;
//    NSLog(@"%@",item);
//	[self setSelected:YES];
    
    id item = notification.object;
    if ([item isEqualTo:self]) {
        [self setSelected:YES];
    }
}

- (void)deSelectAll:(NSNotification *)notification {
//    NSArray *ary = notification.object;
//    
//    for (CNGridViewItem *item in ary) {
//        item.selected = NO;
//    }
//    CNGridViewItem *item = notification.object;
//    item.selected = NO;
//	[self setSelected:NO];
    
    id object = notification.object;
    if ([object isEqualTo:self.superview]) {
        [self setSelected:NO];
    }
}

@end


//@interface CNGridViewItem ()
//@property (retain) NSImageView *itemImageView;
//@property (retain) CNGridViewItemLayout *currentLayout;
//@end

@implementation CNGridViewItem
@synthesize isAppPhoto = _isAppPhoto;
@synthesize itemImage = _itemImage;
@synthesize itemTitle = _itemTitle;
@synthesize defaultLayout = _defaultLayout;
@synthesize hoverLayout = _hoverLayout;
@synthesize selectionLayout = _selectionLayout;
@synthesize useLayout = _useLayout;
@synthesize itemImageView = _itemImageView;
@synthesize currentLayout = _currentLayout;
@synthesize seledImg = _seledImg;
@synthesize isDeleted = _isDeleted;
@synthesize deletedImg = _deletedImg;
@synthesize bgImg = _bgImg;
@synthesize isPhotoView = _isPhotoView;
@synthesize isFileManager = _isFileManager;
@synthesize isSelectView = _isSelectView;
@synthesize isAudioView = _isAudioView;
@synthesize isiOSToAndroid = _isiOSToAndroid;
@synthesize isSecond = _isSecond;
@synthesize seledImgFrame = _seledImgFrame;
@synthesize entity = _entity;
@synthesize isEdit = _isEdit;
@synthesize editText = _editText;

#pragma mark - Initialzation

- (id)initWithLayout:(CNGridViewItemLayout *)layout reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self init];
	if (self) {
		self.defaultLayout = layout;
		self.hoverLayout = layout;
		self.selectionLayout = layout;
		self.currentLayout = _defaultLayout;
		self.reuseIdentifier = reuseIdentifier;
        _isMouseEnter = NO;
	}
	return self;
}

- (void)initProperties {
	[super initProperties];

	/// Item Default Content
	_itemImage = nil;
	_itemTitle = @"";
	/// Grid View Item Layout
//	_defaultLayout = [CNGridViewItemLayout defaultLayout];
//	_hoverLayout = [CNGridViewItemLayout defaultLayout];
//	_selectionLayout = [CNGridViewItemLayout defaultLayout];
	_currentLayout = _defaultLayout;
	_useLayout = YES;
    _isMouseEnter = NO;
}

- (BOOL)isFlipped {
	return YES;
}

#pragma mark - Reusing Grid View Items
- (void)prepareForReuse {
	[super prepareForReuse];

	self.itemImage = nil;
	self.itemTitle = @"";
}

#pragma mark - ViewDrawing

- (void)drawRect:(NSRect)rect {
	NSRect dirtyRect = self.bounds;
    //设置选中背景
    if (self.selected && _isFileManager) {
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(36, 30, 92, 82) xRadius:5 yRadius:5];
        [[NSColor colorWithDeviceRed:225/255.0 green:244/255.0 blue:255/255.0 alpha:1.0] setFill];
        [path fill];
    }
    if (_isFileManager) {
        [self.bgImg setSize:NSMakeSize(80, 60)];
    }else if (_isAudioView) {
        [self.bgImg setSize:NSMakeSize(150, 150)];
    }else {
        [self.bgImg setSize:NSMakeSize(122, 122)];
    }
    
	// decide which layout we have to use
	/// contentRect is the rect respecting the value of layout.contentInset
    NSRect contentRect = NSMakeRect(dirtyRect.origin.x + self.currentLayout.contentInset +10,
                                        dirtyRect.origin.y + self.currentLayout.contentInset ,
                                        dirtyRect.size.width - self.currentLayout.contentInset * 2 -10 ,
                                        dirtyRect.size.height - self.currentLayout.contentInset * 2);

    
    NSImage *image = nil;
    if (self.itemImage != nil) {
        image = self.itemImage;
    }else {
        image = self.bgImg;
        
    }
	NSRect srcRect = NSZeroRect;
    NSSize imgSize = image.size;
	srcRect.size = imgSize;
	NSRect imageRect = NSZeroRect;
	NSRect textRect = NSZeroRect;
	CGFloat contentInset = self.currentLayout.contentInset ;

	CGFloat imgW = imgSize.width;
	CGFloat imgH = imgSize.height;
	CGFloat W = NSWidth(contentRect);
	CGFloat H = NSHeight(contentRect);

	if ((self.currentLayout.visibleContentMask & (CNGridViewItemVisibleContentImage | CNGridViewItemVisibleContentTitle)) ==
	    (CNGridViewItemVisibleContentImage | CNGridViewItemVisibleContentTitle)
	    ) {
        if (_isAppPhoto) {
            imageRect = NSMakeRect(((W - imgW) / 2) + 10 + 6,
                                   (H - imgH)/2  ,
                                   imgW,
                                   imgH);
        }else if (_isPhotoView){
            imageRect = NSMakeRect(((W - imgW) / 2) + 10 + 6,
                                   (H - imgH)/2 +20 ,
                                   imgW,
                                   imgH);
        }else if (_isFileManager) {
            imageRect = NSMakeRect(((W - imgW) / 2)+26 - 15,
                                   (H - imgH)/2  ,
                                   imgW,
                                   imgH);
        }else if (_isSelectView) {
            
            imageRect = NSMakeRect(((W - imgW) / 2) + 10 + 6,
                                       (H - imgH)/2,
                                       imgW,
                                       imgH);

        }else{
            imageRect = NSMakeRect(((W - imgW) / 2) + 10 + 6,
                                   (H - imgH)/2 ,
                                   imgW,
                                   imgH);
        }
        
		[image drawInRect:imageRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        
        if (_isSelectView) {
            NSImage *checkBoxImg = nil;
            if (self.selected) {
                checkBoxImg = [NSImage imageNamed:@"checkbox2"];
            } else {
                checkBoxImg = [NSImage imageNamed:@"checkbox1"];
            }
            NSRect checkRect = NSZeroRect;
            checkRect = imageRect;
            checkRect.origin.x = imageRect.origin.x + image.size.width - checkBoxImg.size.width + 5;
            checkRect.origin.y = imageRect.origin.y - image.size.height + checkBoxImg.size.height - 5;
            [checkBoxImg drawInRect:checkRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            NSRect enterBgRect = NSZeroRect;
            enterBgRect.origin.x = rect.origin.x + 25;
            enterBgRect.origin.y = rect.origin.y + 10;
            enterBgRect.size.width = rect.size.width - 40;
            enterBgRect.size.height = rect.size.height - 20;
            if (_isMouseEnter) {
                NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:enterBgRect xRadius:5 yRadius:5];
                [[NSColor colorWithDeviceRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.3] setFill];
                [path fill];
            }
        }
        
       NSRect imageRect1 = NSMakeRect(imageRect.origin.x + imageRect.size.width - self.deletedImg.size.width,imageRect.origin.y+imageRect.size.height - self.deletedImg.size.height -6, self.deletedImg.size.width, self.deletedImg.size.height);
        NSRect srcRect1 = NSZeroRect;
        NSSize imgSize1 = self.deletedImg.size;
        srcRect1.size = imgSize1;
        if (_isDeleted) {
            [self.deletedImg drawInRect:imageRect1 fromRect:srcRect1 operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];

        }

        if (self.selected && self.seledImg != nil) {
            [self.seledImg drawInRect:imageRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
        _seledImgFrame = imageRect;
        if (_isFileManager) {
            textRect = NSMakeRect(contentRect.origin.x + 12 , H - 30, 108, 14+6);
        }else if (_isSelectView) {
            textRect = NSMakeRect(contentRect.origin.x + 3, H - 20, W - 6, 14+6);
        }else {
            textRect = NSMakeRect(contentRect.origin.x + 3, H -10, W - 6, 14+4);
        }
        
        if (self.selected && _isFileManager && !_isEdit) {
            NSRect titleRect = [StringHelper calcuTextBounds:self.itemTitle fontSize:12.0];
            if (titleRect.size.width + 6 > 108) {
                titleRect.size.width = 108;
            } else {
                titleRect.size.width = titleRect.size.width + 6;
            }
            titleRect.size.height = textRect.size.height - 2;
            titleRect.origin.x = (154 - titleRect.size.width)/2 + 4;
            titleRect.origin.y = textRect.origin.y + 2;
            
            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:titleRect xRadius:5 yRadius:5];
            [[NSColor colorWithDeviceRed:225/255.0 green:244/255.0 blue:255/255.0 alpha:1.0] setFill];
            [path fill];
        }
        if (_isEdit && ![(IMBDriveEntity *)_entity isEditing]) {
            [_entity setIsEditing:YES];
            if (_editText != nil) {
                [_editText release];
                _editText = nil;
            }
            _editText = [[NSTextField alloc] initWithFrame:NSZeroRect];
            NSRect titleRect = [StringHelper calcuTextBounds:self.itemTitle fontSize:12.0];
            titleRect.size.height = 24;
            titleRect.size.width = 108;
            titleRect.origin.x = (154 - titleRect.size.width)/2 + 4;
            titleRect.origin.y = textRect.origin.y + 4;
            
            [_editText setFrame:titleRect];
            
            NSMutableAttributedString *promptAs = [TempHelper setSingleTextAttributedString:self.itemTitle withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[NSColor blackColor]];
            NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
            [mutParaStyle setAlignment:NSCenterTextAlignment];
            [mutParaStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];
            [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
//            [_editText setPlaceholderString:self.itemTitle];
            [_editText setEditable:YES];
            [_editText setSelectable:YES];
            [_editText setFocusRingType:NSFocusRingTypeNone];
            [_editText setAttributedStringValue:promptAs];
            [_editText setAlignment:NSCenterTextAlignment];
            [mutParaStyle release];
            mutParaStyle = nil;

            [self addSubview:_editText];
            [_editText becomeFirstResponder];
        } else {
            [self.itemTitle drawInRect:textRect withAttributes:self.currentLayout.itemTitleTextAttributes];
        }

	} else if (self.currentLayout.visibleContentMask & CNGridViewItemVisibleContentImage) {
		if (W >= imgW && H >= imgH) {
			imageRect = NSMakeRect(((W - imgW) / 2) + contentInset,
			                       ((H - imgH) / 2) + contentInset,
			                       imgW,
			                       imgH);
		}
		else if (0 < W && 0 < H && imgW > 0 && imgH > 0) {
			CGFloat kView = H / W;
			CGFloat kImg = imgH / imgW;

			if (kView > kImg) {
				// use W
				CGFloat newH = W * kImg;
				CGFloat y = floorf((H - newH) / 2);
				imageRect.size.width = W;
				imageRect.size.height = ceilf(newH);
				imageRect.origin.x = 0;
				imageRect.origin.y = y;
			}
			else {
				// use H

				CGFloat newW = H / kImg;
				CGFloat x = floorf((W - newW) / 2);
				imageRect.size.width = newW;
				imageRect.size.height = H;
				imageRect.origin.x = x;
				imageRect.origin.y = 0;
			}
		}
		[image drawInRect:imageRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
	} else if (self.currentLayout.visibleContentMask & CNGridViewItemVisibleContentTitle) {
    } else {
    
        if (_isAppPhoto) {
            imageRect = NSMakeRect(((W - imgW) / 2) + 10 + 6,
                                   (H - imgH)/2  ,
                                   imgW,
                                   imgH);
        }else if (_isPhotoView){
            imageRect = NSMakeRect(((W - imgW) / 2) + 10 + 6,
                                   (H - imgH)/2 +20 ,
                                   imgW,
                                   imgH);
        }else if (_isFileManager) {
            imageRect = NSMakeRect(((W - imgW) / 2)+26,
                                   (H - imgH)/2  ,
                                   imgW,
                                   imgH);
        }else if (_isSelectView) {
            
            imageRect = NSMakeRect(((W - imgW) / 2) + 10 + 6,
                                   (H - imgH)/2,
                                   imgW,
                                   imgH);
            
        }else{
            imageRect = NSMakeRect(((W - imgW) / 2) + 10 + 6,
                                   (H - imgH)/2 ,
                                   imgW,
                                   imgH);
        }
        
        [image drawInRect:imageRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        
        if (_isSelectView) {
            NSImage *checkBoxImg = nil;
            if (self.selected) {
                checkBoxImg = [NSImage imageNamed:@"checkbox2"];
            } else {
                checkBoxImg = [NSImage imageNamed:@"checkbox1"];
            }
            NSRect checkRect = NSZeroRect;
            checkRect = imageRect;
            checkRect.origin.x = imageRect.origin.x + image.size.width - checkBoxImg.size.width + 5;
            checkRect.origin.y = imageRect.origin.y - image.size.height + checkBoxImg.size.height - 5;
            [checkBoxImg drawInRect:checkRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            NSRect enterBgRect = NSZeroRect;
            enterBgRect.origin.x = rect.origin.x + 25;
            enterBgRect.origin.y = rect.origin.y + 10;
            enterBgRect.size.width = rect.size.width - 40;
            enterBgRect.size.height = rect.size.height - 20;
            if (_isMouseEnter) {
                NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:enterBgRect xRadius:5 yRadius:5];
                [[NSColor colorWithDeviceRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.3] setFill];
                [path fill];
            }
        }
    
        NSRect imageRect1 = NSMakeRect(imageRect.origin.x + imageRect.size.width - self.deletedImg.size.width,imageRect.origin.y+imageRect.size.height - self.deletedImg.size.height -6, self.deletedImg.size.width, self.deletedImg.size.height);
        NSRect srcRect1 = NSZeroRect;
        NSSize imgSize1 = self.deletedImg.size;
        srcRect1.size = imgSize1;
        if (_isDeleted) {
            [self.deletedImg drawInRect:imageRect1 fromRect:srcRect1 operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            
        }
        
        if (self.selected && self.seledImg != nil) {
            [self.seledImg drawInRect:imageRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
        _seledImgFrame = imageRect;
        if (_isFileManager) {
            textRect = NSMakeRect(contentRect.origin.x + 30 , H - 10, W - 6, 14+6);
        }else if (_isSelectView) {
            textRect = NSMakeRect(contentRect.origin.x + 3, H - 20, W - 6, 14+6);
        }else {
            textRect = NSMakeRect(contentRect.origin.x + 3, H -10, W - 6, 14+4);
        }
        
        [self.itemTitle drawInRect:textRect withAttributes:self.currentLayout.itemTitleTextAttributes];
        
        if (self.selected && _isFileManager) {
            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:textRect xRadius:5 yRadius:5];
            [[NSColor colorWithDeviceRed:225/255.0 green:244/255.0 blue:255/255.0 alpha:1.0] setFill];
            [path fill];
        }
    }
}

#pragma mark - Notifications

- (void)clearHovering {
	[self setHovered:NO];
}

- (void)clearSelection {
	[self setSelected:NO];
}

#pragma mark - Accessors

- (void)setHovered:(BOOL)hovered {
	[super setHovered:hovered];
	_currentLayout = (self.hovered ? _hoverLayout : (self.selected ? _selectionLayout : _defaultLayout));
	[self setNeedsDisplay:YES];
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	_currentLayout = (self.selected ? _selectionLayout : _defaultLayout);
    
	[self setNeedsDisplay:YES];
}

- (void)setDefaultLayout:(CNGridViewItemLayout *)defaultLayout {
	_defaultLayout = defaultLayout;
	self.currentLayout = _defaultLayout;
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
        _trackingArea = nil;
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [super mouseEntered:theEvent];
//    if (_entity) {
//        NSString *toolStr = nil;
//        NSString *name = nil;
//        NSString *size = nil;
//        NSString *path = nil;
//        long long sizenum = 0;
//        long long timenum = 0;
//        if (_category == Category_Document) {
//            name = ((IMBADFileEntity *)_entity).fileName;
//            if([(IMBADFileEntity *)_entity isFile]) {
//                sizenum = ((IMBADFileEntity *)_entity).fileSize;
//            }else {
//                sizenum = 0;
//            }
//            path = ((IMBADFileEntity *)_entity).filePath;
//        } else if (_category == Category_Music) {
//            name = ((IMBADAudioTrack *)_entity).title;
//            sizenum = ((IMBADAudioTrack *)_entity).size;
//            path = ((IMBADAudioTrack *)_entity).url;
//        } else if (_category == Category_Movies) {
//            name = ((IMBADVideoTrack *)_entity).title;
//            sizenum = ((IMBADVideoTrack *)_entity).size;
//            path = ((IMBADVideoTrack *)_entity).url;
//        } else if (_category == Category_Photo) {
//            name = ((IMBADPhotoEntity *)_entity).title;
//            sizenum = ((IMBADPhotoEntity *)_entity).size;
//            path = ((IMBADPhotoEntity *)_entity).url;
//        }
//        
//        if ([StringHelper stringIsNilOrEmpty:path]){
//            path = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"ListToolTip_path", nil),@"--"];
//        }else {
//            path = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"ListToolTip_path", nil),path];
//        }
//        if (sizenum == 0){
//            size = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"List_Header_id_Size", nil),@"--"];
//        }else {
//            size = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"List_Header_id_Size", nil),[StringHelper getFileSizeString:sizenum reserved:2]];
//        }
//        
//        toolStr = [NSString stringWithFormat:@"%@ \n %@ \n %@",name,size,path];
//        [self setToolTip:toolStr];
//    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    [super mouseExited:theEvent];
}

- (void)dealloc {
    if(_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}

//- (BOOL)mouseDownCanMoveWindow {
//    NSLog(@"----------cngrid view item");
//    return NO;
//}

@end
