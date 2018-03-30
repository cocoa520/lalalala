//
//  IMBSortPopoverViewController.h
//  iOSFiles
//
//  Created by hym on 30/03/2018.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBSortPopoverViewController : NSViewController
{
    id _target;
    SEL _action;
    id _delegate;
    NSMutableArray *_typeAry;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSortTypeAry:(NSMutableArray *)typeAry;


@end


@interface IMBSortView : NSView
{
    id _target;
    SEL _action;
    id _delegate;
    NSString *_title;
    NSTextField *_textField;
    MouseStatusEnum _mouseSatue;
    NSTrackingArea *_trackingArea;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;
@property (nonatomic, retain) NSString *title;

- (instancetype)initWithFrame:(NSRect)frameRect withTitle:(NSString *)title;

@end
