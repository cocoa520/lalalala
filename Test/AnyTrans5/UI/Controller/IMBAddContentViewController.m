//
//  IMBAddContentViewController.m
//  AnyTrans
//
//  Created by m on 16/12/14.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBAddContentViewController.h"
#import "StringHelper.h"
#import "IMBTrack.h"
#import "IMBImageTextFieldCell.h"
#import "NextCell.h"
#import "IMBDeviceInfo.h"
#import "IMBMediaInfo.h"
#import "IMBAnimation.h"
#import "IMBTransferViewController.h"
#import "IMBDeviceMainPageViewController.h"
#import "IMBNotificationDefine.h"
#import "RegexKitLite.h"

@implementation IMBAddContentViewController
@synthesize delegate = _delegate;
@synthesize isiCloudAdd = _isiCloudAdd;
@synthesize icloudManager = _icloudManager;
@synthesize addCategoryAryM = _addCategoryAryM;

- (id)initWithiPod:(IMBiPod *)iPod  withAllPaths:(NSMutableArray *)allPaths WithPhotoAlbum:(IMBPhotoEntity *)albumEntity playlistID:(int64_t) playlistID{
    if (self = [super initWithNibName:@"IMBAddContentViewController" bundle:nil]) {
        _iPod = [iPod retain];
        _allPaths = [allPaths retain];
        _photoAlbum = [albumEntity retain];
        _playlistID = playlistID;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _addCategoryAryM = [[NSMutableArray alloc] init];
    _detailArray = [[NSMutableArray alloc] init];
    [_mainTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_subTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_mainTitle setStringValue:CustomLocalizedString(@"AddContent_SelectCatagory_Title", nil)];
    if (_isiCloudAdd) {
        [_subTitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"AddContent_SelectCatagory_Descript", nil),_icloudManager.netClient.loginInfo.loginInfoEntity.fullName]];
    }else{
        [_subTitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"AddContent_SelectCatagory_Descript", nil),_iPod.deviceInfo.deviceName]];
    }
    
    
    [_contentView setBackgroundColor:[NSColor clearColor]];
    [_contentView setHasCorner:YES];
    [_selectView setIsGradientWithCornerPart4:YES];
    [_mainBox setContentView:_selectView];
    [_categoryView setFrameOrigin:NSMakePoint(2, 2)];
    
    [_catagoryTableView setFocusRingType:NSFocusRingTypeNone];
    [_catagoryTableView setBackgroundColor:[NSColor clearColor]];
    [_detailTableView setFocusRingType:NSFocusRingTypeNone];
    [_detailTableView setBackgroundColor:[NSColor clearColor]];
    [_catagoryTableView setListener:self];
    [_detailTableView setListener:self];
    
    _closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil((NSHeight(_topView.frame) - 32)/2), 32, 32)];
    [_closebutton setTarget:self];
    [_closebutton setAction:@selector(closeWindow:)];
    [_closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_topView addSubview:_closebutton];
    _nextBtn = [[HoverButton alloc] init];
    [_nextBtn setAutoresizesSubviews:YES];
    [_nextBtn setWantsLayer:YES];
    [_nextBtn.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    _nextBtn.layer.frame = NSRectToCGRect(_nextBtn.frame);
    _nextBtn.layer.anchorPointZ = -1;
    [_nextBtn setAutoresizesSubviews:YES];
    [_nextBtn setAutoresizingMask:NSViewMinXMargin|NSViewMinYMargin|NSViewMaxYMargin];
    [_nextBtn setTarget:self];
    [_nextBtn setAction:@selector(startTransfer)];
    [_nextBtn setMouseEnteredImage:[StringHelper imageNamed:@"clone_next_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_next_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_next_down"]];
    [_nextBtn setFrame:NSMakeRect(_selectView.frame.size.width - 76, _selectView.frame.size.height / 2.0, 56, 56)];
    [_selectView addSubview:_nextBtn];
    [_nextBtn release], _nextBtn = nil;
    [_animationView startAnimation];
    [_contentView addSubview:_loadingView];
    [_loadingView setFrameOrigin:NSMakePoint(2, 2)];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getCategoryArry];
        [self initCategoryTableView];
        [self initDetailTableView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_contentView addSubview:_categoryView];
            [_loadingView removeFromSuperview];
            [_animationView endAnimation];
        });
    });
    NSString *str = @"close";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
}

