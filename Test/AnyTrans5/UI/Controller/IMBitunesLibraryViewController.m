//
//  IMBitunesLibraryViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBitunesLibraryViewController.h"
#import "HoverButton.h"
#import "IMBAllMediaViewController.h"
#import "IMBPlaylistViewController.h"
#import "IMBiTunesCategoryBindData.h"
#import "IMBNotificationDefine.h"
#import "IMBiTunesTrackViewController.h"
#import "IMBAppsListViewController.h"
#import "IMBPopController.h"
#import "IMBNotificationDefine.h"
#import "IMBAnimation.h"
#import "IMBBackgroundBorderView.h"
#import "ATTracker.h"
#import "CommonEnum.h"
#import "SystemHelper.h"
#import "IMBMainWindowController.h"

@interface IMBitunesLibraryViewController ()

@end

@implementation IMBitunesLibraryViewController
@synthesize bindCategoryArray = _bindCategoryArray;
@synthesize categoryView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
         [_toolBar changeBtnTooltipStr];
        [self setBindCategoryArray:[self createCategoryItems]];
        NSString *str = CustomLocalizedString(@"iTunes_Default_Title", nil);
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
        
        if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:40] range:NSMakeRange(0, as.length)];
        }else {
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:40] range:NSMakeRange(0, as.length)];
        }
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
        
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [_disConnectTitleStr setAttributedStringValue:as];
        
        NSString *str2 = CustomLocalizedString(@"iTunes_Default_Describe", nil);
        NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc]initWithString:str2];
        [as2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, as2.length)];
        [as2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as2.length)];
        [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as2.length)];
        [_disSubTitleStr setAttributedStringValue:as2];
    });
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_loadView setWantsLayer:YES];
    [_loadView.layer setMasksToBounds:YES];
    [_loadView.layer setCornerRadius:5];
    [_loadView setIsGradientColorNOCornerPart4:YES];
    [_loadTwoView setWantsLayer:YES];
    [_loadTwoView.layer setMasksToBounds:YES];
    [_loadTwoView.layer setCornerRadius:5];
    [_loadTwoView setIsGradientColorNOCornerPart3:YES];
    [((IMBBackgroundBorderView *)self.view) setIsGradientWithCornerPart4:YES];
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_alertViewController setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    [_box setContentView:_loadView];
    [_loadAnimationView startAnimation];
    [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(4),@(5), nil] Target:self DisplayMode:NO];
    [bgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [bgView initWithLuCorner:NO LbCorner:YES RuCorner:NO RbConer:YES CornerRadius:5];
    nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(onCollectionCreated:) name:COLLECTION_ITEM_CREATED object:nil];
    
    [_collectionView setFocusRingType:NSFocusRingTypeNone];
    [_collectionView setBackgroundColors:[NSArray arrayWithObjects:[NSColor clearColor], nil]];
    _contentViewControllerDic = [[NSMutableDictionary alloc] init];
    lastBinditem = [[IMBiTunesCategoryBindData alloc] init];
    
    NSString *str = CustomLocalizedString(@"iTunes_Default_Title", nil);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:40] range:NSMakeRange(0, as.length)];
    }else {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:40] range:NSMakeRange(0, as.length)];
    }
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
    
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_disConnectTitleStr setAttributedStringValue:as];
    
    NSString *str2 = CustomLocalizedString(@"iTunes_Default_Describe", nil);
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc]initWithString:str2];
    [as2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, as2.length)];
    [as2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as2.length)];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as2.length)];
    [_disSubTitleStr setAttributedStringValue:as2];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _iTunes = [IMBiTunes singleton];
        [_iTunes parserLibrary];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadAnimationView endAnimation];
            NSMutableArray *ituneslibAry = nil;
            IMBiTLPlaylist *pl = [_iTunes getPlaylistByDistinguished:[IMBiTunesEnum getDistinguishedKindId:Category_iTunes_lib]];
            if (pl != nil) {
                ituneslibAry = pl.playlistItems;
            }
            NSMutableArray *itunesAPPAry = nil;
            IMBiTLPlaylist *pl2 = [_iTunes getPlaylistByDistinguished:[IMBiTunesEnum getDistinguishedKindId:Category_iTunes_App]];
            if (pl2 != nil) {
                itunesAPPAry = pl2.playlistItems;
            }
            _itunesIsOpen = _iTunes.isOpeniTunes;
            if (!_iTunes.isOpeniTunes) {
                NSLog(@"+++++++++++++++");
                [self performSelector:@selector(showAlert) withObject:nil afterDelay:0];
            }else {
                [self setBindCategoryArray:[self createCategoryItems]];
            }
            if (itunesAPPAry.count <= 0 && ituneslibAry.count <= 0) {
                [self setIsShowLineView:NO];
                [_disConnectView setWantsLayer:YES];
                [_disConnectView.layer setCornerRadius:5];
                [_box setContentView:_disConnectView];
                IMBMainWindowController *mainWindow = (IMBMainWindowController *)_delegate;
                if (mainWindow.curFunctionType == iTunesLibraryModule) {
                    [mainWindow.searchView setHidden:YES];
                }
            }else{
                [self setIsShowLineView:YES];
                [_box setContentView:_dataView];
                IMBMainWindowController *mainWindow = (IMBMainWindowController *)_delegate;
                if (mainWindow.curFunctionType == iTunesLibraryModule) {
                    [mainWindow.searchView setHidden:NO];
                }
            }
        });
    });
}

