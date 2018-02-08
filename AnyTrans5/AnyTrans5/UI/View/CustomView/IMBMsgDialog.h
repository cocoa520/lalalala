//
//  IMBMsgDialog.h
//  iMobieTrans
//
//  Created by iMobie on 5/27/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBSMSChatDataEntity.h"
typedef enum {
    Left = 0,
    Right = 1
}DisplaySide;


@interface IMBMsgDialog : NSView{
    NSString *_text;
    NSImage *_image;
    DisplaySide _displaySide;
    IMBMessageDataEntity *_msgData;
    NSMutableArray *_imageArray;
    NSMutableArray *drawArray;
    BOOL _isiMessage;
}

@property (nonatomic,retain,setter = setText:) NSString *text;
@property (nonatomic,retain,setter = setImage:) NSImage *image;
@property (nonatomic,assign,setter = setDisplaySide:) DisplaySide displaySide;
@property (nonatomic,retain,setter = setMsgData:) IMBMessageDataEntity *msgData;
@property (nonatomic,assign) BOOL isiMessage;

- (void)setText:(NSString *)text;
- (void)setImage:(NSImage *)image;
- (void)setMsgData:(IMBMessageDataEntity *)msgData;
- (void)setDisplaySide:(DisplaySide)displaySide;

@end
