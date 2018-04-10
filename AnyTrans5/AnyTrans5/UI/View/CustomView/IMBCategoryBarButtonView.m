//
//  IMBCategoryButtonView.m
//  iMobieTrans
//
//  Created by iMobie on 14-4-28.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBCategoryBarButtonView.h"
//#import "IMBApplicationManager.h"
#import "HoverButton.h"
//#import "IMBPlaylistList.h"
//#import "IMBRecording.h"
#import "IMBDeviceInfo.h"
#import "IMBInformationManager.h"
//#import "IMBCommonDefine.h"
#import "IMBInformation.h"
#import "IMBNotificationDefine.h"
//#import "IMBCheckiCloudWindowController.h"
//#import "IMBProductConfigurationFile.h"
#import "StringHelper.h"
#import "IMBCalendarEntity.h"
#import "IMBCalendarEventEntity.h"
#import "IMBSMSChatDataEntity.h"
#import "IMBSoftWareInfo.h"

#define CategoryButtonWidth 80
#define CategoryButtonHeight 100
#define CategoryButtonFrontSpace 236
#define CategoryButtonSpace 58

@implementation IMBCategoryBarButtonView
@synthesize catagoryBlock = _catagoryBlock;
@synthesize ipod = _ipod;
@synthesize transparentView = _transparentView;
@synthesize popUpView = _popUpView;
@synthesize audioArr = _audioArr;
@synthesize videosArr = _videosArr;
@synthesize safraiArr = _safraiArr;
@synthesize photosArr = _photosArr;
@synthesize currentContainer = _currentContainer;
@synthesize categoryArr = _categoryArr;
@synthesize allcategoryArr = _allcategoryArr;
@synthesize currentButton = currentButton;
@synthesize allBtnArr = _allBtnArr;
@synthesize reloadBlock = _reloadBlock;
@synthesize timer = timer;
@synthesize threadBreak = _threadBreak;
@synthesize systemArr = _systemArr;
@synthesize android = _android;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithiPod:(IMBiPod*)iPod withFrame:(NSRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
       
        timerqueue = dispatch_queue_create("timer", NULL);
        dispatch_async(timerqueue, ^{
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1f/120 target:self selector:@selector(needDisplay:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            [timer setFireDate:[NSDate distantFuture]];
            while (!_threadBreak) {
               [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
            }
            
        });
        self.ipod = iPod;
        K = 0;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBadgeCount:) name:NOTIFY_BADGECOUNT_REFRESH object:nil];
        //创建设备支持的categorybutton
        containerView = [[NSView alloc] initWithFrame:NSMakeRect(0, 36, 1060, CategoryButtonHeight)];
        [self addSubview:containerView];
//        [containerView release];
        [self createSupportedCategorybutton];
        [self setWantsLayer:YES];

    }
    return self;
}

- (void)initializationCategoryView:(IMBiPod *)iPod withCategoryBlock:(CategorybuttonBlock)categoryBlock
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationViewChanged:) name:NSViewFrameDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    timerqueue = dispatch_queue_create("timer", NULL);
    dispatch_async(timerqueue, ^{
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1f/60 target:self selector:@selector(needDisplay:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [timer setFireDate:[NSDate distantFuture]];
        while (!_threadBreak) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
        }
        
    });
    self.ipod = iPod;
    self.catagoryBlock = categoryBlock;
    K = 0;
    containerView = [[NSView alloc] initWithFrame:NSMakeRect(0, self.frame.size.height - 86 - (CategoryButtonHeight+30)*2, 1060, CategoryButtonHeight)];
    [self addSubview:containerView];
//    [containerView release];
    [self createSupportedCategorybutton];
    [self setWantsLayer:YES];
}

- (void)initializationCategoryBlock:(CategorybuttonBlock)categoryBlock
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationViewChanged:) name:NSViewFrameDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    
    self.catagoryBlock = categoryBlock;
    K = 0;
    containerView = [[NSView alloc] initWithFrame:NSMakeRect(0, self.frame.size.height - 86 - (CategoryButtonHeight+30)*2, 1060, CategoryButtonHeight)];
    [self addSubview:containerView];
    //    [containerView release];
    [self createiCloudCategorybutton];
    [self setWantsLayer:YES];
}

- (void)initializationCategoryAndroid:(IMBAndroid *)android withCategoryBlock:(CategorybuttonBlock)categoryBlock
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationViewChanged:) name:NSViewFrameDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    self.android = android;
    self.catagoryBlock = categoryBlock;
    K = 0;
    containerView = [[NSView alloc] initWithFrame:NSMakeRect(0, self.frame.size.height - 86 - (CategoryButtonHeight+30)*2, 1060, CategoryButtonHeight)];
    [self addSubview:containerView];
    //    [containerView release];
    [self createAndroidCategorybutton];
    [self setWantsLayer:YES];
}