- (void)changeSkin:(NSNotification *)notification
{
    [_loadView setIsGradientColorNOCornerPart4:YES];
    [_loadTwoView setIsGradientColorNOCornerPart3:YES];
    [_loadView setNeedsDisplay:YES];
    [_loadTwoView setNeedsDisplay:YES];
    [bgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [bgView setNeedsDisplay:YES];
    [_collectionView setBackgroundColors:[NSArray arrayWithObjects:[NSColor clearColor], nil]];
    [self setBindCategoryArray:[self createCategoryItems]];
    [self.view setNeedsDisplay:YES];
    
    NSString *str = CustomLocalizedString(@"iTunes_Default_Title", nil);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:40] range:NSMakeRange(0, as.length)];
    }else {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:40] range:NSMakeRange(0, as.length)];
    }
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
    
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_disConnectTitleStr setAttributedStringValue:as];
    
    NSString *str2 = CustomLocalizedString(@"iTunes_Default_Describe", nil);
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc]initWithString:str2];
    [as2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, as2.length)];
    [as2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as2.length)];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as2.length)];
    [_disSubTitleStr setAttributedStringValue:as2];
    
    [_bgImageView setImage:[StringHelper imageNamed:@"noconnect_itunes"]];
    [self.view setWantsLayer:YES];
    [self.view.layer setCornerRadius:5];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"roseSkin"]) {
        NSRect frame =  _disConnectView.frame;
        frame.origin.y = self.view.frame.origin.y ;
        frame.size.width = self.view.frame.size.width;
        _disConnectView.frame = frame;
        [_bgImageView.cell setImageAlignment:NSImageAlignBottom];
    }else {
        NSRect frame =  _disConnectView.frame;
        frame.origin.y = self.view.frame.origin.y + 5;
        frame.size.width = self.view.frame.size.width;
        _disConnectView.frame = frame;
        [_bgImageView.cell setImageAlignment: NSImageAlignCenter];
    }
    [_disConnectView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMaxYMargin|NSViewWidthSizable|NSViewHeightSizable];
}

