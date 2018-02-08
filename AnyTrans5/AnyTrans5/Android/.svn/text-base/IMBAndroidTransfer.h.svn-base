//
//  IMBAndroidTransfer.h
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBBaseTransfer.h"
#import "IMBAndroid.h"
#import "IMBADAudioTrack.h"
#import "IMBADVideoTrack.h"
#import "IMBADFileEntity.h"
#import "IMBADPhotoEntity.h"
/**
 android 传输类的父类
 */
@interface IMBAndroidTransfer : IMBBaseTransfer
{
    IMBAndroid *_android; ///<此处需要添加Android对象,用来将android数据传输到电脑
    NSDictionary *_transferDic; ///< 需要传输的android数据，以字典形式存在  以key来区分类型
}
//初始化方法
- (id)initWithTransferDataDic:(NSDictionary *)dataDic TransferDelegate:(id<TransferDelegate>)transferDelegate;

@end
