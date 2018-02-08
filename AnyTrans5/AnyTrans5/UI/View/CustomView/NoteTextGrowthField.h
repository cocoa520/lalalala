//
//  TSTTextGrowth.h
//  autoGrowingExample
//
//  Created by Scott O'Brien on 1/01/13.
//  Copyright (c) 2013 Scott O'Brien. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NoteTextGrowthField : NSTextField<NSTextFieldDelegate,NSTextViewDelegate>{
	BOOL _hasLastIntrinsicSize;
	BOOL _isEditing;
	NSSize _lastIntrinsicSize;
    NSSize originSize;
    NSAttributedString *_editAttributedString;
    dispatch_queue_t focusQueue;
    id _bindingEntity;
    NSString *_bindingEntityKeyPath;
    BOOL _canBeEditing;
    float _fontSize;
    BOOL _isCalendarNote;
    BOOL _isFillet;//圆角

}
@property (nonatomic,assign) BOOL isCalendarNote;
@property (nonatomic,assign) float fontSize;
@property (nonatomic,assign) BOOL isEditing;
@property (nonatomic,retain) NSAttributedString *editAttributedString;
@property (nonatomic,retain) id bindingEntity;
@property (nonatomic,retain) NSString *bindingEntityKeyPath;
@property (nonatomic,assign) BOOL canBeEditing;
@property (nonatomic,assign) NSSize lastIntrinsicSize;
@property (nonatomic, assign) BOOL isFillet;

- (void)setBindingEntity:(id)bindingEntiy andPath:(NSString *)bindingPath;

-(NSSize)intrinsicContentSize;

@end
