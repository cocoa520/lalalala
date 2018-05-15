//
//  IMBCloudTableCellView.h
//  AnyTransforCloud
//
//  Created by hym on 19/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
@class IMBWhiteView;
@class IMBImageAndColorButton;
@interface IMBCloudTableCellView : NSTableCellView
{
    IBOutlet NSImageView *_cloudImageView;
    IBOutlet NSTextField *_cloudName;
    IBOutlet IMBImageAndColorButton *_editBtn;
    IBOutlet NSTextField *_cloudPerson;
    IBOutlet NSTextField *_cloudSize;
    IBOutlet NSTextField *_cloudTime;
    IBOutlet IMBImageAndColorButton *_deleteBtn;
    IBOutlet IMBWhiteView *_underLineView;
    
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _buttonType;
    NSShadow *_shadow;
    BOOL _isEditingName;
    id _delegate;
    NSString *_driveID;
}
@property (nonatomic, retain, readwrite) NSImageView *cloudImageView;
@property (nonatomic, retain, readwrite) NSTextField *cloudName;
@property (nonatomic, retain, readwrite) NSButton *editBtn;
@property (nonatomic, retain, readwrite) NSTextField *cloudPerson;
@property (nonatomic, retain, readwrite) NSTextField *cloudSize;
@property (nonatomic, retain, readwrite) NSTextField *cloudTime;
@property (nonatomic, retain, readwrite) NSButton *deleteBtn;
@property (nonatomic, assign, readwrite) BOOL isEditingName;
@property (nonatomic, assign, readwrite) id delegate;
@property (nonatomic, retain, readwrite) NSString *driveID;
@end
