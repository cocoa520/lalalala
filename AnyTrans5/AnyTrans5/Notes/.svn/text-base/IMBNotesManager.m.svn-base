//
//  IMBNotesManager.m
//  ParseiPhoneInfoDemo
//
//  Created by Pallas on 4/27/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBNotesManager.h"
#import "StringHelper.h"
#import "DateHelper.h"

@implementation IMBNotesManager
@synthesize allNotesArray = _allNotesArray;
@synthesize allNotesDic = _allNotesDic;

- (void)queryAllNotes{
    if (_allItemDic != nil) {
        [_allItemDic release];
        _allItemDic = nil;
    }
    if (_allNotesArray != nil) {
        [_allNotesArray release];
        _allNotesArray = nil;
    }
    _allNotesArray = [[NSMutableArray alloc]init];
    _allItemDic = [[NSMutableDictionary alloc] init];
    
    id retArray = [mobileSync startQuerySessionWithDomain:@"com.apple.Notes"];
    for (id item in retArray) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            NSDictionary *tmpDic = item;
            NSArray *allKey = [tmpDic allKeys];
            if (allKey != nil && [allKey count] > 0) {
                NSMutableDictionary *noteDic = nil;
                for (NSString *key in allKey) {
                    noteDic = [[tmpDic objectForKey:key] retain];
                    [_allItemDic setValue:noteDic forKey:key];
                    [noteDic release];
                }
            }
        }
    }
    NSArray *message = [NSArray arrayWithObjects:
               @"SDMessageAcknowledgeChangesFromDevice",
               @"com.apple.Notes",
               nil];

    __block BOOL needHandClose = NO;
    __block BOOL onece = NO;
    while (YES) {
        if(mobileSync == nil || _threadBreak)
        {
            break;
        }
        retArray = [mobileSync getData:message waitingReply:YES];
        
        if ([[retArray objectAtIndex:0] isEqualToString:@"SDMessageDeviceReadyToReceiveChanges"]) {
            break;
        }else
        {
            if (!onece) {
                onece = YES;
                double delayInSeconds = 15.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    needHandClose = YES;
                });
            }
        }
        if (needHandClose) {
            break;
        }
    }
    [mobileSync endSessionWithDomain:@"com.apple.Notes"];
    for(NSString *key in _allItemDic.allKeys){
        IMBNoteModelEntity *entity = [[IMBNoteModelEntity alloc]init];
        entity.noteKey = key;
        entity.author = [[_allItemDic objectForKey:key] objectForKey:@"author"];
        entity.content = [self modifyShowContent:[[_allItemDic objectForKey:key] objectForKey:@"content"]];//[StringHelper flattenHTML:[[_allItemDic objectForKey:key] objectForKey:@"content"] trimWhiteSpace:YES] ;
        entity.contentType = [[_allItemDic objectForKey:key] objectForKey:@"contentType"];
        NSDate *cdate = [[_allItemDic objectForKey:key] objectForKey:@"dateCreated"];
        entity.creatDateStr = [DateHelper stringFromFomate:cdate formate:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *mdate = [[_allItemDic objectForKey:key] objectForKey:@"dateModified"];
        entity.modifyDateStr = [DateHelper stringFromFomate:mdate formate:@"yyyy-MM-dd HH:mm:ss"];
        entity.modifyDate = [DateHelper getTimeStampFrom1970Date:mdate];
        entity.shortDateStr = [DateHelper stringFromFomate:mdate formate:@"yyyy-MM-dd"];
        entity.title = [self modifyShowContent:[[_allItemDic objectForKey:key] objectForKey:@"subject"]];//[StringHelper flattenHTML:[[_allItemDic objectForKey:key] objectForKey:@"subject"] trimWhiteSpace:YES];
        entity.summary = entity.title;
        if (entity.title == nil ||[entity.title isEqualToString:@""]) {
            entity.title =  CustomLocalizedString(@"Common_id_10", nil);
        }
        [_allNotesArray addObject:entity];
        [entity release];
    }
}

