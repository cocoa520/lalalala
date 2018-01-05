//
//  IMBNoteContentView.h
//  iMobieTrans
//
//  Created by iMobie on 5/27/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBNoteContentView : NSView{
    NSString *_time;
    NSString *_content;
    NSRect _timeRect;
    NSRect _contentRect;
}
@property (nonatomic,retain,setter = setTime:) NSString *time;
@property (nonatomic,retain,setter = setContent:) NSString *content;

- (void)setTime:(NSString *)time;
- (void)setContent:(NSString *)content;

@end
