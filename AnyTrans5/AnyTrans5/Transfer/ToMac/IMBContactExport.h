//
//  IMBContactExport.h
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-7.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBBaseTransfer.h"
#import "IMBContactManager.h"
@interface IMBContactExport : IMBBaseTransfer {
    IMBContactManager *_contactManager;
}

@property (nonatomic, retain) IMBContactManager *contactManager;

#pragma mark - export To Contacts
- (void)exportToContacts;
#pragma mark - export import Contacts
- (void)importContactVCF;
- (void)importContact:(NSMutableArray *)contactArray;
@end
