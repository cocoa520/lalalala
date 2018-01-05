//
//  IMBADCalendar.h
//  PhoneRescue_Android
//
//  Created by iMobie on 4/5/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBBaseCommunicate.h"
#import "IMBADCalendarEntity.h"

@interface IMBADCalendar : IMBBaseCommunicate {
    NSMutableArray *_accountList;
}
@property (nonatomic, retain) NSMutableArray *accountList;

@end
