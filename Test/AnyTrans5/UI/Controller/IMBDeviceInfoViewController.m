//
//  IMBDeviceInfoViewController.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/9/20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBDeviceInfoViewController.h"
#import "IMBVolumeEntity.h"
#import "IMBVolumView.h"
#import "IMBAnimation.h"
#import "IMBDeviceInfoEntity.h"
#import "IMBNotificationDefine.h"
#import "customTextFieldCell.h"
@implementation IMBDeviceInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    IMBInformationManager *manager = [IMBInformationManager shareInstance];
    _information = [manager.informationDic objectForKey:_iPod.uniqueKey];
    [_deviceInforView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(changeAlertViewState:) name:DeviceDisConnectedNotification object:nil];
    [((customTextFieldCell *)_deviceName.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    _isFirst = YES;
}

- (void)showInformationWithiPod:(IMBiPod *)iPod WithSuperView:(NSView *)superView{
    _volumeRectArray = [[NSMutableArray alloc] init];
    _volumeBarArray = [[NSMutableArray alloc] init];
    _iPod = [iPod retain];
    [self prepareDeviceInfo];
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    _animationView.backgroundColor = [StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)];
    [_animationView initWithLuCorner:NO LbCorner:YES RuCorner:NO RbConer:YES CornerRadius:5];
    [_deviceInforView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_deviceInforView addSubview:_animationView];
    [_animationView setFrameOrigin:NSMakePoint(5, 5)];
    [self loadAlertView:superView alertView:_deviceInforView];
    [_loadingView setbackColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_loadingView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self drawVolumeBar];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self configBtn];
            _bgView.isDrawFrame = YES;
            [_bgView setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            [_loadingView endAnimation];
            [_animationView removeFromSuperview];
        });
    });
}

- (void)configBtn {
    [_cancelBtn reSetInit:CustomLocalizedString(@"Button_Cancel", nil) WithPrefixImageName:@"cancal"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:CustomLocalizedString(@"Button_Cancel", nil)]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, CustomLocalizedString(@"Button_Cancel", nil).length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, CustomLocalizedString(@"Button_Cancel", nil).length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, CustomLocalizedString(@"Button_Cancel", nil).length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_cancelBtn setAttributedTitle:attributedTitles];
    
    [_cancelBtn setIsReslutVeiw:YES];
    [_cancelBtn setTarget:self];
    [_cancelBtn setAction:@selector(cancelBtnClick:)];
    
    [_openBtn reSetInit:CustomLocalizedString(@"DeviceDetailed_id_2", nil) WithPrefixImageName:@"cancal"];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:CustomLocalizedString(@"DeviceDetailed_id_2", nil)]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, CustomLocalizedString(@"DeviceDetailed_id_2", nil).length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, CustomLocalizedString(@"DeviceDetailed_id_2", nil).length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, CustomLocalizedString(@"DeviceDetailed_id_2", nil).length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_openBtn setAttributedTitle:attributedTitles1];
    
    [_openBtn setIsReslutVeiw:YES];
    [_openBtn setTarget:self];
    [_openBtn setAction:@selector(openBtnClick:)];
    
    [_copyBtn reSetInit:CustomLocalizedString(@"DeviceDetailed_id_1", nil) WithPrefixImageName:@"cancal"];
    NSMutableAttributedString *attributedTitles2 = [[[NSMutableAttributedString alloc]initWithString:CustomLocalizedString(@"DeviceDetailed_id_1", nil)]autorelease];
    [attributedTitles2 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, CustomLocalizedString(@"DeviceDetailed_id_1", nil).length)];
    [attributedTitles2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, CustomLocalizedString(@"DeviceDetailed_id_1", nil).length)];
    [attributedTitles2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, CustomLocalizedString(@"DeviceDetailed_id_1", nil).length)];
    [attributedTitles2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles2.length)];
    [_copyBtn setAttributedTitle:attributedTitles2];
    
    [_copyBtn setIsReslutVeiw:YES];
    [_copyBtn setTarget:self];
    [_copyBtn setAction:@selector(copyBtnClick:)];
    
    if ([_iPod.deviceInfo isIOSDevice]) {
        _editNameBtn = [[[IMBGeneralButton alloc] initWithFrame:NSMakeRect(174, 423, 74, 22)] autorelease];
        [_editNameBtn reSetInit:CustomLocalizedString(@"deviceInfo_id_2", nil) WithPrefixImageName:@"cancal"];
        NSMutableAttributedString *attributedTitles3 = [[[NSMutableAttributedString alloc]initWithString:CustomLocalizedString(@"deviceInfo_id_2", nil)]autorelease];
        [attributedTitles3 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, CustomLocalizedString(@"deviceInfo_id_2", nil).length)];
        [attributedTitles3 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, CustomLocalizedString(@"deviceInfo_id_2", nil).length)];
        [attributedTitles3 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, CustomLocalizedString(@"deviceInfo_id_2", nil).length)];
        [attributedTitles3 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles3.length)];
        [_editNameBtn setAttributedTitle:attributedTitles3];
        [_editNameBtn setIsReslutVeiw:YES];
        [_editNameBtn setTarget:self];
        [_editNameBtn setAction:@selector(editBtnClick:)];
        [_deviceInforView addSubview:_editNameBtn positioned:NSWindowBelow relativeTo:_animationView];
    }
}

