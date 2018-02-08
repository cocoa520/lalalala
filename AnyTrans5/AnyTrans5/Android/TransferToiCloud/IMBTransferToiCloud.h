//
//  IMBTransferToiCloud.h
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBAndroidTransfer.h"
#import "IMBiCloudManager.h"
#import "ContactConversioniCloud.h"
#import "CalendarConversioniCloud.h"
#import "PhotoConversioniCloud.h"

@interface IMBTransferToiCloud : IMBAndroidTransfer<TransferDelegate>
{
    IMBiCloudManager *_icloudManager;
    ContactConversioniCloud *_contactConversion;                 //联系人转换
    CalendarConversioniCloud *_calendarConversion;               //日历转换
    PhotoConversioniCloud *_photoConversion;                     //图片转换
    float _copyProgressPercent;
    int _copyPhotoItem;
    
    int contactCount;                                            //当前选择联系人个数
    int calendarCount;                                           //当前选择日历个数
    int photoCount;                                              //当前选择图片个数
}

/**
 *  copyProgressPercent        copy photo占用百分比
 *  copyPhotoItem              copy photo项数
 */
@property (nonatomic, assign) float copyProgressPercent;
@property (nonatomic, assign) int copyPhotoItem;

- (id)initWithTransferDataDic:(NSDictionary *)dataDic TransferDelegate:(id<TransferDelegate>)transferDelegate iCloudManager:(IMBiCloudManager *)icloudManager withAndroid:(IMBAndroid *)android;
- (void)setContactConversion:(ContactConversioniCloud *)contactConversion calendarConversion:(CalendarConversioniCloud *)calendarConversion photoConversion:(PhotoConversioniCloud *)photoConversion;

@end