- (void)createiCloudCategorybutton
{
    _allcategoryArr = [[NSMutableArray alloc] init];
    NSArray *category = [NSArray arrayWithObjects:@(Category_Contacts),@(Category_Notes),@(Category_Photo),@(Category_PhotoVideo),@(Category_Calendar),@(Category_Reminder),@(Category_iCloudBackup),nil];
    int i=0;
    for (NSNumber *item in category) {
        IMBFunctionButton *button  = [[IMBFunctionButton alloc] initWithFrame:NSMakeRect(CategoryButtonFrontSpace+(CategoryButtonWidth + 10 +CategoryButtonSpace)*i,self.frame.size.height - 86 - (CategoryButtonHeight + 10 +30), CategoryButtonWidth + 10, CategoryButtonHeight + 10)];
        switch (item.intValue) {
            case Category_Photo:
                button.tag = Category_Photo;
                [button setImageWithImageName:@"btn_iCloud_photoNew" withButtonName:CustomLocalizedString(@"MenuItem_id_9", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_iCloudphotos"]];
                [button setSelectIcon:[StringHelper imageNamed:@"select_photo"]];
                [button setToolTip:CustomLocalizedString(@"MenuItem_id_9", nil)];
                break;
            case Category_PhotoVideo:
                button.tag = Category_PhotoVideo;
                [button setImageWithImageName:@"btn_photo_videosnew" withButtonName:CustomLocalizedString(@"MenuItem_id_24", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_video_photovideo"]];
                [button setSelectIcon:[StringHelper imageNamed:@"select_video_photovideo"]];
                [button setToolTip:CustomLocalizedString(@"MenuItem_id_24", nil)];
                break;
            case Category_ContinuousShooting:
                button.tag = Category_ContinuousShooting;
                [button setImageWithImageName:@"btn_burstnew" withButtonName:CustomLocalizedString(@"MenuItem_id_47", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_photo_bursts"]];
                [button setSelectIcon:[StringHelper imageNamed:@"select_photo_bursts"]];
                [button setToolTip:CustomLocalizedString(@"MenuItem_id_47", nil)];
                break;
            case Category_Contacts:
                button.tag = Category_Contacts;
                [button setImageWithImageName:@"btn_contactsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_20", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_contact"]];
                [button setSelectIcon:[StringHelper imageNamed:@"select_contact"]];
                [button setToolTip:CustomLocalizedString(@"MenuItem_id_20", nil)];

                break;
            case Category_Notes:
                button.tag = Category_Notes;
                [button setImageWithImageName:@"btn_notenew" withButtonName:CustomLocalizedString(@"MenuItem_id_17", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_notes"]];
                [button setSelectIcon:[StringHelper imageNamed:@"select_note"]];
                [button setToolTip:CustomLocalizedString(@"MenuItem_id_17", nil)];

                break;
            case Category_Calendar:
                button.tag = Category_Calendar;
                [button setImageWithImageName:@"btn_calendarnew" withButtonName:CustomLocalizedString(@"MenuItem_id_62", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_calendar"]];
                [button setSelectIcon:[StringHelper imageNamed:@"select_calendar"]];
                [button setToolTip:CustomLocalizedString(@"MenuItem_id_9", nil)];

                break;
            case Category_Reminder:
                button.tag = Category_Reminder;
                [button setImageWithImageName:@"btn_remindernew" withButtonName:CustomLocalizedString(@"Reminders_id", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_iCloudreminder"]];
                [button setSelectIcon:[StringHelper imageNamed:@"select_reminder"]];
                [button setToolTip:CustomLocalizedString(@"Reminders_id", nil)];

                break;
            case Category_iCloudDriver:
//                button.tag = Category_iCloudDriver;
//                [button setImageWithImageName:@"btn_iCloudDrivernew" withButtonName:CustomLocalizedString(@"iCloudDriver", nil)];
//                [button setNavagationIcon:[StringHelper imageNamed:@"nav_calendar"]];
//                [button setSelectIcon:[StringHelper imageNamed:@"select_calendar"]];
                break;
            case Category_iCloudBackup:
                button.tag = Category_iCloudBackup;
                [button setImageWithImageName:@"btn_iCloud_backup" withButtonName:CustomLocalizedString(@"icloud_backup", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_iCloudbackup"]];
                [button setSelectIcon:[StringHelper imageNamed:@"select_calendar"]];
                [button setToolTip:CustomLocalizedString(@"icloud_backup", nil)];

                break;
                
            default:
                break;
        }
        if (i>=4) {
            [button setFrame:NSMakeRect(CategoryButtonFrontSpace+(CategoryButtonWidth + 10 + CategoryButtonSpace)*(i-4), self.frame.size.height - 86 - (CategoryButtonHeight + 10 +30) * 2, CategoryButtonWidth + 10, CategoryButtonHeight + 10)];
            [self addSubview:button];
        }else
        {
            [self addSubview:button];
        }
        i++;
        [button setTarget:self];
        [button setAction:@selector(clickCategory:)];
        [_allcategoryArr addObject:button];
        [button release];

    }
    
    //默认支持note
}

- (void)createAndroidCategorybutton
{
    _allcategoryArr = [[NSMutableArray alloc] init];
    NSArray *category = [NSArray arrayWithObjects:@(Category_Music),@(Category_Movies),@(Category_Ringtone),@(Category_Photo),@(Category_iBooks),@(Category_Contacts),@(Category_Message),@(Category_CallHistory),@(Category_Calendar),@(Category_Compressed),@(Category_Document),nil];
    int i=0;
    for (NSNumber *item in category) {
        IMBFunctionButton *button  = [[IMBFunctionButton alloc] initWithFrame:NSMakeRect(146+(CategoryButtonWidth + 46)*i + 30,self.frame.size.height - 86 - (CategoryButtonHeight +30), CategoryButtonWidth, CategoryButtonHeight)];
        button.isAndroid = YES;
        switch (item.intValue) {
            case Category_Music:
                button.tag = Category_Music;
                [button setImageWithImageName:@"toios_music" withButtonName:CustomLocalizedString(@"MenuItem_id_1", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"toios_navmusic"]];
                [button setSelectIcon:[StringHelper imageNamed:@"toios_selectmusic"]];
                [button setToolTip:CustomLocalizedString(@"MenuItem_id_1", nil)];
                break;
            case Category_Movies:
                button.tag = Category_Movies;
                [button setImageWithImageName:@"toios_movies" withButtonName:CustomLocalizedString(@"MenuItem_id_6", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"toios_navmovies"]];
                [button setSelectIcon:[StringHelper imageNamed:@"toios_selectmovies"]];
                [button setToolTip:CustomLocalizedString(@"MenuItem_id_6", nil)];
                break;
            case Category_Ringtone:
                button.tag = Category_Ringtone;
                [button setImageWithImageName:@"toios_ringtone" withButtonName:CustomLocalizedString(@"MenuItem_id_2", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"toios_navringtone"]];
                [button setSelectIcon:[StringHelper imageNamed:@"toios_selectringtone"]];
                [button setToolTip:CustomLocalizedString(@"MenuItem_id_2", nil)];
                break;
            case Category_Photo:
                button.tag = Category_Photo;
                [button setImageWithImageName:@"toios_photo" withButtonName:CustomLocalizedString(@"MenuItem_id_12", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"toios_navphoto"]];
                [button setSelectIcon:[StringHelper imageNamed:@"toios_selectphoto"]];
                [button setToolTip:CustomLocalizedString(@"MenuItem_id_12", nil)];
                break;
            case Category_iBooks:
                button.tag = Category_iBooks;
                [button setImageWithImageName:@"toios_books" withButtonName:CustomLocalizedString(@"MenuItem_id_13", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"toios_navbooks"]];
                [button setSelectIcon:[StringHelper imageNamed:@"toios_selectbooks"]];
                [button setToolTip:CustomLocalizedString(@"MenuItem_id_13", nil)];
                break;
            case Category_Contacts:
                button.tag = Category_Contacts;
                [button setImageWithImageName:@"toios_contact" withButtonName:CustomLocalizedString(@"MenuItem_id_20", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"toios_navcontact"]];
                [button setSelectIcon:[StringHelper imageNamed:@"toios_selectcontact"]];
                [button setToolTip:CustomLocalizedString(@"MenuItem_id_20", nil)];
                
                break;
            case Category_Message:
                button.tag = Category_Message;
                [button setImageWithImageName:@"toios_message" withButtonName:CustomLocalizedString(@"MenuItem_id_19", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"toios_navmessage"]];
                [button setSelectIcon:[StringHelper imageNamed:@"toios_selectmessage"]];
                [button setToolTip:CustomLocalizedString(@"MenuItem_id_19", nil)];
                
                break;
            case Category_CallHistory:
                button.tag = Category_CallHistory;
                [button setImageWithImageName:@"toios_callhistory" withButtonName:CustomLocalizedString(@"MenuItem_CallLog", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"toios_navcallhistory"]];
                [button setSelectIcon:[StringHelper imageNamed:@"toios_selectcallhistory"]];
                [button setToolTip:CustomLocalizedString(@"MenuItem_CallLog", nil)];
                
                break;
            case Category_Calendar:
                button.tag = Category_Calendar;
                [button setImageWithImageName:@"toios_calendar" withButtonName:CustomLocalizedString(@"MenuItem_id_22", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"toios_navcalendar"]];
                [button setSelectIcon:[StringHelper imageNamed:@"toios_selectcalendar"]];
                [button setToolTip:CustomLocalizedString(@"MenuItem_id_22", nil)];
                
                break;
            case Category_Compressed:
                button.tag = Category_Compressed;
                [button setImageWithImageName:@"toios_compress" withButtonName:CustomLocalizedString(@"MenuItem_id_87", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"toios_navcompress"]];
                [button setSelectIcon:[StringHelper imageNamed:@"toios_selectcompress"]];
                [button setToolTip:CustomLocalizedString(@"MenuItem_id_87", nil)];
                
                break;
            case Category_Document:
                button.tag = Category_Document;
                [button setImageWithImageName:@"toios_document" withButtonName:CustomLocalizedString(@"MenuItem_id_88", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"toios_navdocument"]];
                [button setSelectIcon:[StringHelper imageNamed:@"toios_selectdocument"]];
                [button setToolTip:CustomLocalizedString(@"MenuItem_id_88", nil)];
                
                break;
            default:
                break;
        }
        if (i>=6) {
            [button setFrame:NSMakeRect(146+(CategoryButtonWidth + 46)*(i-6) + 30, self.frame.size.height - 86 - (CategoryButtonHeight + 30) * 2, CategoryButtonWidth, CategoryButtonHeight)];
            [self addSubview:button];
        }else
        {
            [self addSubview:button];
        }
        i++;
        [button setTarget:self];
        [button setAction:@selector(clickCategory:)];
        [_allcategoryArr addObject:button];
        [button release];
        
    }
}

- (void)changeSkin:(NSNotification *)notification {
    [_transparentView setNeedsDisplay:YES];
    [_popUpView setNeedsDisplay:YES];
}

- (void)viewWillDraw
{
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:YES];
}

- (void)createSupportedCategorybutton
{
    self.categoryArr = [NSMutableArray array];
    self.allcategoryArr = [NSMutableArray array];
    _allBtnArr = [[NSMutableArray array] retain];
    NSMutableArray *categoryStrArr = [NSMutableArray array];
  
    if (_ipod.deviceInfo.isIOSDevice)
    {
        //如果是ios设备
        //先加上5中分类容器,在加上其他的category
        if ([self createAudioArrButtons]) {
            [categoryStrArr addObject:CustomLocalizedString(@"MenuItem_id_28", nil)];
        }
        if ([self createvideosArrButtons]) {
            [categoryStrArr addObject:CustomLocalizedString(@"MenuItem_id_33", nil)];
        }
        //进行photo是否支持判断
        if ([self createphotosArrButtons]) {
        
            [categoryStrArr addObject:CustomLocalizedString(@"MenuItem_id_9", nil)];
        
        }
        if ([self createsafraiArrButtons]) {
            [categoryStrArr addObject:CustomLocalizedString(@"MenuItem_id_38", nil)];
        
        }
        //加上storage和system的文件夹图标
        if ([self createSystemButtons]) {
             [categoryStrArr addObject:CustomLocalizedString(@"MenuItem_id_40", nil)];
        }
        //iOS设备默认支持system
        if ([_ipod.deviceInfo isSupportiBook]) {
            [categoryStrArr addObject:CustomLocalizedString(@"MenuItem_id_13", nil)];
        }
        // to do 进行是否支持判断
            [categoryStrArr addObject:CustomLocalizedString(@"MenuItem_id_14", nil)];//ios设备默认支持app
        if (_ipod.deviceInfo.isSupportPodcast) {
        
            [categoryStrArr addObject:CustomLocalizedString(@"MenuItem_id_15", nil)];
        }
        if (_ipod.deviceInfo.isSupportiTunesU) {
            [categoryStrArr addObject:CustomLocalizedString(@"MenuItem_id_16", nil)];
        }

        //进行支持判断,ios 11暂不支持notes
        if (![_ipod.deviceInfo.productVersion isVersionMajorEqual:@"11"]) {
            [categoryStrArr addObject:CustomLocalizedString(@"MenuItem_id_17",nil)];
        }
    
        if (_ipod.deviceInfo.isiPhone) {
            
            [categoryStrArr addObject:CustomLocalizedString(@"MenuItem_id_27",nil)];
            
        }
        if ([_ipod.deviceInfo getDeviceVersionNumber]>=4) {
            if (!(_ipod.deviceInfo.family == iPhone_3G ||_ipod.deviceInfo.family == iPhone_3GS)) {
                [categoryStrArr addObject:CustomLocalizedString(@"MenuItem_id_19",nil)];
            }
        }

        //iOS设备默认支持calendar iCloud
        [categoryStrArr addObjectsFromArray:@[CustomLocalizedString(@"MenuItem_id_20",nil),CustomLocalizedString(@"MenuItem_id_22",nil)]];
        for (int i = 0 ;i<[categoryStrArr count];i++) {
            NSString *categoryName = nil;
            IMBFunctionButton *button = nil;
            categoryName = [categoryStrArr objectAtIndex:i];
            button = [[IMBFunctionButton alloc] initWithFrame:NSMakeRect(147+(CategoryButtonWidth+32)*i,self.frame.size.height - 86 - (CategoryButtonHeight+30), CategoryButtonWidth, CategoryButtonHeight)];
            [_categoryArr addObject:button];
            [_allBtnArr addObject:button];
            if (i>=7) {
                [button setFrame:NSMakeRect(147+(CategoryButtonWidth+32)*(i-7), 0, CategoryButtonWidth, CategoryButtonHeight)];
                [containerView addSubview:button];
            }else {
                [self addSubview:button];
            }
        
            [button setTitle:categoryName];
            [button setTarget:self];
            [button setAction:@selector(clickCategory:)];
            
            if ([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_28", nil)]) {
                [button setImageWithImageName:@"btn_audionew" withButtonName:CustomLocalizedString(@"MenuItem_id_28", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_audio"]];
                button.isContainer = YES;     //此按钮是容器
                button.tag = 500;
                [_allcategoryArr addObjectsFromArray:_audioArr];
                [_allBtnArr addObjectsFromArray:_audioArr];
                
            }else if([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_33", nil)]){
                [button setImageWithImageName:@"btn_videosnew" withButtonName:CustomLocalizedString(@"MenuItem_id_33", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_video"]];
                button.isContainer = YES;     //此按钮是容器
                button.tag = 501;
                [_allcategoryArr addObjectsFromArray:_videosArr];
                [_allBtnArr addObjectsFromArray:_videosArr];
                
            }else if([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_9", nil)]){
                [button setImageWithImageName:@"btn_photosnew" withButtonName:CustomLocalizedString(@"MenuItem_id_9", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_photo"]];

                button.isContainer = YES;     //此按钮是容器
                button.tag = 502;
                [_allcategoryArr addObjectsFromArray:_photosArr];
                [_allBtnArr addObjectsFromArray:_photosArr];
            }else if([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_38", nil)]){
                
                [button setImageWithImageName:@"btn_safarinew" withButtonName:CustomLocalizedString(@"MenuItem_id_38", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_safari"]];

                button.isContainer = YES;     //此按钮是容器
                button.tag = 503;
                [_allcategoryArr addObjectsFromArray:_safraiArr];
                [_allBtnArr addObjectsFromArray:_safraiArr];

            }else if ([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_42", nil)])
            {
                [button setImageWithImageName:@"btn_tools" withButtonName:CustomLocalizedString(@"MenuItem_id_42", nil)];
                button.isContainer = YES;     //此按钮是容器
                button.tag = 504;
                //[_allcategoryArr addObjectsFromArray:_safraiArr];
                [_allBtnArr addObjectsFromArray:_toolsArr];
//                [_allBtnArr addObject:button];
            
            }else if ([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_40", nil)])
            {
                [button setImageWithImageName:@"nav_system_folder" withButtonName:CustomLocalizedString(@"MenuItem_id_40", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_filesystem"]];

                button.isContainer = YES;     //此按钮是容器
                button.tag = 505;
                [_allcategoryArr addObjectsFromArray:_systemArr];
                [_allBtnArr addObjectsFromArray:_systemArr];
                
            }
            else if([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_13", nil)]){
                [_allcategoryArr addObject:button];
                button.tag = Category_iBooks;
                [button setImageWithImageName:@"btn_ibooknew" withButtonName:CustomLocalizedString(@"MenuItem_id_13", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_books"]];
                [button setSelectIcon:[StringHelper imageNamed:@"select_book"]];

            }else if ([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_14", nil)]) {
                [_allcategoryArr addObject:button];
                button.tag = Category_Applications;
                [button setImageWithImageName:@"btn_appsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_14", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_apps"]];
                [button setSelectIcon:[StringHelper imageNamed:@"select_app"]];
            }else if ([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_15", nil)]) {
                [_allcategoryArr addObject:button];
                button.tag = Category_PodCasts;
                [button setImageWithImageName:@"btn_podcastsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_15", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_podcasts"]];
                [button setSelectIcon:[StringHelper imageNamed:@"select_podcasts"]];

                
            }else if ([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_16", nil)]) {
                [_allcategoryArr addObject:button];
                button.tag = Category_iTunesU;
                [button setImageWithImageName:@"btn_itunesunew" withButtonName:CustomLocalizedString(@"MenuItem_id_16", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_itunesU"]];
                [button setSelectIcon:[StringHelper imageNamed:@"select_iTunesU"]];

                
            }else if ([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_17", nil)]) {
               
                [_allcategoryArr addObject:button];
                //默认支持note
                button.tag = Category_Notes;
                [button setImageWithImageName:@"btn_notenew" withButtonName:CustomLocalizedString(@"MenuItem_id_17", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_notes"]];
                [button setSelectIcon:[StringHelper imageNamed:@"select_note"]];


            }else if ([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_27", nil)])
            {   [_allcategoryArr addObject:button];
                button.tag = Category_Voicemail;
                [button setImageWithImageName:@"btn_voicemailnew" withButtonName:CustomLocalizedString(@"MenuItem_id_27", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_voicemail"]];
                [button setSelectIcon:[StringHelper imageNamed:@"select_voiceMail"]];


            }else if ([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_19", nil)]) {
                //ios4.0以下不支持
                [_allcategoryArr addObject:button];
                button.tag = Category_Message;
                [button setImageWithImageName:@"btn_messagenew" withButtonName:CustomLocalizedString(@"MenuItem_id_19", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_message"]];
                [button setSelectIcon:[StringHelper imageNamed:@"select_message"]];
                
            }else if ([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_20", nil)]) {
                //默认支持contact
                [_allcategoryArr addObject:button];
                button.tag = Category_Contacts;
                [button setImageWithImageName:@"btn_contactsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_20", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_contact"]];
                [button setSelectIcon:[StringHelper imageNamed:@"select_contact"]];


            }else if ([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_22", nil)]) {
                //默认支持calendar
                [_allcategoryArr addObject:button];
                button.tag = Category_Calendar;
                [button setImageWithImageName:@"btn_calendarnew" withButtonName:CustomLocalizedString(@"MenuItem_id_22", nil)];
                [button setNavagationIcon:[StringHelper imageNamed:@"nav_calendar"]];
                [button setSelectIcon:[StringHelper imageNamed:@"select_calendar"]];

            }
        }
    }else
    {
        //如果是ipod设备
        self.allcategoryArr = [NSMutableArray array];
        if ([_ipod.deviceInfo isSupportMusic]) {
            //支持music
            IMBFunctionButton *musicBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [musicBtn setEnabled:YES];
            [musicBtn setImageWithImageName:@"btn_musicnew" withButtonName:CustomLocalizedString(@"MenuItem_id_1", nil)];
            [musicBtn setNavagationIcon:[StringHelper imageNamed:@"nav_audio_music"]];
            [musicBtn setSelectIcon:[StringHelper imageNamed:@"select_audio_music"]];
            musicBtn.tag = (int)Category_Music;
            [musicBtn setTarget:self];
            [musicBtn setAction:@selector(clickCategory:)];
            [_allcategoryArr addObject:musicBtn];
            
        }
        if([_ipod.deviceInfo isSupportAudioBook])
        {
            //支持Audio Books
            IMBFunctionButton *abBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [abBtn setImageWithImageName:@"btn_audio_booksnew" withButtonName:CustomLocalizedString(@"MenuItem_id_3", nil)];
            [abBtn setNavagationIcon:[StringHelper imageNamed:@"nav_audio_audiobook"]];
            [abBtn setSelectIcon:[StringHelper imageNamed:@"select_audio_book"]];
            [abBtn sizeToFit];
             abBtn.tag = (int)Category_Audiobook;
            [abBtn setTarget:self];
            [abBtn setAction:@selector(clickCategory:)];
            [_allcategoryArr addObject:abBtn];
        }
        
        if (_ipod.deviceInfo.isSupportPodcast) {
            //支持Audio Books
            IMBFunctionButton *podcastBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [podcastBtn setImageWithImageName:@"btn_podcastsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_15", nil)];
            [podcastBtn setNavagationIcon:[StringHelper imageNamed:@"nav_podcasts"]];
            [podcastBtn setSelectIcon:[StringHelper imageNamed:@"select_podcasts"]];
            [podcastBtn sizeToFit];
            podcastBtn.tag = (int)Category_PodCasts;
            [podcastBtn setTarget:self];
            [podcastBtn setAction:@selector(clickCategory:)];
            [_allcategoryArr addObject:podcastBtn];
        }
        if (_ipod.deviceInfo.isSupportiTunesU) {
            //支持Audio Books
            IMBFunctionButton *itunesuBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [itunesuBtn setImageWithImageName:@"btn_itunesunew" withButtonName:CustomLocalizedString(@"MenuItem_id_16", nil)];
            [itunesuBtn setNavagationIcon:[StringHelper imageNamed:@"nav_itunesU"]];
            [itunesuBtn setSelectIcon:[StringHelper imageNamed:@"select_iTunesU"]];
            [itunesuBtn sizeToFit];
            itunesuBtn.tag = (int)Category_iTunesU;
            [itunesuBtn setTarget:self];
            [itunesuBtn setAction:@selector(clickCategory:)];
            [_allcategoryArr addObject:itunesuBtn];
        }
        if ([_ipod.deviceInfo isSupportMovie]) {
            //支持movies
            IMBFunctionButton *movieBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [movieBtn setEnabled:YES];
            [movieBtn setImageWithImageName:@"btn_moviesnew" withButtonName:CustomLocalizedString(@"MenuItem_id_6", nil)];
            [movieBtn setNavagationIcon:[StringHelper imageNamed:@"nav_video_movies"]];
            [movieBtn setSelectIcon:[StringHelper imageNamed:@"select_video_movies"]];
            [movieBtn sizeToFit];
            movieBtn.tag = (int)Category_Movies;
            [movieBtn setTarget:self];
            [movieBtn setAction:@selector(clickCategory:)];
            [_allcategoryArr addObject:movieBtn];
        }
        if ([_ipod.deviceInfo isSupportTVShow]) {
            
            //支持tvshow
            IMBFunctionButton *tvshowBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [tvshowBtn setEnabled:YES];
            [tvshowBtn setImageWithImageName:@"btn_tv_showsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_7", nil)];
            [tvshowBtn setNavagationIcon:[StringHelper imageNamed:@"nav_video_tvshow"]];
            [tvshowBtn setSelectIcon:[StringHelper imageNamed:@"select_video_tvshow"]];
            [tvshowBtn sizeToFit];
            tvshowBtn.tag = (int)Category_TVShow;
            [tvshowBtn setTarget:self];
            [tvshowBtn setAction:@selector(clickCategory:)];
            [_allcategoryArr addObject:tvshowBtn];
        }
        if ([_ipod.deviceInfo isSupportMV]) {
            //支持musicvideo
            IMBFunctionButton *musicVBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [musicVBtn setEnabled:YES];
            [musicVBtn setImageWithImageName:@"btn_music_videosnew" withButtonName:CustomLocalizedString(@"MenuItem_id_8", nil)];
            [musicVBtn setNavagationIcon:[StringHelper imageNamed:@"nav_video_musicvideo"]];
            [musicVBtn setSelectIcon:[StringHelper imageNamed:@"select_video_musicvideo"]];
            [musicVBtn sizeToFit];
            musicVBtn.tag = (int)Category_MusicVideo;
            [musicVBtn setTarget:self];
            [musicVBtn setAction:@selector(clickCategory:)];
            [_allcategoryArr addObject:musicVBtn];
            
            
        }
        IMBFunctionButton *plBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
        //默认支持playlist
        [plBtn setImageWithImageName:@"btn_playlistsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_4", nil)];
        [plBtn setNavagationIcon:[StringHelper imageNamed:@"nav_audio_playlist"]];
        [plBtn setSelectIcon:[StringHelper imageNamed:@"select_audio_playlist"]];
        [plBtn sizeToFit];
        plBtn.tag = (int)Category_Playlist;
        [plBtn setTarget:self];
        [plBtn setAction:@selector(clickCategory:)];
        [_allcategoryArr addObject:plBtn];
        
        
        if (_allcategoryArr.count <= 10) {
            int initOx = 147;
            if (_allcategoryArr.count < 6) {
                initOx = ((CategoryButtonWidth+32+22) / 2) * (6 - (int)_allcategoryArr.count) + 147;
            }
            for (int i = 0;i<[_allcategoryArr count]; i++) {
                IMBFunctionButton *button = [_allcategoryArr objectAtIndex:i];
                if (i>=6) {
                    [button setFrame:NSMakeRect(initOx+(CategoryButtonWidth+32+22)*(i-6), 0, CategoryButtonWidth, CategoryButtonHeight)];
                    [containerView addSubview:button];
                }else
                {
                    [button setFrame:NSMakeRect(initOx+(CategoryButtonWidth+32+22)*i,self.frame.size.height - 86 - (CategoryButtonHeight+30), CategoryButtonWidth, CategoryButtonHeight)];
                    [self addSubview:button];
                }
                [_allBtnArr addObject:button];
                [button release];
            }
        }else {
            for (int i = 0;i<[_allcategoryArr count]; i++) {
                IMBFunctionButton *button = [_allcategoryArr objectAtIndex:i];
                if (i>=7) {
                    [button setFrame:NSMakeRect(147+(CategoryButtonWidth+32)*(i-7), 0, CategoryButtonWidth, CategoryButtonHeight)];
                    [containerView addSubview:button];
                }else
                {
                    [button setFrame:NSMakeRect(147+(CategoryButtonWidth+32)*i,self.frame.size.height - 86 - (CategoryButtonHeight+30), CategoryButtonWidth, CategoryButtonHeight)];
                    [self addSubview:button];
                }
            }
        }
         self.categoryArr = _allcategoryArr;
    }
}

//加载除开media video等等其他数据
- (void)loadothersData:(dispatch_queue_t)queue
{
    IMBInformationManager *manager= [IMBInformationManager shareInstance];
    IMBInformation *information = [manager.informationDic objectForKey:_ipod.uniqueKey];
    if (_ipod.deviceInfo.isIOSDevice) {
        NSMutableArray *currentOpenContainerArray = nil;
        IMBFunctionButton *audioButton = nil;
        IMBFunctionButton *videoButton = nil;
        IMBFunctionButton *podcastsButton = nil;
        IMBFunctionButton *itunesUButton = nil;
        for (IMBFunctionButton *button in _allBtnArr) {
            if (button.isContainer) {
                NSString *categoryName = button.title;
                if ([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_28", nil)]) {
                    [button addLoadingView];
                    audioButton = button;
                    if ([currentButton.title isEqualToString:CustomLocalizedString(@"MenuItem_id_28", nil)]) {
                        for (IMBFunctionButton *button in _audioArr) {
                            [button addLoadingView];
                        }
                    }
                }else if([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_33", nil)]){
                    [button addLoadingView];
                    videoButton = button;
                    if ([currentButton.title isEqualToString:CustomLocalizedString(@"MenuItem_id_33", nil)])
                    {
                        for (IMBFunctionButton *button in _videosArr) {
                            [button addLoadingView];
                        }
                        
                        currentOpenContainerArray = _videosArr;
                    }
                }
            }else{
                if (button.tag == Category_PodCasts) {
                    [button addLoadingView];
                    podcastsButton = button;
                }else if (button.tag == Category_iTunesU)
                {
                    [button addLoadingView];
                    itunesUButton = button;
                }
                button.badgeCount = 0;
            }
        }
        //刷新media，video内存数据
        dispatch_async(queue, ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [audioButton showloading:YES];
                [videoButton showloading:YES];
                [podcastsButton showloading:YES];
                [itunesUButton showloading:YES];
            });
            [_ipod startSync];
            [information refreshMedia];
            [information refreshCloudMusic];
            [information recording];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                //关闭loading
                [audioButton showloading:NO];
                [videoButton showloading:NO];
                [podcastsButton showloading:NO];
                [itunesUButton showloading:NO];
                podcastsButton.badgeCount = [[information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_PodCasts]] count];
                itunesUButton.badgeCount = [[information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_iTunesU]] count];
                for (IMBFunctionButton *button in currentOpenContainerArray) {
                    if (button.tag != Category_PhotoVideo&&button.tag != Category_TimeLapse&&button.tag != Category_SlowMove) {
                        [button showloading:NO];
                    }
                }
                //刷新media video按钮的badgecount
                for (IMBFunctionButton *button in _audioArr) {
                    if (button.tag == Category_Music) {
                        button.badgeCount = [[information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_Music]] count];
                    }else if (button.tag == Category_CloudMusic)
                    {
                        int cloudMusicbadgeCount = (int)[[information cloudTrackArray] count];
                        button.badgeCount = cloudMusicbadgeCount;
                        
                    }else if (button.tag == Category_Ringtone)
                    {
                        button.badgeCount = [[information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_Ringtone]] count];
                        
                    }else if (button.tag == Category_Audiobook)
                    {
                        button.badgeCount = [[information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_Audiobook]] count];
                        
                    }else if (button.tag == Category_VoiceMemos)
                    {
                        button.badgeCount = [[[information recording] recordingArray] count];
                        
                    }else if (button.tag == Category_Playlist)
                    {
                        button.badgeCount = [information.playlists.playlistArray count];
                        
                    }
                }
                for (IMBFunctionButton *button in _videosArr)
                {
                    if (button.tag == Category_Movies) {
                        button.badgeCount = [[information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_Movies]] count];
                    }else if (button.tag == Category_TVShow)
                    {
                        button.badgeCount = [[information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_TVShow]] count];
                        
                    }else if (button.tag == Category_MusicVideo)
                    {
                        button.badgeCount = [[information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_MusicVideo]] count];
                        
                    }else if (button.tag == Category_HomeVideo)
                    {
                        button.badgeCount = [[information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_HomeVideo]] count];
                        
                    }
                }
            });
            [_ipod endSync];
        });
        
        for(IMBFunctionButton *button in _categoryArr) {
            if (button.isContainer) {
                NSString *categoryName = button.title;
                if([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_9", nil)]){
                    [button addLoadingView];
                    for (IMBFunctionButton *photoButton in _photosArr) {
                        [photoButton addLoadingView];
                    }
                    for (IMBFunctionButton *vButton in _videosArr) {
                        if (vButton.tag == Category_PhotoVideo)
                        {
                            [vButton addLoadingView];
                        }else if (vButton.tag == Category_TimeLapse)
                        {
                            [vButton addLoadingView];
                        }else if (vButton.tag == Category_SlowMove)
                        {
                            [vButton addLoadingView];
                        }
                    }
                    dispatch_async(queue,^{
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [button showloading:YES];
                            for (IMBFunctionButton *photoButton in _photosArr) {
                                [photoButton showloading:YES];
                            }
                            for (IMBFunctionButton *vButton in _videosArr) {
                                if (vButton.tag == Category_PhotoVideo)
                                {
                                    [vButton showloading:YES];
                                }else if (vButton.tag == Category_TimeLapse)
                                {
                                    [vButton showloading:YES];
                                }else if (vButton.tag == Category_SlowMove)
                                {
                                    [vButton showloading:YES];
                                }
                            }
                        });
                        
                        @autoreleasepool {
                            [[IMBLogManager singleton] writeInfoLog:@"load photo start"];
                            [information loadphotoData];
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [[IMBLogManager singleton] writeInfoLog:@"load photo end"];
                                for (IMBFunctionButton *photoButton in _photosArr) {
                                    if (photoButton.tag == Category_CameraRoll) {
                                        photoButton.badgeCount = [[information camerarollArray] count];
                                    }else if (photoButton.tag == Category_PhotoStream) {
                                        photoButton.badgeCount = [[information photostreamArray] count];
                                    }else if (photoButton.tag == Category_PhotoLibrary) {
                                        photoButton.badgeCount = [[information photolibraryArray] count];
                                    }else if (photoButton.tag == Category_MyAlbums) {
                                        photoButton.badgeCount = [[information myAlbumsArray] count];
                                    }else if (photoButton.tag == Category_PhotoShare)
                                    {
                                        photoButton.badgeCount = [[information photoshareArray] count];
                                    }else if (photoButton.tag == Category_Panoramas)
                                    {
                                        photoButton.badgeCount = [[information panoramasArray] count];
                                        
                                    }else if (photoButton.tag == Category_ContinuousShooting)
                                    {
                                        photoButton.badgeCount = [[information continuousShootingArray] count];
                                    }else if (photoButton.tag == Category_LivePhoto)
                                    {
                                        photoButton.badgeCount = [[information livePhotoArray] count];
                                    }else if (photoButton.tag == Category_PhotoSelfies)
                                    {
                                        photoButton.badgeCount = [[information photoSelfiesArray] count];
                                    }else if (photoButton.tag == Category_Screenshot)
                                    {
                                        photoButton.badgeCount = [[information screenshotArray] count];
                                    }else if (photoButton.tag == Category_Location)
                                    {
                                        photoButton.badgeCount = [[information locationArray] count];
                                    }else if (photoButton.tag == Category_Favorite)
                                    {
                                        photoButton.badgeCount = [[information favoriteArray] count];
                                    }
                                    [photoButton showloading:NO];
                                }
                                
                                for (IMBFunctionButton *vButton in _videosArr) {
                                    if (vButton.tag == Category_PhotoVideo)
                                    {
                                        [vButton showloading:NO];
                                        vButton.badgeCount = [[information photovideoArray] count];
                                    }else if (vButton.tag == Category_TimeLapse)
                                    {
                                        [vButton showloading:NO];
                                        vButton.badgeCount = [[information timelapseArray] count];
                                        
                                    }else if (vButton.tag == Category_SlowMove)
                                    {
                                        [vButton showloading:NO];
                                        vButton.badgeCount = [[information slowMoveArray] count];
                                        
                                    }
                                }
                                [button showloading:NO];
                                if (currentButton == button) {
                                    for (IMBFunctionButton *photoButton in _photosArr) {
                                        
                                        [photoButton showloading:NO];
                                    }
                                    
                                }
                                
                            });
                        }
                    });
                    
                }else if([categoryName isEqualToString:CustomLocalizedString(@"MenuItem_id_38", nil)]){
                    
                    [button addLoadingView];
                    int i = 0;
                    for (IMBFunctionButton *safariBtn in _safraiArr) {
                        i ++;
                        if (safariBtn.tag == Category_Bookmarks) {
                            [safariBtn setOpeniCloud:NO];//刷新是去掉icloud图标
                            [safariBtn addLoadingView];
                            dispatch_async(queue,^{
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    [safariBtn showloading:YES];
                                    if (i == 1) {
                                        [button showloading:YES];
                                    }
                                });
                                
                                @autoreleasepool {
                                    [[IMBLogManager singleton] writeInfoLog:@"load bookmark start"];
                                    [information loadBookmark];
                                    
                                    dispatch_sync(dispatch_get_main_queue(), ^{
                                        [[IMBLogManager singleton] writeInfoLog:@"load bookmark end"];
                                        safariBtn.badgeCount = [[information bookmarkArray] count];
                                        if (![self checkItemsValidWithIPod:@"Bookmarks" ]&&safariBtn.badgeCount == 0){
                                            [safariBtn setOpeniCloud:YES];
                                        }
                                        [safariBtn showloading:NO];
                                        if (_safraiArr.count == i) {
                                            [button showloading:NO];
                                        }
                                    });
                                }
                            });
                        }else if (safariBtn.tag == Category_SafariHistory) {
                            [safariBtn addLoadingView];
                            dispatch_async(queue,^{
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    [safariBtn showloading:YES];
                                    if (i == 1) {
                                        [button showloading:YES];
                                    }
                                });
                                @autoreleasepool {
                                    [[IMBLogManager singleton] writeInfoLog:@"load History start"];
                                    [information loadSafariHistory:YES];
                                    dispatch_sync(dispatch_get_main_queue(), ^{
                                        [[IMBLogManager singleton] writeInfoLog:@"load history end"];
                                        safariBtn.badgeCount = [[information safariHistoryArray] count];
                                        [safariBtn showloading:NO];
                                        if (_safraiArr.count == i) {
                                            [button showloading:NO];
                                        }
                                    });
                                }
                            });
                        }
                    }
                }
            }else
            {
                if (button.tag == Category_iBooks) {
                    
                    [button addLoadingView];
                    dispatch_async(queue,^{
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [button showloading:YES];
                        });
                        @autoreleasepool {
                            [[IMBLogManager singleton] writeInfoLog:@"load ibook start"];
                            [information loadiBook];
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [[IMBLogManager singleton] writeInfoLog:@"load ibook end"];
                                button.badgeCount = [[information allBooksArray] count];
                                [button showloading:NO];
                            });
                        }
                    });
                    
                }else if(button.tag == Category_Applications)
                {
                    [button addLoadingView];
                    
                    dispatch_async(queue,^{
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [button showloading:YES];
                        });
                        
                        [[IMBLogManager singleton] writeInfoLog:@"load app start"];
                        @autoreleasepool {
                            if (information.applicationManager != nil) {
                                [information.applicationManager loadAppArray];
                            }
                            
                            if (_reloadBlock != nil) {
                                _reloadBlock();
                            }
                            
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [[IMBLogManager singleton] writeInfoLog:@"load app end"];
                                button.badgeCount = information.applicationManager.appEntityArray.count;
                                [button showloading:NO];
                            });
                            
                        }
                    });
                }else if(button.tag == Category_Notes)
                {
                    //开起一个线程加载note数据
                    [button setOpeniCloud:NO];
                    [button addLoadingView];
                    dispatch_async(queue,^{
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [button showloading:YES];
                        });
                        @autoreleasepool {
                            [[IMBLogManager singleton] writeInfoLog:@"load note start"];
                            [information loadNote];
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [[IMBLogManager singleton] writeInfoLog:@"load note end"];
                                button.badgeCount = [[information noteArray] count];
                                [button showloading:NO];
                                if (![self checkItemsValidWithIPod:@"Notes"]&&button.badgeCount == 0) {
                                    [button setOpeniCloud:YES];
                                }
                                
                            });
                        }
                    });
                }else if(button.tag == Category_Message)
                {
                    //开起一个线程加载note数据
                    [button addLoadingView];
                    dispatch_async(queue,^{
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [button showloading:YES];
                        });
                        @autoreleasepool {
                            [[IMBLogManager singleton] writeInfoLog:@"load message start"];
                            [information loadMessage:YES];
                            float count = 0;
                            for (IMBSMSChatDataEntity *entity in information.messageArray) {
                                count += entity.msgModelList.count;
                            }
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [[IMBLogManager singleton] writeInfoLog:@"load message end"];
                                button.badgeCount = count;
                                [button showloading:NO];
                            });
                        }
                    });
                    
                }else if(button.tag == Category_Voicemail)
                {
                    [button addLoadingView];
                    dispatch_async(queue,^{
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [button showloading:YES];
                        });
                        @autoreleasepool {
                            [[IMBLogManager singleton] writeInfoLog:@"load voicemail start"];
                            [information loadVoicemail:YES];
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [[IMBLogManager singleton] writeInfoLog:@"load voicemail end"];
                                for (IMBVoiceMailAccountEntity *entity in [information voicemailArray]) {
                                    button.badgeCount += entity.subArray.count;
                                }
                                [button showloading:NO];
                                
                            });
                        }
                    });
                }
                else if(button.tag == Category_Contacts)
                {
                    [button setOpeniCloud:NO];
                    [button addLoadingView];
                    dispatch_async(queue,^{
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [button showloading:YES];
                        });
                        @autoreleasepool {
                            [[IMBLogManager singleton] writeInfoLog:@"load contact start"];
                            [information loadContact];
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [[IMBLogManager singleton] writeInfoLog:@"load contact end"];
                                button.badgeCount = [[information contactArray] count];
                                [button showloading:NO];
                                //检测icloud是否开启
                                if (![self checkItemsValidWithIPod:@"Contacts"]&&button.badgeCount == 0) {
                                    [button setOpeniCloud:YES];
                                }
                            });
                        }
                    });
                    
                }else if (button.tag == Category_Calendar)
                {
                    [button setOpeniCloud:NO];
                    [button addLoadingView];
                    dispatch_async(queue,^{
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [button showloading:YES];
                            [systemButton showloading:YES];
                        });
                        @autoreleasepool {
                            [[IMBLogManager singleton] writeInfoLog:@"load calendar start"];
                            [information loadCalendar];
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                _ipod.infoLoadFinished = YES;
                                [[IMBLogManager singleton] writeInfoLog:@"load calendar end"];
                                NSInteger calendarCount = 0;
                                NSMutableArray *calendarArr = [information calendarArray];
                                for (IMBCalendarEntity *collectionEntity in calendarArr) {
                                    calendarCount += collectionEntity.eventCalendatArray.count;
                                }
                                button.badgeCount = calendarCount;
                                [button showloading:NO];
                                [systemButton showloading:NO];
                                if (![self checkItemsValidWithIPod:@"Calendars"]&&button.badgeCount == 0) {
                                    [button setOpeniCloud:YES];
                                }
                            });
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_INFORMATIONDATA_LOADFINISH object:_ipod];
                        }
                    });
                }else if (button.tag == Category_System)
                {
                    [button addLoadingView];
//                    [button showloading:YES];
                    systemButton = button;
                }
            }
        }
    }else {
        for (IMBFunctionButton *button in _allBtnArr) {
            button.badgeCount = 0;
            [button addLoadingView];
        }
        dispatch_async(queue, ^{
            for (IMBFunctionButton *button in _allBtnArr) {
                [button showloading:YES];
            }
            [_ipod startSync];
            [information refreshMedia];
            
            int musicbadgeCount = (int)[[information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_Music]] count];
            int podCastsbadgeCount = (int)[[information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_PodCasts]] count];
            int audiobookbadgeCount = (int)[[information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_Audiobook]] count];
            int iTunesUbadgeCount = (int)[[information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_iTunesU]] count];
            int moviesbadgeCount = (int)[[information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_Movies]] count];
            int tvshowbadgeCount = (int)[[information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_TVShow]] count];
            int musicVideobadgeCount = (int)[[information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_MusicVideo]] count];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                for (IMBFunctionButton *button in _allBtnArr) {
                    [button showloading:NO];
                    if (button.tag == Category_Music)
                    {
                        button.badgeCount = musicbadgeCount;
                    }else if (button.tag == Category_PodCasts)
                    {
                        button.badgeCount = podCastsbadgeCount;
                        
                    }else if (button.tag == Category_Audiobook)
                    {
                        button.badgeCount = audiobookbadgeCount;
                        
                    }else if (button.tag == Category_iTunesU)
                    {
                        button.badgeCount = iTunesUbadgeCount;

                    }else if (button.tag == Category_Playlist)
                    {
                        button.badgeCount = [information.playlists.playlistArray count];
                    }if (button.tag == Category_Movies)
                    {
                        button.badgeCount = moviesbadgeCount;
                    }else if (button.tag == Category_TVShow)
                    {
                        button.badgeCount = tvshowbadgeCount;
                        
                    }else if (button.tag == Category_MusicVideo)
                    {
                        button.badgeCount = musicVideobadgeCount;
                    }
                }
                _ipod.infoLoadFinished = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_INFORMATIONDATA_LOADFINISH object:_ipod];
            });
            [_ipod endSync];
        });
    }
}

