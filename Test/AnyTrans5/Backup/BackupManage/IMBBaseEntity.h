//
//  IMBBaseEntity.h
//  PhoneRescue
//
//  Created by iMobie on 3/22/16.
//  Copyright (c) 2016 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"


@interface IMBBaseEntity : NSObject {
    CheckStateEnum _checkState;
    BOOL _isDeleted;
    int64_t _selectedCount;
    int64_t _deleteCount;
    BOOL _isHaveExistAndDeleted;
    NSString *_sortStr;
    
    BOOL isHiddenSelectImage;
}

@property (nonatomic, readwrite) CheckStateEnum checkState;
@property (nonatomic, readwrite) BOOL isDeleted;
@property (nonatomic, readwrite) int64_t selectedCount;
@property (nonatomic, readwrite) int64_t deleteCount;
@property (nonatomic, readwrite) BOOL isHaveExistAndDeleted;
@property (nonatomic, readwrite, retain) NSString *sortStr;
@property(assign, nonatomic) BOOL isHiddenSelectImage;

@end