- (void)drawVolumeBar {
        //1.准备数据
        long long totalVolume = _iPod.deviceInfo.totalDiskCapacity;
        long long totalUsedVolume = 0;
        if (totalVolume != 0) {
            if (_volArray != nil) {
                [_volArray release];
                _volArray = nil;
            }
            _volArray = [[NSMutableArray alloc] init];
            if (_iPod.deviceInfo.isSupportMusic) {
                NSArray *audioArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:(int)Audio],
                                       [NSNumber numberWithInt:(int)AudioAndVideo],
                                       [NSNumber numberWithInt:(int)Podcast],
                                       [NSNumber numberWithInt:(int)iTunesU],
                                       [NSNumber numberWithInt:(int)Audiobook],
                                       nil];
                NSMutableArray *trackArray = [_information cloudTrackArray];
                [trackArray addObjectsFromArray:[_iPod getTrackArrayByMediaTypes:audioArray]];
                NSNumber *size = [trackArray valueForKeyPath:@"@sum.fileSize"];
                int64_t sumSize = size.longLongValue;
                if (sumSize > 0) {
                    IMBVolumeEntity *audioVolume = [[IMBVolumeEntity alloc] init];
                    audioVolume.size = sumSize;
                    audioVolume.volumeType = VolumeType_Audio;
                    audioVolume.percentage = audioVolume.size * 1.0 / totalVolume;
                    audioVolume.volumeName = CustomLocalizedString(@"DeviceView_id_4", nil);
                    [audioVolume setImageNameWithPrefix:@"vol_audio"];
                    [_volArray addObject:audioVolume];
                    totalUsedVolume+=sumSize;
                    [audioVolume release];
                }
            }
            if (_iPod.deviceInfo.isSupportVideo) {
                NSArray *videoArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:(int)Video],
                                       [NSNumber numberWithInt:(int)TVAndMusic],
                                       [NSNumber numberWithInt:(int)TVShow],
                                       [NSNumber numberWithInt:(int)MusicVideo],
                                       [NSNumber numberWithInt:(int)VideoPodcast],
                                       [NSNumber numberWithInt:(int)iTunesUVideo],
                                       nil];
                NSArray *trackArray = [_iPod getTrackArrayByMediaTypes:videoArray];
                NSNumber *size = [trackArray valueForKeyPath:@"@sum.fileSize"];
                int64_t sumSize = size.longLongValue;
                if (sumSize > 0) {
                    IMBVolumeEntity *videoVolume = [[IMBVolumeEntity alloc] init];
                    videoVolume.size = sumSize;
                    videoVolume.volumeType = VolumeType_Video;
                    videoVolume.percentage = videoVolume.size * 1.0 / totalVolume;
                    videoVolume.volumeName = CustomLocalizedString(@"DeviceView_id_5", nil);
                    [videoVolume setImageNameWithPrefix:@"vol_video"];
                    [_volArray addObject:videoVolume];
                    totalUsedVolume+=sumSize;
                    [videoVolume release];
                }
            }
            if (_iPod.deviceInfo.isSupportPhoto) {
                IMBInformationManager *manager = [IMBInformationManager shareInstance];
                IMBInformation *information = [manager.informationDic objectForKey:_iPod.uniqueKey];
                int64_t size = [information calulatePhotoSize];
                if (size>0) {
                    IMBVolumeEntity *photoVolume = [[IMBVolumeEntity alloc] init];
                    photoVolume.size = size;
                    photoVolume.volumeType = VolumeType_Photo;
                    photoVolume.percentage = photoVolume.size * 1.0 / totalVolume;
                    photoVolume.volumeName = CustomLocalizedString(@"DeviceView_id_6", nil);
                    [photoVolume setImageNameWithPrefix:@"vol_photo"];
                    [_volArray addObject:photoVolume];
                    totalUsedVolume += size;
                    [photoVolume release];
                    
                }
            }
            if (_iPod.deviceInfo.isSupportRingtone) {
                NSArray *rtArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:(int)Ringtone],
                                    nil];
                NSArray *trackArray = [_iPod getTrackArrayByMediaTypes:rtArray];
                NSNumber *size = [trackArray valueForKeyPath:@"@sum.fileSize"];
                int64_t sumSize = size.longLongValue;
                if (sumSize > 0) {
                    IMBVolumeEntity *ringtoneVolume = [[IMBVolumeEntity alloc] init];
                    ringtoneVolume.size = sumSize;
                    ringtoneVolume.volumeType = VolumeType_Ringtones;
                    ringtoneVolume.percentage = ringtoneVolume.size * 1.0 / totalVolume;
                    ringtoneVolume.volumeName = CustomLocalizedString(@"DeviceView_id_9", nil);
                    [ringtoneVolume setImageNameWithPrefix:@"vol_ringtone"];
                    [_volArray addObject:ringtoneVolume];
                    totalUsedVolume+=sumSize;
                    [ringtoneVolume release];
                }
            }
            
            if (_iPod.deviceInfo.isSupportiBook) {
                IMBInformationManager *manager = [IMBInformationManager shareInstance];
                IMBInformation *information = [manager.informationDic objectForKey:_iPod.uniqueKey];
                int64_t sumSize = [information calulateiBookSize];
                if (sumSize > 0) {
                    IMBVolumeEntity *booksVolume = [[IMBVolumeEntity alloc] init];
                    booksVolume.size = sumSize;
                    booksVolume.volumeType = VolumeType_Books;
                    booksVolume.percentage = booksVolume.size * 1.0 / totalVolume;
                    booksVolume.volumeName = CustomLocalizedString(@"DeviceView_id_7", nil);
                    [booksVolume setImageNameWithPrefix:@"vol_books"];
                    [_volArray addObject:booksVolume];
                    totalUsedVolume+=sumSize;
                    [booksVolume release];
                }
            }
            
            if (_iPod.deviceInfo.isIOSDevice) {
                int64_t sumSize = _iPod.deviceInfo.mobileApplicationUsage;
                if (sumSize > 0) {
                    IMBVolumeEntity *appsVolume = [[IMBVolumeEntity alloc] init];
                    appsVolume.size = sumSize;
                    appsVolume.volumeType = VolumeType_Apps;
                    appsVolume.percentage = appsVolume.size * 1.0 / totalVolume;
                    appsVolume.volumeName = CustomLocalizedString(@"DeviceView_id_8", nil);
                    [appsVolume setImageNameWithPrefix:@"vol_apps"];
                    [_volArray addObject:appsVolume];
                    totalUsedVolume+=appsVolume.size;
                    [appsVolume release];
                }
            }
            
            long long cs = [self getDeviceCapcityType:_iPod.deviceInfo.totalDiskCapacity];
            _capacitySize = cs * (1024*1024*1024);
            _usedSize = _capacitySize - _iPod.deviceInfo.totalDataAvailable;
            _freeSize = _iPod.deviceInfo.totalDataAvailable;
            NSString *capacityStr = [StringHelper getFileSizeString:_capacitySize reserved:2];
            NSString *usedStr = [StringHelper getFileSizeString:_usedSize reserved:2];
            NSString *freeStr = [StringHelper getFileSizeString:_freeSize reserved:2];
            
            IMBVolumeEntity *othersVolume = [[IMBVolumeEntity alloc] init];
            othersVolume.size = _iPod.deviceInfo.totalDiskCapacity - _iPod.deviceInfo.totalSystemCapacity - _iPod.deviceInfo.totalDataAvailable + _iPod.deviceInfo.totalSystemAvailable - totalUsedVolume;
            if (othersVolume.size > 0) {
                othersVolume.volumeType = VolumeType_Others;
                othersVolume.percentage = othersVolume.size * 1.0 / totalVolume;
                othersVolume.volumeName = CustomLocalizedString(@"DeviceView_id_11", nil);
                [othersVolume setImageNameWithPrefix:@"vol_others"];
                [_volArray addObject:othersVolume];
            }
            [othersVolume release];
            if (_iPod.deviceInfo.isIOSDevice) {
                IMBVolumeEntity *systemVolume = [[IMBVolumeEntity alloc] init];
                systemVolume.size = _iPod.deviceInfo.totalSystemCapacity - _iPod.deviceInfo.totalSystemAvailable;
                systemVolume.volumeType = VolumeType_System;
                systemVolume.percentage = systemVolume.size * 1.0 / totalVolume;
                systemVolume.volumeName = CustomLocalizedString(@"DeviceView_id_29", nil);
                [systemVolume setImageNameWithPrefix:@"vol_system"];
                [_volArray addObject:systemVolume];
                [systemVolume release];
            }
            
            
            //        dispatch_async(dispatch_get_main_queue(), ^{
            ////            [capacitytextfield setStringValue:capacityStr];//总容量
            ////            [usedtextfield setStringValue:usedStr];
            ////            [freetextfield setStringValue:freeStr];//剩余容量
            ////            [self showDeviceInforloading:NO baseView:refreshLoadingFatherView];
            //        });
            int totalWidth = volumeBarImageView.frame.size.width;
            int minWidth = 7;
            int originX = 0;
            int originY = 0;
            int height = 16;
            int culWidth = 0;
            for (int i = 0; i<[_volArray count]; i++) {
                IMBVolumeEntity *volume = [_volArray objectAtIndex:i];
                IMBVolumView *barView = [[IMBVolumView alloc]initWithImageName:volume.volumebarImageName currentCount:i];
                [barView setFrameOrigin:NSMakePoint(originX, originY)];
                int width = (int)(totalWidth * volume.percentage);
                if (i==0) {
                    
                    width -= 2;
                }
                if (width < minWidth) {
                    width = minWidth;
                }
                culWidth += width;
                if (culWidth >= volumeBarImageView.frame.size.width) {
                    [barView setIsFull:YES];
                    width = volumeBarImageView.frame.size.width -originX;
                }
                
               
                [barView setFrame:NSMakeRect(originX, originY,width,height)];
                originX += width;
                
                [_volumeBarArray addObject:barView];
                [barView release];
            }
            
            int i = 0;
            int bufferWidth = 160;
            int bufferHeight = 35;
            int imageX = 0;
            int imageY = 0;
            int textX = 0;
            int textY = 0;
            int y;
            //        [VolumeRectPlaceHolderImageView setHidden:TRUE];
            //        [VolumeRectPlaceHolderLabel setHidden:TRUE];
            if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                [VolumeRectPlaceHolderLabel setFrameOrigin:NSMakePoint(36, 56)];
                if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"] ) {
                    [VolumeRectPlaceHolderImageView setFrameOrigin:NSMakePoint(184, 58)];
                     y = 184;
                }else {
                    [VolumeRectPlaceHolderImageView setFrameOrigin:NSMakePoint(164, 58)];
                     y = 164;
                }
               
            }else {
                [VolumeRectPlaceHolderImageView setFrameOrigin:NSMakePoint(34, 58)];
                [VolumeRectPlaceHolderLabel setFrameOrigin:NSMakePoint(46, 56)];
                y = 34;
            }
            
            
            for (IMBVolumeEntity* volume in _volArray) {
                imageX = y + i % 4 * bufferWidth;
                if (i >3) {
                    imageY = VolumeRectPlaceHolderImageView.frame.origin.y - 10 - 10-(VolumeRectPlaceHolderLabel.frame.size.height - 10)/2;   //(i/3)*bufferHeight
                } else {
                    imageY = VolumeRectPlaceHolderImageView.frame.origin.y;
                }
                NSImageView *imageView = [[[NSImageView alloc] initWithFrame:NSMakeRect(imageX, imageY, VolumeRectPlaceHolderImageView.frame.size.width, VolumeRectPlaceHolderImageView.frame.size.height)] autorelease];
                imageView.image = [StringHelper imageNamed:volume.voluemRectImageName];
                [useinforView addSubview:imageView];
                [_volumeRectArray addObject:imageView];
                
                textX = VolumeRectPlaceHolderLabel.frame.origin.x + i % 4 * bufferWidth;
                
                if (i >3) {
                    textY = VolumeRectPlaceHolderImageView.frame.origin.y - 10 - VolumeRectPlaceHolderLabel.frame.size.height+1;
                } else {
                    textY = VolumeRectPlaceHolderLabel.frame.origin.y;
                }
                
                NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(textX, textY, VolumeRectPlaceHolderLabel.frame.size.width + 10, VolumeRectPlaceHolderLabel.frame.size.height)];
                [VolumeRectPlaceHolderLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                NSString *CtString = [StringHelper getFileSizeString:volume.size reserved:2];
                NSString *stringValue = [NSString stringWithFormat:@"%@: %@",volume.volumeName,CtString];
                NSMutableAttributedString *attrString = [[[NSMutableAttributedString alloc]initWithString:stringValue] autorelease];
                [attrString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, attrString.length)];
                [attrString addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0 , attrString.length)];
                [textField setAttributedStringValue:attrString];
                [textField setEditable:FALSE];
                [textField setBordered:NO];
                [textField setBackgroundColor:[NSColor clearColor]];
                [textField setFont:[NSFont systemFontOfSize:14.0]];
                
                [_volumeRectArray addObject:textField];
                [textField release];
                i++;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for (IMBVolumView *barView in _volumeBarArray) {
                    [volumeBarImageView addSubview:barView];
                }
                for (NSTextField *textfield in _volumeRectArray) {
                    [useinforView addSubview:textfield];
                }
                
                //设备图片
                if (_iPod.deviceInfo.family < 1006 ) {
                    _deviceImage.image = [StringHelper imageNamed:@"ipod_touch"];
                } else if (_iPod.deviceInfo.family < 2018) {
                    _deviceImage.image = [StringHelper imageNamed:@"iPhone"];
                } else if (_iPod.deviceInfo.family < 4005) {
                    _deviceImage.image = [StringHelper imageNamed:@"ipad"];
                }
                
                if (_iPod.deviceInfo.deviceName != nil) {
                    [_deviceName setStringValue:_iPod.deviceInfo.deviceName];
                }
                [_deviceName setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                [_deviceName setEditable:NO];
                [_deviceName setSelectable:NO];
                _isEdit = NO;
                
                NSString *freeCapacityStr = [NSString stringWithFormat:CustomLocalizedString(@"deviceInfo_id_1", nil),freeStr,capacityStr];
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:freeCapacityStr];
                [attri addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, attri.length)];
                [attri addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, attri.length)];
                
                NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
                [textParagraph setAlignment:NSRightTextAlignment];
                [attri addAttribute:NSParagraphStyleAttributeName value:textParagraph range:NSMakeRange(0, attri.length)];
                [attri addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, attri.length)];
                [_deviceCapacityLable setAttributedStringValue:attri];
                [attri release], attri = nil;
            });
        }

}

