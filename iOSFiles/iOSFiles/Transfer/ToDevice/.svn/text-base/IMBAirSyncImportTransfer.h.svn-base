//
//  IMBAirSyncImportTransfer.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-28.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseTransfer.h"
#import "IMBCommonEnum.h"
#import "IMBMediaConverter.h"
#import "IMBPhotoEntity.h"
#import "IMBPlaylist.h"
#import "IMBATHSync.h"
/**
 此类的作用是导入到设备 传输类型有app media book photo ringtong voicememos
 除app外 其他类型都是通过同步的方式导入
 */


@interface IMBAirSyncImportTransfer : IMBBaseTransfer<ATHCopyFileToDeviceListener>
{
    //存放需要导入文件的路径
    NSArray *_importFilePath;  //开始传输时，传入的需要导入的文件路径集合
    BOOL _isSingleImport; //是单个类型导入还是多个类型一起导入
    BOOL _isNeedConversion;
    CategoryNodesEnum _importcategory; //传入导入文件的类型
    IMBMediaConverter *_mediaConverter;
    NSMutableArray *_toConvertFiles;
    NSMutableArray *_toConvertCategoryEnums;
    NSMutableArray *_importFiles;  //将各个传输文件分类存储在_importFiles中 与_importcategoryNodes进行一一对应 _importFiles中存储的是数组，数组中存放的是文件路径
    NSMutableArray *_importcategoryNodes;
    int64_t _maxID;
    IMBPhotoEntity *_importPhotoAlbum;
    int64_t _playlistID;
    IMBPlaylist *_plistItem;
    //itunes中部分导入时使用
    BOOL _isNeedToSpecificPlaylist;
    NSString *_specificPlistName;
    IMBTracklist *_listTrack;
    //itunes中playlists导入时使用
    NSDictionary *_specificPlistNamses;
    //同步类
    IMBATHSync *_athSync;
    NSString *_rename;
    
    //用于android手机到iOS 数据的存储
    NSMutableDictionary *_transferDic;
    
    NSString *_maxUUIDStr;
    
    BOOL _isRestore;
    
    @public
    BOOL _isiTunesImport; //如果是itunes导入 则不需要转换
}
@property (nonatomic, readwrite) BOOL isRestore;
/**
 如果有导入到photoAlbum 传入photoAlbum对象 否则传入为空 
 importFilePath为导入文件的路径数组
 CategoryNodesEnum 为导入文件类型，如果各种文件一起导入则传入Category_Summary即可
 */
- (id)initWithIPodkey:(NSString *)ipodKey importFiles:(DriveItem*)importFilePath CategoryNodesEnum:(CategoryNodesEnum)importcategory photoAlbum:(IMBPhotoEntity *)photoAlbum playlistID:(int64_t)playlistID delegate:(id)delegate;
- (id)initWithIPodkey:(NSString *)ipodKey TransferDic:(NSMutableDictionary *)transferDic delegate:(id)delegate;
//重命名相册
- (id)initWithIPodkey:(NSString *)ipodKey Rename:(NSString *)rename AlbumEntity:(IMBPhotoEntity *)albumEntity;
- (NSDictionary *)paraseFileType;
- (void)prepareAndFilterConverterFiles:(NSDictionary *)dictionary;
- (BOOL)conversionAndImportFiles;
- (NSMutableArray *)prepareAllTrack;

#pragma mark - 重命名相册
-(void)renameAlbum;
@end
