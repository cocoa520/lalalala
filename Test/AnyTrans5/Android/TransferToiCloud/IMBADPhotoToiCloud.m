//
//  IMBADPhotoToiCloud.m
//  
//
//  Created by JGehry on 7/13/17.
//
//

#import "IMBADPhotoToiCloud.h"
#import "TempHelper.h"

#define chunckSize 131072

@implementation IMBADPhotoToiCloud
@synthesize selectArray = _selectArray;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [self setSelectArray:nil];
    [super dealloc];
#endif
}

- (id)initWithTransferDataDic:(NSDictionary *)dataDic TransferDelegate:(id<TransferDelegate>)transferDelegate iCloudManager:(IMBiCloudManager *)icloudManager withAndroid:(IMBAndroid *)android {
    if (self = [super initWithTransferDataDic:dataDic TransferDelegate:transferDelegate iCloudManager:icloudManager withAndroid:android]) {
        _selectArray = [[NSMutableArray alloc] init];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}
- (void)setPhotoConversion:(PhotoConversioniCloud *)photoConversion {
    _photoConversion = [photoConversion retain];
    NSArray *allkey = [_transferDic allKeys];
    if ([allkey count] > 0) {
        for (NSNumber *category in allkey) {
            if (category.intValue == Category_Photo) {                
                if (_photoConversion) {
                    if ([_selectArray count] > 0) {
                        for (IMBADAlbumEntity *entity in _selectArray) {
                            _totalItemCount += [[entity photoArray] count];
                        }
                    }else {
                        for (IMBADAlbumEntity *entity in [[[_android adGallery] reslutEntity] reslutArray]) {
                            _totalItemCount += [[entity photoArray] count];
                        }
                    }
                }
            }
        }
    }
}

- (void)startTransfer {
    NSArray *allkey = [_transferDic allKeys];
    if ([allkey count] > 0) {
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
        NSString *iCloudImageCache = nil;
        for (NSNumber *category in allkey) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }
            if (category.intValue == Category_Photo) {
                iCloudImageCache = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"iCloudImageCache"];
                if ([[NSFileManager defaultManager] fileExistsAtPath:iCloudImageCache]) {
                    [[NSFileManager defaultManager] removeItemAtPath:iCloudImageCache error:nil];
                }
                if (![[NSFileManager defaultManager] fileExistsAtPath:iCloudImageCache]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:iCloudImageCache withIntermediateDirectories:YES attributes:nil error:nil];
                }
                //导出Photo到iCloudImageCache临时目录下
                [[_android adGallery] setTransDelegate:self];
                [[_android adGallery] exportContent:iCloudImageCache ContentList:_selectArray];
                for (id entity in _selectArray) {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        break;
                    }
                    IMBADAlbumEntity *albumEntity = nil;
                    if ([entity isMemberOfClass:[IMBADAlbumEntity class]]) {
                        albumEntity = (IMBADAlbumEntity *)entity;
                    }
                    [_photoConversion conversionAlbumToiCloud:entity];
                }
                float index = _copyPhotoItem * 0.2;
                float copyProgress = (index/(_totalItemCount*1.0))*_copyProgressPercent*0.2*100;
                float photoProgressPercent = 1 - (copyProgress / 100);
                _copyPhotoItem = 0;
                NSArray *albumAllKey = [[_photoConversion conversionDict] allKeys];
                if ([albumAllKey count] > 0) {
                    for (NSString *albumID in albumAllKey) {
                        [_condition lock];
                        if (_isPause) {
                            [_condition wait];
                        }
                        [_condition unlock];
                        if (_isStop) {
                            break;
                        }
                        NSMutableArray *albumAry = [[_photoConversion conversionDict] objectForKey:albumID];
                        if (albumAry) {
                            [_icloudManager getPhotosContent];
                            //创建Photo Album
                            BOOL success = [_icloudManager addPhotoAlbum:albumID];
                            if (success) {
                                for (IMBToiCloudPhotoEntity *entity in albumAry) {
                                    [_condition lock];
                                    if (_isPause) {
                                        [_condition wait];
                                    }
                                    [_condition unlock];
                                    if (_isStop) {
                                        break;
                                    }
                                    _currItemIndex++;
                                    IMBToiCloudPhotoEntity *photoEntity = [_icloudManager.albumArray lastObject];
                                    NSString *containerId = nil;
                                    if (photoEntity != nil && ![photoEntity.clientId isEqualToString:@"CPLAssetByAddedDate"]) {
                                        containerId = [photoEntity recordName];
                                    }
                                    if (containerId) {
                                        NSString *filePathFolder = [iCloudImageCache stringByAppendingPathComponent:albumID];
                                        NSString *filePath = [filePathFolder stringByAppendingPathComponent:entity.photoTitle];
                                        NSString *pathExtension = [[filePath lastPathComponent] pathExtension];
                                        
                                        /**
                                         *  文件格式转换：png --> jpg
                                         */
                                        if ([pathExtension isEqualToString:@"png"]) {
                                            NSString *stringPathExtension = [filePath stringByDeletingPathExtension];
                                            BOOL success = [self startConvert:stringPathExtension withConvetPath:stringPathExtension withPathExtension:pathExtension];
                                            if (success) {
                                                [_fileManager removeItemAtPath:filePath error:nil];
                                                NSString *entityPathExtension = [[entity photoTitle] stringByDeletingPathExtension];
                                                NSString *convertEntityPathExtension = [NSString stringWithFormat:@"%@.jpg", entityPathExtension];
                                                filePath = [filePathFolder stringByAppendingPathComponent:convertEntityPathExtension];
                                            }
                                        }
                                        
                                        //To iCloud
                                        BOOL result = [_icloudManager uploadPhoto:filePath withContainerId:containerId];
                                        if (result) {
                                            _successCount += 1;
                                        }
                                        if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                                            [_transferDelegate transferProgress:(copyProgress + ((_currItemIndex)/(_totalItemCount*1.0))*photoProgressPercent*100)];
                                        }
                                    }
                                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                        [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_77", nil)]];
                                    }
                                }
                            }else {
                                NSLog(@"创建相册失败，请打开图片库");
                            }
                        }
                    }
                }
            }
        }
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
        if ([_fileManager fileExistsAtPath:iCloudImageCache]) {
            [_fileManager removeItemAtPath:iCloudImageCache error:nil];
        }
    }
}

