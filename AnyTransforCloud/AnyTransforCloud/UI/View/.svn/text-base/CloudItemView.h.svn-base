/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    This is the "CloudItemView" class declaration.
*/

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
@class IMBWhiteView;
@class IMBSVGClickView;
@class CloudItemSelectedView;
@class IMBDriveModel;
#define SLIDE_WIDTH           166.0     // width  of the SlideCarrier image (which includes shadow margins) in points, and thus the width  that we give to a Slide's root view
#define SLIDE_HEIGHT          166.0     // height of the SlideCarrier image (which includes shadow margins) in points, and thus the height that we give to a Slide's root view

#define SLIDE_SHADOW_MARGIN    0.0     // margin on each side between the actual slide shape edge and the edge of the SlideCarrier image
#define SLIDE_CORNER_RADIUS     2.0     // corner radius of the slide shape in points
#define SLIDE_BORDER_WIDTH      1.0     // thickness of border when shown, in points

// A AAPLSlideCarrierView serves as the container view for each AAPLSlide item.  It displays a "SlideCarrier" slide shape image with built-in shadow, customizes hit-testing to account for the slide shape's rounded corners, and implements visual indication of item selection and highlighting state.
@interface CloudItemView : NSView
{
    NSCollectionViewItemHighlightState highlightState;
    BOOL selected;
    CloudItemSelectedView *_selectedView;
    MouseStatusEnum _mouseState;
    NSTrackingArea *_trackingArea;
    IMBSVGClickView *_SVGView;
    IBOutlet NSTextField *_textFiled;
    IBOutlet NSImageView *_imageView;
    IBOutlet IMBWhiteView *_toolView;
    BOOL _isOpenMenu;
    id _delegate;
    IMBDriveModel* _model;
    BOOL _isRename;///正在编辑名字
    
    BOOL _isDisable;
}

// To leave the specifics of highlighted and selected appearance to the SlideCarrierView's implementation, we mirror NSCollectionViewItem's "highlightState" and "selected" properties to it.
@property NSCollectionViewItemHighlightState highlightState;
@property (getter=isSelected) BOOL selected;
@property (nonatomic, assign) BOOL isOpenMenu;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) IMBDriveModel* model;
@property (nonatomic, retain) NSTextField *textFiled;
@property (nonatomic, assign) BOOL isRename;
@end
