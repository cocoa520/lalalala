//
//  IMBAndroidTransferToiTunes.h
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBAndroidTransfer.h"
#import "IMBMediaConverter.h"

@interface IMBAndroidTransferToiTunes : IMBAndroidTransfer <TransferDelegate>
{
    NSMutableDictionary *_addItemDic;
    int _addCount;
    IMBMediaConverter *_mediaConverter;
    
    float _curPro;
    BOOL _isPhoto;
    
    int musicCount;
    int movieCount;
    int ringtoneCount;
    int iBookCount;
    int photoCount;
}

- (id)initWithAndroid:(IMBAndroid *)android TransferDataDic:(NSDictionary *)dataDic TransferDelegate:(id<TransferDelegate>)transferDelegate;

@end
