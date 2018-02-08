//
//  IMBBackupNoteEditView.h
//  iMobieTrans
//
//  Created by apple on 9/27/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NoteTextGrowthField.h"
@interface IMBBackupNoteEditView : NSView{
    NSString *_time;
    NSString *_contentValue;
    NSRect _timeRect;
    NSRect _contentRect;
    NSTextField *_timeField;
    NoteTextGrowthField *_contentField;
    BOOL _isEditing;
    int _noteHigh;
    int _strHigh;
}
@property (nonatomic, retain) NoteTextGrowthField *contentField;
@property (nonatomic, assign) int noteHigh;
@property (nonatomic,retain,setter = setTime:) NSString *time;
@property (nonatomic,retain,setter = setContent:) NSString *contentValue;
- (void)setIsEditing:(BOOL)isEditing;
- (void)setTime:(NSString *)time;
- (void)setContent:(NSString *)content;
- (void)setBindingEntity:(id)bindingEntiy andPath:(NSString *)bindingPath;
- (void)addAttachment:(NSString *)path;
@end;