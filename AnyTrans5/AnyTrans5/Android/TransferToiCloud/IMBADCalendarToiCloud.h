//
//  IMBCalendarToiCloud.h
//  
//
//  Created by JGehry on 7/13/17.
//
//

#import "IMBTransferToiCloud.h"

@interface IMBADCalendarToiCloud : IMBTransferToiCloud {
    NSMutableArray *_selectArray;
}

/*
 *    selectArray    选择性传输数组
 */
@property (nonatomic, readwrite, retain) NSMutableArray *selectArray;

- (void)setCalendarConversion:(CalendarConversioniCloud *)calendarConversion;

@end
