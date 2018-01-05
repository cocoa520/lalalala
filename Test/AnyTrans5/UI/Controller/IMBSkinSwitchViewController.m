//
//  IMBSkinSwitchViewController.m
//  AnyTrans
//
//  Created by iMobie on 10/18/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBSkinSwitchViewController.h"
#import "TempHelper.h"
#import "SystemHelper.h"
#import "IMBSoftWareInfo.h"
#import "IMBNotificationDefine.h"
#import "IMBZipHelper.h"
#import "NSString+Compare.h"
#import "IMBPopViewController.h"
#import "IMBSoftWareInfo.h"
@interface IMBSkinSwitchViewController ()

@end

@implementation IMBSkinSwitchViewController
@synthesize skinArray = _skinArray;

- (void)dealloc
{
    if (_loadPopover != nil) {
        [_loadPopover release];
        _loadPopover = nil;
    }
    [_skinPath release], _skinPath = nil;
    [_skinArray release], _skinArray = nil;
//    [_downloadFile release],_downloadFile = nil;
    [_downloadArray release]; _downloadArray = nil;
    [_filpedView release];_filpedView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [super dealloc];
}

-(void)doChangeLanguage:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *str1 = CustomLocalizedString(@"SkinWindow_choose_title", nil);
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str1];
        
        if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:30] range:NSMakeRange(0, as.length)];
        }else {
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:30] range:NSMakeRange(0, as.length)];
        }
        
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.string.length)];
        [_titleTextField setAttributedStringValue:as];
        [as release];
        as = nil;
    });
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [_loadingView setWantsLayer:YES];
    [_loadingView.layer setCornerRadius:5];
    fm = [NSFileManager defaultManager];
    _skinPath = [[TempHelper getAppSkinPath] retain];
    _skinArray = [[NSMutableArray alloc] init];
    _downloadArray = [[NSMutableArray alloc] init];
    _filpedView = [[IMBFilpedView alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_alertViewController setDelegate:self];
    
//    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_loadingView setIsGradientColorNOCornerPart4:YES];
    
    [_skinScrollView setHasHorizontalScroller:NO];
    [_skinScrollView setHasVerticalScroller:NO];
    [_filpedView setFrame:NSMakeRect(0, 0, _skinScrollView.frame.size.width, _skinScrollView.frame.size.height)];

    NSString *str1 = CustomLocalizedString(@"SkinWindow_choose_title", nil);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str1];

    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:30] range:NSMakeRange(0, as.length)];
    }else {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:30] range:NSMakeRange(0, as.length)];
    }
    
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.string.length)];
    [_titleTextField setAttributedStringValue:as];
    [as release];
    as = nil;

//    [_mainCustomView addSubview:_contentCustomView];
    
    [self judgeSkinConfigFileIsExist];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart4:YES];
    [self.view setWantsLayer:YES];
    [self.view.layer setCornerRadius:5];
}

- (void)judgeSkinConfigFileIsExist {
    NSString *skinConfigPath = [_skinPath stringByAppendingPathComponent:@"SkinConfig.plist"];
    if (![fm fileExistsAtPath:skinConfigPath]) {
        //不存在，就先下载；
        [_loadingAnimationView startAnimation];
        [_contentBox setContentView:_loadingView];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            BOOL isAvailble = [TempHelper checkInternetAvailble];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (isAvailble) {
                    //下载skinConfig.plist文件
                    NSString *downloadUrlPath = @"http://dl.imobie.com/skin/anytrans_newskin/SkinConfig.plist";
                    [self downloadFile:downloadUrlPath isDownloadPlist:YES DownloadFileName:@"SkinConfig.plist"];
                }else {
                    //没有skinConfig.plist文件,就读SkinConfig_default.plist(上一次下载好的)文件
                    NSString *skinConfigPath = [_skinPath stringByAppendingPathComponent:@"SkinConfig_default.plist"];
                    if ([fm fileExistsAtPath:skinConfigPath]) {
                        [self analyticSkinConfigFile:skinConfigPath];
                    }else {
                        [self skinConfigFileNotExist];
                    }
                    [_loadingView removeFromSuperview];
                    [_loadingAnimationView endAnimation];
                }
            });
        });
    }else {
        [self analyticSkinConfigFile:skinConfigPath];
    }
}

- (void)downloadFile:(NSString *)downloadUrlPath isDownloadPlist:(BOOL)isDownloadPlist DownloadFileName:(NSString *)downloadFileName {
    _isDownloadPlist = isDownloadPlist;
    IMBDownloadFile *downloadFile = [[IMBDownloadFile alloc] initWithDelegate:self downloadUrlPath:downloadUrlPath isDownloadPlist:_isDownloadPlist downFileName:downloadFileName];
    [_downloadArray addObject:downloadFile];
    [downloadFile downloadSpecifiedFile];
}

- (void)removeDownloadArray:(NSString *)fileName {
    for (IMBDownloadFile *downloadFile in _downloadArray) {
        if ([downloadFile.downFileName isEqualToString:fileName]) {
            [downloadFile cancelDownload];
            [_downloadArray removeObject:downloadFile];
            [downloadFile release];
            break;
        }
    }
}

