//
//  IMBNotesManager.h
//  ParseiPhoneInfoDemo
//
//  Created by Pallas on 4/27/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileDeviceAccess.h"
#import "IMBiPod.h"
#import "FMDatabase.h"
#import "IMBNoteDataEntity.h"
#import "IMBMobileSyncManager.h"

@interface IMBNotesManager : IMBMobileSyncManager {
@private
    AMDevice *deviceHandle;
    AMMobileSync *mobleSync;
    BOOL isValid;
    
    NSMutableDictionary *_allNotesDic;
    NSMutableDictionary *_redundancyDic;
    int increNum;
    NSMutableArray *_allNotesArray;
    
}

@property (nonatomic, readwrite, retain) NSMutableDictionary *allNotesDic;
@property (nonatomic,retain) NSMutableArray *allNotesArray;

- (void)queryAllNotes;                                  //查询所有笔记

- (NSDictionary *)insertNote:(IMBNoteModelEntity *)entity;  //插入一条笔记

- (BOOL)modifyNote:(IMBNoteModelEntity *)entity;           //修改一条笔记

- (BOOL)delNotes:(NSArray*)delEntities;                  //删除一条笔记,传递对象数组

+ (BOOL)checkNotesValidWithIPod:(IMBiPod *)ipod;

- (BOOL)exportAllNotesToFile:(NSString *)stringPath withIpod:(IMBiPod *)ipod;
//luolei add
- (BOOL)exportTofolderPath:(NSString *)folderPath noteArray:(NSMutableArray *)noteArray withExportMode:(NSString *)type;
@end
