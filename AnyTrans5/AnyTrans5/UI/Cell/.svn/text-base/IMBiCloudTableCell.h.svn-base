//
//  IMBiCloudTableCell.h
//  PhoneRescue
//
//  Created by 肖体华 on 14-9-26.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBCenterTextFieldCell.h"
#import "IMBiCloudDownloadProgressView.h"
//#import "IMBiCloudButton.h"
#import "IMBCommonEnum.h"
#import "IMBiCloudBackupBindingEntity.h"

@interface IMBiCloudTableCell : IMBCenterTextFieldCell{
    NSArray *_dataArray;
    NSTextField *_showText;
    
    NSNotificationCenter *nc;
    int _curRowIndex;
    int _selectIndex;
    BOOL _isSelected;
    BOOL _isDisable;
    
    NSString *_size;
    IMBiCloudBackupBindingEntity *_bindingEntity;
    NSString *_proessStr;
}
@property (nonatomic, assign) NSString *proessStr;
@property (nonatomic, readwrite, retain) NSString *size;
@property (nonatomic, readwrite, retain) NSArray *dataArray;
@property (nonatomic, readwrite, assign) int curRowIndex;
@property (nonatomic, readwrite, assign) int selectIndex;
@property (nonatomic, retain) IMBiCloudBackupBindingEntity *bindingEntity;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isDisable;//是否禁用
@end