- (void)notificationViewChanged:(NSNotification *)notify
{
    NSPoint point = [self convertPoint:currentButton.frame.origin toView:_transparentView];
    _popUpView.startPoint = point.x + currentButton.frame.size.width/2;
}

//所有category响应的事件
- (void)clickCategory:(IMBFunctionButton *)sender
{
//    if (_isDownBtn) {
//        _isremovePopView = YES;
//    }else{
//        _isremovePopView = NO;
//    }
    if (_popUpView == nil) {
        _popUpView = [[IMBPopupView alloc] initWithFrame:NSMakeRect(0, 66, self.window.frame.size.width+6,ArrowSize)];
        _popUpView.categoryBarView = self;
        [_popUpView setAutoresizesSubviews:YES];
        [_popUpView setAutoresizingMask:NSViewWidthSizable];
    }else {
        [_popUpView setFrameSize:NSMakeSize(self.window.frame.size.width+6, _popUpView.frame.size.height)];
    }
    //向popUpView上添加按钮之前，先移除之前的subview
    //如果按钮是容器可以扩展的
    IMBSoftWareInfo *software = [IMBSoftWareInfo singleton];
    if (sender.isContainer) {
        NSInteger tags = (NSInteger)sender.tag;
        if (tags == 500) {
            [software setSelectModular:@"Audio"];
        }else if (tags == 501) {
            [software setSelectModular:@"Videos"];
        }else if (tags == 502) {
            [software setSelectModular:@"Photos"];
        }else if (tags == 503) {
            [software setSelectModular:@"Safari"];
        }else if (tags == 505) {
            [software setSelectModular:@"File System"];
        }
        
        NSPoint point = sender.frame.origin;//[self convertPoint:sender.frame.origin toView:_transparentView];
        _popUpView.startPoint = point.x + sender.frame.size.width/2;
       
        [self reloadPopupViewButtons:sender];
      
//        if (_isremovePopView) {
//            _isDownBtn = YES;
//            _isTwo = YES;
//            [_popUpView setIsTwoBtn:YES];
//        }else {
//            if (_isTwo) {
//                _isDownBtn = YES;
//            }else{
//                _isDownBtn = NO;
//            }
            [_popUpView setIsTwoBtn:_isTwo];
//        }
        NSView *mainView = [self superview];
        if (![_transparentView superview]) {
            if (_isTwo) {
                _transparentView = [[IMBTransparentView alloc] initWithFrame:NSMakeRect(-3, 40, _popUpView.frame.size.width, 216 + 108)];
            }else {
                _transparentView = [[IMBTransparentView alloc] initWithFrame:NSMakeRect(-3, 148, _popUpView.frame.size.width, 216)];
            }
            [_transparentView setAutoresizesSubviews:YES];
            [_transparentView setAutoresizingMask:NSViewWidthSizable];
            _transparentView.alphaValue = 1.0;
            _popUpView.containerView = containerView;
        }
        else {
            if (_isTwo) {
                [_transparentView setFrame:NSMakeRect(-3, 40, _popUpView.frame.size.width, 216 + 108)];
                if (_popUpView.frame.size.height == 147) {
                      [_popUpView setFrameSize:NSMakeSize(self.window.frame.size.width+6, 147*2)];
                }
            }else {
                [_transparentView setFrame:NSMakeRect(-3, 148, _popUpView.frame.size.width, 216)];
                [_popUpView setFrameSize:NSMakeSize(self.window.frame.size.width+6, 147)];
            }
        }
        if (![_popUpView superview]) {
            [_transparentView addSubview:_popUpView];
        }
        if (![_transparentView superview]) {
            [mainView addSubview:_transparentView];
        }
        [_popUpView setNeedsDisplay:YES];
        if (_popUpView.frame.size.height <= ArrowSize) {
            //将要展开
            for (IMBFunctionButton *button in _categoryArr) {
                if (button != sender) {
                    button.containerOpened = YES;
                }
            }
            if (_catagoryBlock != nil) {
                _catagoryBlock(300,sender);
            }
            
        }else{
            //将要关闭
            if (currentButton == sender) {
                for (IMBFunctionButton *button in _categoryArr) {
                    button.containerOpened = NO;
                }
                if (_catagoryBlock != nil) {
                    _catagoryBlock(301,sender);
                }
            }else{
                for (IMBFunctionButton *button in _categoryArr) {
                    if (button != sender) {
                        button.containerOpened = YES;
                    }
                }
                sender.containerOpened = NO;
            }
        }
        //执行弹出动画
        [self animation:sender];
    }else
    {
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        NSInteger tags = (NSInteger)sender.tag;
        if (tags == 9) {
            [software setSelectModular:@"Books"];
        }else if (tags == 18) {
            [software setSelectModular:@"Apps"];
        }else if (tags == 19) {
            [software setSelectModular:@"Podcasts"];
        }else if (tags == 20) {
            [software setSelectModular:@"iTunes U"];
        }else if (tags == 21) {
            [software setSelectModular:@"Notes"];
        }else if (tags == 33) {
            [software setSelectModular:@"Voice Mail"];
        }else if (tags == 23) {
            [software setSelectModular:@"Messages"];
        }else if (tags == 24) {
            [software setSelectModular:@"Contacts"];
        }else if (tags == 26) {
            [software setSelectModular:@"Calendars"];
        }
        
        //按钮不能扩展
        CategoryNodesEnum category = (CategoryNodesEnum)sender.tag;

        if (_catagoryBlock != nil) {
            
            if ([_transparentView superview]) {
                _catagoryBlock(category,sender);
                
            }else
            {
                _catagoryBlock(category,sender);
            }
        }
    }
}

