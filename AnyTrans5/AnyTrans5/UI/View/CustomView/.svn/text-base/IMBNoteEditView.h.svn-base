//
//  IMBNoteEditView.h
//  iMobieTrans
//
//  Created by apple on 9/27/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NoteTextGrowthField.h"

@interface IMBNoteEditView : NSView{
    NSString *_time;
    NSString *_contentValue;
    NSRect _timeRect;
    NSRect _contentRect;
    NSTextField *_timeField;
    NoteTextGrowthField *_contentField;
    BOOL _isEditing;
}

@property (nonatomic,retain,setter = setTime:) NSString *time;
@property (nonatomic,retain,setter = setContent:) NSString *contentValue;
@property (nonatomic, retain) NoteTextGrowthField *contentField;
- (void)setTime:(NSString *)time;
- (void)setContent:(NSString *)content;
- (void)setIsEditing:(BOOL)isEditing;
- (void)setBindingEntity:(id)bindingEntiy andPath:(NSString *)bindingPath;

@end;