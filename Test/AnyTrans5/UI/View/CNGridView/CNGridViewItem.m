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
#pragma mark - Initialzation

- (id)initWithLayout:(CNGridViewItemLayout *)layout reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self init];
	if (self) {
		self.defaultLayout = layout;
		self.hoverLayout = layout;
		self.selectionLayout = layout;
		self.currentLayout = _defaultLayout;
		self.reuseIdentifier = reuseIdentifier;
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
    [self.bgImg setSize:NSMakeSize(122, 122)];
	// decide which layout we have to use
	/// contentRect is the rect respecting the value of layout.contentInset
    NSRect contentRect = NSMakeRect(dirtyRect.origin.x + self.currentLayout.contentInset +10,
                                        dirtyRect.origin.y + self.currentLayout.contentInset ,
                                        dirtyRect.size.width - self.currentLayout.contentInset * 2 -10 ,
                                        dirtyRect.size.height - self.currentLayout.contentInset * 2);
//    NSRect backGroundRect = NSMakeRect(dirtyRect.origin.x + self.currentLayout.contentInset +10, dirtyRect.origin.y + self.currentLayout.contentInset +20, dirtyRect.size.width - self.currentLayout.contentInset * 2 -10 , dirtyRect.size.height - self.currentLayout.contentInset * 2 -20);
//	NSBezierPath *contentRectPath = [NSBezierPath bezierPathWithRoundedRect:backGroundRect
//	                                                                xRadius:5
//	                                                                yRadius:5];
//	[self.currentLayout.backgroundColor setFill];
//	[contentRectPath fill];
//
//	/// draw selection ring
//	if (self.selected) {
//		[self.currentLayout.selectionRingColor setStroke];
//		[contentRectPath setLineWidth:self.currentLayout.selectionRingLineWidth];
//		[contentRectPath stroke];
//	}
//    if (self.itemImage == nil) {
//        self.itemImage = [[NSImage imageNamed:@"sel-photo"] retain];
//    }
    
    NSImage *image = nil;
    if (self.itemImage != nil) {
        image = self.itemImage;
    }else {
//        if (_isAppPhoto) {
//            image = [NSImage imageNamed:@"app_photo_sel_none"];
//        }else{
//            image = [NSImage imageNamed:@"default_image_photo"];
//        }
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
        }
        else{
            imageRect = NSMakeRect(((W - imgW) / 2) + 10 + 6,
                                   (H - imgH)/2 ,
                                   imgW,
                                   imgH);
        }


		[image drawInRect:imageRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
//        [self.bgImg drawInRect:imageRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
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
		textRect = NSMakeRect(contentRect.origin.x + 3,
		                      H -10,
		                      W - 6,
		                      14+4);
		[self.itemTitle drawInRect:textRect withAttributes:self.currentLayout.itemTitleTextAttributes];

	}else if (self.currentLayout.visibleContentMask & CNGridViewItemVisibleContentImage) {
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
	}

	else if (self.currentLayout.visibleContentMask & CNGridViewItemVisibleContentTitle) {
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

//- (BOOL)mouseDownCanMoveWindow {
//    NSLog(@"----------cngrid view item");
//    return NO;
//}

@end