- (int)getDeviceCapcityType:(long long)totalSize {
    double type = (double)(totalSize/(1024*1024*1024));
    if (type>0.0&&type<=8.0) {
        return 8;
    }else if (type>8.0&&type<=16.0)
    {
        return 16;
    }else if (type>16.0&&type<=32.0)
    {
        return 32;
    }else if (type>32.0&&type<=64.0)
    {
        return 64;
    }else if (type>64&&type<=128.0)
    {
        return 128;
    }else if (type>128.0&&type<=256.0)
    {
        return 256;
    }
    
    return 8;
}

- (void)loadAlertView:(NSView *)view alertView:(IMBBorderRectAndColorView *)alertView {
    [self setupAlertRect:alertView];
    if (![self.view.subviews containsObject:alertView]) {
        [self.view addSubview:alertView];
    }
//    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//        [alertView.layer addAnimation:[IMBAnimation moveY:3 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-500] repeatCount:1] forKey:@"moveY"];
//    } completionHandler:^{
//        [alertView.layer removeAnimationForKey:@"moveY"];
//        [alertView setFrame:NSMakeRect(ceil((NSMaxX(view.bounds) - NSWidth(alertView.frame)) / 2), NSMaxY(view.bounds) - NSHeight(alertView.frame) + 10, NSWidth(alertView.frame), NSHeight(alertView.frame))];
//    }];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(ceil((NSMaxX(view.bounds) - NSWidth(alertView.frame)) / 2), NSMaxY(view.bounds) - NSHeight(alertView.frame) + 10, NSWidth(alertView.frame), NSHeight(alertView.frame));
        
        [context setDuration:0.3];
        [[alertView animator] setFrame:rect];
    } completionHandler:^{
        [self.view setWantsLayer:YES];
    }];
}