- (void)animation:(IMBFunctionButton *)sender
{
    if (_popUpView.frame.size.height <= ArrowSize) {
        
        //属性字典
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //设置目标对象
        [dict setObject:_popUpView forKey:NSViewAnimationTargetKey];
        //设置其实大小
        [dict setObject:[NSValue valueWithRect:NSMakeRect(0,  _popUpView.frame.origin.y, _popUpView.frame.size.width, 1)] forKey:NSViewAnimationStartFrameKey];
        //设置最终大小
        if (_isTwo) {
            [dict setObject:[NSValue valueWithRect:NSMakeRect(0,  _popUpView.frame.origin.y , _popUpView.frame.size.width, PopUpViewHeight * 2 )] forKey:NSViewAnimationEndFrameKey];
        }else {
            [dict setObject:[NSValue valueWithRect:NSMakeRect(0,  _popUpView.frame.origin.y , _popUpView.frame.size.width, PopUpViewHeight)] forKey:NSViewAnimationEndFrameKey];
        }
        //属性字典
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        //设置目标对象
        [dict1 setObject:containerView forKey:NSViewAnimationTargetKey];
        //设置其实大小
        [dict1 setObject:[NSValue valueWithRect:NSMakeRect(0, containerView.frame.origin.y, containerView.frame.size.width, containerView.frame.size.height)] forKey:NSViewAnimationStartFrameKey];
        //设置最终大小
        if (_isTwo) {
            [dict1 setObject:[NSValue valueWithRect:NSMakeRect(0,  containerView.frame.origin.y -  PopUpViewHeight * 2, containerView.frame.size.width, containerView.frame.size.height)] forKey:NSViewAnimationEndFrameKey];
        }else {
            [dict1 setObject:[NSValue valueWithRect:NSMakeRect(0,  containerView.frame.origin.y -  PopUpViewHeight, containerView.frame.size.width, containerView.frame.size.height)] forKey:NSViewAnimationEndFrameKey];
        }
        //设置动画效果
        //[dict setObject:NSViewAnimationFadeOutEffect forKey:NSViewAnimationEffectKey];
        
        //设置动画
        NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:dict,nil]];
        animation.delegate = self;
        [animation setDuration:0.2];
        //启动动画
        [animation startAnimation];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [containerView setHidden:YES];
        });
        
        
    }else
    {
        
        [containerView setHidden:NO];
        if (!sender.isContainer) {
            [_popUpView animation:_isTwo];
            [self performSelector:@selector(removePopUpAndTransView) withObject:nil afterDelay:0.3];
            
        }else
        {
            if (currentButton == sender) {
                [_popUpView animation:_isTwo];
                [self performSelector:@selector(removePopUpAndTransView) withObject:nil afterDelay:0.3];
                
            }else
            {
                startPointButton = currentButton;
                currentButton = sender;
                NSPoint point = [self convertPoint:startPointButton.frame.origin toView:_transparentView];
                _popUpView.startPoint = point.x + startPointButton.frame.size.width/2;
                [timer setFireDate:[NSDate date]];
            }
        }
        _isTwo = NO;
    }
    currentButton = sender;
}

