//
//  IMBCalendarToiCloud.m
//  
//
//  Created by JGehry on 7/13/17.
//
//

#import "IMBADCalendarToiCloud.h"

@implementation IMBADCalendarToiCloud
@synthesize selectArray = _selectArray;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [self setSelectArray:nil];
    [super dealloc];
#endif
}

- (id)initWithTransferDataDic:(NSDictionary *)dataDic TransferDelegate:(id<TransferDelegate>)transferDelegate iCloudManager:(IMBiCloudManager *)icloudManager withAndroid:(IMBAndroid *)android {
    if (self = [super initWithTransferDataDic:dataDic TransferDelegate:transferDelegate iCloudManager:icloudManager withAndroid:android]) {
        _selectArray = [[NSMutableArray alloc] init];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)setCalendarConversion:(CalendarConversioniCloud *)calendarConversion {
    _calendarConversion = [calendarConversion retain];
    NSArray *allkey = [_transferDic allKeys];
    if ([allkey count] > 0) {
        for (NSNumber *category in allkey) {
            if (category.intValue == Category_Calendar) {                
                if (_calendarConversion) {
                    if ([_selectArray count] > 0) {
                        for (IMBCalendarAccountEntity *entity in _selectArray) {
                            _totalItemCount += [[entity eventArray] count];
                        }
                    }else {
                        for (IMBCalendarAccountEntity *entity in [[[_android adCalendar] reslutEntity] reslutArray]) {
                            _totalItemCount += [[entity eventArray] count];
                        }
                    }
                }
            }
        }
    }
}

- (void)startTransfer {
    NSArray *allkey = [_transferDic allKeys];
    if ([allkey count] > 0) {
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
        for (NSNumber *category in allkey) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }
            if (category.intValue == Category_Calendar) {
                for (id entity in _selectArray) {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        break;
                    }
                    [_calendarConversion conversionAccountToiCloud:entity];
                }
                NSArray *eventAllKey = [[_calendarConversion conversionDict] allKeys];
                if ([eventAllKey count] > 0) {
                    for (NSString *acountID in eventAllKey) {
                        [_condition lock];
                        if (_isPause) {
                            [_condition wait];
                        }
                        [_condition unlock];
                        if (_isStop) {
                            break;
                        }
                        NSMutableDictionary *acountDict = [[_calendarConversion conversionDict] objectForKey:acountID];
                        if (acountDict) {
                            BOOL success = NO;
                            if ([_icloudManager getCalendarCollectionContentName:[acountDict objectForKey:@"accountName"]]) {
                                success = YES;
                            }else {
                                //创建Calendar Conllection
                                success = [_icloudManager addCalenderCollection:[acountDict objectForKey:@"accountName"]];
                            }
                            if (success) {
                                for (NSString *eventID in [acountDict allKeys]) {
                                    [_condition lock];
                                    if (_isPause) {
                                        [_condition wait];
                                    }
                                    [_condition unlock];
                                    if (_isStop) {
                                        break;
                                    }
                                    if ([eventID isEqualToString:@"accountName"]) {
                                        continue;
                                    }
                                    _currItemIndex++;
                                    IMBiCloudCalendarEventEntity *entity = [acountDict objectForKey:eventID];
                                    for (IMBiCloudCalendarCollectionEntity *colleciton in _icloudManager.calendarCollectionArray) {
                                        if ([colleciton.title isEqualToString:[acountDict objectForKey:@"accountName"]]) {
                                            CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
                                            NSString *addGuid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
                                            entity.guid = addGuid;
                                            entity.pGuid = colleciton.guid;
                                            break;
                                        }
                                    }
                                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                        [_transferDelegate transferFile:entity.summary];
                                    }
                                    
                                    //To iCloud
                                    BOOL success = [_icloudManager addCalender:entity];
                                    if (success) {
                                        _successCount += 1;
                                    }
                                    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                                        [_transferDelegate transferProgress:_currItemIndex/(_totalItemCount*1.0)*100];
                                    }
                                }
                            }else {
                                NSLog(@"创建日历组失败");
                            }
                        }
                    }
                    [_icloudManager getCalendarContent];
                }
            }
        }
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
}

@end