- (void)setupAlertRect:(IMBBorderRectAndColorView *)alertView {
    [alertView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    NSRect rect = [alertView frame];
    [alertView setWantsLayer:YES];
    [alertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - NSWidth(rect)) / 2), NSMaxY(self.view.bounds), NSWidth(rect), NSHeight(rect))];
}

- (void)prepareDeviceInfo {
    if (_deviceArray != nil) {
        [_deviceArray release];
        _deviceArray = nil;
    }
    _deviceArray = [[NSMutableArray alloc] init];
    
    IMBDeviceInfoEntity *entity = nil;
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo deviceName]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_DeviceName", nil)];
        entity.valueString = [_iPod.deviceInfo deviceName];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo serialNumber]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_SerialNumber", nil)];
        entity.valueString = [_iPod.deviceInfo serialNumber];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo getIPodFamilyString]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_Description", nil)];
        entity.valueString = [[_iPod.deviceInfo getIPodFamilyString] stringByAppendingString:[NSString stringWithFormat:@" (%dG)",[self getDeviceCapcityType:_iPod.deviceInfo.totalDiskCapacity]]];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo deviceClass]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_DeviceClass", nil)];
        entity.valueString = [_iPod.deviceInfo deviceClass];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo productType]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_ProductType", nil)];
        entity.valueString = [_iPod.deviceInfo productType];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo productVersion]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_ProductVersion", nil)];
        entity.valueString = [_iPod.deviceInfo productVersion];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo uniqueChipID]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_DeviceUUID", nil)];
        entity.valueString = [_iPod.deviceInfo uniqueChipID];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo modelNumber]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_ModelNumber", nil)];
        entity.valueString = [_iPod.deviceInfo modelNumber];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo buildVersion]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_BuildVersion", nil)];
        entity.valueString = [_iPod.deviceInfo buildVersion];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo hardwareModel]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_HardwareModel", nil)];
        entity.valueString = [_iPod.deviceInfo hardwareModel];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo deviceColor]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_DeviceColor", nil)];
        entity.valueString = [_iPod.deviceInfo deviceColor];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo regionInfo]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_RegionInfo", nil)];
        entity.valueString = [_iPod.deviceInfo regionInfo];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo CPUArchitecture]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_CPUArchitecture", nil)];
        entity.valueString = [_iPod.deviceInfo CPUArchitecture];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo wifiAddress]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_WiFiAddress", nil)];
        entity.valueString = [_iPod.deviceInfo wifiAddress];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo bluetoothAddress]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_BluetoothAddress", nil)];
        entity.valueString = [_iPod.deviceInfo bluetoothAddress];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo firmwareVersion]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_FirmwareVersion", nil)];
        entity.valueString = [_iPod.deviceInfo firmwareVersion];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo activationState]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_ActivationState", nil)];
        entity.valueString = [_iPod.deviceInfo activationState];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    entity = [[IMBDeviceInfoEntity alloc] init];
    entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_ActivationStateAcknowledged", nil)];
    entity.valueString = [_iPod.deviceInfo activationStateAcknowledged] == 0 ? CustomLocalizedString(@"Button_No", nil) : CustomLocalizedString(@"Button_Yes", nil);
    [_deviceArray addObject:entity];
    [entity release];
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo basebandVersion]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_BasebandVersion", nil)];
        entity.valueString = [_iPod.deviceInfo basebandVersion];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo basebandBootloaderVersion]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_BasebandBootloaderVersion", nil)];
        entity.valueString = [_iPod.deviceInfo basebandBootloaderVersion];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if ([_iPod.deviceInfo basebandChipId] != 0) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_BasebandChipId", nil)];
        entity.valueString = [NSString stringWithFormat:@"%ld",[_iPod.deviceInfo basebandChipId]];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if ([_iPod.deviceInfo basebandGoldCertId] != 0) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_BasebandGoldCertId", nil)];
        entity.valueString = [NSString stringWithFormat:@"%ld",[_iPod.deviceInfo basebandGoldCertId]];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo integratedCircuitCardIdentity]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_IntegratedCircuitCardIdentity", nil)];
        entity.valueString = [_iPod.deviceInfo integratedCircuitCardIdentity];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo internationalMobileEquipmentIdentity]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_InternationalMobileEquipmentIdentity", nil)];
        entity.valueString = [_iPod.deviceInfo internationalMobileEquipmentIdentity];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo internationalMobileSubscriberIdentity]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_InternationalMobileSubscriberIdentity", nil)];CustomLocalizedString(@"IMSI :", nil);
        entity.valueString = [_iPod.deviceInfo internationalMobileSubscriberIdentity];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo MLBSerialNumber]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_MLBSerialNumber", nil)];
        entity.valueString = [_iPod.deviceInfo MLBSerialNumber];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo mobileSubscriberCountryCode]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_MobileSubscriberCountryCode", nil)];
        entity.valueString = [_iPod.deviceInfo mobileSubscriberCountryCode];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo mobileSubscriberNetworkCode]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_MobileSubscriberNetworkCode", nil)];
        entity.valueString = [_iPod.deviceInfo mobileSubscriberNetworkCode];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    entity = [[IMBDeviceInfoEntity alloc] init];
    entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_PasswordProtected", nil)];
    entity.valueString = [_iPod.deviceInfo passwordProtected] == 0 ? CustomLocalizedString(@"Button_No", nil) : CustomLocalizedString(@"Button_Yes", nil);
    [_deviceArray addObject:entity];
    [entity release];
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo phoneNumber]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_PhoneNumber", nil)];
        entity.valueString = [_iPod.deviceInfo phoneNumber];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    entity = [[IMBDeviceInfoEntity alloc] init];
    entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_ProductionSOC", nil)];
    entity.valueString = [_iPod.deviceInfo productionSOC] == 0 ? CustomLocalizedString(@"Button_No", nil) : CustomLocalizedString(@"Button_Yes", nil);
    [_deviceArray addObject:entity];
    [entity release];
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo protocolVersion]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_ProtocolVersion", nil)];
        entity.valueString = [_iPod.deviceInfo protocolVersion];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo SDIOProductInfo]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_SDIOProductInfo", nil)];
        entity.valueString = [_iPod.deviceInfo SDIOProductInfo];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo simStatus]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_SIMStatus", nil)];
        entity.valueString = [_iPod.deviceInfo simStatus];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
    //    if ([IMBHelper stringIsNilOrEmpty:[_iPod.deviceInfo supportedDeviceFamilies]]) {
    //        entity = [[IMBDeviceInfoEntity alloc] init];
    //        entity.typeString = NSLocalizedString(@"SupportedDeviceFamilies :", nil);
    //        entity.valueString = [_iPod.deviceInfo supportedDeviceFamilies];
    //        [_deviceArray addObject:entity];
    //        [entity release];
    //    }
    
    entity = [[IMBDeviceInfoEntity alloc] init];
    entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_TimeIntervalSince1970", nil)];
    entity.valueString = [DateHelper longToDateString1970:[_iPod.deviceInfo timeIntervalSince1970] withMode:2];
    [_deviceArray addObject:entity];
    [entity release];
    
    if (![StringHelper stringIsNilOrEmpty:[_iPod.deviceInfo timeZone]]) {
        entity = [[IMBDeviceInfoEntity alloc] init];
        entity.typeString = [NSString stringWithFormat:@"%@ :",CustomLocalizedString(@"DeviceDetailed_TimeZone", nil)];
        entity.valueString = [_iPod.deviceInfo timeZone];
        [_deviceArray addObject:entity];
        [entity release];
    }
    
}

