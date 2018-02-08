//
//  IMBContactToiCloud.m
//  
//
//  Created by JGehry on 7/13/17.
//
//

#import "IMBADContactToiCloud.h"

@implementation IMBADContactToiCloud
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

- (void)setContactConversion:(ContactConversioniCloud *)contactConversion {
    _contactConversion = [contactConversion retain];
    NSArray *allkey = [_transferDic allKeys];
    if ([allkey count] > 0) {
        for (NSNumber *category in allkey) {
            if (category.intValue == Category_Contacts) {
                if (_contactConversion) {
                    if ([_selectArray count] > 0) {
                        _totalItemCount += [_selectArray count];
                    }else {
                        _totalItemCount += [[[[_android adContact] reslutEntity] reslutArray] count];
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
            if (category.intValue == Category_Contacts) {
                for (id entity in _selectArray) {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        break;
                    }
                    [_contactConversion conversionToiCloud:entity];
                }
                NSArray *contactAllKey = [[_contactConversion conversionDict] allKeys];
                if ([contactAllKey count] > 0) {
                    for (NSString *contactStr in contactAllKey) {
                        [_condition lock];
                        if (_isPause) {
                            [_condition wait];
                        }
                        [_condition unlock];
                        if (_isStop) {
                            break;
                        }
                        _currItemIndex++;
                        IMBiCloudContactEntity *entity = [[_contactConversion conversionDict] objectForKey:contactStr];
                        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                            [_transferDelegate transferFile:[entity lastName]];
                        }
                        CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
                        NSString *addGuid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
                        [entity setContactId:addGuid];
                        
                        //每次都必须请求一次数据
                        [_icloudManager getContactContent];
                        //To iCloud
                        BOOL success = [_icloudManager importAndroidContact:entity];
                        if (success) {
                            _successCount += 1;
                        }
                        if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                            [_transferDelegate transferProgress:_currItemIndex/(_totalItemCount*1.0)*100];
                        }
                    }
                }
            }
        }
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
}

@end
