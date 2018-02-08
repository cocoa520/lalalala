//
//  CallLogConversioniOS.m
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "CallLogConversioniOS.h"
#import "IMBADCallHistoryEntity.h"
#import "IMBCallHistoryDataEntity.h"
@implementation CallLogConversioniOS
- (id)dataConversion:(id)entity
{
    IMBADCallContactEntity *adcalcontact = (id)entity;
    IMBCallContactModel *callContactModel = [[IMBCallContactModel alloc] init];
    callContactModel.contactName = adcalcontact.callName;
    callContactModel.callHistoryCount = adcalcontact.callCount;
    for (IMBADCallHistoryEntity *adcall in adcalcontact.callArray) {
        IMBCallHistoryDataEntity *call = [[IMBCallHistoryDataEntity alloc] init];
        call.address = adcall.phoneNumber;
        call.date = adcall.callTime;
        call.duration = adcall.duration;
        [self getCallHistoryType:adcall.callType CallHistory:call];
        [callContactModel.callHistoryList addObject:call];
        [call release];
    }
    return [callContactModel autorelease];
}

- (void)getCallHistoryType:(CallHistoryTypeEnum )callHistoryType   CallHistory:(IMBCallHistoryDataEntity *)callHistory
{

    switch (callHistoryType) {
        case 1:
            callHistory.zoriginated = 0;
            callHistory.answered = 1;
            callHistory.flags = 0;
            break;
        case 2:
            callHistory.zoriginated = 1;
            callHistory.answered = 0;
            callHistory.flags = 1;
            break;
        case 3:
            callHistory.zoriginated = 0;
            callHistory.answered = 0;
            callHistory.flags = 0;
            break;
        case 4:
            callHistory.zoriginated = 0;
            callHistory.answered = 0;
            break;
        case 5:
            callHistory.zoriginated = 0;
            callHistory.answered = 0;
            callHistory.flags = 1;
            break;
        case 6:
            callHistory.zoriginated = 0;
            callHistory.answered = 0;
            break;
        case 10:
            callHistory.zoriginated = 0;
            callHistory.answered = 0;
            callHistory.flags = 0;
            break;
        default:
            callHistory.zoriginated = 0;
            callHistory.answered = 0;
            callHistory.flags = 0;
            break;
    }
}
@end