- (void)cancelBtnClick:(id)sender {
    [self unloadAlertView:_deviceInforView];
}

- (void)openBtnClick:(id)sender {
    NSString *result = [self stringFromTransactions];
    NSString *expath = [_iPod.exportSetting.exportPath stringByAppendingPathComponent:@"AnyTrans"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:expath]) {
        [fm createDirectoryAtPath:expath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *path = [expath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",CustomLocalizedString(@"Device_Info_id", nil)]];
    if ([fm fileExistsAtPath:path]) {
        path = [TempHelper getFilePathAlias:path];
    }
    [result writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if ([fm fileExistsAtPath:path]) {
        NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
        [workSpace openFile:path withApplication:@"TextEdit"];
    }
}

- (void)copyBtnClick:(id)sender {
    [self writeSelectionToPasteboard:[NSPasteboard generalPasteboard] types:[self writablePasteboardTypes]];
}

- (void)editBtnClick:(id)sender {
    _isEdit = !_isEdit;
   [_deviceName setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    if (_isEdit) {
        [_deviceName becomeFirstResponder];
        [_editNameBtn setButtonName:CustomLocalizedString(@"contact_id_92", nil)];
        [_deviceName setEditable:YES];
        [_deviceName setSelectable:YES];
        [_deviceName setEnabled:YES];
        [_deviceName.cell setSelectable:YES];
        [_deviceName.cell setEditable:YES];
        [_deviceName setNeedsDisplay:YES];
//        if (_isFirst) {
            [_deviceName mouseDown:nil];
//        }
        _isFirst = NO;
    }else {
        
        [_deviceName setNeedsDisplay:YES];
        [_deviceName setEditable:NO];
        [_deviceName setSelectable:NO];
        [_deviceName setEnabled:NO];
        [_deviceName.cell setSelectable:NO];
        [_deviceName.cell setEditable:NO];
        [_editNameBtn setButtonName:CustomLocalizedString(@"deviceInfo_id_2", nil)];
        [_editNameBtn setNeedsDisplay:YES];
        NSString *newName = _deviceName.stringValue;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if ([StringHelper stringIsNilOrEmpty:newName]) {
                return;
            }
            BOOL success = [_iPod.deviceHandle reDeviceName:newName];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (success) {
                }
            });
        });
        
    }
    
}