- (void)analyticSkinConfigFile:(NSString *)skinConfigPath {
    NSDictionary *skinDic = [NSDictionary dictionaryWithContentsOfFile:skinConfigPath];
    if (skinDic != nil) {
        NSArray *skinArray = [skinDic objectForKey:@"MacSkinTotalModel"];
        _skinCount = (int)skinArray.count;//[[skinDic objectForKey:@"SkinTotalCount"] intValue];
        int height = 242;
        if (_skinCount == 2) {
            height = 280;
            [_skinScrollView setFrameOrigin:NSMakePoint(0, -24)];
        }else if (_skinCount > 3) {
            if (_skinCount == 4) {
                height = 248;
            } else {
                height = ((_skinCount- 1)/4 + 1) * 230 - 20;
            }
        }
        [_filpedView setFrameSize:NSMakeSize(_filpedView.frame.size.width, height)];
  
        if (skinArray != nil) {
            int i = -1;
            NSString *selectPackSkin = [[NSUserDefaults standardUserDefaults] objectForKey:@"customColor"];
            for (NSDictionary *singleSkinDic in skinArray) {
                i ++;
                IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
                BOOL isNew = [[singleSkinDic objectForKey:@"IsNew"] boolValue];
                NSString *version = [singleSkinDic objectForKey:@"Version"];
                IMBSkinEntity *skinEntity = [[IMBSkinEntity alloc] init];
                NSString *skinPackName = [singleSkinDic objectForKey:@"SkinName"];
                NSString *skinPath = [singleSkinDic objectForKey:@"ResourceDownloadPath"];
                NSString *skinImageName = [singleSkinDic objectForKey:@"SkinImageName"];
                NSString *thumbPath = [singleSkinDic objectForKey:@"ThumbDownloadPath"];
                NSDictionary *languageDic = [singleSkinDic objectForKey:@"Language"];
                NSString *md5Str = [singleSkinDic objectForKey:@"DLLMD5"];
                
                NSString *skinName = @"";
                if (softWare.chooseLanguageType == EnglishLanguage) {
                    skinName = [languageDic objectForKey:@"English"];
                }else if (softWare.chooseLanguageType == JapaneseLanguage) {
                    skinName = [languageDic objectForKey:@"Japanese"];
                }else if (softWare.chooseLanguageType == FrenchLanguage) {
                    skinName = [languageDic objectForKey:@"French"];
                }else if (softWare.chooseLanguageType == GermanLanguage) {
                    skinName = [languageDic objectForKey:@"German"];
                }else if (softWare.chooseLanguageType == SpanishLanguage){
                    skinName = [languageDic objectForKey:@"Spanish"];
                }else if (softWare.chooseLanguageType == ArabLanguage){
                    skinName = [languageDic objectForKey:@"Arabic"];
                }else if (softWare.chooseLanguageType == ChinaLanguage){
                    skinName = [languageDic objectForKey:@"Chinese"];
                }
                else {
                    skinName = [languageDic objectForKey:@"English"];
                }
                
                skinEntity.enSkinName = [languageDic objectForKey:@"English"];
                skinEntity.jaSkinName = [languageDic objectForKey:@"Japanese"];
                skinEntity.frSkinName = [languageDic objectForKey:@"French"];
                skinEntity.geSkinName = [languageDic objectForKey:@"German"];
                skinEntity.esSkinName = [languageDic objectForKey:@"Spanish"];
                skinEntity.arSkinName = [languageDic objectForKey:@"Arabic"];
                skinEntity.chSkinName = [languageDic objectForKey:@"Chinese"];
                
                [skinEntity setIsNew:isNew];
                [skinEntity setSkinVersion:version];
                [skinEntity setSkinPackName:skinPackName];
                [skinEntity setSkinName:skinName];
                [skinEntity setSkinNameAttributedString];
                [skinEntity setDownloadPath:skinPath];
                [skinEntity setSkinImageName:skinImageName];
                NSImage *image = [StringHelper imageNamed:skinImageName];
                if (image) {
                    [skinEntity setSkinImage:image];
                }else {
                    [skinEntity setSkinImage:[StringHelper imageNamed:@"skin_default_image"]];
                    [self downloadFile:thumbPath isDownloadPlist:YES DownloadFileName:skinImageName];
                }
                [skinEntity setThumbDownloadPath:thumbPath];
                
//                NSString *depath = [[_skinPath stringByAppendingPathComponent:skinPackName] stringByAppendingPathComponent:@"toolbox1.png"];
//                if ([fm fileExistsAtPath:depath]) {
//                    [fm removeItemAtPath:[_skinPath stringByAppendingPathComponent:skinPackName] error:nil];
//                }
                
                if ([selectPackSkin isEqualToString:skinPackName]) {
                    [skinEntity setIsDownload:YES];
                    [skinEntity setIsNoSelect:NO];
                }else {
                    if ([skinPackName isEqualToString:@"christmasSkin"]) {//默认设置圣诞节皮肤
                        [skinEntity setIsDownload:YES];
                        if (selectPackSkin == nil) {
                            [skinEntity setIsNoSelect:NO];
                        }else {
                            [skinEntity setIsNoSelect:YES];
                        }
                    }else {
                        NSString *existPath = [_skinPath stringByAppendingPathComponent:skinPackName];
                        if ([fm fileExistsAtPath:existPath]) {
                            [fm removeItemAtPath:existPath error:nil];
                        }
                        NSString *zipPath = [_skinPath stringByAppendingPathComponent:[skinPackName stringByAppendingPathExtension:@"zip"]];
                        if ([fm fileExistsAtPath:zipPath]) {
                            @autoreleasepool {
                                NSString *existMd5Str = [StringHelper md5ForFile:zipPath].lowercaseString;
                                if (![existMd5Str isEqualToString:[md5Str lowercaseString]]) {
                                    if ([fm fileExistsAtPath:zipPath]) {
                                        [fm removeItemAtPath:zipPath error:nil];
                                    }
                                    [skinEntity setIsDownload:NO];
                                }else {
                                    //解压下载文件到指定文件；
                                    @try {
                                        [IMBZipHelper unZipByAllF:zipPath decFolderPath:_skinPath];
                                        [skinEntity setIsDownload:YES];
                                    }
                                    @catch (NSException *exception) {
                                        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"skin zip error:%@  %@",[exception name],[exception reason]]];
                                        [skinEntity setIsDownload:NO];
                                    }
                                }
                            }
                        }else {
                            [skinEntity setIsDownload:NO];
                        }
                        [skinEntity setIsNoSelect:YES];
                    }
                }
                
                float ow = 120;
                float oh = 26;
                float ox = 0;
                if (_skinCount >= 3) {
                    if (_skinCount == 4) {
                        ox = (210 - ow) / 2;
                    } else {
                        ox = (200 - ow) / 2;
                    }
                }else if (_skinCount == 2) {
                    ox = (320 - ow) / 2;
                }else {
                    ox = (242 - ow) / 2;
                }
                NSString *name = @"";
                if (skinEntity.isDownload) {
                    name = CustomLocalizedString(@"SkinWindow_apply_btn", nil);
                }else {
                    name = CustomLocalizedString(@"iCloudBackup_View_Tips2", nil);
                }
                IMBSkinButton *btn = [[IMBSkinButton alloc] initWithFrame:NSMakeRect(ox, 2, ow, oh) WithPrefixImageName:@"skin" WithButtonName:name];
                [btn setIsChange:skinEntity.isDownload];
                [btn setEnabled:skinEntity.isNoSelect];
                [btn setSkinName:skinEntity.skinPackName];
                [btn setTarget:self];
                [btn setAction:@selector(switchSkin:)];
                [skinEntity setSkinBtn:btn];
                
                NSRect rect = NSZeroRect;
                BOOL bigView = NO;
                if (_skinCount == 2) {
                    if (i == 0) {
                        rect = NSMakeRect(i*320 + 186, 0, 320, 280);
                    }else {
                        rect = NSMakeRect(i*320 + 186 + 50, 0, 320, 280);
                    }
                    bigView = 1;
                }else if (_skinCount <= 3) {
                    if (i == 0) {
                        rect = NSMakeRect(i*242 + 166 - 30, 0, 242, 242);
                    } else if (i == 1) {
                        rect = NSMakeRect(i*242 + 166, 0, 242, 242);
                    } else {
                        rect = NSMakeRect(i*242 + 166 + 30, 0, 242, 242);
                    }
                    bigView = 2;
                }else if (_skinCount == 4) {
                    
                    rect = NSMakeRect(i*(210 + 30) + 64, 0, 210, 248);
                    bigView = 4;
                    
                }else {
                    rect = NSMakeRect((i%4)*200 + 130, 230*(i/4), 200, 210);
                    bigView = 3;
                }
                IMBSkinCollectionItemView *itemView = [[IMBSkinCollectionItemView alloc] initWithFrame:rect withSkinEntity:skinEntity delegate:self];
                [itemView setIsBigView:bigView];
                [itemView addContentView];
                [_filpedView addSubview:itemView];
//                [_skinScrollView.documentView addSubview:itemView];
                
                [_skinArray addObject:skinEntity];
                [skinEntity release];
                skinEntity = nil;
            }
            [_skinScrollView setDocumentView:_filpedView];
        }
    }
}