- (void)removePopUpAndTransView {
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3/*延迟执行时间*/ * NSEC_PER_SEC));
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [_popUpView setFrame:NSMakeRect(0,  _popUpView.frame.origin.y, _popUpView.frame.size.width, 1)];
//    });
    
    _isDownBtn = NO;
    [_popUpView removeFromSuperview];
    [_transparentView removeFromSuperview];
}

- (BOOL)createAudioArrButtons
{
    BOOL issupported = NO;
    if (_audioArr == nil) {
        
        self.audioArr = [NSMutableArray array];
        //此处找出audio下的类别
        if ([_ipod.deviceInfo isSupportMusic]) {
            //支持music
            IMBFunctionButton *musicBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [musicBtn setEnabled:YES];
            [musicBtn setImageWithImageName:@"btn_musicnew" withButtonName:CustomLocalizedString(@"MenuItem_id_1", nil)];
            [musicBtn setNavagationIcon:[StringHelper imageNamed:@"nav_audio_music"]];
            [musicBtn setSelectIcon:[StringHelper imageNamed:@"select_audio_music"]];
            musicBtn.tag = (int)Category_Music;
            [musicBtn setTarget:self];
            [musicBtn setAction:@selector(clickCategory:)];
            [_audioArr addObject:musicBtn];
            [musicBtn release];
            issupported = YES;
            
            if ([_ipod.deviceInfo.productVersion isVersionMajorEqual:@"9.0"]) {
                //支持cloud music
                IMBFunctionButton *cloudMusicBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
                [cloudMusicBtn setEnabled:YES];
                [cloudMusicBtn setImageWithImageName:@"btn_cloudmusicnew" withButtonName:CustomLocalizedString(@"MenuItem_id_91", nil)];
                [cloudMusicBtn setNavagationIcon:[StringHelper imageNamed:@"nav_audio_cloudmusic"]];
                [cloudMusicBtn setSelectIcon:[StringHelper imageNamed:@"select_audio_cloudmusic"]];
                cloudMusicBtn.tag = (int)Category_CloudMusic;
                [cloudMusicBtn setTarget:self];
                [cloudMusicBtn setAction:@selector(clickCategory:)];
                [_audioArr addObject:cloudMusicBtn];
                [cloudMusicBtn release];
                issupported = YES;
            }
        }
        if ([_ipod.deviceInfo isSupportRingtone]) {
            //支持ringtones
            IMBFunctionButton *rtBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [rtBtn setEnabled:YES];
            [rtBtn setImageWithImageName:@"btn_ringtonesnew" withButtonName:CustomLocalizedString(@"MenuItem_id_2", nil)];
            [rtBtn setNavagationIcon:[StringHelper imageNamed:@"nav_audio_ringtones"]];
            [rtBtn setSelectIcon:[StringHelper imageNamed:@"select_audio_ringtones"]];

            rtBtn.tag = (int)Category_Ringtone;
            [rtBtn setTarget:self];
            [rtBtn setAction:@selector(clickCategory:)];
            [_audioArr addObject:rtBtn];
            [rtBtn release];
            issupported = YES;
            
        }
        if([_ipod.deviceInfo isSupportAudioBook]) {
            //支持Audio Books
            IMBFunctionButton *abBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [abBtn setImageWithImageName:@"btn_audio_booksnew" withButtonName:CustomLocalizedString(@"MenuItem_id_3", nil)];
            [abBtn setNavagationIcon:[StringHelper imageNamed:@"nav_audio_audiobook"]];
            [abBtn setSelectIcon:[StringHelper imageNamed:@"select_audio_book"]];

            [abBtn sizeToFit];
            abBtn.tag = (int)Category_Audiobook;
            [abBtn setTarget:self];
            [abBtn setAction:@selector(clickCategory:)];
            [_audioArr addObject:abBtn];
            [abBtn release];
            issupported = YES;
        }
        if ([_ipod.deviceInfo isSupportVoiceMemo]) {
            //支持voicememos
            IMBFunctionButton *vmBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [vmBtn setEnabled:YES];
            [vmBtn setImageWithImageName:@"btn_voice_memosnew" withButtonName:CustomLocalizedString(@"MenuItem_id_5", nil)];
            [vmBtn setNavagationIcon:[StringHelper imageNamed:@"nav_audio_voicememo"]];
            [vmBtn setSelectIcon:[StringHelper imageNamed:@"select_audio_voicememo"]];

            [vmBtn sizeToFit];
            vmBtn.tag = (int)Category_VoiceMemos;
            [vmBtn setTarget:self];
            [vmBtn setAction:@selector(clickCategory:)];
            [_audioArr addObject:vmBtn];
            [vmBtn release];
            issupported = YES;
            
            
        }
     
        //默认支持playlist
        IMBFunctionButton *plBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
        [plBtn setEnabled:YES];
        [plBtn setImageWithImageName:@"btn_playlistsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_4", nil)];
        [plBtn setNavagationIcon:[StringHelper imageNamed:@"nav_audio_playlist"]];
        [plBtn setSelectIcon:[StringHelper imageNamed:@"select_audio_playlist"]];
        [plBtn sizeToFit];
        plBtn.tag = (int)Category_Playlist;
        [plBtn setTarget:self];
        [plBtn setAction:@selector(clickCategory:)];
        [_audioArr addObject:plBtn];
        [plBtn release];
        issupported = YES;
    }
    return issupported;
}

