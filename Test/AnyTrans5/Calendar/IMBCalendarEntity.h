//
//  IMBCalendarEntity.h
//  iMobieTrans
//
//  Created by iMobie on 14-2-24.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBBaseModel.h"
@interface IMBCalendarEntity : IMBBaseModel
{
    NSString  *_calendarID;
    NSString  *_title;
    NSString  *_calendarRowID;
    NSColor   *_color;
    NSMutableArray *_eventCalendatArray;
    int _isOnlyRead;
    NSString *_recordEntityName;
    NSInteger _tag;
}

@property(nonatomic,retain)NSString  *calendarID;      //根据mobilesync calendarID为1/calendarRowID
@property(nonatomic,retain)NSString  *calendarRowID;   //calendarRowID为数据库中的ID
@property(nonatomic,retain)NSString  *title;
@property(nonatomic,retain)NSColor *color;
@property(nonatomic,retain)NSMutableArray *eventCalendatArray;
@property(nonatomic,readwrite)int isOnlyRead;
@property(nonatomic,retain)NSString *recordEntityName;
@property (nonatomic, assign) NSInteger tag;

@end
