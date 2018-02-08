//
//  IMBPhotoExportSettingConfig.h
//  AnyTrans
//
//  Created by long on 10/16/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
//事件标签
typedef enum LivePhotoType {
    ExportLivePhoto_MP4 = 1,
    ExportLivePhoto_M4V = 2,
    ExportLivePhoto_GifHigh = 3,
    ExportLivePhoto_GifMiddle = 4,
    ExportLivePhoto_GifLow = 5,
    ExportLivePhoto_GifOriginal = 6,
}LivePhotoTypeEnum;
@interface IMBPhotoExportSettingConfig : NSObject
{
    NSString *_exportPath;
    NSString *_configLocalPath;
    NSFileManager *_fm;
    BOOL _isHEICState;
    int _chooseLivePhotoExportType; //1.MP4 2.M4V 3.gif 高质量 原图 4.gif 中等质量 2/1图 5.gif 低质量图 4/1 6.live Photos 原始格式导出
    BOOL _sureSaveCheckBtnState;
    BOOL _isCreadPhotoDate;
}
@property (nonatomic, retain) NSString *exportPath;
@property (nonatomic, assign) BOOL isHEICState;
@property (nonatomic, assign) int chooseLivePhotoExportType;
@property (nonatomic, assign) BOOL sureSaveCheckBtnState;
@property (nonatomic, assign) BOOL isCreadPhotoDate;
+ (IMBPhotoExportSettingConfig*)singleton;
- (void)saveData;
@end