- (void)skinConfigFileNotExist {
    IMBSkinEntity *skinEntity = [[IMBSkinEntity alloc] init];
    NSString *skinName = CustomLocalizedString(@"SkinWindow_Christmas_Theme_name", nil);
    [skinEntity setSkinPackName:@"christmasSkin"];//默认设置成圣诞节皮肤
    [skinEntity setSkinName:skinName];
    [skinEntity setSkinNameAttributedString];
    [skinEntity setDownloadPath:@""];
    [skinEntity setSkinImage:[StringHelper imageNamed:@"christmas_thmb_image"]];
    [skinEntity setThumbDownloadPath:@""];
    [skinEntity setIsDownload:YES];
    [skinEntity setIsNoSelect:NO];
    
    [_skinScrollView setFrameOrigin:NSMakePoint(0, -24)];
    [_filpedView setFrameSize:NSMakeSize(_filpedView.frame.size.width, 280)];
    
    float ow = 120;
    float oh = 26;
    float ox = (320 - ow) / 2;
    NSString *name = @"";
    if (skinEntity.isDownload) {
        name = CustomLocalizedString(@"SkinWindow_apply_btn", nil);
    }else {
        name = CustomLocalizedString(@"iCloudBackup_View_Tips2", nil);
    }
    IMBSkinButton *btn = [[IMBSkinButton alloc] initWithFrame:NSMakeRect(ox, 2, ow, oh) WithPrefixImageName:@"skin" WithButtonName:name];
    [btn setIsChange:skinEntity.isDownload];
    [btn setEnabled:skinEntity.isNoSelect];
    [btn setSkinName:skinEntity.skinPackName];
    [btn setTarget:self];
    [btn setAction:@selector(switchSkin:)];
    [skinEntity setSkinBtn:btn];
    
    NSRect rect = NSZeroRect;
    rect = NSMakeRect(156, 0, 320, 280);

    IMBSkinCollectionItemView *itemView = [[IMBSkinCollectionItemView alloc] initWithFrame:rect withSkinEntity:skinEntity delegate:self];
    [itemView setIsBigView:1];
    [itemView addContentView];
    [_filpedView addSubview:itemView];
    [_skinScrollView setDocumentView:_filpedView];
//    [_skinScrollView.documentView addSubview:itemView];
    
    [_skinArray addObject:skinEntity];
    [skinEntity release];
    skinEntity = nil;
}