- (NSString *)modifyShowContent:(NSString *)content {
    NSString *str = content;
    str = [str stringByReplacingOccurrencesOfString:@"<div><br></div>" withString:@"\r\n"];
    str = [str stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<div>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<br>" withString:@"\r"];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    return str;
}

- (void)dealloc{
    if (_allNotesArray != nil) {
        [_allNotesArray release];
        _allNotesArray = nil;
    }
    if (_allItemDic != nil) {
        [_allItemDic release];
        _allItemDic = nil;
    }
    [super dealloc];
}

+ (BOOL)checkNotesValidWithIPod:(IMBiPod *)ipod {
   return [super checkItemsValidWithIPod:ipod itemKey:@"Notes"];
}

-(NSDictionary *)insertNote:(IMBNoteModelEntity *)entity{
    NSDictionary *retDic = nil;
    
    [mobileSync startModifySessionWithDomain:@"com.apple.Notes" withDomainAnchor:@"Notes-Device-Anchor"];
    NSArray *addNoteContent = [self prepareInsetData:entity.content author:entity.author];
    NSArray *retDicArray = [mobileSync getData:addNoteContent waitingReply:YES];
    
    [mobileSync endSessionWithDomain:@"com.apple.Notes"];
    NSLog(@"retDic:%@",retDic);
    retDic = [IMBNotesManager findDictionaryInNoteArray:retDicArray];
    return retDic;
}

+ (NSDictionary *)findDictionaryInNoteArray:(NSArray *)arr{
    CFArrayRef dicArr = (CFArrayRef)arr;
    NSArray *array = (NSArray *)dicArr;
    for (id item in array) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = item;
            return dic;
        }
    }
    return nil;
}


- (NSArray*)prepareInsetData:(NSString*)content author:(NSString*)author {
    NSMutableArray *addNoteArr = [[NSMutableArray alloc] init];
    [addNoteArr addObject:@"SDMessageProcessChanges"];
    [addNoteArr addObject:@"com.apple.Notes"];
    srandom((unsigned int)time((time_t *)NULL));
    
    NSMutableDictionary *notesDic = [[NSMutableDictionary alloc] init];
    NSString *nRandID = [NSString stringWithFormat:@"Note/%ld", random()];
    NSMutableDictionary *detailDic = [[NSMutableDictionary alloc] init];
    [detailDic setObject:author forKey:@"author"];
    [detailDic setObject:@"com.apple.notes.Note" forKey:@"com.apple.syncservices.RecordEntityName"];
    NSString *con = [self modifySaveContent:content];
    if (con) {
        [detailDic setObject:con forKey:@"content"];
    }
    [detailDic setObject:@"text/html" forKey:@"contentType"];
    [detailDic setObject:[NSDate date] forKey:@"dateCreated"];
    [detailDic setObject:[NSDate date] forKey:@"dateModified"];
    [detailDic setObject:content forKey:@"subject"];
    [notesDic setObject:detailDic forKey:nRandID];
    [detailDic release];
    
    [addNoteArr addObject:notesDic];
    [notesDic release];
    
    [addNoteArr addObject:[NSNumber numberWithBool:NO]];
    [addNoteArr addObject:@"___EmptyParameterString___"];
    return addNoteArr;
}

- (BOOL)modifyNote:(IMBNoteModelEntity *)entity {
    NSArray *retArray = nil;
    
    [mobileSync startModifySessionWithDomain:@"com.apple.Notes" withDomainAnchor:@"Notes-Device-Anchor"];
    
    NSMutableArray *modifyArray = [self prepareModifyData:entity.content orgNoteKey:entity.noteKey];
    retArray = [mobileSync getData:modifyArray waitingReply:YES];
    
    [mobileSync endSessionWithDomain:@"com.apple.Notes"];
    return YES;
}