- (BOOL)createvideosArrButtons
{
    BOOL issupported = NO;
    
    if (_videosArr == nil) {
        self.videosArr = [NSMutableArray array];
        if ([_ipod.deviceInfo isSupportMovie]) {
            //支持movies
            IMBFunctionButton *movieBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [movieBtn setEnabled:YES];
            [movieBtn setImageWithImageName:@"btn_moviesnew" withButtonName:CustomLocalizedString(@"MenuItem_id_6", nil)];
            [movieBtn setNavagationIcon:[StringHelper imageNamed:@"nav_video_movies"]];
            [movieBtn setSelectIcon:[StringHelper imageNamed:@"select_video_movies"]];

            [movieBtn sizeToFit];
            movieBtn.tag = (int)Category_Movies;
            [movieBtn setTarget:self];
            [movieBtn setAction:@selector(clickCategory:)];
            [_videosArr addObject:movieBtn];
            [movieBtn release];
            issupported = YES;
            
        }
        
        if ([_ipod.deviceInfo isSupportVideo]) {
            
            if ( [_ipod.deviceInfo getDeviceVersionNumber] >= 7) {
                IMBFunctionButton *HomeVideoBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
                [HomeVideoBtn setEnabled:YES];
                [HomeVideoBtn setImageWithImageName:@"btn_home_videonew" withButtonName:CustomLocalizedString(@"MenuItem_id_50", nil)];
                [HomeVideoBtn setNavagationIcon:[StringHelper imageNamed:@"nav_video_homevideo"]];
                [HomeVideoBtn setSelectIcon:[StringHelper imageNamed:@"select_video_homevideo"]];
                [HomeVideoBtn sizeToFit];
                HomeVideoBtn.tag = (int)Category_HomeVideo;
                [HomeVideoBtn setTarget:self];
                [HomeVideoBtn setAction:@selector(clickCategory:)];
                [_videosArr addObject:HomeVideoBtn];
                [HomeVideoBtn release];
                issupported = YES;
            }

        }
        
        if ([_ipod.deviceInfo isSupportTVShow]) {
            
            //支持tvshow
            IMBFunctionButton *tvshowBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [tvshowBtn setEnabled:YES];
            [tvshowBtn setImageWithImageName:@"btn_tv_showsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_7", nil)];
            [tvshowBtn setNavagationIcon:[StringHelper imageNamed:@"nav_video_tvshow"]];
            [tvshowBtn setSelectIcon:[StringHelper imageNamed:@"select_video_tvshow"]];

            [tvshowBtn sizeToFit];
            tvshowBtn.tag = (int)Category_TVShow;
            [tvshowBtn setTarget:self];
            [tvshowBtn setAction:@selector(clickCategory:)];
            [_videosArr addObject:tvshowBtn];
            [tvshowBtn release];
            issupported = YES;
            
        }

        if ([_ipod.deviceInfo isSupportMV]) {
            //支持musicvideo
            IMBFunctionButton *musicVBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [musicVBtn setEnabled:YES];
            [musicVBtn setImageWithImageName:@"btn_music_videosnew" withButtonName:CustomLocalizedString(@"MenuItem_id_8", nil)];
            [musicVBtn setNavagationIcon:[StringHelper imageNamed:@"nav_video_musicvideo"]];
            [musicVBtn setSelectIcon:[StringHelper imageNamed:@"select_video_musicvideo"]];

            [musicVBtn sizeToFit];
            musicVBtn.tag = (int)Category_MusicVideo;
            [musicVBtn setTarget:self];
            [musicVBtn setAction:@selector(clickCategory:)];
            [_videosArr addObject:musicVBtn];
            [musicVBtn release];
            issupported = YES;
            
        }

        IMBFunctionButton *photoVideoBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
        [photoVideoBtn setEnabled:YES];
        [photoVideoBtn setImageWithImageName:@"btn_photo_videosnew" withButtonName:CustomLocalizedString(@"MenuItem_id_24", nil)];
        [photoVideoBtn setNavagationIcon:[StringHelper imageNamed:@"nav_video_photovideo"]];
        [photoVideoBtn setSelectIcon:[StringHelper imageNamed:@"select_video_photovideo"]];

        [photoVideoBtn sizeToFit];
        photoVideoBtn.tag = (int)Category_PhotoVideo;
        [photoVideoBtn setTarget:self];
        [photoVideoBtn setAction:@selector(clickCategory:)];
        [_videosArr addObject:photoVideoBtn];
        [photoVideoBtn release];
        issupported = YES;

        if ([_ipod.deviceInfo getDeviceVersionNumber] >= 8) {
            //添加微速摄影
            IMBFunctionButton *timelapseBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [timelapseBtn setEnabled:YES];
            [timelapseBtn setImageWithImageName:@"btn_delaynew" withButtonName:CustomLocalizedString(@"MenuItem_id_48", nil)];
            [timelapseBtn setNavagationIcon:[StringHelper imageNamed:@"nav_video_timelapse"]];
            [timelapseBtn setSelectIcon:[StringHelper imageNamed:@"select_video_timelapse"]];

            [timelapseBtn sizeToFit];
            timelapseBtn.tag = (int)Category_TimeLapse;
            [timelapseBtn setTarget:self];
            [timelapseBtn setAction:@selector(clickCategory:)];
            [_videosArr addObject:timelapseBtn];
            [timelapseBtn release];
            issupported = YES;
            
            IMBFunctionButton *slowBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [slowBtn setEnabled:YES];
            [slowBtn setImageWithImageName:@"btn_slo_monew" withButtonName:CustomLocalizedString(@"MenuItem_id_51", nil)];
            [slowBtn setNavagationIcon:[StringHelper imageNamed:@"nav_video_slomo"]];
            [slowBtn setSelectIcon:[StringHelper imageNamed:@"select_video_slomo"]];
            [slowBtn sizeToFit];
            slowBtn.tag = (int)Category_SlowMove;
            [slowBtn setTarget:self];
            [slowBtn setAction:@selector(clickCategory:)];
            [_videosArr addObject:slowBtn];
            [slowBtn release];
            issupported = YES;

        }
    }
    
    return issupported;
}

