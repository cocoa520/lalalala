//
//  CNGridViewItem.h
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

#import <Cocoa/Cocoa.h>

@class CNGridViewItemLayout;

APPKIT_EXTERN NSString* const kCNDefaultItemIdentifier;
#define CNItemIndexUndefined NSNotFound



#pragma mark - CNGridViewItemBase
@interface CNGridViewItemBase : NSView {
    NSString *_reuseIdentifier;
    BOOL _isReuseable;
    NSInteger _index;
    id _representedObject;
    BOOL _selected;
    BOOL _selectable;
    BOOL _hovered;
}


#pragma mark - Reusing Grid View Items
/** @name Reusing Grid View Items */

/**
 ...
 */
@property (retain) NSString *reuseIdentifier;

/**
 ...
 */
@property (readonly, nonatomic) BOOL isReuseable;

/**
 ...
 */
- (void)prepareForReuse;

/**
 ...
 */
@property (assign) NSInteger index;

/**
 The object that the receiving item view represents 
 */
@property (assign) id representedObject;



#pragma mark - Selection and Hovering
/** @name Selection and Hovering */

/**
 ...
 */
@property (nonatomic, assign) BOOL selected;

/**
 ...
 */
@property (nonatomic, assign) BOOL selectable;

/**
 ...
 */
@property (nonatomic, assign) BOOL hovered;

/**
 ...
 */
+ (NSSize)defaultItemSize;

@end


#import "StringHelper.h"
#import "IMBCommonDefine.h"
#import "IMBDriveEntity.h"
#import "IMBGridTextField.h"


#pragma mark - CNGridViewItem
@interface CNGridViewItem : CNGridViewItemBase {
    NSImage *_itemImage;
    NSString *_itemTitle;
    CNGridViewItemLayout *_defaultLayout;
    CNGridViewItemLayout *_hoverLayout;
    CNGridViewItemLayout *_selectionLayout;
    BOOL _useLayout;
    
    NSImageView *_itemImageView;
    CNGridViewItemLayout *_currentLayout;
    NSImage *_seledImg;
    BOOL _isDeleted;
    NSImage *_deletedImg;
    NSImage *_bgImg;
    BOOL _isAppPhoto;
    BOOL _isPhotoView;
    BOOL _isFileManager;
    BOOL _isSelectView;
    BOOL _isAudioView;
    BOOL _isMouseEnter;
    BOOL _isiOSToAndroid;
    BOOL _isSecond;
    NSTrackingArea *_trackingArea;
    NSRect _seledImgFrame;
    id _entity;
    CategoryNodesEnum _category;
    BOOL _isEdit;
    IMBGridTextField *_editText;
    BOOL _isEditing;
}
@property (nonatomic, retain) IMBGridTextField *editText;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL isAppPhoto;
@property (nonatomic, assign) BOOL isPhotoView;
@property (nonatomic, assign) BOOL isFileManager;
@property (nonatomic, assign) BOOL isSelectView;
@property (nonatomic, assign) BOOL isAudioView;
@property (nonatomic, assign) BOOL isiOSToAndroid;
@property (nonatomic, assign) BOOL isSecond;
@property (nonatomic, assign) NSRect seledImgFrame;
@property (nonatomic, retain) id entity;
@property (nonatomic, assign) CategoryNodesEnum category;

#pragma mark - Initialization
/** @name Initialization */

/**
 Creates and returns an initialized  This is the designated initializer.
 */
- (id)initWithLayout:(CNGridViewItemLayout *)layout reuseIdentifier:(NSString *)reuseIdentifier;

#pragma mark - Item Default Content
/** @name Item Default Content */
@property (retain) NSImage *seledImg;
/**
 ...
 */
@property (retain) IBOutlet NSImage *itemImage;

/**
 ...
 */
@property (retain) IBOutlet NSString *itemTitle;

@property (retain) NSImage *deletedImg;
@property (retain) NSImage *bgImg;
@property (assign) BOOL isDeleted;
#pragma mark - Grid View Item Layout
/** @name Grid View Item Layout */

/**
 ...
 */
@property (nonatomic, retain) CNGridViewItemLayout *defaultLayout;

/** 
 ...
 */
@property (nonatomic, retain) CNGridViewItemLayout *hoverLayout;

/**
 ...
 */
@property (nonatomic, retain) CNGridViewItemLayout *selectionLayout;

/**
 ...
 */
@property (nonatomic, assign) BOOL useLayout;

@property (retain) NSImageView *itemImageView;
@property (retain) CNGridViewItemLayout *currentLayout;



@end