- (void)downComplete:(NSString*)fileName {
//    if (_downloadFile != nil) {
//        [_downloadFile release];
//        _downloadFile = nil;
//    }
    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"download file complete:%@!!!",fileName]];
    if (_isDownloadPlist) {
        if ([fileName isEqualToString:@"SkinConfig.plist"]) {
            [self analyticSkinConfigFile:[_skinPath stringByAppendingPathComponent:@"SkinConfig.plist"]];
            [_loadingView removeFromSuperview];
            [_loadingAnimationView endAnimation];
        }else {
            if (_skinArray != nil) {
                for (IMBSkinEntity *entity in _skinArray) {
                    if ([entity.skinImageName isEqualToString:fileName]) {
                        NSString *path = [_skinPath stringByAppendingPathComponent:fileName];
                        if ([fm fileExistsAtPath:path]) {
                            NSBundle *bundle = [NSBundle mainBundle];
                            NSString *resourceSkinPath = [[bundle resourcePath] stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"tiff"]];
                            if (![fm fileExistsAtPath:resourceSkinPath]) {
                                [fm copyItemAtPath:path toPath:resourceSkinPath error:nil];
                            }
                            NSImage *image = [StringHelper imageNamed:fileName];
                            if (image != nil) {
                                entity.skinImage = image;
                                NSArray *views = [_skinScrollView.documentView subviews];
                                if (views != nil) {
                                    for (NSView *view in views) {
                                        if ([view isKindOfClass:[IMBSkinCollectionItemView class]]) {
                                            IMBSkinCollectionItemView *itemView = (IMBSkinCollectionItemView *)view;
                                            if ([itemView.skinEntity.skinImageName isEqualToString:fileName]) {
                                                [itemView.bgImageView setImage:entity.skinImage];
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }else {
        NSArray *views = [_skinScrollView.documentView subviews];
        if (views != nil) {
            for (NSView *view in views) {
                if ([view isKindOfClass:[IMBSkinCollectionItemView class]]) {
                    IMBSkinCollectionItemView *itemView = (IMBSkinCollectionItemView *)view;
                    if ([itemView.skinEntity.skinPackName isEqualToString:fileName]) {
                        [itemView downloadComplete];
                    }
                }
            }
        }
    }
}

- (void)downErrorWithFileName:(NSString*)fileName withError:(NSString*)error {
//    if (_downloadFile != nil) {
//        [_downloadFile release];
//        _downloadFile = nil;
//    }
    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"download file error:%@!!!",fileName]];
    if (_isDownloadPlist) {
        if ([fileName isEqualToString:@"SkinConfig.plist"]) {
            //没有skinConfig.plist文件, 就读SkinConfig_default.plist(上一次下载好的)文件
            NSString *skinConfigPath = [_skinPath stringByAppendingPathComponent:@"SkinConfig_default.plist"];
            if ([fm fileExistsAtPath:skinConfigPath]) {
                [self analyticSkinConfigFile:skinConfigPath];
            }else {
                [self skinConfigFileNotExist];
            }
            [_loadingView removeFromSuperview];
            [_loadingAnimationView endAnimation];
        }
    }else {
        [self removeDownloadArray:fileName];
        NSArray *views = [_skinScrollView.documentView subviews];
        if (views != nil) {
            for (NSView *view in views) {
                if ([view isKindOfClass:[IMBSkinCollectionItemView class]]) {
                    IMBSkinCollectionItemView *itemView = (IMBSkinCollectionItemView *)view;
                    if ([itemView.skinEntity.skinPackName isEqualToString:[fileName stringByDeletingPathExtension]]) {
                        [itemView addDownloadErrorField];
                    }
                }
            }
        }
    }
}

- (void)downProgressWithFileName:(NSString*)fileName withProgress:(double)progress {
    if (_isDownloadPlist) {
        
    }else {
        NSArray *views = [_skinScrollView.documentView subviews];
        if (views != nil) {
            for (NSView *view in views) {
                if ([view isKindOfClass:[IMBSkinCollectionItemView class]]) {
                    IMBSkinCollectionItemView *itemView = (IMBSkinCollectionItemView *)view;
                    if ([itemView.skinEntity.skinPackName isEqualToString:[fileName stringByDeletingPathExtension]]) {
                        NSLog(@"progress:%f",progress);
                        [itemView reloadProgressValue:progress];
                    }
                }
            }
        }
    }
}

- (void)switchSkin:(id)sender {
    IMBSkinButton *btn = (IMBSkinButton *)sender;
    if (btn.isEnabled) {
        if (btn.isChange) {//执行应用方法
            if (_isSwitchSkin) {
                return;
            }
            _isSwitchSkin = YES;
//            [_loadingAnimationView startAnimation];
//            [_contentBox setContentView:_loadingView];
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                BOOL issuccess = [self setImageResourcesContent:btn.skinName];
//                sleep(1);
//                dispatch_async(dispatch_get_main_queue(), ^{
                    if (issuccess) {
                        NSArray *views = [_skinScrollView.documentView subviews];
                        if (views != nil) {
                            for (NSView *view in views) {
                                if ([view isKindOfClass:[IMBSkinCollectionItemView class]]) {
                                    IMBSkinCollectionItemView *itemView = (IMBSkinCollectionItemView *)view;
                                    if (!itemView.skinEntity.isNoSelect) {
                                        itemView.skinEntity.isNoSelect = YES;
                                        itemView.skinEntity.isDownload = YES;
                                        [itemView.skinEntity.skinBtn setIsChange:YES];
                                        [itemView.skinEntity.skinBtn setEnabled:YES];
                                        [itemView.skinEntity.skinBtn setButtonName:CustomLocalizedString(@"SkinWindow_apply_btn", nil)];
                                        [itemView.selectImageView setHidden:YES];
                                    }
                                    if ([itemView.skinEntity.skinPackName isEqualToString:btn.skinName]) {
                                        itemView.skinEntity.isNoSelect = NO;
                                        itemView.skinEntity.isDownload = YES;
                                        [itemView.skinEntity.skinBtn setEnabled:NO];
                                        [itemView.selectImageView setHidden:NO];
                                    }
                                }
                            }
                        }
                        [btn setEnabled:NO];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:btn.skinName forKey:@"customColor"];
                        [[IMBSoftWareInfo singleton] setCurUseSkin:btn.skinName];
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHANGE_SKIN object:nil];
                        [_loadingView removeFromSuperview];
                        [_loadingAnimationView endAnimation];
                    }
//                });
//            });
            _isSwitchSkin = NO;
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:Skin_Theme action:SkinApply actionParams:[IMBSoftWareInfo singleton].curUseSkin label:Switch transferCount:1 screenView:@"Skin_Switch" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
        }else {//执行下载方法
            NSArray *views = [_skinScrollView.documentView subviews];
            if (views != nil) {
                for (NSView *view in views) {
                    if ([view isKindOfClass:[IMBSkinCollectionItemView class]]) {
                        IMBSkinCollectionItemView *itemView = (IMBSkinCollectionItemView *)view;
                        if ([itemView.skinEntity.skinPackName isEqualToString:btn.skinName]) {
                            if (![[IMBSoftWareInfo singleton].version isVersionMajorEqual:itemView.skinEntity.skinVersion]) {
                                //弹出提示框，提示用户
                                [self showLoadPromptPopover:@"" withSuperView:btn];
                                return;
                            }
                            
                            [itemView addProgressVeiw];
                            //开始下载
                            [self downloadFile:itemView.skinEntity.downloadPath isDownloadPlist:NO DownloadFileName:[itemView.skinEntity.skinPackName stringByAppendingPathExtension:@"zip"]];
                            
                            NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
                            NSString *curSkinPath = [[resourcePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:btn.skinName];
                            if ([fm fileExistsAtPath:curSkinPath]) {
                                [fm removeItemAtPath:curSkinPath error:nil];
                            }
                            
                            break;
                        }
                    }
                }
            }
        }
    }
}

- (BOOL)setImageResourcesContent:(NSString *)switchSkin {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resourcePath = [bundle resourcePath];
    NSString *curSkinPath = [[resourcePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:switchSkin];
    NSString *selectSkin = [[NSUserDefaults standardUserDefaults] objectForKey:@"customColor"];
    NSString *selectSkinPath = [[resourcePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:selectSkin];
    
    if ([fm fileExistsAtPath:curSkinPath]) {
        if (![fm fileExistsAtPath:[curSkinPath stringByAppendingPathComponent:[switchSkin stringByAppendingPathExtension:@"plist"]]]) {
            [self showAlertText:CustomLocalizedString(@"SkinWindow_notfound_error", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            NSArray *views = [_skinScrollView.documentView subviews];
            if (views != nil) {
                for (NSView *view in views) {
                    if ([view isKindOfClass:[IMBSkinCollectionItemView class]]) {
                        IMBSkinCollectionItemView *itemView = (IMBSkinCollectionItemView *)view;
                        if ([itemView.skinEntity.skinPackName isEqualToString:switchSkin]) {
                            [itemView.skinEntity setIsDownload:NO];
                            [itemView.skinEntity setIsNoSelect:YES];
                            [itemView.skinEntity.skinBtn setIsChange:NO];
                            [itemView.skinEntity.skinBtn setButtonName:CustomLocalizedString(@"iCloudBackup_View_Tips2", nil)];
                            break;
                        }
                    }
                }
            }
            return NO;
        }
        if ([fm fileExistsAtPath:selectSkinPath]) {
            [fm removeItemAtPath:selectSkinPath error:nil];
        }
        if (![fm moveItemAtPath:resourcePath toPath:selectSkinPath error:nil]) {
            [self showAlertText:CustomLocalizedString(@"SkinWindow_apply_error", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            NSArray *views = [_skinScrollView.documentView subviews];
            if (views != nil) {
                for (NSView *view in views) {
                    if ([view isKindOfClass:[IMBSkinCollectionItemView class]]) {
                        IMBSkinCollectionItemView *itemView = (IMBSkinCollectionItemView *)view;
                        if ([itemView.skinEntity.skinPackName isEqualToString:switchSkin]) {
                            [itemView.skinEntity setIsDownload:NO];
                            [itemView.skinEntity setIsNoSelect:YES];
                            [itemView.skinEntity.skinBtn setIsChange:NO];
                            [itemView.skinEntity.skinBtn setButtonName:CustomLocalizedString(@"iCloudBackup_View_Tips2", nil)];
                            break;
                        }
                    }
                }
            }
            return NO;
        }else {
            if (![fm moveItemAtPath:curSkinPath toPath:resourcePath error:nil]) {
                [fm moveItemAtPath:selectSkinPath toPath:resourcePath error:nil];
                [self showAlertText:CustomLocalizedString(@"SkinWindow_apply_error", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
                NSArray *views = [_skinScrollView.documentView subviews];
                if (views != nil) {
                    for (NSView *view in views) {
                        if ([view isKindOfClass:[IMBSkinCollectionItemView class]]) {
                            IMBSkinCollectionItemView *itemView = (IMBSkinCollectionItemView *)view;
                            if ([itemView.skinEntity.skinPackName isEqualToString:switchSkin]) {
                                [itemView.skinEntity setIsDownload:NO];
                                [itemView.skinEntity setIsNoSelect:YES];
                                [itemView.skinEntity.skinBtn setIsChange:NO];
                                [itemView.skinEntity.skinBtn setButtonName:CustomLocalizedString(@"iCloudBackup_View_Tips2", nil)];
                                break;
                            }
                        }
                    }
                }
                return NO;
            }
        }
    }else {
        NSString *configPath = [_skinPath stringByAppendingPathComponent:switchSkin];
        if ([fm fileExistsAtPath:configPath]) {
            NSString *plistPath = [configPath stringByAppendingPathComponent:[switchSkin stringByAppendingPathExtension:@"plist"]];
            if (![fm fileExistsAtPath:plistPath]) {
                [self showAlertText:CustomLocalizedString(@"SkinWindow_notfound_error", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
                NSArray *views = [_skinScrollView.documentView subviews];
                if (views != nil) {
                    for (NSView *view in views) {
                        if ([view isKindOfClass:[IMBSkinCollectionItemView class]]) {
                            IMBSkinCollectionItemView *itemView = (IMBSkinCollectionItemView *)view;
                            if ([itemView.skinEntity.skinPackName isEqualToString:switchSkin]) {
                                [itemView.skinEntity setIsDownload:NO];
                                [itemView.skinEntity setIsNoSelect:YES];
                                [itemView.skinEntity.skinBtn setIsChange:NO];
                                [itemView.skinEntity.skinBtn setButtonName:CustomLocalizedString(@"iCloudBackup_View_Tips2", nil)];
                                break;
                            }
                        }
                    }
                }
                return NO;
            }
            
            NSArray *fileArray = [fm contentsOfDirectoryAtPath:configPath error:nil];
            if (fileArray != nil) {
                //先copy .plist 文件，判断能否copy成功
                NSString *oriPlistPath = [resourcePath stringByAppendingPathComponent:[switchSkin stringByAppendingPathExtension:@"plist"]];
                if ([fm fileExistsAtPath:oriPlistPath]) {
                    [fm removeItemAtPath:oriPlistPath error:nil];
                }
                if (![fm copyItemAtPath:plistPath toPath:oriPlistPath error:nil]) {
                    [self showAlertText:CustomLocalizedString(@"SkinWindow_apply_error_id1", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
//                    NSArray *views = [_skinScrollView.documentView subviews];
//                    if (views != nil) {
//                        for (NSView *view in views) {
//                            if ([view isKindOfClass:[IMBSkinCollectionItemView class]]) {
//                                IMBSkinCollectionItemView *itemView = (IMBSkinCollectionItemView *)view;
//                                if ([itemView.skinEntity.skinPackName isEqualToString:switchSkin]) {
//                                    [itemView.skinEntity setIsDownload:NO];
//                                    [itemView.skinEntity setIsNoSelect:YES];
//                                    [itemView.skinEntity.skinBtn setIsChange:NO];
//                                    [itemView.skinEntity.skinBtn setButtonName:CustomLocalizedString(@"iCloudBackup_View_Tips2", nil)];
//                                    break;
//                                }
//                            }
//                        }
//                    }
                    return NO;
                }
                
                if (![fm fileExistsAtPath:selectSkinPath]) {
                    [fm copyItemAtPath:resourcePath toPath:selectSkinPath error:nil];
                }
                for (NSString *fileName in fileArray) {
                    if ([fileName hasPrefix:@"."] || [fileName hasPrefix:@"__MACOSX"] || [fileName hasPrefix:switchSkin]) {
                        continue;
                    }
                    NSString *singleFilePath = [configPath stringByAppendingPathComponent:fileName];
                    if ([fm fileExistsAtPath:singleFilePath]) {
                        NSString *oriFilePath = [resourcePath stringByAppendingPathComponent:fileName];
                        if ([fm fileExistsAtPath:oriFilePath]) {
                            [fm removeItemAtPath:oriFilePath error:nil];
                        }
                        [fm copyItemAtPath:singleFilePath toPath:oriFilePath error:nil];
                    }else {
                        NSLog(@"该皮肤不存在----2");
//                        dispatch_sync(dispatch_get_main_queue(), ^{
                        [self showAlertText:CustomLocalizedString(@"SkinWindow_notfound_error", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
                        NSArray *views = [_skinScrollView.documentView subviews];
                        if (views != nil) {
                            for (NSView *view in views) {
                                if ([view isKindOfClass:[IMBSkinCollectionItemView class]]) {
                                    IMBSkinCollectionItemView *itemView = (IMBSkinCollectionItemView *)view;
                                    if ([itemView.skinEntity.skinPackName isEqualToString:switchSkin]) {
                                        [itemView.skinEntity setIsDownload:NO];
                                        [itemView.skinEntity setIsNoSelect:YES];
                                        [itemView.skinEntity.skinBtn setIsChange:NO];
                                        [itemView.skinEntity.skinBtn setButtonName:CustomLocalizedString(@"iCloudBackup_View_Tips2", nil)];
                                        break;
                                    }
                                }
                            }
                        }
//                        });
                        return NO;
                    }
                }
                //删除之前选择的plist文件
                NSString *skinPlistPath = [[NSBundle mainBundle] pathForResource:selectSkin ofType:@"plist"];
                if ([fm fileExistsAtPath:skinPlistPath]) {
                    [fm removeItemAtPath:skinPlistPath error:nil];
                }
            }else {
                NSLog(@"该皮肤不存在");
//                dispatch_sync(dispatch_get_main_queue(), ^{
                [self showAlertText:CustomLocalizedString(@"SkinWindow_apply_error", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
                NSArray *views = [_skinScrollView.documentView subviews];
                if (views != nil) {
                    for (NSView *view in views) {
                        if ([view isKindOfClass:[IMBSkinCollectionItemView class]]) {
                            IMBSkinCollectionItemView *itemView = (IMBSkinCollectionItemView *)view;
                            if ([itemView.skinEntity.skinPackName isEqualToString:switchSkin]) {
                                [itemView.skinEntity setIsDownload:NO];
                                [itemView.skinEntity setIsNoSelect:YES];
                                [itemView.skinEntity.skinBtn setIsChange:NO];
                                [itemView.skinEntity.skinBtn setButtonName:CustomLocalizedString(@"iCloudBackup_View_Tips2", nil)];
                                break;
                            }
                        }
                    }
                }
//                });
                return NO;
            }
        }else {
            NSLog(@"该皮肤不存在  --- 1");
//            dispatch_sync(dispatch_get_main_queue(), ^{
            [self showAlertText:CustomLocalizedString(@"SkinWindow_apply_error", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            NSArray *views = [_skinScrollView.documentView subviews];
            if (views != nil) {
                for (NSView *view in views) {
                    if ([view isKindOfClass:[IMBSkinCollectionItemView class]]) {
                        IMBSkinCollectionItemView *itemView = (IMBSkinCollectionItemView *)view;
                        if ([itemView.skinEntity.skinPackName isEqualToString:switchSkin]) {
                            [itemView.skinEntity setIsDownload:NO];
                            [itemView.skinEntity setIsNoSelect:YES];
                            [itemView.skinEntity.skinBtn setIsChange:NO];
                            [itemView.skinEntity.skinBtn setButtonName:CustomLocalizedString(@"iCloudBackup_View_Tips2", nil)];
                            break;
                        }
                    }
                }
            }
//            });
            return NO;
        }
    }
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        [[NSUserDefaults standardUserDefaults] setObject:switchSkin forKey:@"customColor"];
//        [[IMBSoftWareInfo singleton] setCurUseSkin:switchSkin];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHANGE_SKIN object:nil];
//    });
    return YES;
}

- (void)changeSkin:(NSNotification *)notification {
    NSString *str1 = CustomLocalizedString(@"SkinWindow_choose_title", nil);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str1];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:30] range:NSMakeRange(0, as.length)];
    }else {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:30] range:NSMakeRange(0, as.length)];
    }
    
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.string.length)];
    [_titleTextField setAttributedStringValue:as];
    [as release];
    as = nil;
    [_loadingAnimationView setNeedsDisplay:YES];
    [self.view setNeedsDisplay:YES];
}

- (void)showLoadPromptPopover:(NSString *)promptName withSuperView:(NSView *)view {
    if (_loadPopover != nil) {
        [_loadPopover close];
        [_loadPopover release];
        _loadPopover = nil;
    }
    _loadPopover = [[NSPopover alloc] init];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
        _loadPopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];
    }else {
        _loadPopover.appearance = NSPopoverAppearanceMinimal;
    }
    
    _loadPopover.animates = YES;
    _loadPopover.behavior = NSPopoverBehaviorSemitransient;
    _loadPopover.delegate = self;
    
    IMBPopViewController *loadPopVC = [[IMBPopViewController alloc] initWithPromptName:promptName];
    [loadPopVC setIsSkin:YES];
    if ([[IMBSoftWareInfo singleton] chooseLanguageType] == GermanLanguage) {
        [loadPopVC.view setFrameSize:NSMakeSize(180, loadPopVC.view.frame.size.height+55)];
    }else {
        [loadPopVC.view setFrameSize:NSMakeSize(180, loadPopVC.view.frame.size.height+35)];
    }
    

    [loadPopVC setPromptNameFrame:NSMakeRect(6, 4, loadPopVC.view.frame.size.width - 12, loadPopVC.view.frame.size.height - 4)];
    if (_loadPopover != nil) {
        _loadPopover.contentViewController = loadPopVC;
    }
    [loadPopVC release];
    
    NSRectEdge prefEdge = NSMinYEdge;
    NSRect rect = NSMakeRect(view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height);
    [_loadPopover showRelativeToRect:rect ofView:view preferredEdge:prefEdge];
}

@end

@implementation IMBDownloadSkinProgressView
@synthesize isDownloadSucess = _isDownloadSucess;

- (id)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
//        _closeBtn = [[IMBiCloudDeleteButton alloc] initWithFrame:NSMakeRect(0, 0, 18, 18)];
//        [_closeBtn setImageWithWithPrefixImageName:@"icloudClose"];
        _curProgress = 0;
        _progress = 0;
    }
    return self;
}

- (void)awakeFromNib {
//    [_closeBtn setFrameOrigin:NSMakePoint(160, (self.frame.size.height - _closeBtn.frame.size.height)/2)];
}

- (void)setProgress:(float)progress {
    if (progress < _curProgress) {
        _progress = _curProgress;
    }else {
        _progress = progress;
    }
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [[NSColor clearColor] set];
    NSRectFill(dirtyRect);
    NSRect rect = NSMakeRect(0, 0, 100, 6);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:3 yRadius:3];
    [path setWindingRule:NSEvenOddWindingRule];
    [path addClip];
    [path setLineWidth:1];
    [[StringHelper getColorFromString:CustomColor(@"progress_bgColor", nil)] set];
    [path fill];
//    [[NSColor grayColor] setStroke];
//    [path stroke];
    
    NSBezierPath *progressPath = [NSBezierPath bezierPath];
    
    [progressPath moveToPoint:NSMakePoint(NSMinX(rect)+3, NSMaxY(rect))];
    
    [progressPath appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect) + 3, NSMaxY(rect) - 3) radius:3 startAngle:90 endAngle:180];
    
    [progressPath lineToPoint:NSMakePoint(NSMinX(rect), NSMinY(rect)+3)];
    
    [progressPath appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect) + 3, NSMinY(rect)+3) radius:3 startAngle:180 endAngle:270];

    float width = rect.size.width * _progress / 100;

    [progressPath lineToPoint:NSMakePoint( NSMinX(rect) + width - 3, NSMinY(rect))];

    [progressPath lineToPoint:NSMakePoint(NSMinX(rect) + width - 3, NSMaxY(rect))];
    
    [path closePath];
    
    if (_isDownloadSucess) {
        progressPath = path;
    }
    [[StringHelper getColorFromString:CustomColor(@"icloud_download_progress_color", nil)] set];
    
//    [path stroke];
    
    [progressPath fill];
    
//    NSString *str= [NSString stringWithFormat:@"%d%@",(int)(_progress *100),@"%"];
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
//                                nil];
//    [str drawAtPoint:NSMakePoint(NSMinX(rect) + width + 90, NSMinY(rect) - 2) withAttributes:attributes];
}

@end

@implementation IMBSkinCollectionItemView
@synthesize isBigView = _isBigView;
@synthesize bgImageView = _bgImageView;
@synthesize skinEntity = _skinEntity;
@synthesize progressView = _progressView;
@synthesize selectImageView = _selectImageView;

- (id)initWithFrame:(NSRect)frameRect withSkinEntity:(IMBSkinEntity *)skinEntity delegate:(id)delegate{
    if (self = [super initWithFrame:frameRect]) {
        _delegate = delegate;
        _skinEntity = [skinEntity retain];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_skinEntity.isDownload) {
            if (_skinEntity.isNoSelect) {
                [_skinEntity.skinBtn setButtonName:CustomLocalizedString(@"SkinWindow_apply_btn", nil)];
            }
        }else {
            [_skinEntity.skinBtn setButtonName:CustomLocalizedString(@"iCloudBackup_View_Tips2", nil)];
        }
        IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
        if (softWare.chooseLanguageType == EnglishLanguage) {
            if (_skinEntity.enSkinName != nil && ![_skinEntity.enSkinName isEqualToString:@""]) {
                _skinEntity.skinName = _skinEntity.enSkinName;
            }
        }else if (softWare.chooseLanguageType == JapaneseLanguage) {
            if (_skinEntity.jaSkinName != nil && ![_skinEntity.jaSkinName isEqualToString:@""]) {
                _skinEntity.skinName = _skinEntity.jaSkinName;
            }
        }else if (softWare.chooseLanguageType == FrenchLanguage) {
            if (_skinEntity.frSkinName != nil && ![_skinEntity.frSkinName isEqualToString:@""]) {
                _skinEntity.skinName = _skinEntity.frSkinName;
            }
        }else if (softWare.chooseLanguageType == GermanLanguage) {
            if (_skinEntity.geSkinName != nil && ![_skinEntity.geSkinName isEqualToString:@""]) {
                _skinEntity.skinName = _skinEntity.geSkinName;
            }
        }else if (softWare.chooseLanguageType == SpanishLanguage) {
            if (_skinEntity.esSkinName != nil && ![_skinEntity.esSkinName isEqualToString:@""]) {
                _skinEntity.skinName = _skinEntity.esSkinName;
            }
        }else if (softWare.chooseLanguageType == ArabLanguage) {
            if (_skinEntity.arSkinName != nil && ![_skinEntity.arSkinName isEqualToString:@""]) {
                _skinEntity.skinName = _skinEntity.arSkinName;
            }
        }else if (softWare.chooseLanguageType == ChinaLanguage) {
            if (_skinEntity.chSkinName != nil && ![_skinEntity.chSkinName isEqualToString:@""]) {
                _skinEntity.skinName = _skinEntity.chSkinName;
            }
        }else {
            if (_skinEntity.enSkinName != nil && ![_skinEntity.enSkinName isEqualToString:@""]) {
                _skinEntity.skinName = _skinEntity.enSkinName;
            }
        }
        [_skinEntity setSkinNameAttributedString];
        [_homeNameText setAttributedStringValue:_skinEntity.skinNameAs];
    });
}

- (void)changeSkin:(NSNotification *)notification {
    [_skinEntity setSkinNameAttributedString];
    if (_progressField != nil) {
        [_progressField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    }
    if (_closeBtn != nil) {
        [_closeBtn setImageWithWithPrefixImageName:@"icloudClose"];
    }
    if (_progressView != nil) {
        [_progressView setNeedsDisplay:YES];
    }
    [_homeNameText setAttributedStringValue:_skinEntity.skinNameAs];
    [_selectImageView setImage:[StringHelper imageNamed:@"skin_selete"]];
    NSImage *image = [StringHelper imageNamed:_skinEntity.skinImageName];
    if (image) {
        [_skinEntity setSkinImage:image];
    }else {
        [_skinEntity setSkinImage:[StringHelper imageNamed:@"skin_default_image"]];
    }
    [_bgImageView setImage:_skinEntity.skinImage];
    
    [_skinEntity.skinBtn setButtonImageName:@"skin"];
    if (_skinEntity.isDownload) {
        if (_skinEntity.isNoSelect) {
            [_skinEntity.skinBtn setButtonName:CustomLocalizedString(@"SkinWindow_apply_btn", nil)];
        }
    }else {
        [_skinEntity.skinBtn setButtonName:CustomLocalizedString(@"iCloudBackup_View_Tips2", nil)];
    }
    
    if (_textView != nil) {
        [_textView setEditable:YES];
        NSString *overStr = CustomLocalizedString(@"Clone_id_23", nil);
        NSString *promptStr = [[CustomLocalizedString(@"iCloudBackup_View_Tips1", nil) stringByAppendingString:@", "] stringByAppendingString:overStr];
        NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
        [_textView setLinkTextAttributes:linkAttributes];
        
        NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
        [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
        NSRange infoRange = [promptStr rangeOfString:overStr];
        [promptAs addAttribute:NSLinkAttributeName value:overStr range:infoRange];
        [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
        [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange];
        [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
        
        NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle setAlignment:NSCenterTextAlignment];
        [mutParaStyle setLineSpacing:5.0];
        [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
        [[_textView textStorage] setAttributedString:promptAs];
        [mutParaStyle release];
        mutParaStyle = nil;
        
        [_textView setEditable:NO];
    }
}

- (void)dealloc {
    [_bgImageView release];_bgImageView = nil;
    [_skinEntity release],_skinEntity = nil;
    if (_progressView != nil) {
        [_progressView release];
        _progressView = nil;
    }
    if (_closeBtn != nil) {
        [_closeBtn release];
        _closeBtn = nil;
    }
    if (_textView != nil) {
        [_textView release];
        _textView = nil;
    }
    if (_selectImageView != nil) {
        [_selectImageView release];
        _selectImageView = nil;
    }
    if (_homeNameText != nil) {
        [_homeNameText release];
        _homeNameText = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [super dealloc];
}

- (void)awakeFromNib {
    
}

- (void)addContentView {
    [self addTextField:_skinEntity.skinNameAs rect:NSMakeRect(0, 0, self.frame.size.width, 26)];
    
    NSSize size = NSZeroSize;
    if (_isBigView == 1) {
        size = NSMakeSize(248, 184);
    }else if (_isBigView == 2) {
        size = NSMakeSize(208, 154);
    }else if (_isBigView == 4) {
        size = NSMakeSize(210, 156);
    }else {
        size = NSMakeSize(170, 128);
    }
    _bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect((self.frame.size.width - size.width) / 2, 38, size.width, size.height)];
    [_bgImageView setImage:_skinEntity.skinImage];
    [self addSubview:_bgImageView];
    
    if (_isBigView == 4) {
        [_skinEntity.skinBtn setFrameOrigin:NSMakePoint((self.frame.size.width - _skinEntity.skinBtn.frame.size.width) / 2, self.frame.size.height - _skinEntity.skinBtn.frame.size.height - 8)];
        [self addSubview:_skinEntity.skinBtn];
        
        if (_skinEntity.isNew) {
            NSImage *image = [StringHelper imageNamed:@"skin_new"];
            NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(self.frame.size.width-image.size.width - 3,image.size.height - 2, image.size.width, image.size.height)];
            [imageView setImage:image];
            [self addSubview:imageView];
            [imageView release], imageView = nil;
        }
    } else {
        [_skinEntity.skinBtn setFrameOrigin:NSMakePoint((self.frame.size.width - _skinEntity.skinBtn.frame.size.width) / 2, self.frame.size.height - _skinEntity.skinBtn.frame.size.height - 2)];
        [self addSubview:_skinEntity.skinBtn];
        
        if (_skinEntity.isNew) {
            NSImage *image = [StringHelper imageNamed:@"skin_new"];
            NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(self.frame.size.width-image.size.width - 23,image.size.height+1, image.size.width, image.size.height)];
            [imageView setImage:image];
            [self addSubview:imageView];
            [imageView release], imageView = nil;
        }
    }
    
    if (_selectImageView != nil) {
        [_selectImageView release];
        _selectImageView = nil;
    }
    _selectImageView = [[NSImageView alloc] initWithFrame:NSMakeRect((self.frame.size.width - size.width) / 2, 38, size.width, size.height)];
    [_selectImageView setImage:[StringHelper imageNamed:@"skin_selete"]];
    [_selectImageView setHidden:_skinEntity.isNoSelect];
    [self addSubview:_selectImageView];
}

- (void)addProgressVeiw {
    if (_progressView != nil) {
        [_progressView release];
        _progressView = nil;
    }
    _progressView = [[IMBDownloadSkinProgressView alloc] initWithFrame:NSMakeRect((self.frame.size.width - 100 - 40 - 18) / 2, self.frame.size.height - 16, 100, 6)];
    [_skinEntity.skinBtn setHidden:YES];
    [self addSubview:_progressView];
    
    if (_progressField != nil) {
        [_progressField release];
        _progressField = nil;
    }
    _progressField = [[NSTextField alloc] initWithFrame:NSMakeRect(_progressView.frame.origin.x + 100, _progressView.frame.origin.y - 8, 40, 26)];
    [_progressField setBordered:NO];
    [_progressField setAlignment:NSCenterTextAlignment];
    [_progressField setDrawsBackground:NO];
    [_progressField setEditable:NO];
    [_progressField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_progressField setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [_progressField setStringValue:@"0%"];
    [self addSubview:_progressField];
    
    if (_closeBtn != nil) {
        [_closeBtn release];
        _closeBtn = nil;
    }
    _closeBtn = [[IMBiCloudDeleteButton alloc] initWithFrame:NSMakeRect(0, 0, 18, 18)];
    [_closeBtn setImageWithWithPrefixImageName:@"icloudClose"];
    [_closeBtn setFrameOrigin:NSMakePoint(_progressField.frame.origin.x + 40, _progressView.frame.origin.y - 7)];
    [_closeBtn setTarget:self];
    [_closeBtn setAction:@selector(closeDownload:)];
    [self addSubview:_closeBtn];
}

- (void)reloadProgressValue:(float)value {
    if (value == 100) {
        [_progressView setIsDownloadSucess:YES];
    }else {
        [_progressView setIsDownloadSucess:NO];
    }
    if (value < 10) {
        [_progressField setStringValue:[NSString stringWithFormat:@"%.1f%%",value]];
    }else {
        [_progressField setStringValue:[NSString stringWithFormat:@"%d%%",(int)value]];
    }
    [_progressView setProgress:value];
}

- (void)addDownloadErrorField {
    if (_textView != nil) {
        [_textView release];
        _textView = nil;
    }
    IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
    if (softWare.chooseLanguageType == EnglishLanguage) {
        _textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, self.frame.size.height - 20, self.frame.size.width , 26)];
    }else if (softWare.chooseLanguageType == JapaneseLanguage) {
        _textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, self.frame.size.height - 20, self.frame.size.width , 26)];
    }else if (softWare.chooseLanguageType == FrenchLanguage) {
        _textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, self.frame.size.height - 30, self.frame.size.width , 40)];
    }else if (softWare.chooseLanguageType == GermanLanguage) {
        _textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, self.frame.size.height - 30, self.frame.size.width , 40)];
    }else if (softWare.chooseLanguageType == ArabLanguage) {
        _textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, self.frame.size.height - 20, self.frame.size.width , 26)];
    }else {
        _textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, self.frame.size.height - 20, self.frame.size.width , 26)];
    }
    [_textView setEditable:YES];
    [_textView setSelectable:YES];
    [_textView setDrawsBackground:NO];
    [_textView setDelegate:(id)self];
    
    NSString *overStr = CustomLocalizedString(@"Clone_id_23", nil);
    NSString *promptStr = [[CustomLocalizedString(@"iCloudBackup_View_Tips1", nil) stringByAppendingString:@", "] stringByAppendingString:overStr];
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_textView setLinkTextAttributes:linkAttributes];
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = [promptStr rangeOfString:overStr];
    [promptAs addAttribute:NSLinkAttributeName value:overStr range:infoRange];
    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_textView textStorage] setAttributedString:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;
    
    [_textView setEditable:NO];
    
    [self addSubview:_textView];
    [_progressView setHidden:YES];
    [_progressField setHidden:YES];
    [_closeBtn setHidden:YES];
}