- (void)getCategoryArry {
    _musicArray = [[NSMutableArray alloc] init];
    _videoArray = [[NSMutableArray alloc] init];
    _voiceMemoArray = [[NSMutableArray alloc] init];
    _ringtoneArray = [[NSMutableArray alloc] init];
    _appArray = [[NSMutableArray alloc] init];
    _bookArray = [[NSMutableArray alloc] init];
    _photoArray = [[NSMutableArray alloc] init];
    _contactArray = [[NSMutableArray alloc] init];
    _noteArray = [[NSMutableArray alloc] init];
    NSMutableArray *fileArray = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *supportAllExtension = nil;
    if (_isiCloudAdd) {
        supportAllExtension = [NSMutableArray arrayWithObjects:@"vcf",@"csv",@"jpg",nil];
    }else{
        supportAllExtension = [MediaHelper filterSupportArrayWithIpod:_iPod isSingleImport:NO];
    }
   
    NSArray *supportVoiceMemoExtension = [[MediaHelper getSupportFileTypeArray:Category_VoiceMemos supportVideo:_iPod.deviceInfo.isSupportVideo supportConvert:NO withiPod:_iPod] componentsSeparatedByString:@";"];
    NSArray *supportRingtoneExtension = [[MediaHelper getSupportFileTypeArray:Category_Ringtone supportVideo:_iPod.deviceInfo.isSupportVideo supportConvert:NO withiPod:_iPod] componentsSeparatedByString:@";"];
    NSArray *supportIBookExtension = [[MediaHelper getSupportFileTypeArray:Category_iBooks supportVideo:_iPod.deviceInfo.isSupportVideo supportConvert:NO withiPod:_iPod] componentsSeparatedByString:@";"];
    NSArray *supportApplicationExtension = [[MediaHelper getSupportFileTypeArray:Category_Applications supportVideo:_iPod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_iPod] componentsSeparatedByString:@";"];
    NSArray *supportPhotoExtension = [[MediaHelper getSupportFileTypeArray:Category_PhotoLibrary supportVideo:_iPod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_iPod] componentsSeparatedByString:@";"];
    NSArray *supportVideoExtension = [[MediaHelper getSupportFileTypeArray:Category_Movies supportVideo:_iPod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_iPod] componentsSeparatedByString:@";"];
    [self getFileNames:_allPaths byFileExtensions:supportAllExtension toArray:fileArray];
    _selectArray = [[NSMutableArray alloc] initWithArray:fileArray];
    if (_isiCloudAdd) {
        for (NSString *string in fileArray) {
            NSString *extension = [[string pathExtension] lowercaseString];
            if ([supportPhotoExtension containsObject:extension]) {
                IMBMediaInfo *mediaInfo = [IMBMediaInfo singleton];
                [mediaInfo openWithFilePath:string];
                if (mediaInfo.isGotMetaData) {
                    IMBToiCloudPhotoEntity *entity = [[IMBToiCloudPhotoEntity alloc] init];
                    entity.checkState = Check;
                    NSString *extensionStr = [NSString stringWithFormat:@".%@",[string pathExtension].lowercaseString];
                    entity.photoTitle = [mediaInfo.title stringByAppendingString:extensionStr];
                    entity.photoSize = [mediaInfo.fileSize unsignedIntValue];
                    entity.photoPath = string;
                    [_photoArray addObject:entity];
                    [entity release];
                }
            }else if ([extension isEqualToString:@"vcf"]){
                //需要解析vcf文件
                NSData *data = [[NSFileManager defaultManager] contentsAtPath:string];
                NSString *vcfStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSArray *contactArray = [self parseVCF:vcfStr];
                [_contactArray addObjectsFromArray:contactArray];
            
            }else if ([extension isEqualToString:@"csv"]){
                //需要解析csv文件
                NSArray *noteArray = [self parseNoteCSV:string];
                [_noteArray addObjectsFromArray:noteArray];
            }
        }
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:iCloud_Content action:iCloud_Import actionParams:@"Photos" label:LabelNone transferCount:_photoArray.count screenView:@"Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [ATTracker event:iCloud_Content action:iCloud_Import actionParams:@"Contacts" label:LabelNone transferCount:_contactArray.count screenView:@"Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [ATTracker event:iCloud_Content action:iCloud_Import actionParams:@"Notes" label:LabelNone transferCount:_noteArray.count screenView:@"Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    }else{
        for (NSString *string in fileArray) {
            IMBMediaInfo *mediaInfo = [IMBMediaInfo singleton];
            [mediaInfo openWithFilePath:string];
            if (mediaInfo.isGotMetaData) {
                IMBTrack *track = [[IMBTrack alloc]init];
                NSString *extensionStr = [NSString stringWithFormat:@".%@",[string pathExtension].lowercaseString];
                track.title = [mediaInfo.title stringByAppendingString:extensionStr];
                track.fileSize = [mediaInfo.fileSize unsignedIntValue];
                [track setLength:[mediaInfo.length intValue]];
                
                track.checkState = Check;
                track.srcFilePath = string;
                NSString *extension = [[string pathExtension] lowercaseString];
                if([supportApplicationExtension containsObject:extension]){
                    [_appArray addObject:track];
                }else if ([supportIBookExtension containsObject:extension]) {
                    [_bookArray addObject:track];
                }else if([supportRingtoneExtension containsObject:extension]){
                    [_ringtoneArray addObject:track];
                }else if([supportVoiceMemoExtension containsObject:extension]){
                    [_voiceMemoArray addObject:track];
                }else if([supportVideoExtension containsObject:extension]){
                    [_videoArray addObject:track];
                }else if ([supportPhotoExtension containsObject:extension]) {
                    [_photoArray addObject:track];
                }else if([supportAllExtension containsObject:extension]){
                    [_musicArray addObject:track];
                }
            }
        }
    }
}

//解析
- (NSMutableArray *)parseVCF:(NSString *)vcgString {
    NSArray *lines = [vcgString componentsSeparatedByString:@"\n"];
    NSMutableArray *contactArray = [NSMutableArray array];
    IMBContactEntity *entity = nil;
    int a1=0; //地址
    int b1=0;//电话
    int c1=0;//email
    int d1=0;//url
    int e1=0;//related
    int f1=0;//date
    int g1=0; //IMP
    for(int i = 0;i<[lines count];i++)
    {
        NSString *line = [lines objectAtIndex:i];
        
        if ([line hasPrefix:@"BEGIN:"]) {
            entity = [[IMBContactEntity alloc] init];
            entity.checkState = Check;
        }else if ([line hasPrefix:@"N:"]||[line hasPrefix:@"N;"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            if ([upperComponents count]>=2) {
                NSArray *names = [[upperComponents objectAtIndex:1] componentsSeparatedByString:@";"];
                for (int i = 0;i<[names count];i++) {
                    
                    if (i==0) {
                        NSString *name = [names objectAtIndex:i];
                        NSString *aname = [name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        [entity setLastName:[aname stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==1)
                    {
                        NSString *name = [names objectAtIndex:i];
                        NSString *aname = [name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        [entity setFirstName:[aname stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==2)
                    {
                        NSString *name = [names objectAtIndex:i];
                        NSString *aname = [name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        [entity setMiddleName:[aname stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==3)
                    {
                        NSString *name = [names objectAtIndex:i];
                        NSString *aname = [name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        [entity setTitle:[aname stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==4)
                    {
                        NSString *name = [names objectAtIndex:i];
                        NSString *aname = [name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        
                        [entity setSuffix:[aname stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }
                    
                }
                
            }
        }else if ([line hasPrefix:@"FN"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setFullName:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
            
        }
        else if ([line hasPrefix:@"NOTE"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setNotes:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
            
            
        }else if ([line hasPrefix:@"ORG"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            if ([upperComponents count]>=2) {
                NSArray *companys = [[upperComponents objectAtIndex:1] componentsSeparatedByString:@";"];
                for (int i = 0;i<[companys count];i++) {
                    
                    if (i==0) {
                        [entity setCompanyName:[[companys objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==1)
                    {
                        [entity setDepartment:[[companys objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }
                }
                
            }
        }else if ([line hasPrefix:@"BDAY:"])//基本数据
        {
            //取数组最后一个为birthday
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            id birthday = [upperComponents lastObject];
            if ([birthday isKindOfClass:[NSString class]]) {
                //将birthday转换成NSDate
                birthday = [birthday stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *date = [formatter dateFromString:birthday];
                [entity setBirthday:date];
            }
        }else if ([line hasPrefix:@"TITLE:"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setJobTitle:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        }else if ([line hasPrefix:@"NICKNAME:"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setNickname:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        }else if ([line hasPrefix:@"X-PHONETIC-FIRST-NAME:"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setFirstNameYomi:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        }else if ([line hasPrefix:@"X-PHONETIC-LAST-NAME:"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setLastNameYomi:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        }else if ([line hasPrefix:@"ADR"])//地址 没有自定义 label为空
        {
            IMBContactAddressEntity *addressEntity = [[IMBContactAddressEntity alloc] init];
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            if ([upperComponents count]>=2) {
                
                NSArray *typeArray = [[upperComponents objectAtIndex:0] componentsSeparatedByString:@";"];
                if ([typeArray count]==0) {
                    [addressEntity setType:@"other"];
                }
                for (int i = 0;i< [typeArray count];i++) {
                    if (i == 1) {
                        NSArray *arr = [[typeArray objectAtIndex:i] componentsSeparatedByString:@"="];
                        if ([arr count]>=2) {
                            [addressEntity setType:((NSString *)[arr lastObject]).lowercaseString];
                        }else
                        {
                            [addressEntity setType:@"other"];
                        }
                    }
                }
                
                
                NSArray *addressArray = [[upperComponents objectAtIndex:1] componentsSeparatedByString:@";"];
                for (int i = 0;i<[addressArray count];i++) {
                    
                    if (i==2) {
                        [addressEntity setStreet:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==3)
                    {
                        [addressEntity setCity:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==4)
                    {
                        [addressEntity setState:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==5)
                    {
                        [addressEntity setPostalCode:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==6)
                    {
                        [addressEntity setCountry:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }
                }
                [addressEntity setEntityID:[NSNumber numberWithInt:a1]];
                a1++;
                [addressEntity setContactCategory:Contact_StreetAddress];
                [entity.addressArray addObject:addressEntity];
                [addressEntity release];
                
            }
            
            
        }else if ([line hasPrefix:@"IMPP;"])//IM 没有自定义
        {
            IMBContactIMEntity *imentity = [[IMBContactIMEntity alloc] init];
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [imentity setUser:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
            if ([upperComponents count]>0) {
                NSString *str = [upperComponents objectAtIndex:0];
                NSArray *arr = [str componentsSeparatedByString:@";"];
                for (int i=0;i<[arr count];i++) {
                    NSString *subStr = nil;
                    if (i==1) {
                        subStr = [arr objectAtIndex:i];
                        NSArray *subArray = [subStr componentsSeparatedByString:@"="];
                        [imentity setService:[subArray lastObject]];
                    }else if (i==2)
                    {
                        subStr = [arr objectAtIndex:i];
                        NSArray *subArray = [subStr componentsSeparatedByString:@"="];
                        [imentity setType:((NSString *)[subArray lastObject]).lowercaseString];
                    }
                }
            }
            [imentity setContactCategory:Contact_IM];
            [imentity setEntityID:[NSNumber numberWithInt:g1]];
            g1++;
            [entity.IMArray addObject:imentity];
            [imentity release];
            
        }else if([line hasPrefix:@"URL;"])//url 没有自定义
        {
            IMBContactKeyValueEntity *urlEntity = [[IMBContactKeyValueEntity alloc] init];
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [urlEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
            if ([upperComponents count]>=1) {
                NSString *str = [upperComponents objectAtIndex:0];
                NSArray *arr = [str componentsSeparatedByString:@";"];
                for (int i=0;i<[arr count];i++) {
                    NSString *subStr = nil;
                    if (i==1) {
                        subStr = [arr objectAtIndex:i];
                        NSArray *subArray = [subStr componentsSeparatedByString:@"="];
                        [urlEntity setType:((NSString *)[subArray lastObject]).lowercaseString];
                    }
                }
                
            }
            [urlEntity setEntityID:[NSNumber numberWithInt:d1]];
            d1++;
            [urlEntity setContactCategory:Contact_URL];
            [entity.urlArray addObject:urlEntity];
            [urlEntity release];
            
        }else if ([line hasPrefix:@"TEL;"])
        {
            IMBContactKeyValueEntity *telEntity = [[IMBContactKeyValueEntity alloc] init];
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [telEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
            
            if ([upperComponents count]>=1) {
                NSString *str = [upperComponents objectAtIndex:0];
                NSArray *arr = [str componentsSeparatedByString:@";"];
                for (int i=0;i<[arr count];i++) {
                    NSString *subStr = nil;
                    if (i==1) {
                        subStr = [arr objectAtIndex:i];
                        NSArray *subArray = [subStr componentsSeparatedByString:@"="];
                        NSString *type = [subArray lastObject];
                        if ([type isEqualToString:@"CELL"]||[type isEqualToString:@"IPHONE"]) {
                            [telEntity setType:@"mobile"];
                        }else
                        {
                            [telEntity setType:((NSString *)[subArray lastObject]).lowercaseString];
                        }
                        
                    }
                }
                
            }
            [telEntity setEntityID:[NSNumber numberWithInt:b1]];
            b1++;
            [telEntity setContactCategory:Contact_PhoneNumber];
            [entity.phoneNumberArray addObject:telEntity];
            [telEntity release];
            
        }else if ([line hasPrefix:@"EMAIL;"])
        {
            IMBContactKeyValueEntity *emailEntity = [[IMBContactKeyValueEntity alloc] init];
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [emailEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
            
            if ([upperComponents count]>=1) {
                NSString *str = [upperComponents objectAtIndex:0];
                NSArray *arr = [str componentsSeparatedByString:@";"];
                for (int i=0;i<[arr count];i++) {
                    NSString *subStr = nil;
                    if (i==2) {
                        subStr = [arr objectAtIndex:i];
                        NSArray *subArray = [subStr componentsSeparatedByString:@"="];
                        [emailEntity setType:((NSString *)[subArray lastObject]).lowercaseString];
                    }
                }
                
            }
            [emailEntity setContactCategory:Contact_EmailAddressNumber];
            [emailEntity setEntityID:[NSNumber numberWithInt:c1]];
            c1++;
            [entity.emailAddressArray addObject:emailEntity];
            [emailEntity release];
        }
        else if ([line hasPrefix:@"item"])
        {
            //地址
            NSString *adrReg = @"item\\w+.ADR:*";
            //电话
            NSString *phoneReg = @"item\\w+.TEL:*";
            //email
            NSString *emailReg = @"item\\w+.EMAIL:*";
            //url
            NSString *urlReg = @"item\\w+.URL:*";
            //related
            NSString *relatedReg = @"item\\w+.X-ABRELATEDNAMES:*";
            //date
            NSString *dateReg = @"item\\w+.X-ABDATE:*";
            //IMPP
            NSString *imppReg = @"item\\w+.IMPP:*";
            //date
            
            if ([line isMatchedByRegex:adrReg]) {
                IMBContactAddressEntity *addressEntity = [[IMBContactAddressEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                if ([upperComponents count]>=2) {
                    
                    NSArray *addressArray = [[upperComponents objectAtIndex:1] componentsSeparatedByString:@";"];
                    for (int i = 0;i<[addressArray count];i++) {
                        
                        if (i==2) {
                            [addressEntity setStreet:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                        }else if (i==3)
                        {
                            [addressEntity setCity:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                        }else if (i==4)
                        {
                            [addressEntity setState:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                        }else if (i==5)
                        {
                            [addressEntity setPostalCode:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                        }else if (i==6)
                        {
                            [addressEntity setCountry:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                        }
                    }
                    
                    
                }
                addressEntity.type = @"other";
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [addressEntity setLabel:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    
                    i++;
                }
                [addressEntity setContactCategory:Contact_StreetAddress];
                [addressEntity setEntityID:[NSNumber numberWithInt:a1]];
                a1++;
                [entity.addressArray addObject:addressEntity];
                
            }else if ([line isMatchedByRegex:phoneReg])
            {
                IMBContactKeyValueEntity *phoneEntity = [[IMBContactKeyValueEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                [phoneEntity setValue:[[upperComponents lastObject]stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [phoneEntity setLabel:[[arr lastObject]stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    i++;
                }
                [phoneEntity setType:@"other"];
                [phoneEntity setEntityID:[NSNumber numberWithInt:b1]];
                b1++;
                [phoneEntity setContactCategory:Contact_PhoneNumber];
                [entity.phoneNumberArray addObject:phoneEntity];
                [phoneEntity release];
                
            }else if ([line isMatchedByRegex:emailReg])
            {
                IMBContactKeyValueEntity *emailEntity = [[IMBContactKeyValueEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                [emailEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [emailEntity setLabel:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    i++;
                }
                [emailEntity setType:@"other"];
                [emailEntity setEntityID:[NSNumber numberWithInt:c1]];
                c1++;
                [emailEntity setContactCategory:Contact_EmailAddressNumber];
                [entity.emailAddressArray addObject:emailEntity];
                [emailEntity release];
                
            }else if ([line isMatchedByRegex:urlReg])
            {
                IMBContactKeyValueEntity *urlEntity = [[IMBContactKeyValueEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                [urlEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [urlEntity setLabel:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    i++;
                }
                [urlEntity setType:@"other"];
                [urlEntity setEntityID:[NSNumber numberWithInt:d1]];
                d1++;
                [urlEntity setContactCategory:Contact_URL];
                [entity.urlArray addObject:urlEntity];
                [urlEntity release];
                
            }else if ([line isMatchedByRegex:relatedReg])
            {
                //item17.X-ABRELATEDNAMES;type=pref:sister
                //item17.X-ABLabel:_$!<Sister>!$_
                IMBContactKeyValueEntity *relatedEntity = [[IMBContactKeyValueEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                [relatedEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [relatedEntity setLabel:[self getValueInangle:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]]];
                    i++;
                }
                [relatedEntity setType:@"other"];
                [relatedEntity setEntityID:[NSNumber numberWithInt:e1]];
                e1++;
                [relatedEntity setContactCategory:Contact_RelatedName];
                [entity.relatedNameArray addObject:relatedEntity];
                [relatedEntity release];
                
            }else if ([line isMatchedByRegex:dateReg])
            {
                //item5.X-ABDATE;X-APPLE-OMIT-YEAR=1604;type=pref:1604-11-17
                //item5.X-ABLabel:_$!<Other>!$_
                IMBContactKeyValueEntity *dateEntity = [[IMBContactKeyValueEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                NSString *strDate = [[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *date = [formatter dateFromString:strDate];
                [dateEntity setValue:date];
                [formatter release];
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [dateEntity setLabel:[self getValueInangle:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]]];
                    
                    i++;
                }
                [dateEntity setType:@"other"];
                [dateEntity setEntityID:[NSNumber numberWithInt:f1]];
                f1++;
                [dateEntity setContactCategory:Contact_Date];
                [entity.dateArray addObject:dateEntity];
                [dateEntity release];
            }else if ([line isMatchedByRegex:imppReg])
            {
                //item15.IMPP;X-SERVICE-TYPE=AIM:aim:15665666
                //item15.X-ABLabel:luoluo
                IMBContactIMEntity *imEntity = [[IMBContactIMEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                [imEntity setUser:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];                if ([upperComponents count]>0) {
                    NSArray *subArr = [[upperComponents objectAtIndex:0] componentsSeparatedByString:@";"];
                    if ([subArr count]>=2) {
                        NSArray *subArr1 = [[subArr objectAtIndex:1] componentsSeparatedByString:@"="];
                        [imEntity setService:[[subArr1 lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }
                }
                
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [imEntity setLabel:[self getValueInangle:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]]];
                    
                    i++;
                }
                [imEntity setType:@"other"];
                [imEntity setEntityID:[NSNumber numberWithInt:g1]];
                g1++;
                [imEntity setContactCategory:Contact_IM];
                [entity.IMArray addObject:imEntity];
                [imEntity release];
                
            }
            
            
        }else if ([line hasPrefix:@"END:"]&&entity != nil)
        {
            [contactArray addObject:entity];
            [entity release];
            entity = nil;
        }
        
    }
    
    
    /* for (IMBContactEntity *entity in contactArray) {
     
     for (IMBContactKeyValueEntity *dateEntity in entity.dateArray) {
     
     
     }
     for (IMBContactKeyValueEntity *urlEntity in entity.urlArray) {
     
     
     }
     for (IMBContactKeyValueEntity *relatedEntity in entity.relatedNameArray) {
     
     
     }
     for (IMBContactKeyValueEntity *phoneEntity in entity.phoneNumberArray) {
     
     
     }
     for (IMBContactIMEntity *imEntity in entity.IMArray) {
     
     
     }
     for (IMBContactAddressEntity *addressEntity in entity.addressArray) {
     
     
     }
     for (IMBContactKeyValueEntity *emailEntity in entity.emailAddressArray) {
     
     
     }
     
     
     }*/
    
    return contactArray;
}

- (NSMutableArray *)parseNoteCSV:(NSString *)path {
    NSMutableArray *notecontentArray = [NSMutableArray array];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *contentData = [fileHandle readDataToEndOfFile];
    NSString *contentStr = [[NSString alloc] initWithData:contentData encoding:NSUTF8StringEncoding];
    NSArray *contentArray = [contentStr componentsSeparatedByString:@";Separator;"];
    for (int i=0;i<[contentArray count];i++) {
        NSString *str = [contentArray objectAtIndex:i];
        if (i== 0) {
            NSString *str2 = [NSString stringWithFormat:@"%@,%@,%@,%@",CustomLocalizedString(@"List_Header_id_Title", nil),CustomLocalizedString(@"backup_id_text_1", nil),CustomLocalizedString(@"MenuItem_id_17", nil),CustomLocalizedString(@"MenuItem_id_56", nil)];
            if (![str hasPrefix:str2]) {
                return notecontentArray;
            }
        }else{
            NSArray *noteArray = [str componentsSeparatedByString:@",element,"];
            if ([noteArray count]>0) {
                IMBNoteModelEntity *note = [[IMBNoteModelEntity alloc] init];
                note.checkState = Check;
                for (int j = 0;j<[noteArray count];j++) {
                    if (j==0) {
                        NSString *title = [noteArray objectAtIndex:j];
                        [note setTitle:title];
                    }else if (j==1) {
                        NSString *dateStr = [noteArray objectAtIndex:j];
                        [note setCreatDateStr:dateStr];
                    }else if (j==2) {
                        NSString *notestr = [noteArray objectAtIndex:j];
                        [note setContent:notestr];
                    }
                }
                [notecontentArray addObject:note];
                [note release];
            }
        }
    }
    [contentStr release];
    
    
    return notecontentArray;
}

- (NSString *)getValueInangle:(NSString *)str {
    NSScanner *theScanner = [NSScanner scannerWithString:str];
    NSString *text = nil;
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
    }
    if ([text hasPrefix:@"<"]) {
        text = [text stringByReplacingOccurrencesOfString:@"<" withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@">" withString:@""];
        return text;
    }else
    {
        return str;
    }
}

- (void)initCategoryTableView {
    _catagoryArray = [[NSMutableArray alloc] init];
    [_addCategoryAryM removeAllObjects];
    if (_musicArray.count > 0) {
        IMBCategoryEntity *entity = [[[IMBCategoryEntity alloc] init] autorelease];
        entity.name = CustomLocalizedString(@"MenuItem_id_1", nil);
        entity.picName = [StringHelper imageNamed:@"select_audio_music"];
        entity.checkState = Check;
        entity.resultArray = _musicArray;
        entity.size = [self getCapacityFormArry:(NSMutableArray *)_musicArray];
        entity.category = AddCategry_Music;
        [_catagoryArray addObject:entity];
        entity.delegate = self;
        [_addCategoryAryM addObject:[NSNumber numberWithInt:Category_Music]];
    }
    if (_videoArray.count > 0) {
        IMBCategoryEntity *entity = [[[IMBCategoryEntity alloc] init] autorelease];
        entity.name = CustomLocalizedString(@"MenuItem_id_33", nil);
        entity.picName = [StringHelper imageNamed:@"select_video_movies"];
        entity.checkState = Check;
        entity.resultArray = _videoArray;
        entity.size = [self getCapacityFormArry:(NSMutableArray *)_videoArray];
         entity.category = AddCategry_Video;
        [_catagoryArray addObject:entity];
        entity.delegate = self;
        [_addCategoryAryM addObject:[NSNumber numberWithInt:Category_Movies]];
    }
    if (_ringtoneArray.count > 0) {
        IMBCategoryEntity *entity = [[[IMBCategoryEntity alloc] init] autorelease];
        entity.name = CustomLocalizedString(@"MenuItem_id_2", nil);
        entity.picName = [StringHelper imageNamed:@"select_audio_ringtones"];
        entity.checkState = Check;
        entity.resultArray = _ringtoneArray;
        entity.size = [self getCapacityFormArry:(NSMutableArray *)_ringtoneArray];
         entity.category = AddCategry_Ringtone;
        [_catagoryArray addObject:entity];
        entity.delegate = self;
        [_addCategoryAryM addObject:[NSNumber numberWithInt:Category_Ringtone]];
    }
    if (_voiceMemoArray.count > 0) {
        IMBCategoryEntity *entity = [[[IMBCategoryEntity alloc] init] autorelease];
        entity.name = CustomLocalizedString(@"MenuItem_id_5", nil);
        entity.picName = [StringHelper imageNamed:@"select_audio_voicememo"];
        entity.checkState = Check;
        entity.resultArray = _voiceMemoArray;
        entity.size = [self getCapacityFormArry:(NSMutableArray *)_voiceMemoArray];
         entity.category = AddCategry_VoiceMemo;
        [_catagoryArray addObject:entity];
        entity.delegate = self;
        [_addCategoryAryM addObject:[NSNumber numberWithInt:Category_VoiceMemos]];
    }
    if (_appArray.count > 0) {
        IMBCategoryEntity *entity = [[[IMBCategoryEntity alloc] init] autorelease];
        entity.name = CustomLocalizedString(@"MenuItem_id_14", nil);
        entity.picName = [StringHelper imageNamed:@"select_app"];
        entity.checkState = Check;
        entity.resultArray = _appArray;
        entity.size = [self getCapacityFormArry:(NSMutableArray *)_appArray];
         entity.category = AddCategry_App;
        [_catagoryArray addObject:entity];
        entity.delegate = self;
        [_addCategoryAryM addObject:[NSNumber numberWithInt:Category_Applications]];
    }
    if (_bookArray.count > 0) {
        IMBCategoryEntity *entity = [[[IMBCategoryEntity alloc] init] autorelease];
        entity.name = CustomLocalizedString(@"MenuItem_id_13", nil);
        entity.picName = [StringHelper imageNamed:@"select_book"];
        entity.checkState = Check;
        entity.resultArray = _bookArray;
        entity.size = [self getCapacityFormArry:(NSMutableArray *)_bookArray];
         entity.category = AddCategry_Book;
        [_catagoryArray addObject:entity];
        entity.delegate = self;
        [_addCategoryAryM addObject:[NSNumber numberWithInt:Category_iBooks]];
    }
    if (_photoArray.count > 0) {
        IMBCategoryEntity *entity = [[[IMBCategoryEntity alloc] init] autorelease];
        entity.name = CustomLocalizedString(@"DeviceView_id_6", nil);
        entity.picName = [StringHelper imageNamed:@"select_photo_library"];
        entity.checkState = Check;
        entity.resultArray = _photoArray;
        entity.size = [self getCapacityFormArry:(NSMutableArray *)_photoArray];
         entity.category = AddCategry_Photo;
        [_catagoryArray addObject:entity];
        entity.delegate = self;
        [_addCategoryAryM addObject:[NSNumber numberWithInt:Category_PhotoLibrary]];
    }
    
    if (_contactArray.count > 0) {
        IMBCategoryEntity *entity = [[[IMBCategoryEntity alloc] init] autorelease];
        entity.name = CustomLocalizedString(@"MenuItem_id_20", nil);
        entity.picName = [StringHelper imageNamed:@"select_contact"];
        entity.checkState = Check;
        entity.resultArray = _contactArray;
        entity.size = 0;
        entity.category = AddCategry_Contact;
        [_catagoryArray addObject:entity];
        entity.delegate = self;
        [_addCategoryAryM addObject:[NSNumber numberWithInt:Category_Contacts]];
    }
    
    if (_noteArray.count > 0) {
        IMBCategoryEntity *entity = [[[IMBCategoryEntity alloc] init] autorelease];
        entity.name = CustomLocalizedString(@"MenuItem_id_17", nil);
        entity.picName = [StringHelper imageNamed:@"select_note"];
        entity.checkState = Check;
        entity.resultArray = _noteArray;
        entity.size = 0;
        entity.category = AddCategry_Note;
        [_catagoryArray addObject:entity];
        entity.delegate = self;
        [_addCategoryAryM addObject:[NSNumber numberWithInt:Category_Notes]];
    }
    if ([_delegate isKindOfClass:[IMBDeviceMainPageViewController class]]) {
        [(IMBDeviceMainPageViewController *)_delegate setAddContentCategoryAryM:_addCategoryAryM];
    }
}

- (void)initDetailTableView {
    HoverButton *backBtn = [[HoverButton alloc] init];
    [backBtn setMouseEnteredImage:[StringHelper imageNamed:@"addcontent_arrow2"] mouseExitImage:[StringHelper imageNamed:@"addcontent_arrow1"] mouseDownImage:[StringHelper imageNamed:@"addcontent_arrow3"]];
    [backBtn setTarget:self];
    [backBtn setAction:@selector(backView)];
    [backBtn setFrame:NSMakeRect(10, 12, 16, 16)];
    [topView addSubview:backBtn];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
}

- (uint)getCapacityFormArry:(NSMutableArray *)array {
    uint allsize = 0;
    if (_isiCloudAdd) {
        for (IMBPhotoEntity  *track in array) {
            if (track.checkState == Check) {
                allsize += track.photoSize;
            }
        }
    }else{
        for (IMBTrack *track in array) {
            if (track.checkState == Check) {
                allsize += track.fileSize;
            }
        }
    }
   
    return allsize;
}

- (void)getFileNames:(NSArray *)fileNames byFileExtensions:(NSArray *)fileExtensions toArray:(NSMutableArray *)array{
    @autoreleasepool {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        for (NSString *string in fileNames) {
            if ([[fileManager attributesOfItemAtPath:string error:nil] fileType] == NSFileTypeDirectory) {
                NSError *error = nil;
                NSArray *items = [fileManager subpathsOfDirectoryAtPath:string error:&error];
                if (error != nil) {
                    NSLog(@"error:%@",error);
                }
                for (NSString *path in items) {
                    path = [string stringByAppendingPathComponent:path];
                    NSString *extension = [path pathExtension].lowercaseString;
                    if ([fileExtensions containsObject:extension]) {
                        [array addObject:path];
                    }
                }
            }
            else{
                NSString *extension = [string pathExtension].lowercaseString;
                if(extension.length > 0 && [fileExtensions containsObject:extension]){
                    [array addObject:string];
                }
            }
        }
    }
}

- (IBAction)closeWindow:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
    [self.view setFrame:NSMakeRect(0, -20, self.view.frame.size.width, self.view.frame.size.height + 20)];
    [self.view setWantsLayer:YES];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0 ]Y:[NSNumber numberWithInt:20] repeatCount:1];
        anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.view.layer addAnimation:anima1 forKey:@"deviceImageView"];
    } completionHandler:^{
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:20] Y:[NSNumber numberWithInt:-self.view.frame.size.height] repeatCount:1];
        anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.view.layer addAnimation:anima1 forKey:@"deviceImageView"];
        [self showTopLineView];
    }];
    [self performSelector:@selector(removeAnimationView) withObject:nil afterDelay:0.6];
    NSString *str = @"open";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
}

- (void)removeAnimationView {
    [self.view removeFromSuperview];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (tableView == _catagoryTableView) {
        return _catagoryArray.count;
    }else {
        return _detailArray.count;
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == _catagoryTableView && row < _catagoryArray.count) {
        IMBCategoryEntity *entity = [_catagoryArray objectAtIndex:row];
        if ([tableColumn.identifier isEqualToString:@"CheckCol"]) {
            return [NSNumber numberWithInt:entity.checkState];
        }else if ([tableColumn.identifier isEqualToString:@"Image"]) {
            return @"";
        }else if ([tableColumn.identifier isEqualToString:@"Name"]) {
            return entity.name;
        }else if ([tableColumn.identifier isEqualToString:@"Item"]) {
            NSArray *array = [self getSelectTracksFromCategoryEntity:entity];
            if (array.count <= 1) {
               return  [[NSString stringWithFormat:@"%d ",(int)array.count] stringByAppendingString:CustomLocalizedString(@"annoy_id_2", nil)];
            }else {
                    return [[NSString stringWithFormat:@"%d ",(int)array.count] stringByAppendingString:CustomLocalizedString(@"annoy_id_3", nil)];
            }
        }else if ([tableColumn.identifier isEqualToString:@"Size"]) {
            if (_isiCloudAdd) {
                if (entity.category == AddCategry_Photo) {
                    NSArray *array  = [self getSelectTracksFromCategoryEntity:entity];
                    uint selectSize = 0;
                    for (IMBPhotoEntity *track in array) {
                        selectSize += track.photoSize;
                    }
                    if (selectSize == 0) {
                        return @"--";
                    }else if (selectSize < 1024 * 1024) {
                        return [NSString stringWithFormat:@"%.1fKB",(float)selectSize/1024];
                    }
                    else if (selectSize < 1024 * 1024 * 1024) {
                        return [NSString stringWithFormat:@"%.1fMB",(float)selectSize/1024/1024];
                    }
                    else if (selectSize / 1024 < 1024 * 1024 * 1024) {
                        return [NSString stringWithFormat:@"%.1fGB",(float)selectSize/1024/1024/1024];
                    }

                }else{
                    return @"--";
                }
            }else{
                NSArray *array  = [self getSelectTracksFromCategoryEntity:entity];
                uint selectSize = 0;
                for (IMBTrack *track in array) {
                    selectSize += track.fileSize;
                }
                if (selectSize == 0) {
                    return @"--";
                }else if (selectSize < 1024 * 1024) {
                    return [NSString stringWithFormat:@"%.1fKB",(float)selectSize/1024];
                }
                else if (selectSize < 1024 * 1024 * 1024) {
                    return [NSString stringWithFormat:@"%.1fMB",(float)selectSize/1024/1024];
                }
                else if (selectSize / 1024 < 1024 * 1024 * 1024) {
                    return [NSString stringWithFormat:@"%.1fGB",(float)selectSize/1024/1024/1024];
                }

            }
            
        }else if ([tableColumn.identifier isEqualToString:@"Next"]) {
            return @"";
        }
    }else {
        if (row < _detailArray.count) {
            if (_isiCloudAdd) {
                id item = [_detailArray objectAtIndex:row];
                if ([item isKindOfClass:[IMBPhotoEntity class]]) {
                    IMBPhotoEntity *entity = (IMBPhotoEntity *)item;
                    if ([tableColumn.identifier isEqualToString:@"CheckCol"]) {
                        return [NSNumber numberWithInt:entity.checkState];
                    }else if ([tableColumn.identifier isEqualToString:@"Name"]) {
                        return entity.photoTitle;
                    }else if ([tableColumn.identifier isEqualToString:@"Time"]) {
                        return @"-";
                    }else if ([tableColumn.identifier isEqualToString:@"Size"]) {
                        return [StringHelper getFileSizeString:entity.photoSize reserved:2];
                    }
                    
                }else if ([item isKindOfClass:[IMBNoteModelEntity class]]){
                    IMBNoteModelEntity *entity = (IMBNoteModelEntity *)item;
                    if ([tableColumn.identifier isEqualToString:@"CheckCol"]) {
                        return [NSNumber numberWithInt:entity.checkState];
                    }else if ([tableColumn.identifier isEqualToString:@"Name"]) {
                        return entity.title;
                    }else if ([tableColumn.identifier isEqualToString:@"Time"]) {
                        return @"-";
                    }
                }else if ([item isKindOfClass:[IMBContactEntity class]]){
                    IMBContactEntity *entity = (IMBContactEntity *)item;
                    if ([tableColumn.identifier isEqualToString:@"CheckCol"]) {
                        return [NSNumber numberWithInt:entity.checkState];
                    }else if ([tableColumn.identifier isEqualToString:@"Name"]) {
                        return [NSString stringWithFormat:@"%@%@%@",entity.lastName,entity.middleName,entity.firstName];
                    }else if ([tableColumn.identifier isEqualToString:@"Time"]) {
                        return @"-";
                    }
                }
            }else{
                IMBTrack *track = [_detailArray objectAtIndex:row];
                if ([tableColumn.identifier isEqualToString:@"CheckCol"]) {
                    return [NSNumber numberWithInt:track.checkState];
                }else if ([tableColumn.identifier isEqualToString:@"Name"]) {
                    return track.title;
                }else if ([tableColumn.identifier isEqualToString:@"Time"]) {
                    if (track.length == 0) {
                        return @"--";
                    }else {
                        return [StringHelper getTimeString:track.length];
                    }
                }else if ([tableColumn.identifier isEqualToString:@"Artist"]) {
                    return track.artist;
                }else if ([tableColumn.identifier isEqualToString:@"Album"]) {
                    return track.album;
                }else if ([tableColumn.identifier isEqualToString:@"Size"]) {
                    return [StringHelper getFileSizeString:track.fileSize reserved:2];
                }
            }
            
        }
    }
    return @"";
}

- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    if (tableView == _catagoryTableView) {
        IMBCategoryEntity *entity = [_catagoryArray objectAtIndex:index];
        entity.checkState = !entity.checkState;

        if (_isiCloudAdd) {
            if (entity.checkState == UnChecked) {
                for (IMBBaseEntity *track in entity.resultArray) {
                    track.checkState = UnChecked;
                }
            }else if (entity.checkState == Check) {
                for (IMBTrack *track in entity.resultArray) {
                    track.checkState = Check;
                }
            }
        }else{
            if (entity.checkState == UnChecked) {
                for (IMBBaseEntity *track in entity.resultArray) {
                    track.checkState = UnChecked;
                }
            }else if (entity.checkState == Check) {
                for (IMBBaseEntity *track in entity.resultArray) {
                    track.checkState = Check;
                }
            }
        }
        [_catagoryTableView reloadData];
    }else {
        if (_isiCloudAdd) {
            IMBBaseEntity *track = [_detailArray objectAtIndex:index];
            track.checkState = !track.checkState;
        }else{
            IMBTrack *track = [_detailArray objectAtIndex:index];
            track.checkState = !track.checkState;
            [self setDetailStringValueWithCategory:_detailArray];
            if (track.checkState == UnChecked && [_selectArray containsObject:track.srcFilePath]) {
                [_selectArray removeObject:track.srcFilePath];
            }else if (track.checkState == Check) {
                [_selectArray addObject:track.srcFilePath];
            }
        }
        [_detailTableView reloadData];

    }
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row  {
    if (tableView == _catagoryTableView) {
        IMBCategoryEntity *entity = [_catagoryArray objectAtIndex:row];
        if ([tableColumn.identifier isEqualToString:@"Image"]) {
            if (row > _catagoryArray.count) {
                return;
            }
            IMBImageTextFieldCell *curCell = (IMBImageTextFieldCell *)cell;
            [curCell setImageSize:NSMakeSize(34, 34)];
            curCell.image = entity.picName;
            curCell.marginX = 0;
        }else if ([tableColumn.identifier isEqualToString:@"Next"]) {
            NextCell *nextCell = (NextCell *)cell;
            nextCell.nextBtn = entity.nextBtn;
        }
    }
}

- (NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes {
//    if (_catagoryTableView == tableView) {
        return nil;
//    }else {
//        return proposedSelectionIndexes;
//    }
}

- (void)viewRemoveFromSuperview:(NSView *)view {
//    if (view == _detailView) {
//        [_categoryView setFrameOrigin:NSMakePoint(2, 2)];
//        [_contentView addSubview:_categoryView];
//    }else {
        [view removeFromSuperview];
//    }
}

- (void)setDetailStringValueWithCategory:(NSMutableArray *) allArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (IMBBaseEntity *track in allArray) {
        if (track.checkState == Check) {
            [array addObject:track];
        }
    }
    
    if (array.count <= 1) {
        [_detailViewCount setStringValue:[[NSString stringWithFormat:@"%d ",(int)array.count] stringByAppendingString:CustomLocalizedString(@"annoy_id_2", nil)]];
    }else {
        [_detailViewCount setStringValue:[[NSString stringWithFormat:@"%d ",(int)array.count] stringByAppendingString:CustomLocalizedString(@"annoy_id_3", nil)]];
    }
    [array release], array = nil;
}

- (void)backView {
    for (IMBCategoryEntity *entity in _catagoryArray) {
        int i = 0;
        for (IMBTrack *track in entity.resultArray) {
            if (track.checkState == Check) {
                i ++;
            }
        }
        if (i == entity.resultArray.count) {
            entity.checkState = Check;
        }else if (i == 0) {
            entity.checkState = UnChecked;
        }else {
            entity.checkState = SemiChecked;
        }
    }
    [_catagoryTableView reloadData];
    
    [_contentView setWantsLayer:YES];
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
//    transition.removedOnCompletion = NO;
//    transition.fillMode = kCAFillModeForwards;
    [_contentView.layer addAnimation:transition forKey:@"animation"];
    [_contentView addSubview:_categoryView];
    
//    [_detailView removeFromSuperview];
    [self performSelector:@selector(viewRemoveFromSuperview:) withObject:_detailView afterDelay:0.5];
    
    
//    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//        [_categoryView setFrame:NSMakeRect(2, 2, 544, 296)];
//        [_contentView addSubview:_categoryView];
//        [_categoryView setAlphaValue:0.2];
//        [_categoryView setWantsLayer:YES];
//        [_detailView.layer  addAnimation:[IMBAnimation moveX:0.5 fromX:[NSNumber numberWithInt:-546] toX:[NSNumber numberWithInt:0] repeatCount:1 beginTime:0] forKey:@"movex"];
//    } completionHandler:^{
//        
//        [_categoryView setAlphaValue:1.0];
//        [_detailView removeFromSuperview];
//    }];
    [_detailTableView reloadData];
    
}

-(void)loadDetailView:(AddContentCategoryEnum )category {
    if (_detailArray != nil) {
        [_detailArray release];
        _detailArray = nil;
    }
    [_detailViewTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_detailViewCount setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    if (category == AddCategry_Music ) {
        _detailArray = [_musicArray retain];
        [_detailViewTitle setStringValue:CustomLocalizedString(@"MenuItem_id_1", nil)];
        [self setDetailStringValueWithCategory:_musicArray];
    }else if (category == AddCategry_Video) {
        _detailArray = [_videoArray retain];
        [_detailViewTitle setStringValue:CustomLocalizedString(@"MenuItem_id_33", nil)];
        [self setDetailStringValueWithCategory:_videoArray];
    }else if (category == AddCategry_VoiceMemo) {
        _detailArray = [_voiceMemoArray retain];
        [_detailViewTitle setStringValue:CustomLocalizedString(@"MenuItem_id_5", nil)];
        [self setDetailStringValueWithCategory:_voiceMemoArray];
    }else if (category == AddCategry_Ringtone) {
        _detailArray = [_ringtoneArray retain];
        [_detailViewTitle setStringValue:CustomLocalizedString(@"MenuItem_id_2", nil)];
        [self setDetailStringValueWithCategory:_ringtoneArray];
    }else if (category == AddCategry_App) {
        _detailArray = [_appArray retain];
        [_detailViewTitle setStringValue:CustomLocalizedString(@"MenuItem_id_14", nil)];
        [self setDetailStringValueWithCategory:_appArray];
    }else if (category == AddCategry_Book) {
        _detailArray = [_bookArray retain];
        [_detailViewTitle setStringValue:CustomLocalizedString(@"MenuItem_id_13", nil)];
        [self setDetailStringValueWithCategory:_bookArray];
    }else if (category == AddCategry_Photo) {
        _detailArray = [_photoArray retain];
        [_detailViewTitle setStringValue:CustomLocalizedString(@"DeviceView_id_6", nil)];
        [self setDetailStringValueWithCategory:_photoArray];
    }else if (category == AddCategry_Contact) {
        _detailArray = [_contactArray retain];
        [_detailViewTitle setStringValue:CustomLocalizedString(@"MenuItem_id_20", nil)];
        [self setDetailStringValueWithCategory:_contactArray];
    }else if (category == AddCategry_Note) {
        _detailArray = [_noteArray retain];
        [_detailViewTitle setStringValue:CustomLocalizedString(@"MenuItem_id_17", nil)];
        [self setDetailStringValueWithCategory:_noteArray];
    }
    
    [_contentView setWantsLayer:YES];
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    [_contentView.layer addAnimation:transition forKey:@"animation"];
    [_detailView setFrameOrigin:NSMakePoint(2, 2)];
    [_contentView addSubview:_detailView];
    [self performSelector:@selector(viewRemoveFromSuperview:) withObject:_categoryView afterDelay:0.5];
//    [_categoryView removeFromSuperview];
    [_detailTableView reloadData];
    
    //    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
    //        [_detailView setFrame:NSMakeRect(2, 2, 544, 296)];
    //        [_contentView addSubview:_detailView];
    //        [_detailView setWantsLayer:YES];
    //        [_detailView.layer  addAnimation:[IMBAnimation moveX:0.5 fromX:[NSNumber numberWithInt:546] toX:[NSNumber numberWithInt:0] repeatCount:1 beginTime:0] forKey:@"movex"];
    //    } completionHandler:^{
    //        [_categoryView removeFromSuperview];
    //    }];
    //    [_detailTableView reloadData];
    
}

- (NSArray *)getSelectTracksFromCategoryEntity:(IMBCategoryEntity *)entity {
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    for (IMBBaseEntity *track in entity.resultArray) {
        if (track.checkState == Check) {
            [array addObject:track];
        }
    }
    return array;
}

- (void)startTransfer {
    IMBTransferViewController * transferController = nil;
    if (_isiCloudAdd) {
        int i = 0;
        NSMutableArray *photoArray = [NSMutableArray array];
        NSMutableArray *contactArray = [NSMutableArray array];
        NSMutableArray *noteArray = [NSMutableArray array];
        for (IMBBaseEntity *entity in _photoArray) {
            if (entity.checkState == Check) {
                i++;
                [photoArray addObject:entity];
            }
        }
        
        for (IMBBaseEntity *entity in _contactArray) {
            if (entity.checkState == Check) {
                i++;
                [contactArray addObject:entity];
            }
        }
        
        for (IMBBaseEntity *entity in _noteArray) {
            if (entity.checkState == Check) {
                i++;
                [noteArray addObject:entity];
            }
        }
        if (i == 0) {
            if ([_delegate respondsToSelector:@selector(showAlertText: OKButton:)]) {
                [_delegate showAlertText:CustomLocalizedString(@"MSG_COM_No_Item_Selected", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            }
            return ;
        }
        
        transferController = [[IMBTransferViewController alloc] initWithIPodkey:nil Type:category_iCloudUp importFiles:[NSMutableArray arrayWithObjects:photoArray,contactArray,noteArray, nil] photoAlbum:nil playlistID:0];
        transferController.icloudManager = _icloudManager;
        transferController.isicloudView = YES;
    }else{
        if (_selectArray.count == 0) {
            if ([_delegate respondsToSelector:@selector(showAlertText: OKButton:)]) {
                [_delegate showAlertText:CustomLocalizedString(@"MSG_COM_No_Item_Selected", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            }
            return ;
        }
         transferController = [[IMBTransferViewController alloc] initWithIPodkey:_iPod.uniqueKey Type:Category_Summary importFiles:_selectArray photoAlbum:_photoAlbum playlistID:0];
    }
    
    [transferController setDelegate:_delegate];
     [transferController.view setFrame:NSMakeRect(0, 0, [(IMBBaseViewController *)_delegate view].frame.size.width, [(IMBDeviceMainPageViewController *)_delegate view].frame.size.height)];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [[(IMBBaseViewController *)_delegate view] addSubview:transferController.view];
        [transferController.view setWantsLayer:YES];
        [transferController.view.layer  addAnimation:[IMBAnimation moveX:0.5 fromX:[NSNumber numberWithInt:transferController.view.frame.size.width] toX:[NSNumber numberWithInt:0] repeatCount:1 beginTime:0] forKey:@"movex"];

    } completionHandler:^{
        [self.view removeFromSuperview];
        [self release];
    }];

}

- (void)showTopLineView {
    if (_delegate && [_delegate respondsToSelector:@selector(setTrackingAreaEnable:)]) {
        [_delegate setTrackingAreaEnable:YES];
    }
}

- (void)dealloc {
    if (_iPod != nil) {
        [_iPod release];
        _iPod = nil;
    }
    if (_allPaths != nil) {
        [_allPaths release];
        _allPaths = nil;
    }
    if (_photoAlbum != nil) {
        [_photoAlbum release];
        _photoAlbum = nil;
    }
    if (_musicArray != nil) {
        [_musicArray release];
        _musicArray = nil;
    }
    if (_videoArray != nil) {
        [_videoArray release];
        _videoArray = nil;
    }
    if (_voiceMemoArray != nil) {
        [_voiceMemoArray release];
        _voiceMemoArray = nil;
    }
    if (_ringtoneArray != nil) {
        [_ringtoneArray release];
        _ringtoneArray = nil;
    }
    if (_appArray != nil) {
        [_appArray release];
        _appArray = nil;
    }
    if (_photoArray != nil) {
        [_photoArray release];
        _photoArray = nil;
    }
    if (_bookArray != nil) {
        [_bookArray release];
        _bookArray = nil;
    }
    if (_catagoryArray != nil) {
        [_catagoryArray release];
        _catagoryArray = nil;
    }
    if (_detailArray != nil) {
        [_detailArray release];
        _detailArray = nil;
    }
    if (_selectArray != nil) {
        [_selectArray release];
        _selectArray = nil;
    }
    if (_addCategoryAryM != nil) {
        [_addCategoryAryM release];
        _addCategoryAryM = nil;
    }
    [super dealloc];
}

@end

@implementation IMBCategoryEntity
@synthesize name = _name;
@synthesize picName = _picName;
@synthesize resultArray = _resultArray;
@synthesize size = _size;;
@synthesize itemsCount = _itemsCount;
@synthesize category = _category;
@synthesize checkState = _checkState;
@synthesize nextBtn = _nextBtn;
@synthesize delegate = _delegate;
- (id)init {
    if (self = [super init]) {
        _resultArray = [[NSMutableArray alloc]init];
        _nextBtn = [[HoverButton alloc] initWithFrame:NSMakeRect(0, 0, 20, 20)];
        [_nextBtn setMouseEnteredImage:[StringHelper imageNamed:@"addcontent_arrowright2"] mouseExitImage:[StringHelper imageNamed:@"addcontent_arrowright1"] mouseDownImage:[StringHelper imageNamed:@"addcontent_arrowright3"]];
        [_nextBtn setTarget:self];
        [_nextBtn setAction:@selector(nextView:)];
    }
    return self;
}

- (void)nextView:(id)sender {
    if ([_delegate respondsToSelector:@selector(loadDetailView:)]) {
        [_delegate loadDetailView:self.category];
    }

}

-(void)dealloc {
    if (_resultArray) {
        [_resultArray release];
        _resultArray = nil;
    }
    if (_nextBtn != nil) {
        [_nextBtn release];
        _nextBtn = nil;
    }

    [super dealloc];
}

@end