- (NSArray *)writablePasteboardTypes {
    return [NSArray arrayWithObjects: NSStringPboardType, nil];
}

- (BOOL)writeSelectionToPasteboard:(NSPasteboard *)pboard types:(NSArray *)types {
    BOOL result = NO;
    NSMutableArray *typesToDeclare = [NSMutableArray array];
    NSArray *writableTypes = [self writablePasteboardTypes];
    NSString *type;
    
    for (type in writableTypes) {
        if ([types containsObject:type]) [typesToDeclare addObject:type];
    }
    if ([typesToDeclare count] > 0) {
        [pboard declareTypes:typesToDeclare owner:self];
        for (type in typesToDeclare) {
            if ([self writeSelectionToPasteboard:pboard type:type]) result = YES;
        }
    }
    return result;
}

- (BOOL)writeSelectionToPasteboard:(NSPasteboard *)pboard type:(NSString *)type {
    BOOL result = NO;
    NSString *string = [self stringFromTransactions];
    if (string && [string length] > 0) result = [pboard setString:string forType:NSStringPboardType];
    return result;
}

- (NSString *)stringFromTransactions {
    // When we are writing out NSStringPboardType, we create a string with one line per transaction and tabs between items in the transaction
    NSMutableString *result = [NSMutableString string];
    for (IMBDeviceInfoEntity *entity in _deviceArray) {
        [result appendString:[NSString stringWithFormat:@"%@ %@\n",entity.typeString,entity.valueString]];
    }
    
    return result;
}