- (void)downloadComplete {
    [_skinEntity setIsDownload:YES];
    [_skinEntity.skinBtn setIsChange:YES];
    [_skinEntity.skinBtn setButtonName:CustomLocalizedString(@"SkinWindow_apply_btn", nil)];
    [_skinEntity.skinBtn setNeedsDisplay:YES];
    [_skinEntity.skinBtn setHidden:NO];
    
    [_progressView setHidden:YES];
    [_progressField setHidden:YES];
    [_closeBtn setHidden:YES];
}

- (void)addTextField:(NSAttributedString *)nameAs rect:(NSRect)rect {
    if (_homeNameText != nil) {
        [_homeNameText release];
        _homeNameText = nil;
    }
    _homeNameText = [[NSTextField alloc] init];
    [_homeNameText setBordered:NO];
    [_homeNameText setAlignment:NSCenterTextAlignment];
    [_homeNameText setDrawsBackground:NO];
    [_homeNameText setEditable:NO];
    [_homeNameText setAttributedStringValue:nameAs];
    [_homeNameText setFrame:rect];
    [self addSubview:_homeNameText];
}

- (BOOL)isFlipped {
    return YES;
}

#pragma mark - text
//点击链接文字
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex{
    NSString *overStr = CustomLocalizedString(@"Clone_id_23", nil);
    NSLog(@"%@",overStr);
    if ([link isEqualToString:overStr]) {
        [_textView removeFromSuperview];
        [_delegate removeDownloadArray:[_skinEntity.skinPackName stringByAppendingPathExtension:@"zip"]];
        [self addProgressVeiw];
        [_delegate downloadFile:_skinEntity.downloadPath isDownloadPlist:NO DownloadFileName:[_skinEntity.skinPackName stringByAppendingPathExtension:@"zip"]];
    }
    return YES;
}

