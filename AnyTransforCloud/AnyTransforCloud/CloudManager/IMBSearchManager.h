//
//  IMBSearchManager.h
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/5/10.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"
@class IMBBaseManager;

@protocol IMBSearchDelegate
@optional
- (void)searchDataComplete:(NSMutableArray *)searchAry;
- (void)searchDataFail;
//加载点击文件夹的信息。 ary {fileID1,fileID2,fileID3} 拼接是  fileID3/fileID2/fileID1
- (void)searchChooseResultsComplete:(NSMutableArray *)ary;
@end
@interface IMBSearchManager : NSObject
{
    NSString *_searchName;
    FileTypeEnum _fileTypeEnum;
    DateTypeEnum _dateTypeEntum;
    NSMutableArray *_searchAry;
    id _delegate;
    BOOL _isCancel; //取消下载
    IMBBaseManager *_baseManager;
    NSMutableArray *_pathAry;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL isCancel;
+ (IMBSearchManager*)singleton;
/**
 *  开始搜索
 *  @param name         搜索的名字
 *  @param driveID      对应云盘的driveID  dirveID 为@""  就是所有的云盘
 *  @param fileTypeEnum 搜索的类型 文件 图片。。。
 *  @param dateTypeEnum 搜索的时候类型  一个月以内 半年以内等等
 *  @param baseManger   
 */
- (void)searchName:(NSString*)name WithCloudDriveID:(NSString *)driveID WithFileType:(FileTypeEnum)fileTypeEnum WithDate:(DateTypeEnum)dateTypeEnum;
/**
 *  搜索完成
 *
 *  @param ary        搜索出来的数据
 *  @param nextString 是否搜索完成，为@""搜索完成
 */
- (void)loadDriveComplete:(NSMutableArray *)ary withNextPageToken:(NSString *)nextString withManager:(IMBBaseManager *) baseManager;

/**
 *  搜索失败
 */
- (void)loadDriveDataFail;

/**
 *  获取选择文件的信息
 *
 *  @param fileID
 *  @param baseManager
 */
- (void)getFolderInfoFileID:(NSString *)fileID WithBaseManager:(IMBBaseManager *)baseManager;

/**
 *  搜索选择文件信息成功
 *
 *  @param ary
 */
- (void)getFolderComplete:(NSMutableArray *)ary;

/**
 *  搜索选择文件信息失败
 */
- (void)getFolderFail;

/**
 *  /测试
 */
//- (void)searchDataComplete:(NSMutableArray *)searchAry {
//    IMBSearchManager *searchManger = [IMBSearchManager singleton];
//    [searchManger setDelegate:self];
//    IMBDriveModel *model = [searchAry objectAtIndex:0];
//    IMBCloudManager *cloudManager = [IMBCloudManager singleton];
//    ;
//    IMBBaseManager *manage = [cloudManager getCloudManager:[cloudManager getBindDrive:model.driveID]];
//    if (manage.baseDrive.driveType == DropboxCSEndPointURL) {
//        //        [manage getFolderInfo:model.filePath];
//        model.filePath;
//    }else {
//        [searchManger getFolderInfoFileID:model.fileID WithBaseManager:manage];
//    }
//}
//
//- (void)searchChooseResultsComplete:(NSString *)ary {
//    
//}
@end
