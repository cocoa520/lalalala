//
//  IMBTransferToiOS.h
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBAndroidTransfer.h"
#import "DataConversion.h"
@interface IMBTransferToiOS : IMBAndroidTransfer<TransferDelegate>
{
    NSString *_errorCode;
    BOOL _hasError;
    __block BOOL _retry;
    id <DataConversion> _messageConversion; ///< message 转换协议类
    id <DataConversion> _contactConversion; ///< contact 转换协议类
    id <DataConversion> _callHistoryConversion; ///< calllog 转换协议类
    id <DataConversion> _calendarConversion; ///< calendar 转换协议类
    double _progress;
    BOOL _isToPC;
    BOOL _hasPhotoBack;
    BOOL _transferDocument;
    IMBBaseTransfer *_baseTransfer;
    int _messageCount;
    int _contactCount;
    int _calendarCount;
    int _callHistoryCount;
    int _musicCount;
    int _moviesCount;
    int _ringtoneCount;
    int _myAblumsCount;
    int _iBookCount;
    int _documentCount;
    int _compressedCount;
    int _mediaCount;
    int _cumediaCount;
    BOOL _isTransMeida;
    float _cumeidaProgress;
}

/**
 ipodKey:iOS设备唯一标识  android:android设备句柄  
 dataDic:传输数据字典 transferDelegate:传输协议代理
 
 */
- (id)initWithIPodkey:(NSString *)ipodKey Android:(IMBAndroid *)android  TransferDataDic:(NSDictionary *)dataDic TransferDelegate:(id<TransferDelegate>)transferDelegate;
/**
 设置message contact calllog  calendar的数据转换类，数据转换类 
 主要是讲android的数据类型转换为iOS的数据类型
 */
- (void)setMessagConversion:(id <DataConversion>) messageConversion ContactConversion:(id <DataConversion>)contactConversion
      CallHistoryConversion:(id <DataConversion>) callHistoryConversion CalendarConversion:(id <DataConversion>)calendarConversion;
@end