- (void)closeDownload:(id)sender {
    [_progressView setHidden:YES];
    [_progressField setHidden:YES];
    [_closeBtn setHidden:YES];
    [_delegate removeDownloadArray:[_skinEntity.skinPackName stringByAppendingPathExtension:@"zip"]];
    [_skinEntity.skinBtn setHidden:NO];
}


@end

@implementation IMBSkinEntity
@synthesize skinName = _skinName;
@synthesize downloadPath = _downloadPath;
@synthesize skinImage = _skinImage;
@synthesize isNoSelect = _isNoSelect;
@synthesize isDownload = _isDownload;
@synthesize thumbDownloadPath = _thumbDownloadPath;
@synthesize skinImageName = _skinImageName;
@synthesize skinNameAs = _skinNameAs;
@synthesize skinPackName = _skinPackName;
@synthesize skinBtn = _skinBtn;
@synthesize enSkinName = _enSkinName;
@synthesize frSkinName = _frSkinName;
@synthesize jaSkinName = _jaSkinName;
@synthesize geSkinName = _geSkinName;
@synthesize esSkinName = _esSkinName;
@synthesize arSkinName = _arSkinName;
@synthesize chSkinName = _chSkinName;
@synthesize isNew = _isNew;
@synthesize skinVersion = _skinVersion;