- (NSMutableArray*)prepareModifyData:(NSString*)content orgNoteKey:(NSString*)orgNoteKey {
    NSMutableArray *modifyArray = [[NSMutableArray alloc] init];
    [modifyArray addObject:@"SDMessageProcessChanges"];
    [modifyArray addObject:@"com.apple.Notes"];
    NSArray *noteKeys = [_allItemDic allKeys];
    NSMutableDictionary *notesDic =[[NSMutableDictionary alloc] init];
    if ([noteKeys containsObject:orgNoteKey]) {
        NSMutableDictionary *noteDic = [[NSMutableDictionary alloc] initWithDictionary:[_allItemDic objectForKey:orgNoteKey]] ;
        NSString *con = [self modifySaveContent:content];
        if (con) {
            [noteDic setObject:con forKey:@"content"];
        }
        [noteDic setObject:[NSDate date] forKey:@"dateModified"];
        [noteDic setObject:content forKey:@"subject"];
        [notesDic setObject:noteDic forKey:orgNoteKey];
    }
    
    [modifyArray addObject:notesDic];
    [notesDic release];
    
    [modifyArray addObject:[NSNumber numberWithBool:NO]];
    [modifyArray addObject:@"___EmptyParameterString___"];
    
    return modifyArray;
}

- (BOOL)delNotes:(NSArray*)delEntities {
    NSArray *retArray = nil;
    [mobileSync startDeleteSessionWithDomain:@"com.apple.Notes" withDomainAnchor:@"Notes-Device-Anchor"];
    NSMutableArray *notesIDArray = [[NSMutableArray alloc]initWithCapacity:delEntities.count];
    for (IMBNoteModelEntity *entity in delEntities) {
        [notesIDArray addObject:entity.noteKey];
    }
    NSArray *delContent = [self prepareDelData:notesIDArray];
    retArray = [mobileSync getData:delContent waitingReply:NO];
    
    [mobileSync endSessionWithDomain:@"com.apple.Notes"];
    return YES;
}

- (NSArray*)prepareDelData:(NSArray*)contentIDArray {
    NSMutableArray *delArray = [[NSMutableArray alloc] init];
    [delArray addObject:@"SDMessageProcessChanges"];
    [delArray addObject:@"com.apple.Notes"];
    
    NSMutableDictionary *delDetail = [[NSMutableDictionary alloc] init];
    for (NSString *cid in contentIDArray) {
        [delDetail setValue:@"___EmptyParameterString___" forKey:cid];
    }
    [delArray addObject:delDetail];
    
    [delArray addObject:[NSNumber numberWithBool:NO]];
    
    [delArray addObject:@"___EmptyParameterString___"];
    
    [delArray autorelease];
    return delArray;
}

- (NSString *)modifySaveContent:(NSString *)str {
    NSString *retStr = [str stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp;"];
    if (![StringHelper stringIsNilOrEmpty:retStr]) {
        NSArray *contentArray = [NSArray arrayWithObjects:@"\r\n", @"\n\n", @"\r", @"\n", nil];
        if (contentArray != nil && contentArray.count > 0) {
            for(NSString *item in contentArray) {
                retStr = [retStr stringByReplacingOccurrencesOfString:item withString:@"<br/>"];
            }
        }
    }
    return retStr;
}

- (BOOL)exportAllNotesToFile:(NSString *)stringPath withIpod:(IMBiPod *)ipod{
    BOOL isSuccess = YES;
    [self openMobileSync];
    [self queryAllNotes];
    [self closeMobileSync];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![IMBNotesManager checkNotesValidWithIPod:ipod]) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:ERROR_ICLOUND_NOT_OPEN object:nil];
        NSLog(@"iclound not open error");
        return NO;
    }
    if (![fileManager fileExistsAtPath:stringPath]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_INVALID_EXPORT_PATH object:nil];
        NSLog(@"invalid export path");
        return NO;
    }
    NSMutableString *stringBuilder = [[NSMutableString alloc]init];
    for (IMBNoteModelEntity *entity in _allNotesArray) {
        
        NSString *str = [NSString stringWithFormat:@"************************************\ntitle:%@\ncontent:\n%@\n************************************\n",entity.summary,entity.content];;
        [stringBuilder appendString:str];
    }
    NSError *error = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    
    NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter release];
    
    NSString *suffix = [NSString stringWithFormat:@"Notes%@",destDateString];
    [stringBuilder writeToFile:[NSString stringWithFormat:@"%@/%@.txt",stringPath,suffix] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    if (error != nil) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_EXPORT_ERROR object:nil];
        isSuccess = NO;
    }
    if (error != nil) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_EXPORT_ERROR object:nil];
        isSuccess = NO;
    }
    [stringBuilder release];
    return isSuccess;
}