- (void)showAlert {
    [self showAlertText:CustomLocalizedString(@"MSG_Open_iTunes", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
}

#pragma mark 响应类别选项卡的事件
- (void)onCollectionCreated:(NSNotification*)notification {
    categoryView = (IMBCategoryView*)notification.object;
    NSString *identify = (NSString*)[notification.userInfo objectForKey:@"CategoryName"];
    IMBiTunesCategoryBindData *binditem = nil;
    for (IMBiTunesCategoryBindData *bindData in self.bindCategoryArray) {
        if ([bindData.categoryName isEqualToString:identify]) {
            binditem = bindData;
            break;
        }
    }
    
    if (categoryView != nil && binditem != nil) {
        [categoryView setDelegate:self];
        [categoryView setToolTip:binditem.displayName];
        [binditem setCategoryView:categoryView];
        if ([binditem.categoryName isEqualToString:@"Category_iTunes_lib"]) {
            [binditem.categoryView setIsSelected:YES];
            [binditem.categoryView setIsEntered:YES];
            [binditem.categoryView setNeedsDisplay:YES];
            [binditem setIsSelected:YES];
            [binditem.categoryView setNeedsDisplay:YES];
            [self selectCategoryChanged:binditem.categoryName];
        }
    }
    [_toolBar setNeedsDisplay:YES];
}

- (void)selectCategoryChanged:(NSString*)identify {
    if (lastCategoryString != nil) {
        [lastCategoryString release];
        lastCategoryString = nil;
    }
    lastCategoryString = [[NSString stringWithString:identify] retain];
    CategoryNodesEnum category = [IMBCommonEnum categoryNodesStringToEnum:identify];
    _itunesCategory = category;
    if (_curContenView != nil) {
        [_curContenView removeFromSuperview];
    }
    
    if (category == Category_iTunes_Playlist) {
        IMBPlaylistViewController *controller = [_contentViewControllerDic objectForKey:[IMBCommonEnum categoryNodesEnumToString:category]];
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:iTunes_Library action:ActionNone actionParams:@"iTunes Playlist" label:Switch transferCount:0 screenView:@"iTunes Playlist" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        if (controller == nil) {
            controller = [[IMBPlaylistViewController alloc] initWithCategory:Category_iTunes_Playlist withDelegate:self];
            [_contentViewControllerDic setObject:controller forKey:[IMBCommonEnum categoryNodesEnumToString:category]];
            _curContenView = [controller view];
            [_iTunesMainBox setContentView:_curContenView];
            [_searchFieldBtn setStringValue:@""];
            [controller reloadTableView];
        } else {
            if ([controller respondsToSelector:@selector(reloadList:)]) {
                [controller reloadList:Category_iTunes_Playlist];
            }
            _curContenView = [controller view];
            [_iTunesMainBox setContentView:_curContenView];
            [_searchFieldBtn setStringValue:@""];
            [controller reloadTableView];
        }
    }else if (category == Category_iTunes_lib) {
        IMBAllMediaViewController *controller = [_contentViewControllerDic objectForKey:[IMBCommonEnum categoryNodesEnumToString:category]];
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:iTunes_Library action:ActionNone actionParams:@"iTunes lib" label:Switch transferCount:0 screenView:@"iTunes lib" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        if (controller == nil) {
            controller = [[IMBAllMediaViewController alloc] initWithDistinguishedKindId:[IMBiTunesEnum getDistinguishedKindId:category] withDelegate:self];
            [_contentViewControllerDic setObject:controller forKey:[IMBCommonEnum categoryNodesEnumToString:category]];
            _curContenView = [controller view];
            [_iTunesMainBox setContentView:_curContenView];
            [_searchFieldBtn setStringValue:@""];
            [controller reloadTableView];
        } else {
            if ([controller respondsToSelector:@selector(reloadList:)]) {
                [controller reloadList:[IMBiTunesEnum getDistinguishedKindId:category]];
            }
            _curContenView = [controller view];
            
            [_iTunesMainBox setContentView:_curContenView];
            [_searchFieldBtn setStringValue:@""];
            [controller reloadTableView];
        }
    }
    else {
        IMBiTunesTrackViewController *controller = [_contentViewControllerDic objectForKey:[IMBCommonEnum categoryNodesEnumToString:category]];
        if (controller == nil) {
            controller = [[IMBiTunesTrackViewController alloc] initWithDistinguishedKindId:[IMBiTunesEnum getDistinguishedKindId:category] withCategory:category withDelegate:self];
            [_contentViewControllerDic setObject:controller forKey:[IMBCommonEnum categoryNodesEnumToString:category]];
            _curContenView = [controller view];
            [_iTunesMainBox setContentView:_curContenView];
            [_searchFieldBtn setStringValue:@""];
            [controller reloadTableView];
        } else {
            if ([controller respondsToSelector:@selector(reloadList:)]) {
                [controller reloadList:Category_iTunes_Playlist];
            }
            _curContenView = [controller view];
            [_iTunesMainBox setContentView:_curContenView];
            [_searchFieldBtn setStringValue:@""];
            [controller reloadTableView];
        }
    }
}

#pragma mark 创建相关的iTunes类别选项卡
- (NSMutableArray*)createCategoryItems {
    //1.这里需要iPod作为参数，判断是否支持某些分类
    NSMutableArray *categoryItems = [[[NSMutableArray alloc] init] autorelease];
    
    //显示All Media的东东
    IMBiTLPlaylist *masterPlaylist = [_iTunes getMasterCategoryiTLPlaylist];
    if (masterPlaylist != nil) {
        IMBiTunesCategoryBindData *item = [[IMBiTunesCategoryBindData alloc] init];
        [item setCategoryName:@"Category_iTunes_lib"];
        [item setDisplayName:CustomLocalizedString(@"ItunesLibrary_id_1", nil)];
        [item setCategoryIcon:[StringHelper imageNamed:@"iTunes_allmedia2"]];
        [item setImageStrName:@"iTunes_allmedia2"];
        [categoryItems addObject:item];
        [item release];
        item = nil;
    }
    
    NSArray *iTunesCateArray = [[_iTunes getCategoryiTLPlaylists] retain];
    if (iTunesCateArray != nil) {
        //添加Playlist
        IMBiTunesCategoryBindData *plistitem = [[IMBiTunesCategoryBindData alloc] init];
        [plistitem setCategoryName:@"Category_iTunes_Playlist"];
        [plistitem setDisplayName:CustomLocalizedString(@"ItunesLibrary_id_2", nil)];
        [plistitem setCategoryIcon:[StringHelper imageNamed:@"iTunes_playlist"]];
        [plistitem setImageStrName:@"iTunes_playlist"];
        [categoryItems addObject:plistitem];
        [plistitem release];
        plistitem = nil;
        
        for (IMBiTLPlaylist* pl in iTunesCateArray) {
            NSString *categoryName = [self getCategoryNodesString:pl];
            IMBiTunesCategoryBindData *item = [[IMBiTunesCategoryBindData alloc] init];
            [item setCategoryName:categoryName];
            if ([item.categoryName isEqualToString:@"Category_iTunes_iBooks"]) {
                [item setDisplayName:CustomLocalizedString(@"ItunesLibrary_id_3", nil)];
            }else {
                [item setDisplayName:pl.name];
            }
            
            [item setCategoryIcon:[StringHelper imageNamed:[self getItemImageName:pl]]];
            [item setImageStrName:[self getItemImageName:pl]];
            int i = 0;
            for (IMBiTunesCategoryBindData *bindDataItem in categoryItems) {
                if ([bindDataItem.categoryName isEqualToString:item.categoryName]) {
                    i ++;
                }
            }
            if (i <= 0) {
                [categoryItems addObject:item];
            }
            [item release];
            item = nil;
        }
    }
    [iTunesCateArray release];
    return categoryItems;
}

- (NSString*) getCategoryNodesString:(IMBiTLPlaylist*)pl {
    switch (pl.distinguishedKindId) {
        case (int)iTunes_Music:
            return @"Category_iTunes_Music";
            break;
        case (int)iTunes_Movie:
            return @"Category_iTunes_Movie";
            break;
        case (int)iTunes_TVShow:
            return @"Category_iTunes_TVShow";
            break;
        case (int)iTunes_Podcast:
            return @"Category_iTunes_PodCasts";
            break;
        case (int)iTunes_iTunesU:
            return @"Category_iTunes_iTunesU";
            break;
        case (int)iTunes_Books:
            return @"Category_iTunes_iBooks";
            break;
        case (int)iTunes_Audiobook:
            return @"Category_iTunes_Audiobook";
            break;
        case (int)iTunes_Ring:
            return @"Category_iTunes_Ringtone";
            break;
        case (int)iTunes_VoiceMemos:
            return @"Category_iTunes_VoiceMemos";
            break;
        case (int)iTunes_Apps:
            return @"Category_iTunes_App";
            break;
        case (int)iTunes_HomeVideo:
            return @"Category_iTunes_HomeVideo";
            break;
        default:
            return @"Category_iTunes_lib";
            break;
    }
}

- (NSString*) getItemImageName:(IMBiTLPlaylist*)pl {
    switch (pl.distinguishedKindId) {
        case (int)iTunes_Music:
            return @"iTunes_music";
            break;
        case (int)iTunes_Movie:
            return @"iTunes_movies";
            break;
        case (int)iTunes_TVShow:
            return @"iTunes_TVshow";
            break;
        case (int)iTunes_Podcast:
            return @"iTunes_podcats";
            break;
        case (int)iTunes_iTunesU:
            return @"iTunes_iTunesU";
            break;
        case (int)iTunes_Books:
            return @"iTunes_iBook";
            break;
        case (int)iTunes_Audiobook:
            return @"iTunes_audiobook";
            break;
        case (int)iTunes_Ring:
            return @"iTunes_tones";
            break;
        case (int)iTunes_VoiceMemos:
            return @"iTunes_voicememos";
            break;
        case (int)iTunes_Apps:
            return @"iTunes_app";
            break;
        case (int)iTunes_HomeVideo:
            return @"iTunes_homevideo";
            break;
        default:
            return @"";
            break;
    }
}

- (void)showToolTip:(IMBCategoryView *)sender withToolTip:(NSString *)toolTip {
    [self createPopover:toolTip];
    if (_toolTipViewController != nil) {
        NSRect rect = [sender frame];
        float x = rect.origin.x + floor((sender.frame.size.width - _toolTipViewController.view.frame.size.width) / 2 - 1);
        float y = rect.origin.y + ceil(sender.frame.size.height);
        NSView *view = ((NSView*)(self.view.window).contentView).superview;
        NSPoint pos = NSMakePoint(x, y);
        NSPoint localPoint = [sender convertPoint:pos toView:view];
        if (localPoint.x < 0) {
            localPoint.x = 2;
        }
        [_toolTipViewController setCategory:sender.categoryName];
        [_toolTipViewController.view setFrameOrigin:localPoint];
        [view addSubview:_toolTipViewController.view];
    }
    [self.view setNeedsDisplay:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:REFREASH_TOPVIEW object:nil];
}

- (void)closeToolTip:(IMBCategoryView *)sender {
    if (_toolTipViewController != nil) {
        [_toolTipViewController.view removeFromSuperview];
        [_toolTipViewController release];
        _toolTipViewController = nil;
    }
    [self.view setNeedsDisplay:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:REFREASH_TOPVIEW object:nil];
}

- (void)categoryClick:(IMBCategoryView *)sender withObject:(id)object {
    IMBiTunesCategoryBindData *binditem = nil;
    for (IMBiTunesCategoryBindData *bindData in self.bindCategoryArray) {
        if ([bindData.categoryName isEqualToString:(NSString*)object]) {
            binditem = bindData;
            if (![binditem.imageStrName hasSuffix:@"2"]) {
                binditem.categoryIcon = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",binditem.imageStrName]];
                [binditem setImageStrName:[NSString stringWithFormat:@"%@2",binditem.imageStrName]];
            }
            //如果点击同一个按钮
            if ([bindData.categoryName isEqualToString:lastBinditem.categoryName]) {
                return;
            }
            [bindData.categoryView setNeedsDisplay:YES];
            break;
        }
    }
    
    for (IMBiTunesCategoryBindData *bindData in self.bindCategoryArray) {
        
        if (bindData.isSelected ) {
            NSString *str = bindData.imageStrName;
            if (![str hasSuffix:@"2"]) {
                bindData.categoryIcon = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",str]];
                [bindData setImageStrName:[NSString stringWithFormat:@"%@2",str]];
            }else {
                NSUInteger leng = str.length;
                NSString *str2 = [str substringToIndex:leng-1];
                bindData.categoryIcon = [StringHelper imageNamed:[NSString stringWithFormat:@"%@",str2]];
                [bindData setImageStrName:[NSString stringWithFormat:@"%@",str2]];
            }
            [bindData.categoryView setIsSelected:NO];
            [bindData.categoryView setIsEntered:NO];
            [bindData.categoryView setNeedsDisplay:YES];
            bindData.isSelected = NO;
        }
        
    }
    
    if (binditem != nil) {
        [binditem setIsSelected:YES];
        [self selectCategoryChanged:binditem.categoryName];
        lastBinditem = [binditem retain];
    }
}

- (void)mouseOnCategory:(IMBCategoryView *)sender withObject:(id)object {
    IMBiTunesCategoryBindData *binditem = nil;
    for (IMBiTunesCategoryBindData *bindData in self.bindCategoryArray) {
        if ([bindData.categoryName isEqualToString:(NSString*)object]) {
            binditem = bindData;
            NSString *str = bindData.imageStrName;
            if (![str hasSuffix:@"2"]) {
                binditem.categoryIcon = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",str]];
                [binditem setImageStrName:[NSString stringWithFormat:@"%@2",str]];
            }
            break;
        }
    }
}

- (void)mouseExiteCategory:(IMBCategoryView *)sender withObject:(id)object {
    for (IMBiTunesCategoryBindData *bindData in self.bindCategoryArray) {
        if (!bindData.isSelected) {
            NSString *str = bindData.imageStrName;
            if ([str hasSuffix:@"2"]) {
                NSUInteger leng = str.length;
                NSString *str2 = [str substringToIndex:leng-1];
                bindData.categoryIcon = [StringHelper imageNamed:[NSString stringWithFormat:@"%@",str2]];
                [bindData setImageStrName:[NSString stringWithFormat:@"%@",str2]];
            }
        }
    }
}

- (void)createPopover:(NSString*)tip {
    if (_toolTipViewController != nil) {
        [_toolTipViewController.view removeFromSuperview];
        [_toolTipViewController release];
        _toolTipViewController = nil;
    }
    [self.view setNeedsDisplay:YES];
    _toolTipViewController = [[IMBToolTipViewController alloc] initWithToolTip:tip];
}

- (void)reloadTableView{
    if (![StringHelper stringIsNilOrEmpty:lastCategoryString]) {
        [self selectCategoryChanged:lastCategoryString];
        IMBMainWindowController *mainWindow = (IMBMainWindowController *)_delegate;
        if (mainWindow.curFunctionType == iTunesLibraryModule) {
            [mainWindow.searchView setHidden:NO];
        }
    }else {
        NSLog(@"+++++++++lastCategoryString is nil");
        IMBMainWindowController *mainWindow = (IMBMainWindowController *)_delegate;
        if (mainWindow.curFunctionType == iTunesLibraryModule && _disConnectView.superview == _box) {
            [mainWindow.searchView setHidden:YES];
        }
    }
}

#pragma  mark-刷新、ToMac、ToDevice功能
- (void)reload:(id)sender {
    [_toolBar toolBarButtonIsEnabled:NO];
    if (_isNotFirstLoadView) {
        [_box setContentView:_loadView];
        [_loadAnimationView startAnimation];
    }
    [_iTunesMainBox setContentView:_loadTwoView];
    [_loadTwoAnimationView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _iTunes = [IMBiTunes singleton];
        [_iTunes parserLibrary];
        [_contentViewControllerDic removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_toolBar toolBarButtonIsEnabled:YES];
            NSMutableArray *ituneslibAry = nil;
            IMBiTLPlaylist *pl = [_iTunes getPlaylistByDistinguished:[IMBiTunesEnum getDistinguishedKindId:Category_iTunes_lib]];
            if (pl != nil) {
                ituneslibAry = pl.playlistItems;
            }
            NSMutableArray *itunesAPPAry = nil;
            IMBiTLPlaylist *pl2 = [_iTunes getPlaylistByDistinguished:[IMBiTunesEnum getDistinguishedKindId:Category_iTunes_App]];
            if (pl2 != nil) {
                itunesAPPAry = pl2.playlistItems;
            }

            if (itunesAPPAry.count <= 0  && ituneslibAry.count <= 0)  {
                [self setIsShowLineView:NO];
                [_disConnectView setWantsLayer:YES];
                [_disConnectView.layer setCornerRadius:5];
                [_box setContentView:_disConnectView];
                IMBMainWindowController *mainWindow = (IMBMainWindowController *)_delegate;
                if (mainWindow.curFunctionType == iTunesLibraryModule) {
                    [mainWindow.searchView setHidden:YES];
                }
            }else{
                IMBMainWindowController *mainWindow = (IMBMainWindowController *)_delegate;
                if (mainWindow.curFunctionType == iTunesLibraryModule) {
                   [mainWindow.searchView setHidden:NO];
                }
                
                if (_isNotFirstLoadView) {
                    [_loadAnimationView endAnimation];
                    [_box setContentView:_dataView];
                }
                [self setIsShowLineView:YES];
                if (!_itunesIsOpen) {
                    NSLog(@"qqqqqqqqqqqqqqqq");
                    [self setBindCategoryArray:[self createCategoryItems]];
                    _itunesIsOpen = YES;
                    [_box setContentView:_dataView];
                }
                [_loadTwoAnimationView endAnimation];
                if (![TempHelper stringIsNilOrEmpty:lastCategoryString]) {
                    [self selectCategoryChanged:lastCategoryString];
                }
            }
            _isNotFirstLoadView = NO;
        });
    });
}