/**
 *  格式转换
 *
 *  @param sourPath      源文件路径
 *  @param conPath       目标文件路径
 *  @param pathExtension 源文件后缀名
 *
 *  @return return YES or NO
 */
- (BOOL)startConvert:(NSString *)sourPath withConvetPath:(NSString *)conPath withPathExtension:(NSString *)pathExtension {
    [_loghandle writeInfoLog:@"start Convert"];
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-i",[NSString stringWithFormat:@"%@.%@",sourPath,pathExtension],[NSString stringWithFormat:@"%@.jpg",conPath],nil];
    return [self runFFMpeg:params];
}

- (BOOL)runFFMpeg:(NSArray*)params {
    [_loghandle writeInfoLog:@"ffmpeg Start"];
    NSString* ffmpegPath = [[NSBundle mainBundle] pathForResource:@"ffmpeg" ofType:@""];
    
    if (params != nil) {
        NSTask *task = [[NSTask alloc] init];
        //Todo这里需要异步操作!!
        [task setLaunchPath: ffmpegPath];
        [task setArguments: params];
        
        [task launch];
        [task waitUntilExit];
        sleep(1);
        int status = [task terminationStatus];
        [task release];
        if (status == 0) {
            NSLog(@"Task succeeded.");
            [_loghandle writeInfoLog:@"ConvertMov succeeded"];
            return YES;
        } else {
            NSLog(@"Task failed.");
            [_loghandle writeInfoLog:@"ConvertMov failed"];
            return NO;
        }
    }
    return NO;
}

//传输准备进度开始
- (void)transferPrepareFileStart:(NSString *)file {
}

//传输准备进度结束
- (void)transferPrepareFileEnd {
}

//传输进度
- (void)transferProgress:(float)progress {
    float otherProgress = (_currItemIndex/(_totalItemCount*1.0))*100;
    _copyProgressPercent = 1 - (otherProgress / 100);
    _copyPhotoItem++;
    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
        float index = _copyPhotoItem * 0.2;
        [_transferDelegate transferProgress:(otherProgress + (index/(_totalItemCount*1.0))*_copyProgressPercent*0.2*100)];
    }
}

//当前传输文件的名字或者路径
- (void)transferFile:(NSString *)file {
    if (![StringHelper stringIsNilOrEmpty:file]) {
        [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil), file]];
    }
}

//分析进度
- (void)parseProgress:(float)progress {
}

//当前分析文件的名字或者路径
- (void)parseFile:(NSString *)file {
}

//全部传输成功
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount {
}

@end