- (BOOL)exportTofolderPath:(NSString *)folderPath noteArray:(NSMutableArray *)noteArray withExportMode:(NSString *)type
{
//    NSNotificationCenter *nc1 = [NSNotificationCenter defaultCenter];
    NSString *filePath = nil;
    if ([type isEqualToString:@".text"]) {
        filePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",CustomLocalizedString(@"MenuItem_id_17", nil)]];
    }else if([type isEqualToString:@".csv"]) {
        filePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.csv",CustomLocalizedString(@"MenuItem_id_17", nil)]];
    }
    
    NSFileManager *Manager = [NSFileManager defaultManager];
    if ([Manager fileExistsAtPath:filePath]) {
        
        filePath = [self createDifferentfileNameinfolder:folderPath filePath:filePath fileManager:Manager];
    }
    BOOL success = [Manager createFileAtPath:filePath contents:nil attributes:nil];
    if (success) {
        NSFileHandle *fhandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        int totalItem = (int)[noteArray count];
        int successNum = 0;
        BOOL isOutOfCount = NO;//[IMBHelper determinWhetherIsOutOfTransferCount];
       if (!isOutOfCount) {
//            [nc1 postNotificationName:COPYINGNOTIFICATION object:[NSNumber numberWithInt:FileTypeIcon]];
//           [nc1 postNotificationName:NOTIFY_TRANSCATEGORY object:CustomLocalizedString(@"Export_id_7", nil) userInfo:nil];
            for (int i=0;i<totalItem; i++) {
                if (_threadBreak == YES) {
                    break;
                }
                IMBNoteModelEntity *note = [noteArray objectAtIndex:i];
                NSString *fileName = note.title;
//                int currItemIndex = i+1;
//                BOOL IsNeedAnimation = YES;
//                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                             fileName,@"Message",
//                                             [NSNumber numberWithInt:currItemIndex], @"CurItemIndex",
//                                             [NSNumber numberWithBool:IsNeedAnimation],@"IsNeedAnimation",
//                                             [NSNumber numberWithInt:totalItem], @"TotalItemCount",
//                                             nil];
//                [nc1 postNotificationName:NOTIFY_CURRENT_MESSAGE object:fileName];
//                [nc1 postNotificationName:NOTIFY_TRANSCOUNTPROGRESS object:@"MSG_COM_Total_Progress" userInfo:info];
                NSData *data = nil;
                if ([type isEqualToString:@".text"]) {
                    data = [[note description] dataUsingEncoding:NSUTF8StringEncoding];
                }else if([type isEqualToString:@".csv"]) {
                    if (i == 0) {
//                        data = [[note descriptionByCSV1] dataUsingEncoding:NSUTF8StringEncoding];
                    }else {
//                        data = [[note descriptionByCSV] dataUsingEncoding:NSUTF8StringEncoding];
                    }
                }
                
                [fhandle writeData:data];
                successNum++;
                [_transResult setMediaSuccessCount:([_transResult mediaSuccessCount] + 1)];
                [_transResult recordMediaResult:fileName resultStatus:TransSuccess messageID:@"MSG_PlaylistResult_Success"];
                _progressCounter.prepareAnalysisSuccessCount++;
//                BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//                if (isOutOfCount) {
//                    break;
//                }

            }

        }
        
        [fhandle closeFile];
//        if (_softWareInfo != nil && _softWareInfo.isNeedRegister&&_softWareInfo.isRegistered == false) {
//            [_softWareInfo addLimitCount:_transResult.mediaSuccessCount];
//        }
        sleep(2);
//         NSDictionary *infor = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:successNum],@"successNum",[NSNumber numberWithInt:FileResultTypeIcon],@"transferType", nil];
//        [nc1 postNotificationName:NOTIFY_TRANSCOMPLETE object:CustomLocalizedString(@"MSG_COM_Transfer_Completed", nil) userInfo:infor];
        return YES;
    }else
    {
        sleep(2);
//        NSDictionary *infor = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"successNum",[NSNumber numberWithInt:FileResultTypeIcon],@"transferType", nil];
//        [nc1 postNotificationName:NOTIFY_TRANSCOMPLETE object:CustomLocalizedString(@"MSG_COM_Transfer_Completed", nil) userInfo:infor];
        return NO;
        
    }
    
}


@end