- (void)unloadAlertView:(IMBBorderRectAndColorView *)alertView {
//    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//        [alertView.layer addAnimation:[IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:700] repeatCount:1] forKey:@"moveY"];
//    } completionHandler:^{
//        [alertView.layer removeAnimationForKey:@"moveY"];
//        [alertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - alertView.frame.size.width) / 2), NSMaxY(self.view.bounds), alertView.frame.size.width, alertView.frame.size.height)];
//        [self.view removeFromSuperview];
//    }];
    
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(ceil((NSMaxX(self.view.bounds) - alertView.frame.size.width) / 2), NSMaxY(self.view.bounds), alertView.frame.size.width, alertView.frame.size.height);
        
        [context setDuration:0.3];
        [[alertView animator] setFrame:rect];
    } completionHandler:^{
        [self.view setWantsLayer:YES];
        [self.view removeFromSuperview];
    }];
}

- (void)changeAlertViewState:(NSNotification *) noti {
    NSDictionary *dic = noti.userInfo;
    if ([[dic objectForKey:@"UniqueKey"] isEqualToString:_iPod.uniqueKey]) {
        [self unloadAlertView:_deviceInforView];
    }
}

#pragma mark - NSTableView datasource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_deviceArray != nil) {
        return _deviceArray.count;
    }
    return 0;
}
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    IMBDeviceInfoEntity *entity = nil;
    entity = [_deviceArray objectAtIndex:row];
    
    if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        if ([[tableColumn identifier] isEqualToString:@"Type"]) {
            
            return entity.valueString;
        }
        if ([[tableColumn identifier] isEqualToString:@"Value"]) {
            return entity.typeString;
        }
    }else {
        if ([[tableColumn identifier] isEqualToString:@"Type"]) {
            
            return entity.typeString;
        }
        if ([[tableColumn identifier] isEqualToString:@"Value"]) {
            return entity.valueString;
        }
    }
    return nil;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 32;
}

- (void)dealloc {
    [nc removeObserver:self name:DeviceDisConnectedNotification object:nil];
    if (_iPod != nil) {
        [_iPod release];
        _iPod = nil;
    }
    if (_volArray != nil) {
        [_volArray release];
        _volArray = nil;
    }
    if (_volumeRectArray != nil) {
        [_volumeRectArray release];
        _volumeRectArray = nil;
    }
    if (_volumeBarArray != nil) {
        [_volumeBarArray release];
        _volumeBarArray = nil;
    }
    [super dealloc];
}
@end








