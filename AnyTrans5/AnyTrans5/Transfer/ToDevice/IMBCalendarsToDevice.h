//
//  IMBCalendarsToDevice.h
//  AnyTrans
//
//  Created by iMobie on 7/27/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBBaseTransfer.h"
#import "IMBCalendarsManager.h"

@interface IMBCalendarsToDevice : IMBBaseTransfer {
    NSString *_calendarID;
    NSArray *_selectedArr;
    IMBCalendarsManager *_calendarsManager;
}


- (id)initWithCalendarID:(NSString *)calendarID selectedArray:(NSArray *)selectArrs desiPodKey:(NSString *)desiPodKey delegate:(id)delegate;

@end