- (id)init {
    self = [super init];
    if (self) {
        _isNoSelect = YES;
        _isDownload = NO;
        _skinName = @"";
        _downloadPath = @"";
        _thumbDownloadPath = @"";
        _skinImage = nil;
        _skinImageName = @"";
        _skinPackName = @"";
        _skinNameAs = nil;
        _skinBtn = nil;
        _geSkinName = @"";
        _frSkinName = @"";
        _jaSkinName = @"";
        _enSkinName = @"";
        _esSkinName = @"";
        _isNew = NO;
        _skinVersion = @"";
//        _skinBtn = [[IMBSkinButton alloc] initWithFrame:NSMakeRect(80, 2, 120, 24) WithPrefixImageName:@"skin" WithButtonName:@"Apply"];
    }
    return self;
}

- (void)setSkinBtn:(IMBSkinButton *)skinBtn {
    if (_skinBtn != nil) {
        [_skinBtn release];
        _skinBtn = nil;
    }
    _skinBtn = [skinBtn retain];
}

- (void)setSkinNameAttributedString {
    if (_skinName) {
        NSMutableAttributedString *as = [[[NSMutableAttributedString alloc] initWithString:_skinName] autorelease];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, as.length)];
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [self setSkinNameAs:as];
    }
}

- (void)dealloc {
    if (_skinBtn != nil) {
        [_skinBtn release];
        _skinBtn = nil;
    }
    [super dealloc];
}

@end