- (BOOL)createphotosArrButtons
{
    BOOL issupported = NO;
    if ([_ipod.deviceInfo.productVersion hasPrefix:@"4."] || [_ipod.deviceInfo.productVersion hasPrefix:@"3."] || [_ipod.deviceInfo.productVersion hasPrefix:@"2."] || [_ipod.deviceInfo.productVersion hasPrefix:@"1."]) {
        return issupported;
    }
    if (_photosArr == nil) {
        self.photosArr = [NSMutableArray array];
        if ([_ipod.deviceInfo isSupportPhoto]) {
            //camera Roll
            IMBFunctionButton *cameraRollBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [cameraRollBtn setEnabled:YES];
            [cameraRollBtn setImageWithImageName:@"btn_camera_rollnew" withButtonName:CustomLocalizedString(@"MenuItem_id_10", nil)];
            [cameraRollBtn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_cameraroll"]];
            [cameraRollBtn setSelectIcon:[StringHelper imageNamed:@"select_photo_cameraroll"]];

            [cameraRollBtn sizeToFit];
            cameraRollBtn.tag = (int)Category_CameraRoll;
            [cameraRollBtn setTarget:self];
            [cameraRollBtn setAction:@selector(clickCategory:)];
            [_photosArr addObject:cameraRollBtn];
            [cameraRollBtn release];
            //photo Stream
            IMBFunctionButton *photoStreamBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [photoStreamBtn setEnabled:YES];
            [photoStreamBtn setImageWithImageName:@"btn_photo_streamnew" withButtonName:CustomLocalizedString(@"MenuItem_id_11", nil)];
            [photoStreamBtn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_stream"]];
            [photoStreamBtn setSelectIcon:[StringHelper imageNamed:@"select_photo_stream"]];

            [photoStreamBtn sizeToFit];
            photoStreamBtn.tag = (int)Category_PhotoStream;
            [photoStreamBtn setTarget:self];
            [photoStreamBtn setAction:@selector(clickCategory:)];
            [_photosArr addObject:photoStreamBtn];
            [photoStreamBtn release];
            //photo Library
            IMBFunctionButton *photoLibraryBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [photoLibraryBtn setEnabled:YES];
           [photoLibraryBtn setImageWithImageName:@"btn_photolibrarynew" withButtonName:CustomLocalizedString(@"MenuItem_id_12", nil)];
            [photoLibraryBtn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_library"]];
            [photoLibraryBtn setSelectIcon:[StringHelper imageNamed:@"select_photo_library"]];

            [photoLibraryBtn sizeToFit];
            photoLibraryBtn.tag = (int)Category_PhotoLibrary;
            [photoLibraryBtn setTarget:self];
            [photoLibraryBtn setAction:@selector(clickCategory:)];
            [_photosArr addObject:photoLibraryBtn];
            [photoLibraryBtn release];
             issupported = YES;
           
           if ([_ipod.deviceInfo getDeviceVersionNumber] >= 7) {
               
               IMBFunctionButton *photoShareBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
               [photoShareBtn setEnabled:YES];
               [photoShareBtn setImageWithImageName:@"btn_photo_sharenew" withButtonName:CustomLocalizedString(@"MenuItem_id_25", nil)];
               [photoShareBtn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_share"]];
               [photoShareBtn setSelectIcon:[StringHelper imageNamed:@"select_photo_share"]];


               [photoShareBtn sizeToFit];
               photoShareBtn.tag = (int)Category_PhotoShare;
               [photoShareBtn setTarget:self];
               [photoShareBtn setAction:@selector(clickCategory:)];
               [_photosArr addObject:photoShareBtn];
               [photoShareBtn release];
               issupported = YES;
               
               //添加全景
               IMBFunctionButton *panoramasBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
               [panoramasBtn setEnabled:YES];
               [panoramasBtn setImageWithImageName:@"btn_panoramicnew" withButtonName:CustomLocalizedString(@"MenuItem_id_49", nil)];
               [panoramasBtn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_panoramas"]];
               [panoramasBtn setSelectIcon:[StringHelper imageNamed:@"select_photo_panoramas"]];


               [panoramasBtn sizeToFit];
               panoramasBtn.tag = (int)Category_Panoramas;
               [panoramasBtn setTarget:self];
               [panoramasBtn setAction:@selector(clickCategory:)];
               [_photosArr addObject:panoramasBtn];
               [panoramasBtn release];
               issupported = YES;
           }
           
            IMBFunctionButton *myAlbumsBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [myAlbumsBtn setEnabled:YES];
            [myAlbumsBtn setImageWithImageName:@"btn_photo_myalbumsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_26", nil)];
            [myAlbumsBtn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_albums"]];
            [myAlbumsBtn setSelectIcon:[StringHelper imageNamed:@"select_photo_albums"]];

            [myAlbumsBtn sizeToFit];
            myAlbumsBtn.tag = (int)Category_MyAlbums;
            [myAlbumsBtn setTarget:self];
            [myAlbumsBtn setAction:@selector(clickCategory:)];
            [_photosArr addObject:myAlbumsBtn];
            [myAlbumsBtn release];
            issupported = YES;
            
            IMBFunctionButton *continuousShootingBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [continuousShootingBtn setEnabled:YES];
            [continuousShootingBtn setImageWithImageName:@"btn_burstnew" withButtonName:CustomLocalizedString(@"MenuItem_id_47", nil)];
            [continuousShootingBtn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_bursts"]];
            [continuousShootingBtn setSelectIcon:[StringHelper imageNamed:@"select_photo_bursts"]];


            [continuousShootingBtn sizeToFit];
             continuousShootingBtn.tag = (int)Category_ContinuousShooting;
            [continuousShootingBtn setTarget:self];
            [continuousShootingBtn setAction:@selector(clickCategory:)];
            [_photosArr addObject:continuousShootingBtn];
            [continuousShootingBtn release];
            issupported = YES;
            
            //后续需要增加
            if ([_ipod.deviceInfo.productVersion isVersionMajorEqual:@"9"]) {//LivePhoto
                IMBFunctionButton *livePhotoBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
                [livePhotoBtn setEnabled:YES];
                [livePhotoBtn setImageWithImageName:@"btn_photo_livephotonew" withButtonName:CustomLocalizedString(@"MenuItem_id_63", nil)];
                [livePhotoBtn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_livephoto"]];
                [livePhotoBtn setSelectIcon:[StringHelper imageNamed:@"select_photo_livephoto"]];
                
                [livePhotoBtn sizeToFit];
                livePhotoBtn.tag = (int)Category_LivePhoto;
                [livePhotoBtn setTarget:self];
                [livePhotoBtn setAction:@selector(clickCategory:)];
                [_photosArr addObject:livePhotoBtn];
                [livePhotoBtn release];
                issupported = YES;
            }
            
            if ([_ipod.deviceInfo.productVersion isVersionMajorEqual:@"9.3.0"]) {//Screenshot
                IMBFunctionButton *screenshotBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
                [screenshotBtn setEnabled:YES];
                [screenshotBtn setImageWithImageName:@"btn_photo_screenshootnew" withButtonName:CustomLocalizedString(@"MenuItem_id_64", nil)];
                [screenshotBtn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_screenshoot"]];
                [screenshotBtn setSelectIcon:[StringHelper imageNamed:@"select_photo_screenshoot"]];
                
                [screenshotBtn sizeToFit];
                screenshotBtn.tag = (int)Category_Screenshot;
                [screenshotBtn setTarget:self];
                [screenshotBtn setAction:@selector(clickCategory:)];
                [_photosArr addObject:screenshotBtn];
                [screenshotBtn release];
                issupported = YES;
            }
            
            if ([_ipod.deviceInfo.productVersion isVersionMajorEqual:@"9.3.0"]) {//PhotoSelfies
                IMBFunctionButton *photoSelfiesBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
                [photoSelfiesBtn setEnabled:YES];
                [photoSelfiesBtn setImageWithImageName:@"btn_photo_selfnew" withButtonName:CustomLocalizedString(@"MenuItem_id_65", nil)];
                [photoSelfiesBtn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_self"]];
                [photoSelfiesBtn setSelectIcon:[StringHelper imageNamed:@"select_photo_self"]];
                
                [photoSelfiesBtn sizeToFit];
                photoSelfiesBtn.tag = (int)Category_PhotoSelfies;
                [photoSelfiesBtn setTarget:self];
                [photoSelfiesBtn setAction:@selector(clickCategory:)];
                [_photosArr addObject:photoSelfiesBtn];
                [photoSelfiesBtn release];
                issupported = YES;
            }
            
            //Favorite
            IMBFunctionButton *favoriteBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            [favoriteBtn setEnabled:YES];
            [favoriteBtn setImageWithImageName:@"btn_photo_favoritenew" withButtonName:CustomLocalizedString(@"MenuItem_id_67", nil)];
            [favoriteBtn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_favorite"]];
            [favoriteBtn setSelectIcon:[StringHelper imageNamed:@"select_photo_favorite"]];
            
            [favoriteBtn sizeToFit];
            favoriteBtn.tag = (int)Category_Favorite;
            [favoriteBtn setTarget:self];
            [favoriteBtn setAction:@selector(clickCategory:)];
            [_photosArr addObject:favoriteBtn];
            [favoriteBtn release];
            issupported = YES;
            
            if ([_ipod.deviceInfo.productVersion isVersionMajorEqual:@"10"]) {//Location
                IMBFunctionButton *locationBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
                [locationBtn setEnabled:YES];
                [locationBtn setImageWithImageName:@"btn_photo_locationnew" withButtonName:CustomLocalizedString(@"MenuItem_id_66", nil)];
                [locationBtn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_location"]];
                [locationBtn setSelectIcon:[StringHelper imageNamed:@"select_photo_location"]];
                
                [locationBtn sizeToFit];
                locationBtn.tag = (int)Category_Location;
                [locationBtn setTarget:self];
                [locationBtn setAction:@selector(clickCategory:)];
                [_photosArr addObject:locationBtn];
                [locationBtn release];
                issupported = YES;
            }
        }
        
    }
    
    return issupported;
}

- (BOOL)createsafraiArrButtons
{
    
    BOOL issupported = NO;
    if (_safraiArr == nil) {
        self.safraiArr = [NSMutableArray array];
        if (_ipod.deviceInfo.isIOSDevice) {
            
            //ios设备支持bookmark
            IMBFunctionButton *bookmakrBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            bookmakrBtn.tag = Category_Bookmarks;
            [bookmakrBtn setImageWithImageName:@"btn_bookmarksnew" withButtonName:CustomLocalizedString(@"MenuItem_id_21", nil)];
            [bookmakrBtn setNavagationIcon:[StringHelper imageNamed:@"nav_safari_bookmark"]];
            [bookmakrBtn setSelectIcon:[StringHelper imageNamed:@"select_safari_bookmark"]];

            [bookmakrBtn setTarget:self];
            [bookmakrBtn setAction:@selector(clickCategory:)];
            [_safraiArr addObject:bookmakrBtn];
            [bookmakrBtn release];
            //ios设备支持safraihistory
            IMBFunctionButton *safarihistoryBtn =[[IMBFunctionButton alloc]initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            safarihistoryBtn.tag = Category_SafariHistory;
            [safarihistoryBtn setImageWithImageName:@"btn_safari_historynew" withButtonName:CustomLocalizedString(@"MenuItem_id_37", nil)];
            [safarihistoryBtn setNavagationIcon:[StringHelper imageNamed:@"nav_safari_history"]];
            [safarihistoryBtn setSelectIcon:[StringHelper imageNamed:@"select_safari_history"]];

            [safarihistoryBtn setTarget:self];
            [safarihistoryBtn setAction:@selector(clickCategory:)];
            [_safraiArr addObject:safarihistoryBtn];
            [safarihistoryBtn release];
            
            issupported = YES;
            
        }
    }
    return issupported;
}

- (BOOL)createtoolsArrButtons
{
     BOOL issupported = NO;
    if (_toolsArr == nil) {
       
        if (_ipod.deviceInfo.isIOSDevice) {
             _toolsArr = [[NSMutableArray array] retain];
            //ios设备支持bookmark
            IMBFunctionButton *rebootBtn =[[IMBFunctionButton alloc] initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            rebootBtn.tag = Category_Reboot;
            [rebootBtn setImageWithImageName:@"btn_rebootnew" withButtonName:CustomLocalizedString(@"MenuItem_id_43", nil)];
            [rebootBtn setTarget:self];
            [rebootBtn setAction:@selector(clickCategory:)];
            [_toolsArr addObject:rebootBtn];
            [rebootBtn release];
            
            IMBFunctionButton *shutdownBtn =[[IMBFunctionButton alloc] initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            shutdownBtn.tag = Category_Shutdown;
            [shutdownBtn setImageWithImageName:@"btn_shutdownnew" withButtonName:CustomLocalizedString(@"MenuItem_id_44", nil)];
            [shutdownBtn setTarget:self];
            [shutdownBtn setAction:@selector(clickCategory:)];
            [_toolsArr addObject:shutdownBtn];
            [shutdownBtn release];

            IMBFunctionButton *logsBtn =[[IMBFunctionButton alloc] initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            logsBtn.tag = Category_Systemlogs;
            [logsBtn setImageWithImageName:@"btn_system_logsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_45", nil)];
            [logsBtn setTarget:self];
            [logsBtn setAction:@selector(clickCategory:)];
            [_toolsArr addObject:logsBtn];
            [logsBtn release];
            issupported = YES;
        }
    }
    return issupported;
}

- (BOOL)createSystemButtons
{
    BOOL issupported = NO;
    if (_systemArr == nil) {
        if (_ipod.deviceInfo.isIOSDevice) {
            //iOS设备默认支持system
            issupported = YES;
            _systemArr = [[NSMutableArray array] retain];
            IMBFunctionButton *systemBtn =[[IMBFunctionButton alloc] initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            systemBtn.tag = Category_System;
            [systemBtn setImageWithImageName:@"btn_systemnew" withButtonName:CustomLocalizedString(@"MenuItem_id_35", nil)];
            [systemBtn setNavagationIcon:[StringHelper imageNamed:@"nav_filesystem_system"]];
            [systemBtn setSelectIcon:[StringHelper imageNamed:@"select_filesystem_system"]];

            [systemBtn setTarget:self];
            [systemBtn setAction:@selector(clickCategory:)];
            [_systemArr addObject:systemBtn];
            [systemBtn release];
            
            IMBFunctionButton *storageBtn =[[IMBFunctionButton alloc] initWithFrame:NSMakeRect(0, 0, CategoryButtonWidth, CategoryButtonHeight)];
            storageBtn.tag = Category_Storage;
            [storageBtn setImageWithImageName:@"btn_storage" withButtonName:CustomLocalizedString(@"MenuItem_id_41", nil)];
            [storageBtn setNavagationIcon:[StringHelper imageNamed:@"nav_filesystem_storage"]];
            [storageBtn setSelectIcon:[StringHelper imageNamed:@"select_filesystem_storage"]];

            [storageBtn setTarget:self];
            [storageBtn setAction:@selector(clickCategory:)];
            [_systemArr addObject:storageBtn];
            [storageBtn release];
        }
    }
    return issupported;
}
    
- (void)setShowBadgeCount:(BOOL)showBadgeCount
{
    for (IMBFunctionButton *button in _allcategoryArr) {
        button.showbadgeCount = showBadgeCount;
    }
}

- (void)needDisplay:(IMBFunctionButton *)sender
{
    K++;
    if (currentButton.frame.origin.x > startPointButton.frame.origin.x) {
        CGFloat velocity = (currentButton.frame.origin.x + currentButton.frame.size.width/2 - (startPointButton.frame.origin.x + startPointButton.frame.size.width/2))/120.0f;
        _popUpView.startPoint = _popUpView.startPoint + velocity;
        
    }else
    {
        CGFloat velocity = ((startPointButton.frame.origin.x + startPointButton.frame.size.width/2)-(currentButton.frame.origin.x + currentButton.frame.size.width/2 ))/120.0f;
        
        _popUpView.startPoint = _popUpView.startPoint - velocity;
        
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_popUpView setNeedsDisplay:YES];
        
    });
    if (K==120) {
        [timer setFireDate:[NSDate distantFuture]];
        NSPoint point = [self convertPoint:currentButton.frame.origin toView:_transparentView];
        _popUpView.startPoint = point.x + currentButton.frame.size.width/2;
        K = 0;
    }
}

- (void)animationDidEnd:(NSAnimation *)animation
{
    
}

- (void)addCategoryButtons:(NSMutableArray *)categoryArr
{
    //此处向_popupview上添加按钮
    NSView *contentView = nil;
    if (_popUpView.subviews.count > 0) {
        for (NSView *view in _popUpView.subviews) {
            if ([view isKindOfClass:[IMBPopupContentView class]]) {
                contentView = (IMBPopupContentView *)view;
                break;
            }
        }
    }
    if (contentView == nil) {
        if (categoryArr.count > 7) {
            _isTwo = YES;
            contentView = [[IMBTransparentView alloc] initWithFrame:NSMakeRect(ceil((_popUpView.frame.size.width - 1060)/2), 0, 1060, PopUpViewHeight * 2)];
        }else {
            _isTwo = NO;
            contentView = [[IMBTransparentView alloc] initWithFrame:NSMakeRect(ceil((_popUpView.frame.size.width - 1060)/2), 0, 1060, PopUpViewHeight)];
        }
        //[contentView setStartPoint:_popUpView.startPoint];
        [_popUpView setStartPoint:_popUpView.startPoint + contentView.frame.origin.x];
        [contentView setAutoresizesSubviews:YES];
        [contentView setAutoresizingMask:NSViewNotSizable|NSViewMinXMargin|NSViewMaxXMargin];
        [_popUpView addSubview:contentView];
        [contentView release];
    }else {
        //[contentView setStartPoint:_popUpView.startPoint];
        [_popUpView setStartPoint:_popUpView.startPoint + contentView.frame.origin.x];
        if (categoryArr.count > 7) {
            _isTwo = YES;
            [contentView setFrameSize:NSMakeSize(1060, PopUpViewHeight * 2)];
        }else {
            _isTwo = NO;
            [contentView setFrameSize:NSMakeSize(1060, PopUpViewHeight)];
        }
        [contentView setNeedsDisplay:YES];
        [_popUpView setNeedsDisplay:YES];
    }
    
    for (int i = 0; i<[categoryArr count];i++) {
        NSButton *button = [categoryArr objectAtIndex:i];
        if (i >= 7) {
            button.frame = NSMakeRect(147+(CategoryButtonWidth+32)*(i-7), ArrowSize + 20 + CategoryButtonHeight , CategoryButtonWidth, CategoryButtonHeight);
        }else {
            button.frame = NSMakeRect(147+(CategoryButtonWidth+32)*i, ArrowSize + 10 , CategoryButtonWidth, CategoryButtonHeight);
        }
        [contentView addSubview:button];
    }
}

- (void)reloadPopupViewButtons:(IMBFunctionButton *)sender
{
    //移除原先的子视图
    if (self.currentContainer == 500) {
        for (NSButton *button in _audioArr) {
            if([button superview])
            {
                [button removeFromSuperview];
            }
            
        }
    }else if (self.currentContainer == 501) {
        for (NSButton *button in _videosArr) {
            if([button superview])
            {
                [button removeFromSuperview];
            }
        }
    }else if (self.currentContainer == 502) {
        for (NSButton *button in _photosArr) {
            if([button superview])
            {
                [button removeFromSuperview];
            }
        }
    }else if (self.currentContainer == 503) {
        for (NSButton *button in _safraiArr) {
            [button removeFromSuperview];
        }
    }
    else if (self.currentContainer == 505) {
        for (NSButton *button in _systemArr) {
            [button removeFromSuperview];
        }
    }

    if (sender.tag == 500) {
        self.currentContainer = 500;
        
        [self addCategoryButtons:_audioArr];
        
        
    }else if (sender.tag == 501 )
    {
        //此处找出Videos下的类别
        self.currentContainer = 501;
        [self addCategoryButtons:_videosArr];
    }else if (sender.tag == 502 )
    {
        
        //此处找出Photos下的类别
        self.currentContainer = 502;
        [self addCategoryButtons:_photosArr];
        
        
    }else if(sender.tag == 503)
    {
        //此处找出safari下的类别
        self.currentContainer = 503;
        [self addCategoryButtons:_safraiArr];
        
        
    }
    else if(sender.tag == 505)
    {
        //此处找出tools下的类别
        self.currentContainer = 505;
        [self addCategoryButtons:_systemArr];
    }

}
- (void)addNoContainerButtons
{
    for (int i = 0; i<[_categoryArr count];i++) {
        IMBFunctionButton *button = [_categoryArr objectAtIndex:i];
        [button setFrame:NSMakeRect(60+(80+20)*i,36+CategoryButtonHeight+10, CategoryButtonWidth, CategoryButtonHeight)];
        if (i>=9) {
            [button setFrame:NSMakeRect(60+100*(i-9),0 , CategoryButtonWidth, CategoryButtonHeight)];
            [containerView addSubview:button];
        }else
        {
            [self addSubview:button];
        }
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
//	[[NSColor whiteColor] setFill];
//    NSRectFill(dirtyRect);
    
}

- (void)refreshBadgeCount:(NSNotification *)notification
{
    IMBiPod *ipod = notification.object;
    if (ipod == _ipod) {
        
        NSDictionary *infor = notification.userInfo;
        NSInteger badgeCount = [[infor objectForKey:@"badgeCount"] intValue];
        NSInteger tag = [[infor objectForKey:@"categorybuttonTag"] intValue];
        for (IMBFunctionButton *button in _allcategoryArr) {
            
            if (button.tag == tag) {
                
                button.badgeCount = badgeCount;
            }
        }
    }
}

- (BOOL)checkItemsValidWithIPod:(NSString *)itemKey{
    BOOL isPass = YES;
    NSDictionary *dataSyncStr = [_ipod.deviceHandle deviceValueForKey:nil inDomain:@"com.apple.mobile.data_sync"];
    if (dataSyncStr != nil) {
        NSArray *allKey = [dataSyncStr allKeys];
        if ([allKey containsObject:itemKey]) {
            NSDictionary *contDic = [dataSyncStr objectForKey:itemKey];
            if (contDic != nil) {
                if (isPass) {
                    NSArray *sourcesInfoArray = [contDic objectForKey:@"Sources"];
                    if (sourcesInfoArray != nil && [sourcesInfoArray count] > 0) {
                        isPass = NO;
                    }
                }
            }
        }
    }
    return isPass;
}

- (void)dealloc
{
    Block_release(_catagoryBlock);
    Block_release(_reloadBlock);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSViewFrameDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [_toolsArr release],_toolsArr = nil;
    [_allBtnArr release],_allBtnArr = nil;
    [_ipod release],_ipod = nil;
    [_transparentView release],_transparentView = nil;
    [_popUpView release],_popUpView = nil;
    [_audioArr release],_audioArr = nil;
    [_photosArr release],_photosArr = nil;
    [_safraiArr release],_safraiArr = nil;
    [_videosArr release],_videosArr = nil;
    [_categoryArr release],_categoryArr = nil;
    [_allcategoryArr release],_allcategoryArr = nil;
    [_systemArr release],_systemArr = nil;
    [containerView release],containerView = nil;
    [_android release],_android = nil;
    _threadBreak = true;
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_BADGECOUNT_REFRESH object:nil];
    [super dealloc];
}
@end