- (void)toMac:(id)sender {
    IMBBaseViewController *controller = [_contentViewControllerDic objectForKey:[IMBCommonEnum categoryNodesEnumToString:_itunesCategory]];
    if (controller != nil) {
        [controller toMac:sender];
    }
}

- (void)toDevice:(id)sender {
    IMBBaseViewController *controller = [_contentViewControllerDic objectForKey:[IMBCommonEnum categoryNodesEnumToString:_itunesCategory]];
    NSIndexSet *selectedSet = [controller selectedItems];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    if (_itunesCategory == Category_iTunes_lib) {
        [ATTracker event:iTunes_Library action:ToDevice actionParams:@"All Media" label:Start transferCount:[selectedSet count] screenView:@"All Media" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }else{
        [ATTracker event:iTunes_Library action:ToDevice actionParams:[IMBCommonEnum attrackerCategoryNodesEnumToString:_itunesCategory] label:Start transferCount:[selectedSet count] screenView:[IMBCommonEnum attrackerCategoryNodesEnumToString:_itunesCategory] userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }

    if ([selectedSet count]>0) {
       
        IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
        NSMutableArray *baseInfoArr = [NSMutableArray array];
        NSArray *array = [connection getConnectedIPods];
        for (IMBiPod *ipod in array) {
            if (ipod.infoLoadFinished) {
                IMBBaseInfo *baseInfo = [connection getDeviceByKey:ipod.uniqueKey];
                [baseInfoArr addObject:baseInfo];
            }
        }
        if (baseInfoArr.count == 0) {
            [self showAlertText:CustomLocalizedString(@"iTunes_Nothave_toDevices", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            return;
        }
        
        if (baseInfoArr.count == 1) {
            IMBBaseInfo *baseInfo = [baseInfoArr objectAtIndex:0];
            IMBiPod *tarIpod = [connection getIPodByKey:baseInfo.uniqueKey];
            if (tarIpod.beingSynchronized) {
                [self showAlertText:CustomLocalizedString(@"AirsyncTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
                return;
            }

            NSViewController *annoyVC = nil;
            long long result = [self checkNeedAnnoy:&(annoyVC)];
            if (result == 0) {
                return;
            }
           
            if (_transferController != nil) {
                [_transferController release];
                _transferController = nil;
            }
            NSMutableArray *path = [NSMutableArray array];
            NSArray *disAry = nil;
            if (_isSearch) {
                disAry = controller.researchdataSourceArray;
            }else{
                disAry = controller.dataSourceArray;
            }
            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                IMBiTLTrack *track = [disAry objectAtIndex:idx];
                NSString *filePath = [track.location path];
                if (filePath != nil) {
                    [path addObject:filePath];
                }
            }];
            CategoryNodesEnum tcategory = controller.category;
            CategoryNodesEnum category = Category_Summary;
            if (tcategory == Category_iTunes_lib) {
                category = Category_Summary;
            }else if (tcategory == Category_iTunes_Music){
                category = Category_Music;
            }else if (tcategory == Category_iTunes_TVShow){
                category = Category_TVShow;
            }else if (tcategory == Category_iTunes_iBooks){
                category = Category_iBooks;
            }else if (tcategory == Category_iTunes_Audiobook){
                category = Category_Audiobook;
            }else if (tcategory == Category_iTunes_Ringtone){
                category = Category_Ringtone;
            }else if (tcategory == Category_iTunes_App){
                category = Category_Applications;
            }else if (tcategory == Category_iTunes_VoiceMemos){
                category = Category_VoiceMemos;
            }else if (tcategory == Category_iTunes_iTunesU){
                category = Category_iTunesU;
            }else if (tcategory == Category_iTunes_PodCasts){
                category = Category_PodCasts;
            }else if (tcategory == Category_iTunes_Playlist){
                category = Category_Summary;
            }
            _transferController = [[IMBTransferViewController alloc] initWithIPodkey:tarIpod.uniqueKey Type:category importFiles:path photoAlbum:nil playlistID:0];
            _transferController.isiTunesImport = YES;
            if (result>0) {
                [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];

            }else{
                [self animationAddTransferView:_transferController.view];
            }
        }else {
            [self toDeviceWithSelectArray:baseInfoArr WithView:sender];
        }
    }else{
        //弹出警告确认框
        NSString *str = nil;
        if (_dataSourceArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_transfer", nil),CustomLocalizedString(@"MenuItem_id_81", nil)];
        }else {
            str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        }
        
        [self showAlertText:CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }
    
}

- (void)loadiTunesData{
    _isNotFirstLoadView = YES;
    [self reload:nil];
}

- (void)onItemClicked:(id)sender {
    IMBBaseInfo *baseInfo = (IMBBaseInfo *)sender;
    [_toDevicePopover close];
    IMBBaseViewController *controller = [_contentViewControllerDic objectForKey:[IMBCommonEnum categoryNodesEnumToString:_itunesCategory]];
    NSIndexSet *selectedSet = [controller selectedItems];
    IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
    IMBiPod *tarIpod = [connection getIPodByKey:baseInfo.uniqueKey];
    if (tarIpod.beingSynchronized) {
        [self showAlertText:CustomLocalizedString(@"AirsyncTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    if (_transferController != nil) {
        [_transferController release];
        _transferController = nil;
    }
    NSMutableArray *path = [NSMutableArray array];
    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        IMBiTLTrack *track = [controller.dataSourceArray objectAtIndex:idx];
        NSString *filePath = [track.location path];
        if (filePath != nil) {
            [path addObject:filePath];
        }
    }];
    CategoryNodesEnum tcategory = controller.category;
    CategoryNodesEnum category = Category_Summary;
    if (tcategory == Category_iTunes_lib) {
        category = Category_Summary;
    }else if (tcategory == Category_iTunes_Music){
        category = Category_Music;
    }else if (tcategory == Category_iTunes_TVShow){
        category = Category_TVShow;
    }else if (tcategory == Category_iTunes_iBooks){
        category = Category_iBooks;
    }else if (tcategory == Category_iTunes_Audiobook){
        category = Category_Audiobook;
    }else if (tcategory == Category_iTunes_Ringtone){
        category = Category_Ringtone;
    }else if (tcategory == Category_iTunes_App){
        category = Category_Applications;
    }else if (tcategory == Category_iTunes_VoiceMemos){
        category = Category_VoiceMemos;
    }else if (tcategory == Category_iTunes_iTunesU){
        category = Category_iTunesU;
    }else if (tcategory == Category_iTunes_PodCasts){
        category = Category_PodCasts;
    }else if (tcategory == Category_iTunes_Playlist){
        category = Category_Summary;
    }
    NSViewController *annoyVC = nil;
    long long result = [self checkNeedAnnoy:&(annoyVC)];
    if (result == 0) {
        return;
    }
    _transferController = [[IMBTransferViewController alloc] initWithIPodkey:tarIpod.uniqueKey Type:category importFiles:path photoAlbum:nil playlistID:0];
    [_transferController setDelegate:self];
    if (result>0) {
        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
    }else{
        [self animationAddTransferView:_transferController.view];

    }
    
}

- (void)animationAddTransferView:(NSView *)view
{
    [view setFrame:NSMakeRect(0, 0, [self view].frame.size.width, [self view].frame.size.height)];
    [view setWantsLayer:YES];
    [view.layer setCornerRadius:5];
    [[self view] addSubview:view];

    [view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
    
//    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//        CABasicAnimation *anima1 = [IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1];
//        [view.layer addAnimation:anima1 forKey:@"deviceImageView"];
//    } completionHandler:^{
//        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//            CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-40] repeatCount:1];
//            [view.layer addAnimation:anima1 forKey:@"deviceImageView"];
//        } completionHandler:^{
//            CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:-40] Y:[NSNumber numberWithInt:0] repeatCount:1];
//            [view.layer addAnimation:anima1 forKey:@"deviceImageView"];
//        }];
//    }];
}

- (long long)checkNeedAnnoy:(NSViewController **)annoyVC;
{
    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
    _endRunloop = NO;
    if (!soft.isRegistered) {
        OperationLImitation *limit = [OperationLImitation singleton];
        long long redminderCount = (long long)limit.remainderCount;
        //弹出骚扰窗口
        (*annoyVC) = [[IMBAnnoyViewController alloc] initWithNibName:@"IMBAnnoyViewController" Delegate:self Result:&redminderCount];
        ((IMBAnnoyViewController *)(*annoyVC)).category = _category;
        ((IMBAnnoyViewController *)(*annoyVC)).isClone = _isClone;
        ((IMBAnnoyViewController *)(*annoyVC)).isMerge = _isMerge;
        ((IMBAnnoyViewController *)(*annoyVC)).isContentToMac = _isContentToMac;
        ((IMBAnnoyViewController *)(*annoyVC)).isAddContent = _isAddContent;
        [(*annoyVC).view setFrameSize:NSMakeSize(NSWidth([self view].frame), NSHeight([self view].frame))];
        [(*annoyVC).view setWantsLayer:YES];
        [[self view] addSubview:(*annoyVC).view];
        [(*annoyVC).view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-(*annoyVC).view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
        NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
        NSInteger result1 = NSRunContinuesResponse;
        while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        [NSApp endModalSession:session];
        _endRunloop = NO;
        return redminderCount;
    }else{
        return -1;
    }
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    IMBBaseViewController *controller = [_contentViewControllerDic objectForKey:[IMBCommonEnum categoryNodesEnumToString:_itunesCategory]];
    _searchFieldBtn = searchBtn;
    [controller doSearchBtn:searchStr withSearchBtn:searchBtn];
}

- (void)setMainTopLineView:(IMBBackgroundBorderView *)mainTopLineView {
    _mainTopLineView = mainTopLineView;
    [mainTopLineView setHidden:NO];
}

- (void)dealloc {
    if (lastBinditem != nil) {
        [lastBinditem release];
        lastBinditem = nil;
    }
    if (_contentViewControllerDic != nil) {
        [_contentViewControllerDic release];
        _contentViewControllerDic = nil;
    }
    if (_popover != nil) {
        [_popover release];
        _popover = nil;
    }
    if (lastCategoryString != nil) {
        [lastCategoryString release];
        lastCategoryString = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}

@end
