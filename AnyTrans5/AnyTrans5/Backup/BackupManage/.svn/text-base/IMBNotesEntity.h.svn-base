//
//  IMBNotesBindingEntity.h
//  PhoneClean3.0
//
//  Created by Pallas on 8/19/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBBaseEntity.h"

@protocol CheckBoxStateChange
@required
- (void)checkboxStatusChange:(id)sender;

@end

@class IMBTextBlock;

@interface IMBNotesEntity : IMBBaseEntity {
@private
    NSString *_noteKey;
    NSString *_title;
    NSString *_author;
    long _createDate;
    NSString *_modifyDate;
    NSString *_content;
    NSString *_contentType;
    NSString *_subject;
    BOOL _isNew;
}

@property (nonatomic, readwrite, retain) NSString *noteKey;
@property (nonatomic, readwrite, retain) NSString *title;
@property (nonatomic, readwrite, retain) NSString *author;
@property (nonatomic, assign) long createDate;
@property (nonatomic, readwrite, retain) NSString *modifyDate;
@property (nonatomic, readwrite, retain) NSString *content;
@property (nonatomic, readwrite, retain) NSString *contentType;
@property (nonatomic, readwrite, retain) NSString *subject;
@property (nonatomic, assign) BOOL isNew;

- (NSString *)descriptionByCSV;
- (NSString *)descriptionByCSV1;

@end
