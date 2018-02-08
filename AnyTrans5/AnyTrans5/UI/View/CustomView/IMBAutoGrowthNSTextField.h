//
//  TSTTextGrowth.h
//  autoGrowingExample
//
//  Created by Scott O'Brien on 1/01/13.
//  Copyright (c) 2013 Scott O'Brien. All rights reserved.
//



#import <Cocoa/Cocoa.h>


@interface IMBAutoGrowthNSTextField : NSTextField<NSTextViewDelegate,NSTextFieldDelegate>
{
	BOOL _hasLastIntrinsicSize;
	BOOL _isEditing;
	NSSize _lastIntrinsicSize;
    NSView *documentView;
    CGFloat currntHeight;
    IMBAutoGrowthNSTextField *labelTextField;
    BOOL isInit;
    CGFloat heightMin;
    CGFloat documentViewinitHeight;
    CGFloat currentDocumentHeight;
    BOOL isenter;
}
@property(nonatomic,assign)CGFloat heightMin;
@property(nonatomic,assign)NSView *documentView;
@property(nonatomic,assign)IMBAutoGrowthNSTextField *labelTextField;
-(NSSize)intrinsicContentSize;

@end
