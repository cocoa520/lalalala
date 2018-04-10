//
//  iMBDeviceMainPageViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-14.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBDeviceMainPageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "StringHelper.h"
#import "IMBDeviceViewController.h"
#import "HoverButton.h"
#import "IMBSegmentedBtn.h"
#import "IMBTracksListViewController.h"
#import "IMBTracksCollectionViewController.h"
#import "IMBAppsListViewController.h"
#import "IMBSafariHistoryViewController.h"
#import "IMBPhotosListViewController.h"
#import "IMBPhotosCollectionViewController.h"
#import "IMBVoiceMemosViewController.h"
#import "IMBDevicePlaylistsViewController.h"
#import "IMBBookMarkViewController.h"
#import "IMBSystemCollectionViewController.h"
#import "IMBMyAlbumsViewController.h"
#import "IMBNoteListViewController.h"
#import "IMBVoiceMailViewController.h"
#import "IMBContactViewController.h"
#import "IMBCalendarViewController.h"
#import "IMBiBookCollectionViewController.h"
#import "IMBMessageViewController.h"
#import "IMBMenuItem.h"
#import "IMBMergeOrCloneViewController.h"
#import "IMBAnimation.h"
#import "IMBCategoryInfoModel.h"
#import "IMBToMacViewController.h"
#import "SystemHelper.h"
#import "IMBNotificationDefine.h"
#import "IMBiTunesPrefs.h"
#import "IMBPopViewController.h"
#import "IMBGuideViewController.h"
#import "IMBTipPopoverViewController.h"
#import "IMBSoftWareInfo.h"
#import "IMBFastDriverSegViewController.h"
#import "IMBMainWindowController.h"
#import "IMBAnnoyViewController.h"
@interface IMBDeviceMainPageViewController ()

@end

@implementation IMBDeviceMainPageViewController
@synthesize addContentCategoryAryM = _addContentCategoryAryM;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self configPhotoPromptView];
        [_mergeBtn setTitleName:CustomLocalizedString(@"Device_Main_id_1", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_merge"] withTextColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)]];
        [_toMacBtn setTitleName:CustomLocalizedString(@"Device_Main_id_2", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_tomac"] withTextColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)]];
        [_toiTunesBtn setTitleName:CustomLocalizedString(@"Device_Main_id_3", nil) WithDarwInterval:25 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_toitunes"] withTextColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)]];
        [_toDevcieBtn setTitleName:CustomLocalizedString(@"Device_Main_id_4", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_todevice"] withTextColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)]];
        [_addBtn setTitleName:CustomLocalizedString(@"Device_Main_id_5", nil) WithDarwInterval:36 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_add"] withTextColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)]];
        [_cloneBtn setTitleName:CustomLocalizedString(@"Device_Main_id_6", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_clone"] withTextColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)]];
        [_fastDriverBtn setTitleName:CustomLocalizedString(@"Fast_Drive_id_1", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"fastdriver"] withTextColor:[NSColor whiteColor]];
        
        NSString *str1 = CustomLocalizedString(@"Device_Main_id_9", nil);
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str1];
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:24] range:NSMakeRange(0, as.length)];
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.string.length)];
        [_mainFirstTitle setAttributedStringValue:as];
        [as release];
        as = nil;
        NSString *str2 = CustomLocalizedString(@"Device_Main_id_8", nil);
        NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc]initWithString:str2];
        [as2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:24] range:NSMakeRange(0, as2.length)];
        [as2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as2.length)];
        [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as2.length)];
        [_mainSecondTitle setAttributedStringValue:as2];
        [as2 release];
        as2 = nil;
        
        NSMutableAttributedString *as3 = [[NSMutableAttributedString alloc]initWithString:CustomLocalizedString(@"MSG_Loading_devicedata", nil)];
        [as3 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as3.length)];
        [as3 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as3.length)];
        [_loadLabel setAttributedStringValue:as3];
        [as3 release], as3 = nil;
        
        
        for (IMBFunctionButton *btn in _categoryBtnBarView.allBtnArr) {
            if (btn.tag == 500) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_28", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_28", nil)];
            }else if (btn.tag == 501) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_33", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_33", nil)];
            }else if (btn.tag == 502) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_9", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_9", nil)];
            }else if (btn.tag == 503) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_38", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_38", nil)];
            }else if (btn.tag == Category_iBooks) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_13", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_13", nil)];
            }else if (btn.tag == Category_System) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_35", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_35", nil)];
            }else if (btn.tag == Category_Applications) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_14", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_14", nil)];
            }else if (btn.tag == Category_PodCasts) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_15", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_15", nil)];
            }else if (btn.tag == Category_iTunesU) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_16", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_16", nil)];
            }else if (btn.tag == Category_Notes) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_17", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_17", nil)];
            }else if (btn.tag == Category_Voicemail) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_27", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_27", nil)];
            }else if (btn.tag == Category_Message) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_19", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_19", nil)];
            }else if (btn.tag == Category_Contacts) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_20", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_20", nil)];
            }else if (btn.tag == Category_Calendar) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_22", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_22", nil)];
            }else if (btn.tag == Category_Backups) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_23", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_23", nil)];
            }else if (btn.tag == Category_iCloud) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_39", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_39", nil)];
            }else if (btn.tag == Category_Music) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_1", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_1", nil)];
            }else if (btn.tag == Category_CloudMusic) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_91", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_91", nil)];
            }else if (btn.tag == Category_Ringtone) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_2", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_2", nil)];
            }else if (btn.tag == Category_Audiobook) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_3", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_3", nil)];
            }else if (btn.tag == Category_VoiceMemos) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_5", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_5", nil)];
            }else if (btn.tag == Category_Playlist) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_4", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_4", nil)];
            }else if (btn.tag == Category_Movies) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_6", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_6", nil)];
            }else if (btn.tag == Category_TVShow) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_7", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_7", nil)];
            }else if (btn.tag == Category_MusicVideo) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_8", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_8", nil)];
            }else if (btn.tag == Category_CameraRoll) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_10", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_10", nil)];
            }else if (btn.tag == Category_PhotoStream) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_11", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_11", nil)];
            }else if (btn.tag == Category_PhotoLibrary) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_12", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_12", nil)];
            }else if (btn.tag == Category_PhotoShare) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_25", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_25", nil)];
            }else if (btn.tag == Category_PhotoVideo) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_24", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_24", nil)];
            }else if (btn.tag == Category_MyAlbums) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_26", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_26", nil)];
            }else if (btn.tag == Category_Bookmarks) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_21", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_21", nil)];
            }else if (btn.tag == Category_SafariHistory) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_37", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_37", nil)];
            }else if (btn.tag == 504) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_42", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_42", nil)];
            }else if (btn.tag == 505) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_40", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_40", nil)];
            }
            else if (btn.tag == Category_Reboot) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_43", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_43", nil)];
            }
            else if (btn.tag == Category_Shutdown) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_44", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_44", nil)];
            }
            else if (btn.tag == Category_Systemlogs) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_45", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_45", nil)];
            }else if (btn.tag == Category_ContinuousShooting) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_47", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_47", nil)];
            }else if (btn.tag == Category_TimeLapse) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_48", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_48", nil)];
            }else if (btn.tag == Category_Panoramas) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_49", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_49", nil)];
            }else if (btn.tag == Category_HomeVideo) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_50", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_50", nil)];
            }else if (btn.tag == Category_SlowMove) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_51", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_51", nil)];
            }else if (btn.tag == Category_Storage) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_41", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_41", nil)];
            }else if (btn.tag == Category_LivePhoto) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_63", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_63", nil)];
            }else if (btn.tag == Category_PhotoSelfies) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_65", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_65", nil)];
            }else if (btn.tag == Category_Screenshot) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_64", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_64", nil)];
            }else if (btn.tag == Category_Location) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_66", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_66", nil)];
            }else if (btn.tag == Category_Favorite) {
                [btn setTitle:CustomLocalizedString(@"MenuItem_id_67", nil)];
                [btn setButtonName:CustomLocalizedString(@"MenuItem_id_67", nil)];
            }
            [btn changeBtnName];
            [btn setNeedsDisplay:YES];
            NSString *countStr = @"";
            if (_selectedItem == nil && btn.tag == 500) {
                if (_selectedItem.badgeCount == 0) {
                    countStr = btn.title;
                }else if (_selectedItem.badgeCount > 1) {
                    if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                        countStr = [NSString stringWithFormat:@"%@ ( %d )",btn.title,(int)btn.badgeCount];
                    }else {
                        countStr = [NSString stringWithFormat:@"%@ (%d %@)",btn.title,(int)btn.badgeCount,CustomLocalizedString(@"MSG_Item_id_4", nil)];
                    }
                }else {
                    if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                        countStr = [NSString stringWithFormat:@"%@ ( %d )",btn.title,(int)btn.badgeCount];
                    }else {
                        countStr = [NSString stringWithFormat:@"%@ (%d %@)",btn.title,(int)btn.badgeCount,CustomLocalizedString(@"MSG_Item_id_3", nil)];
                    }
                }
                [_popUpButton setTitle:countStr];
                [_occlusionView setFrameOrigin:NSMakePoint(_popUpButton.frame.size.width-_occlusionView.frame.size.width-2, 4)];
                [_popUpButton setNeedsDisplay:YES];
            }else{
                if (_selectedItem.functionButton.tag == btn.tag ) {
                    if (_selectedItem.badgeCount == 0) {
                        countStr = btn.buttonName;
                    }else if (_selectedItem.badgeCount > 1) {
                        if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                            countStr = [NSString stringWithFormat:@"%@ ( %d )",btn.buttonName,(int)btn.badgeCount];
                        }else {
                            countStr = [NSString stringWithFormat:@"%@ (%d %@)",btn.buttonName,(int)btn.badgeCount,CustomLocalizedString(@"MSG_Item_id_4", nil)];
                        }
                    }else {
                        if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                            countStr = [NSString stringWithFormat:@"%@ ( %d )",btn.buttonName,(int)btn.badgeCount];
                        }else {
                            countStr = [NSString stringWithFormat:@"%@ (%d %@)",btn.buttonName,(int)btn.badgeCount,CustomLocalizedString(@"MSG_Item_id_3", nil)];
                        }
                    }
                    [_popUpButton setTitle:countStr];
                    [_occlusionView setFrameOrigin:NSMakePoint(_popUpButton.frame.size.width-_occlusionView.frame.size.width-2, 4)];
                    [_popUpButton setNeedsDisplay:YES];
                }else if ( _selectedBtn.tag == btn.tag) {
                    if (_selectedBtn.badgeCount == 0) {
                        countStr = btn.buttonName;
                    }else if (_selectedBtn.badgeCount > 1) {
                        if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                            countStr = [NSString stringWithFormat:@"%@ ( %d )",btn.buttonName,(int)btn.badgeCount];
                        }else {
                            countStr = [NSString stringWithFormat:@"%@ (%d %@)",btn.buttonName,(int)btn.badgeCount,CustomLocalizedString(@"MSG_Item_id_4", nil)];
                        }
                    }else {
                        if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                            countStr = [NSString stringWithFormat:@"%@ ( %d )",btn.buttonName,(int)btn.badgeCount];
                        }else {
                            countStr = [NSString stringWithFormat:@"%@ (%d %@)",btn.buttonName,(int)btn.badgeCount,CustomLocalizedString(@"MSG_Item_id_3", nil)];
                        }
                    }
                    [_popUpButton setTitle:countStr];
                    [_occlusionView setFrameOrigin:NSMakePoint(_popUpButton.frame.size.width-_occlusionView.frame.size.width-2, 4)];
                    [_popUpButton setNeedsDisplay:YES];

                }
            }
        }
        NSRect strRect = [StringHelper calcuTextBounds:_photoPromptString.stringValue fontSize:13.0];
        NSRect btnRect = [StringHelper calcuTextBounds:_photoPromptBtn.buttonTitle fontSize:13.0];
        [_photoPromptBgView setFrame:NSMakeRect((self.view.frame.size.width - strRect.size.width - btnRect.size.width - 40)/2.0, _photoPromptBgView.frame.origin.y, strRect.size.width + btnRect.size.width + 40, _photoPromptBgView.frame.size.height)];
        [_photoPromptString setFrame:NSMakeRect(14, _photoPromptString.frame.origin.y, strRect.size.width + 2, _photoPromptString.frame.size.height)];
        [_photoPromptBtn setFrame:NSMakeRect(_photoPromptString.frame.origin.x + strRect.size.width + 10, _photoPromptString.frame.origin.y + 2, btnRect.size.width + 10, _photoPromptBtn.frame.size.height)];
       
    });
}

- (void)changeSkin:(NSNotification *)notification {
    [_occlusionView setNeedsDisplay:YES];
    [_scrollView setNeedsDisplay:YES];
    [self configPhotoPromptView];
    [_mergeBtn setTitleName:CustomLocalizedString(@"Device_Main_id_1", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_merge"] withTextColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)]];
    [_toMacBtn setTitleName:CustomLocalizedString(@"Device_Main_id_2", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_tomac"] withTextColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)]];
    [_toiTunesBtn setTitleName:CustomLocalizedString(@"Device_Main_id_3", nil) WithDarwInterval:25 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_toitunes"] withTextColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)]];
    [_toDevcieBtn setTitleName:CustomLocalizedString(@"Device_Main_id_4", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_todevice"] withTextColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)]];
    [_addBtn setTitleName:CustomLocalizedString(@"Device_Main_id_5", nil) WithDarwInterval:36 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_add"] withTextColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)]];
    [_cloneBtn setTitleName:CustomLocalizedString(@"Device_Main_id_6", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_clone"] withTextColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)]];
    [_fastDriverBtn setTitleName:CustomLocalizedString(@"Fast_Drive_id_1", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"fastdriver"] withTextColor:[NSColor whiteColor]];
    
    NSString *str1 = CustomLocalizedString(@"Device_Main_id_9", nil);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str1];
    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:24] range:NSMakeRange(0, as.length)];
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.string.length)];
    [_mainFirstTitle setAttributedStringValue:as];
    [as release];
    as = nil;
    NSString *str2 = CustomLocalizedString(@"Device_Main_id_8", nil);
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc]initWithString:str2];
    [as2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:24] range:NSMakeRange(0, as2.length)];
    [as2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as2.length)];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as2.length)];
    [_mainSecondTitle setAttributedStringValue:as2];
    [as2 release];
    as2 = nil;
    
    NSMutableAttributedString *as3 = [[NSMutableAttributedString alloc]initWithString:CustomLocalizedString(@"MSG_Loading_devicedata", nil)];
    [as3 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as3.length)];
    [as3 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as3.length)];
    [_loadLabel setAttributedStringValue:as3];
    [as3 release], as3 = nil;
    [_devicebgView setImage:[StringHelper imageNamed:@"device_bg"]];
    [_arrowImageView setImage:[StringHelper imageNamed:@"mainFrame_arrow"]];
    
    NSMutableAttributedString *as4 = [[NSMutableAttributedString alloc]initWithString:CustomLocalizedString(@"MSG_Loading_devicedata", nil)];
    [as4 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as4.length)];
    [as4 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_loadLabel setAttributedStringValue:as];
    [as4 release], as4 = nil;
    
    HoverButton *detailCategoryBtn = [self.view viewWithTag:200];
    [detailCategoryBtn setMouseEnteredImage:[StringHelper imageNamed:@"mainFrame_switch2"] mouseExitImage:[StringHelper imageNamed:@"mainFrame_switch1"] mouseDownImage:[StringHelper imageNamed:@"mainFrame_switch3"]];
    HoverButton *summaryCategoryBtn = [self.view viewWithTag:201];
    [summaryCategoryBtn setMouseEnteredImage:[StringHelper imageNamed:@"mainFrame_tool2"] mouseExitImage:[StringHelper imageNamed:@"mainFrame_tool1"] mouseDownImage:[StringHelper imageNamed:@"mainFrame_tool3"]];
    
    for (IMBFunctionButton *btn in _categoryBtnBarView.allBtnArr) {
        if (btn.tag == 500) {
            [btn setImageWithImageName:@"btn_audionew" withButtonName:CustomLocalizedString(@"MenuItem_id_28", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_audio"]];
        }else if (btn.tag == 501) {
            [btn setImageWithImageName:@"btn_videosnew" withButtonName:CustomLocalizedString(@"MenuItem_id_33", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_video"]];
        }else if (btn.tag == 502) {
            [btn setImageWithImageName:@"btn_photosnew" withButtonName:CustomLocalizedString(@"MenuItem_id_9", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_photo"]];
        }else if (btn.tag == 503) {
            [btn setImageWithImageName:@"btn_safarinew" withButtonName:CustomLocalizedString(@"MenuItem_id_38", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_safari"]];
        }else if (btn.tag == Category_iBooks) {
            [btn setImageWithImageName:@"btn_ibooknew" withButtonName:CustomLocalizedString(@"MenuItem_id_13", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_books"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_book"]];
        }else if (btn.tag == Category_System) {
            [btn setImageWithImageName:@"btn_systemnew" withButtonName:CustomLocalizedString(@"MenuItem_id_35", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_filesystem_system"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_filesystem_system"]];
        }else if (btn.tag == Category_Applications) {
            [btn setImageWithImageName:@"btn_appsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_14", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_apps"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_app"]];
        }else if (btn.tag == Category_PodCasts) {
            [btn setImageWithImageName:@"btn_podcastsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_15", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_podcasts"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_podcasts"]];
        }else if (btn.tag == Category_iTunesU) {
            [btn setImageWithImageName:@"btn_itunesunew" withButtonName:CustomLocalizedString(@"MenuItem_id_16", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_itunesU"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_iTunesU"]];
        }else if (btn.tag == Category_Notes) {
            [btn setImageWithImageName:@"btn_notenew" withButtonName:CustomLocalizedString(@"MenuItem_id_17", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_notes"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_note"]];
        }else if (btn.tag == Category_Voicemail) {
            [btn setImageWithImageName:@"btn_voicemailnew" withButtonName:CustomLocalizedString(@"MenuItem_id_27", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_voicemail"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_voiceMail"]];
        }else if (btn.tag == Category_Message) {
            [btn setImageWithImageName:@"btn_messagenew" withButtonName:CustomLocalizedString(@"MenuItem_id_19", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_message"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_message"]];
        }else if (btn.tag == Category_Contacts) {
            [btn setImageWithImageName:@"btn_contactsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_20", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_contact"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_contact"]];
        }else if (btn.tag == Category_Calendar) {
            [btn setImageWithImageName:@"btn_calendarnew" withButtonName:CustomLocalizedString(@"MenuItem_id_22", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_calendar"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_calendar"]];
        }else if (btn.tag == Category_Music) {
            [btn setImageWithImageName:@"btn_musicnew" withButtonName:CustomLocalizedString(@"MenuItem_id_1", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_audio_music"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_audio_music"]];
        }else if (btn.tag == Category_CloudMusic) {
            [btn setImageWithImageName:@"btn_cloudmusicnew" withButtonName:CustomLocalizedString(@"MenuItem_id_91", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_audio_cloudmusic"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_audio_cloudmusic"]];
        }else if (btn.tag == Category_Ringtone) {
            [btn setImageWithImageName:@"btn_ringtonesnew" withButtonName:CustomLocalizedString(@"MenuItem_id_2", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_audio_ringtones"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_audio_ringtones"]];
        }else if (btn.tag == Category_Audiobook) {
            [btn setImageWithImageName:@"btn_audio_booksnew" withButtonName:CustomLocalizedString(@"MenuItem_id_3", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_audio_audiobook"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_audio_book"]];
        }else if (btn.tag == Category_VoiceMemos) {
            [btn setImageWithImageName:@"btn_voice_memosnew" withButtonName:CustomLocalizedString(@"MenuItem_id_5", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_audio_voicememo"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_audio_voicememo"]];
        }else if (btn.tag == Category_Playlist) {
            [btn setImageWithImageName:@"btn_playlistsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_4", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_audio_playlist"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_audio_playlist"]];
        }else if (btn.tag == Category_Movies) {
            [btn setImageWithImageName:@"btn_moviesnew" withButtonName:CustomLocalizedString(@"MenuItem_id_6", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_video_movies"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_video_movies"]];
        }else if (btn.tag == Category_TVShow) {
            [btn setImageWithImageName:@"btn_tv_showsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_7", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_video_tvshow"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_video_tvshow"]];
        }else if (btn.tag == Category_MusicVideo) {
            [btn setImageWithImageName:@"btn_music_videosnew" withButtonName:CustomLocalizedString(@"MenuItem_id_8", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_video_musicvideo"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_video_musicvideo"]];
        }else if (btn.tag == Category_CameraRoll) {
            [btn setImageWithImageName:@"btn_camera_rollnew" withButtonName:CustomLocalizedString(@"MenuItem_id_10", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_cameraroll"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_photo_cameraroll"]];
        }else if (btn.tag == Category_PhotoStream) {
            [btn setImageWithImageName:@"btn_photo_streamnew" withButtonName:CustomLocalizedString(@"MenuItem_id_11", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_stream"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_photo_stream"]];
        }else if (btn.tag == Category_PhotoLibrary) {
            [btn setImageWithImageName:@"btn_photolibrarynew" withButtonName:CustomLocalizedString(@"MenuItem_id_12", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_library"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_photo_library"]];
        }else if (btn.tag == Category_PhotoShare) {
            [btn setImageWithImageName:@"btn_photo_sharenew" withButtonName:CustomLocalizedString(@"MenuItem_id_25", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_share"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_photo_share"]];
        }else if (btn.tag == Category_PhotoVideo) {
            [btn setImageWithImageName:@"btn_photo_videosnew" withButtonName:CustomLocalizedString(@"MenuItem_id_24", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_video_photovideo"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_video_photovideo"]];
        }else if (btn.tag == Category_MyAlbums) {
            [btn setImageWithImageName:@"btn_photo_myalbumsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_26", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_albums"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_photo_albums"]];
        }else if (btn.tag == Category_Bookmarks) {
            [btn setImageWithImageName:@"btn_bookmarksnew" withButtonName:CustomLocalizedString(@"MenuItem_id_21", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_safari_bookmark"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_safari_bookmark"]];
        }else if (btn.tag == Category_SafariHistory) {
            [btn setImageWithImageName:@"btn_safari_historynew" withButtonName:CustomLocalizedString(@"MenuItem_id_37", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_safari_history"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_safari_history"]];
        }else if (btn.tag == 504) {
            [btn setImageWithImageName:@"btn_tools" withButtonName:CustomLocalizedString(@"MenuItem_id_42", nil)];
        }else if (btn.tag == 505) {
            [btn setImageWithImageName:@"nav_system_folder" withButtonName:CustomLocalizedString(@"MenuItem_id_40", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_filesystem"]];
        }else if (btn.tag == Category_Reboot) {
            [btn setImageWithImageName:@"btn_rebootnew" withButtonName:CustomLocalizedString(@"MenuItem_id_43", nil)];
        }else if (btn.tag == Category_Shutdown) {
            [btn setImageWithImageName:@"btn_shutdownnew" withButtonName:CustomLocalizedString(@"MenuItem_id_44", nil)];
        }else if (btn.tag == Category_Systemlogs) {
            [btn setImageWithImageName:@"btn_system_logsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_45", nil)];
        }else if (btn.tag == Category_ContinuousShooting) {
            [btn setImageWithImageName:@"btn_burstnew" withButtonName:CustomLocalizedString(@"MenuItem_id_47", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_bursts"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_photo_bursts"]];
        }else if (btn.tag == Category_TimeLapse) {
            [btn setImageWithImageName:@"btn_delaynew" withButtonName:CustomLocalizedString(@"MenuItem_id_48", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_video_timelapse"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_video_timelapse"]];
        }else if (btn.tag == Category_Panoramas) {
            [btn setImageWithImageName:@"btn_panoramicnew" withButtonName:CustomLocalizedString(@"MenuItem_id_49", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_panoramas"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_photo_panoramas"]];
        }else if (btn.tag == Category_HomeVideo) {
            [btn setImageWithImageName:@"btn_home_videonew" withButtonName:CustomLocalizedString(@"MenuItem_id_50", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_video_homevideo"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_video_homevideo"]];
        }else if (btn.tag == Category_SlowMove) {
            [btn setImageWithImageName:@"btn_slo_monew" withButtonName:CustomLocalizedString(@"MenuItem_id_51", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_video_slomo"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_video_slomo"]];
        }else if (btn.tag == Category_Storage) {
            [btn setImageWithImageName:@"btn_storage" withButtonName:CustomLocalizedString(@"MenuItem_id_41", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_filesystem_storage"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_filesystem_storage"]];
        }else if (btn.tag == Category_LivePhoto) {
            [btn setImageWithImageName:@"btn_photo_livephotonew" withButtonName:CustomLocalizedString(@"MenuItem_id_63", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_livephoto"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_photo_livephoto"]];
        }else if (btn.tag == Category_PhotoSelfies) {
            [btn setImageWithImageName:@"btn_photo_selfnew" withButtonName:CustomLocalizedString(@"MenuItem_id_65", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_self"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_photo_self"]];
        }else if (btn.tag == Category_Screenshot) {
            [btn setImageWithImageName:@"btn_photo_screenshootnew" withButtonName:CustomLocalizedString(@"MenuItem_id_64", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_screenshoot"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_photo_screenshoot"]];
        }else if (btn.tag == Category_Location) {
            [btn setImageWithImageName:@"btn_photo_locationnew" withButtonName:CustomLocalizedString(@"MenuItem_id_66", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_location"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_photo_location"]];
        }else if (btn.tag == Category_Favorite) {
            [btn setImageWithImageName:@"btn_photo_favoritenew" withButtonName:CustomLocalizedString(@"MenuItem_id_67", nil)];
            [btn setNavagationIcon:[StringHelper imageNamed:@"nav_photo_favorite"]];
            [btn setSelectIcon:[StringHelper imageNamed:@"select_photo_favorite"]];
        }
        [btn setNeedsDisplay:YES];
    }
    
    [_mergeBtn setComponentColor:[self getColorFromColorString:@"mergeBtn_upColor" WithIndex:0] withG1:[self getColorFromColorString:@"mergeBtn_upColor" WithIndex:1] withB1:[self getColorFromColorString:@"mergeBtn_upColor" WithIndex:2] withAlpha1:[self getColorFromColorString:@"mergeBtn_upColor" WithIndex:3] withR2:[self getColorFromColorString:@"mergeBtn_downColor" WithIndex:0] withG2:[self getColorFromColorString:@"mergeBtn_downColor" WithIndex:1] withB2:[self getColorFromColorString:@"mergeBtn_downColor" WithIndex:2] withAlpha2:[self getColorFromColorString:@"mergeBtn_downColor" WithIndex:3]];
//    [_mergeBtn setTitleName:CustomLocalizedString(@"Device_Main_id_1", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_merge"] withTextColor:[NSColor whiteColor]];
    
    [_toMacBtn setComponentColor:[self getColorFromColorString:@"toMac_upColor" WithIndex:0] withG1:[self getColorFromColorString:@"toMac_upColor" WithIndex:1] withB1:[self getColorFromColorString:@"toMac_upColor" WithIndex:2] withAlpha1:[self getColorFromColorString:@"toMac_upColor" WithIndex:3] withR2:[self getColorFromColorString:@"toMac_downColor" WithIndex:0] withG2:[self getColorFromColorString:@"toMac_downColor" WithIndex:1] withB2:[self getColorFromColorString:@"toMac_downColor" WithIndex:2] withAlpha2:[self getColorFromColorString:@"toMac_downColor" WithIndex:3]];
//    [_toMacBtn setTitleName:CustomLocalizedString(@"Device_Main_id_2", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_tomac"] withTextColor:[NSColor whiteColor]];
    
    [_toiTunesBtn setComponentColor:[self getColorFromColorString:@"toiTunes_upColor" WithIndex:0] withG1:[self getColorFromColorString:@"toiTunes_upColor" WithIndex:1] withB1:[self getColorFromColorString:@"toiTunes_upColor" WithIndex:2] withAlpha1:[self getColorFromColorString:@"toiTunes_upColor" WithIndex:3] withR2:[self getColorFromColorString:@"toiTunes_downColor" WithIndex:0] withG2:[self getColorFromColorString:@"toiTunes_downColor" WithIndex:1] withB2:[self getColorFromColorString:@"toiTunes_downColor" WithIndex:2] withAlpha2:[self getColorFromColorString:@"toiTunes_downColor" WithIndex:3]];
//    [_toiTunesBtn setTitleName:CustomLocalizedString(@"Device_Main_id_3", nil) WithDarwInterval:36 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_toitunes"] withTextColor:[NSColor whiteColor]];
    
    [_toDevcieBtn setComponentColor:[self getColorFromColorString:@"toDevice_upColor" WithIndex:0] withG1:[self getColorFromColorString:@"toDevice_upColor" WithIndex:1] withB1:[self getColorFromColorString:@"toDevice_upColor" WithIndex:2] withAlpha1:[self getColorFromColorString:@"toDevice_upColor" WithIndex:3] withR2:[self getColorFromColorString:@"toDevice_downColor" WithIndex:0] withG2:[self getColorFromColorString:@"toDevice_downColor" WithIndex:1] withB2:[self getColorFromColorString:@"toDevice_downColor" WithIndex:2] withAlpha2:[self getColorFromColorString:@"toDevice_downColor" WithIndex:3]];
//    [_toDevcieBtn setTitleName:CustomLocalizedString(@"Device_Main_id_4", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_todevice"] withTextColor:[NSColor whiteColor]];
    
    [_addBtn setComponentColor:[self getColorFromColorString:@"addBtn_upColor" WithIndex:0] withG1:[self getColorFromColorString:@"addBtn_upColor" WithIndex:1] withB1:[self getColorFromColorString:@"addBtn_upColor" WithIndex:2] withAlpha1:[self getColorFromColorString:@"addBtn_upColor" WithIndex:3] withR2:[self getColorFromColorString:@"addBtn_downColor" WithIndex:0] withG2:[self getColorFromColorString:@"addBtn_downColor" WithIndex:1] withB2:[self getColorFromColorString:@"addBtn_downColor" WithIndex:2] withAlpha2:[self getColorFromColorString:@"addBtn_downColor" WithIndex:3]];
//    [_addBtn setTitleName:CustomLocalizedString(@"Device_Main_id_5", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_add"] withTextColor:[NSColor whiteColor]];
    
    [_cloneBtn setComponentColor:[self getColorFromColorString:@"cloneBtn_upColor" WithIndex:0] withG1:[self getColorFromColorString:@"cloneBtn_upColor" WithIndex:1] withB1:[self getColorFromColorString:@"cloneBtn_upColor" WithIndex:2] withAlpha1:[self getColorFromColorString:@"cloneBtn_upColor" WithIndex:3] withR2:[self getColorFromColorString:@"cloneBtn_downColor" WithIndex:0] withG2:[self getColorFromColorString:@"cloneBtn_downColor" WithIndex:1] withB2:[self getColorFromColorString:@"cloneBtn_downColor" WithIndex:2] withAlpha2:[self getColorFromColorString:@"cloneBtn_downColor" WithIndex:3]];
//    [_cloneBtn setTitleName:CustomLocalizedString(@"Device_Main_id_6", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_clone"] withTextColor:[NSColor whiteColor]];
    
    [_fastDriverBtn setComponentColor:[self getColorFromColorString:@"fastDriveBtn_upColor" WithIndex:0] withG1:[self getColorFromColorString:@"fastDriveBtn_upColor" WithIndex:1] withB1:[self getColorFromColorString:@"fastDriveBtn_upColor" WithIndex:2] withAlpha1:[self getColorFromColorString:@"fastDriveBtn_upColor" WithIndex:3] withR2:[self getColorFromColorString:@"fastDriveBtn_downColor" WithIndex:0] withG2:[self getColorFromColorString:@"fastDriveBtn_downColor" WithIndex:1] withB2:[self getColorFromColorString:@"fastDriveBtn_downColor" WithIndex:2] withAlpha2:[self getColorFromColorString:@"fastDriveBtn_downColor" WithIndex:3]];
//    [_fastDriverBtn setTitleName:CustomLocalizedString(@"Fast_Drive_id_1", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"fastdriver"] withTextColor:[NSColor whiteColor]];
    
    [_mergeBtn setNeedsDisplay:YES];
    [_toMacBtn setNeedsDisplay:YES];
    [_toiTunesBtn setNeedsDisplay:YES];
    [_toDevcieBtn setNeedsDisplay:YES];
    [_addBtn setNeedsDisplay:YES];
    [_cloneBtn setNeedsDisplay:YES];
    [_fastDriverBtn setNeedsDisplay:YES];
    [_popUpButton setNeedsDisplay:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    BOOL notfirst = [[[NSUserDefaults standardUserDefaults] objectForKey:@"first_open_guideView"] boolValue] ;
    if (!notfirst) {
        [_scrollView setIsScroll:YES];
    }
    [self configPhotoPromptView];
    [_photoPromptBgView setHidden:YES];
    _isfirstEnter  = YES;
    
    [_devicebgView setImage:[StringHelper imageNamed:@"device_bg"]];
    [_arrowImageView setImage:[StringHelper imageNamed:@"mainFrame_arrow"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadFinish:) name:NOTIFY_INFORMATIONDATA_LOADFINISH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeTipPopover) name:NOTIFY_CLOSE_TIP object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addContentReload:) name:NOTIFY_AddCONTENT_SUCCESSED object:nil];
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:CustomLocalizedString(@"MSG_Loading_devicedata", nil)];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.length)];
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_loadLabel setAttributedStringValue:as];
    [as release], as = nil;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeDownBtn) name: NOTIFY_GUIDEVIEW_MAIN_DOWN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAddBtn) name: NOTIFY_GUIDEVIEW_REMOVEADDBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name: NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guideViewOpen:) name:NOTIFY_GUIDEVIEW_OPEN object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guideViewClose) name:NOTIFY_GUIDEVIEW_CLOSE object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guideViewAddBtn:) name:NOTIFY_GUIDEVIEW_ADDBUTTON object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guideViewContectIpod:) name:NOTIFY_IPOD_CONTENT object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guideViewDisContectIpod:) name:NOTIFY_IPOD_DISCONTENT object:nil];
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_alertViewController setDelegate:self];
    if (!_ipod.deviceInfo.isIOSDevice) {
        [_mergeBtn setHidden:YES];
        [_cloneBtn setHidden:YES];
    }
    [self configMainTitle];
    [_toolBar setHidden:YES];
    _detailPageDic = [[NSMutableDictionary dictionary] retain];
    _displayModeDic = [[NSMutableDictionary dictionary] retain];
    [self.view setWantsLayer:YES];
    [self.view.layer setCornerRadius:5];
    [_scrollView setDelegate:self];
    [_scrollView setIsdown:NO];
    
    NSView *swbuttonView = [[NSView alloc] initWithFrame:NSMakeRect(NSWidth(self.view.frame)-34 - 25, ceil(NSHeight(self.view.frame)/2.0)-30, 34, 34*2+20)];
    swbuttonView.autoresizesSubviews = YES;
    swbuttonView.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin|NSViewMaxYMargin;
    
    HoverButton *detailCategoryBtn = [[HoverButton alloc] initWithFrame:NSMakeRect(0,0,34, 34)];
    detailCategoryBtn.tag = 201;
    [detailCategoryBtn setTarget:self];
    [detailCategoryBtn setAction:@selector(switchView:)];
    [detailCategoryBtn setMouseEnteredImage:[StringHelper imageNamed:@"mainFrame_switch2"] mouseExitImage:[StringHelper imageNamed:@"mainFrame_switch1"] mouseDownImage:[StringHelper imageNamed:@"mainFrame_switch3"]];
    [detailCategoryBtn setIsSelected:NO];
    HoverButton *summaryCategoryBtn = [[HoverButton alloc] initWithFrame:NSMakeRect(0,34+20,34, 34)];
    summaryCategoryBtn.tag = 200;
    [summaryCategoryBtn setTarget:self];
    [summaryCategoryBtn setAction:@selector(switchView:)];
    [summaryCategoryBtn setMouseEnteredImage:[StringHelper imageNamed:@"mainFrame_tool2"] mouseExitImage:[StringHelper imageNamed:@"mainFrame_tool1"] mouseDownImage:[StringHelper imageNamed:@"mainFrame_tool3"]];
    [summaryCategoryBtn setIsSelected:YES];
    [swbuttonView addSubview:detailCategoryBtn];
    [swbuttonView addSubview:summaryCategoryBtn];
    [detailCategoryBtn release];
    [summaryCategoryBtn release];

    
//    [_mergeBtn setFrameOrigin:NSMakePoint(578, _mergeBtn.frame.origin.y)];
    [_mergeBtn setComponentColor:[self getColorFromColorString:@"mergeBtn_upColor" WithIndex:0] withG1:[self getColorFromColorString:@"mergeBtn_upColor" WithIndex:1] withB1:[self getColorFromColorString:@"mergeBtn_upColor" WithIndex:2] withAlpha1:[self getColorFromColorString:@"mergeBtn_upColor" WithIndex:3] withR2:[self getColorFromColorString:@"mergeBtn_downColor" WithIndex:0] withG2:[self getColorFromColorString:@"mergeBtn_downColor" WithIndex:1] withB2:[self getColorFromColorString:@"mergeBtn_downColor" WithIndex:2] withAlpha2:[self getColorFromColorString:@"mergeBtn_downColor" WithIndex:3]];
    [_mergeBtn setTitleName:CustomLocalizedString(@"Device_Main_id_1", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_merge"] withTextColor:[NSColor whiteColor]];
    
//    [_toMacBtn setFrameOrigin:NSMakePoint(692, _toMacBtn.frame.origin.y)];
    [_toMacBtn setComponentColor:[self getColorFromColorString:@"toMac_upColor" WithIndex:0] withG1:[self getColorFromColorString:@"toMac_upColor" WithIndex:1] withB1:[self getColorFromColorString:@"toMac_upColor" WithIndex:2] withAlpha1:[self getColorFromColorString:@"toMac_upColor" WithIndex:3] withR2:[self getColorFromColorString:@"toMac_downColor" WithIndex:0] withG2:[self getColorFromColorString:@"toMac_downColor" WithIndex:1] withB2:[self getColorFromColorString:@"toMac_downColor" WithIndex:2] withAlpha2:[self getColorFromColorString:@"toMac_downColor" WithIndex:3]];
    [_toMacBtn setTitleName:CustomLocalizedString(@"Device_Main_id_2", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_tomac"] withTextColor:[NSColor whiteColor]];
    
//    [_toiTunesBtn setFrameOrigin:NSMakePoint(852, _toiTunesBtn.frame.origin.y)];
    [_toiTunesBtn setComponentColor:[self getColorFromColorString:@"toiTunes_upColor" WithIndex:0] withG1:[self getColorFromColorString:@"toiTunes_upColor" WithIndex:1] withB1:[self getColorFromColorString:@"toiTunes_upColor" WithIndex:2] withAlpha1:[self getColorFromColorString:@"toiTunes_upColor" WithIndex:3] withR2:[self getColorFromColorString:@"toiTunes_downColor" WithIndex:0] withG2:[self getColorFromColorString:@"toiTunes_downColor" WithIndex:1] withB2:[self getColorFromColorString:@"toiTunes_downColor" WithIndex:2] withAlpha2:[self getColorFromColorString:@"toiTunes_downColor" WithIndex:3]];
    [_toiTunesBtn setTitleName:CustomLocalizedString(@"Device_Main_id_3", nil) WithDarwInterval:25 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_toitunes"] withTextColor:[NSColor whiteColor]];
//    [_toDevcieBtn setFrameOrigin:NSMakePoint(1040, _toDevcieBtn.frame.origin.y)];
    [_toDevcieBtn setComponentColor:[self getColorFromColorString:@"toDevice_upColor" WithIndex:0] withG1:[self getColorFromColorString:@"toDevice_upColor" WithIndex:1] withB1:[self getColorFromColorString:@"toDevice_upColor" WithIndex:2] withAlpha1:[self getColorFromColorString:@"toDevice_upColor" WithIndex:3] withR2:[self getColorFromColorString:@"toDevice_downColor" WithIndex:0] withG2:[self getColorFromColorString:@"toDevice_downColor" WithIndex:1] withB2:[self getColorFromColorString:@"toDevice_downColor" WithIndex:2] withAlpha2:[self getColorFromColorString:@"toDevice_downColor" WithIndex:3]];
    [_toDevcieBtn setTitleName:CustomLocalizedString(@"Device_Main_id_4", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_todevice"] withTextColor:[NSColor whiteColor]];
//    [_addBtn setFrameOrigin:NSMakePoint(1154, _addBtn.frame.origin.y)];
    [_addBtn setComponentColor:[self getColorFromColorString:@"addBtn_upColor" WithIndex:0] withG1:[self getColorFromColorString:@"addBtn_upColor" WithIndex:1] withB1:[self getColorFromColorString:@"addBtn_upColor" WithIndex:2] withAlpha1:[self getColorFromColorString:@"addBtn_upColor" WithIndex:3] withR2:[self getColorFromColorString:@"addBtn_downColor" WithIndex:0] withG2:[self getColorFromColorString:@"addBtn_downColor" WithIndex:1] withB2:[self getColorFromColorString:@"addBtn_downColor" WithIndex:2] withAlpha2:[self getColorFromColorString:@"addBtn_downColor" WithIndex:3]];
    [_addBtn setTitleName:CustomLocalizedString(@"Device_Main_id_5", nil) WithDarwInterval:36 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_add"] withTextColor:[NSColor whiteColor]];
//    [_cloneBtn setFrameOrigin:NSMakePoint(1248, _cloneBtn.frame.origin.y)];
    [_cloneBtn setComponentColor:[self getColorFromColorString:@"cloneBtn_upColor" WithIndex:0] withG1:[self getColorFromColorString:@"cloneBtn_upColor" WithIndex:1] withB1:[self getColorFromColorString:@"cloneBtn_upColor" WithIndex:2] withAlpha1:[self getColorFromColorString:@"cloneBtn_upColor" WithIndex:3] withR2:[self getColorFromColorString:@"cloneBtn_downColor" WithIndex:0] withG2:[self getColorFromColorString:@"cloneBtn_downColor" WithIndex:1] withB2:[self getColorFromColorString:@"cloneBtn_downColor" WithIndex:2] withAlpha2:[self getColorFromColorString:@"cloneBtn_downColor" WithIndex:3]];
    [_cloneBtn setTitleName:CustomLocalizedString(@"Device_Main_id_6", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"mainFrame_clone"] withTextColor:[NSColor whiteColor]];
    
    [_fastDriverBtn setComponentColor:[self getColorFromColorString:@"fastDriveBtn_upColor" WithIndex:0] withG1:[self getColorFromColorString:@"fastDriveBtn_upColor" WithIndex:1] withB1:[self getColorFromColorString:@"fastDriveBtn_upColor" WithIndex:2] withAlpha1:[self getColorFromColorString:@"fastDriveBtn_upColor" WithIndex:3] withR2:[self getColorFromColorString:@"fastDriveBtn_downColor" WithIndex:0] withG2:[self getColorFromColorString:@"fastDriveBtn_downColor" WithIndex:1] withB2:[self getColorFromColorString:@"fastDriveBtn_downColor" WithIndex:2] withAlpha2:[self getColorFromColorString:@"fastDriveBtn_downColor" WithIndex:3]];
    [_fastDriverBtn setTitleName:CustomLocalizedString(@"Fast_Drive_id_1", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"fastdriver"] withTextColor:[NSColor whiteColor]];
    
    
    [_detailBox setContentView:_firstCustomView];
    [_detailBox setFrameSize:self.view.frame.size];
    [_contentBox setWantsLayer:YES];
    [_contentBox setContentView:_functionView];
    
//    [self startTestBtnAnimation];
//    [self configCapacityView];
    
    [self.view addSubview:swbuttonView];
    [swbuttonView release];
    [self loadDeviceContent];
    [_popUpButton setMenu:[self createNavagationMenu]];
    [_popUpButton setFrame:NSMakeRect(16+4+36, ceil((NSHeight(_toolBar.frame) - NSHeight(_popUpButton.frame))/2.0),100,22)];
    [_occlusionView setFrameOrigin:NSMakePoint(_popUpButton.frame.size.width-_occlusionView.frame.size.width-2, 4)];
    [_popUpButton addSubview:_occlusionView];
    [_toolBar addSubview:_popUpButton];

    [_toiTunesBtn setHidden:YES];
    [_toMacBtn setHidden:YES];
    [_mergeBtn setHidden:YES];
    [_toDevcieBtn setHidden:YES];
    [_addBtn setHidden:YES];
    [_cloneBtn setHidden:YES];
    [_fastDriverBtn setHidden:YES];
    [self performSelector:@selector(moveMainViewBtnAnimation) withObject:nil afterDelay:0.1];

}

- (void)dataLoadFinish:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_ipod.infoLoadFinished) {
            [_loadLabel setHidden:YES];
            if (_loadPopover != nil) {
                [_loadPopover close];
            }
        }
    });
}

- (void)removeAddBtn{
//    [_addBtn removeFromSuperview];
    [_mainFunctionView addSubview:_addBtn];
}

- (void)guideViewClose{
    [_scrollView setIsScroll:NO];
//    [_ setMovableByWindowBackground:YES];
    [_mainFunctionView addSubview:_addBtn];
    [self startTestBtnAnimation];
    [self isNoDownMainBtn:YES];
}

- (void)guideViewAddBtn:(NSNotification *)obj{
//    [_addBtn removeFromSuperview];
    IMBGuideViewController *guideViewController = obj.object;
    [guideViewController.addBtnView addSubview:_addBtn];
}

- (void)removeDownBtn{
    [self stopTestBtnAnimation];
}

-(void)guideViewContectIpod:(NSNotification *)notification{
    _newIpod = notification.object;
}

-(void)guideViewDisContectIpod:(NSNotification *)notification{
    NSString *str = notification.object;
    if ([_newIpod.uniqueKey isEqualToString:str]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GUIDEVIEW_RELELE object:nil];
    }
}

- (void)guideViewOpen:(NSNotification *)notification{
    [_scrollView setIsScroll:YES];
    [self stopTestBtnAnimation];
    [self isNoDownMainBtn:NO];
}

- (void)isNoDownMainBtn:(BOOL) isDown{
    [_mergeBtn setIsDown:isDown];
    [_toMacBtn setIsDown:isDown];
    [_toiTunesBtn setIsDown:isDown];
    [_toDevcieBtn setIsDown:isDown];
    [_addBtn setIsDown:isDown];
    [_cloneBtn setIsDown:isDown];
    [_fastDriverBtn setIsDown:isDown];
}

- (void)ipodShowAlter {
    if (!_ipod.deviceInfo.isIOSDevice) {
        IMBiTunesPrefs *iTunesPrefs = [[IMBiTunesPrefs alloc] initWithiPod:_ipod];
        if (![iTunesPrefs manualSyncFlag]) {
            [self showAlertText:CustomLocalizedString(@"iTunes_id_1", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        }
        [iTunesPrefs release];
    }
}

- (void)configMainTitle {
    NSString *str1 = CustomLocalizedString(@"Device_Main_id_9", nil);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str1];
    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:24] range:NSMakeRange(0, as.length)];
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.string.length)];
    [_mainFirstTitle setAttributedStringValue:as];
    [as release];
    as = nil;
    NSString *str2 = CustomLocalizedString(@"Device_Main_id_8", nil);
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc]initWithString:str2];
    [as2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:24] range:NSMakeRange(0, as2.length)];
    [as2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as2.length)];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as2.length)];
    [_mainSecondTitle setAttributedStringValue:as2];
    [as2 release];
    as2 = nil;
}

- (NSMenu *)createNavagationMenu {
    NSMenu *mainMenu = [[NSMenu alloc] init];
    [mainMenu setDelegate:self];
    if (_ipod.deviceInfo.isIOSDevice) {
        NSMenu *audioMenu = [[NSMenu alloc] init];
        NSMenu *videoMenu = [[NSMenu alloc] init];
        NSMenu *photoMenu = [[NSMenu alloc] init];
        NSMenu *safariMenu = [[NSMenu alloc] init];
        NSMenu *filesystemMenu = [[NSMenu alloc] init];
        for (IMBFunctionButton *button in _categoryBtnBarView.allBtnArr) {
            switch (button.tag) {
                case Category_Music:
                case Category_CloudMusic:
                case Category_Ringtone:
                case Category_Audiobook:
                case Category_VoiceMemos:
                case Category_Playlist:
                case 500:
                {
                    if (button.tag == 500) {
                        IMBMenuItem *item = [[IMBMenuItem alloc] init];
                        [item setState:NSOnState];
                        [item setFunctionButton:button];
                        [item setEnabled:YES];
                        [item setSubmenu:audioMenu];
                        [mainMenu addItem:item];
                        [item release];
                    }else{
                        IMBMenuItem *item = [[IMBMenuItem alloc] init];
                        [item setAction:@selector(navigateTo:)];
                        [item setTarget:self];
                        [item setFunctionButton:button];
                        [item setEnabled:NO];
                        [audioMenu addItem:item];
                        [item release];
                    }
                }
                    break;
                case Category_Movies:
                case Category_HomeVideo:
                case Category_TVShow:
                case Category_MusicVideo:
                case Category_PhotoVideo:
                case Category_TimeLapse:
                case Category_SlowMove:
                case 501:
                {
                    if (button.tag == 501) {
                        IMBMenuItem *item = [[IMBMenuItem alloc] init];
                        [item setFunctionButton:button];
                        [item setEnabled:YES];
                        [item setSubmenu:videoMenu];
                        [mainMenu addItem:item];
                        [item release];
                    }else{
                        IMBMenuItem *item = [[IMBMenuItem alloc] init];
                        [item setAction:@selector(navigateTo:)];
                        [item setTarget:self];
                        [item setFunctionButton:button];
                        [item setEnabled:NO];
                        [videoMenu addItem:item];
                        [item release];
                    }
                }
                    break;
                case Category_CameraRoll:
                case Category_PhotoStream:
                case Category_PhotoLibrary:
                case Category_PhotoShare:
                case Category_Panoramas:
                case Category_MyAlbums:
                case Category_ContinuousShooting:
                case Category_LivePhoto:
                case Category_PhotoSelfies:
                case Category_Screenshot:
                case Category_Location:
                case Category_Favorite:
                case 502:
                {
                    if (button.tag == 502) {
                        IMBMenuItem *item = [[IMBMenuItem alloc] init];
                        [item setEnabled:YES];
                        [item setFunctionButton:button];
                        [item setSubmenu:photoMenu];
                        [mainMenu addItem:item];
                        [item release];
                    }else{
                        IMBMenuItem *item = [[IMBMenuItem alloc] init];
                        [item setAction:@selector(navigateTo:)];
                        [item setTarget:self];
                        [item setFunctionButton:button];
                        [item setEnabled:NO];
                        [photoMenu addItem:item];
                        [item release];
                    }
                    
                }
                    break;
                case Category_Bookmarks:
                case Category_SafariHistory:
                case 503:
                {
                    if (button.tag == 503) {
                        IMBMenuItem *item = [[IMBMenuItem alloc] init];
                        [item setFunctionButton:button];
                        [item setEnabled:YES];
                        [item setSubmenu:safariMenu];
                        [mainMenu addItem:item];
                        [item release];
                    }else{
                        IMBMenuItem *item = [[IMBMenuItem alloc] init];
                        [item setAction:@selector(navigateTo:)];
                        [item setTarget:self];
                        [item setFunctionButton:button];
                        [item setEnabled:NO];
                        [safariMenu addItem:item];
                        [item release];
                    }
                }
                    break;
                case Category_System:
                case Category_Storage:
                case 505:
                {
                    if (button.tag == 505) {
                        IMBMenuItem *item = [[IMBMenuItem alloc] init];
                        [item setFunctionButton:button];
                        [item setEnabled:YES];
                        [item setSubmenu:filesystemMenu];
                        [mainMenu addItem:item];
                        [item release];
                    }else{
                        IMBMenuItem *item = [[IMBMenuItem alloc] init];
                        [item setAction:@selector(navigateTo:)];
                        [item setTarget:self];
                        [item setFunctionButton:button];
                        [item setEnabled:NO];
                        [filesystemMenu addItem:item];
                        [item release];
                    }
                }
                    break;
                case Category_iBooks:
                case Category_Applications:
                case Category_PodCasts:
                case Category_iTunesU:
                case Category_Notes:
                case Category_Voicemail:
                case Category_Message:
                case Category_Contacts:
                case Category_Calendar:
                {
                    IMBMenuItem *item = [[IMBMenuItem alloc] init];
                    
                    
                    
                    [item setAction:@selector(navigateTo:)];
                    [item setTarget:self];
                    [item setFunctionButton:button];
                    [item setEnabled:NO];
                    [mainMenu addItem:item];
                    [item release];
                }
                    break;
            }
        }
        [audioMenu release];
        [videoMenu release];
        [photoMenu release];
        [safariMenu release];
        [filesystemMenu release];

    }else{
        for (IMBFunctionButton *button in _categoryBtnBarView.allBtnArr) {
            switch (button.tag) {
                case Category_Music:
                case Category_PodCasts:
                case Category_Audiobook:
                case Category_iTunesU:
                case Category_Movies:
                case Category_TVShow:
                case Category_MusicVideo:
                case Category_Playlist:
                {
                    IMBMenuItem *item = [[IMBMenuItem alloc] init];
                    [item setAction:@selector(navigateTo:)];
                    [item setTarget:self];
                    [item setFunctionButton:button];
                    [item setEnabled:NO];
                    [mainMenu addItem:item];
                    [item release];
                }
                    break;
            }
    }
    }
    return [mainMenu autorelease];
}

#pragma mark - NSMenuDelegate
- (void)menuDidClose:(NSMenu *)menu {
    for (IMBMenuItem *menuitem in menu.itemArray) {
        ((IMBMenuItemView *)menuitem.view).isMouseEnter = NO;
    }
}

- (void)menu:(NSMenu *)menu willHighlightItem:(NSMenuItem *)item {
    for (IMBMenuItem *menuitem in menu.itemArray) {
        if (menuitem == item) {
            ((IMBMenuItemView *)menuitem.view).isMouseEnter = YES;
        }else{
            ((IMBMenuItemView *)menuitem.view).isMouseEnter = NO;
        }
    }
}

- (void)navigateTo:(IMBMenuItem *)item {
    [_searchFieldBtn setStringValue:@""];
    [self changeView:(CategoryNodesEnum)item.FunctionButton.tag];
    ((IMBMenuItemView *)item.view).isMouseEnter = NO;
    _selectedItem = item;
    [_popUpButton.menu cancelTracking];
    NSString *countStr = @"";
    if (item.badgeCount == 0) {
        countStr = item.functionButton.buttonName;
    }else if (_selectedItem.badgeCount > 1) {
        if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
            countStr = [NSString stringWithFormat:@"%@ ( %d )",item.functionButton.buttonName,(int)item.functionButton.badgeCount];
        }else {
            countStr = [NSString stringWithFormat:@"%@ (%d %@)",item.functionButton.buttonName,(int)item.functionButton.badgeCount,CustomLocalizedString(@"MSG_Item_id_4", nil)];
        }
    }else {
        if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
            countStr = [NSString stringWithFormat:@"%@ ( %d )",item.functionButton.buttonName,(int)item.functionButton.badgeCount];
        }else {
            countStr = [NSString stringWithFormat:@"%@ (%d %@)",item.functionButton.buttonName,(int)item.functionButton.badgeCount,CustomLocalizedString(@"MSG_Item_id_3", nil)];
        }
    }
    
    [_popUpButton setTitle:countStr];
    [_occlusionView setFrameOrigin:NSMakePoint(_popUpButton.frame.size.width-_occlusionView.frame.size.width-2, 4)];
    [_popUpButton setNeedsDisplay:YES];
}

- (void)loadDeviceContent {
    __block IMBDeviceMainPageViewController *this = self;
    [_categoryBtnBarView initializationCategoryView:_ipod withCategoryBlock:^(CategoryNodesEnum category,IMBFunctionButton *button) {
        if ((int)category == 300) {
            if (_category == Category_Summary) {
                HoverButton *button1 = [self.view viewWithTag:200];
                HoverButton *button2 = [self.view viewWithTag:201];
                [button1 setHidden:YES];
                [button2 setHidden:YES];
            }
        }else if ((int)category == 301){
            if (_category == Category_Summary) {
                HoverButton *button1 = [self.view viewWithTag:200];
                HoverButton *button2 = [self.view viewWithTag:201];
                [button1 setHidden:NO];
                [button2 setHidden:NO];
            }
        }else{
            if (category == Category_Contacts) {
                IMBInformationManager *manager= [IMBInformationManager shareInstance];
                IMBInformation *information = [manager.informationDic objectForKey:_ipod.uniqueKey];
                
                if ([information contactArray].count == 0) {
                    if (![self chekiCloud:@"Contacts" withCategoryEnum:category]) {
                        return;
                    }
                }else
                {
                    if (button.openiCloud) {
                        [button setOpeniCloud:NO];
                        information.contactNeedReload = YES;
                    }
                }
            }else if (category == Category_Notes)
            {
                IMBInformationManager *manager= [IMBInformationManager shareInstance];
                IMBInformation *information = [manager.informationDic objectForKey:_ipod.uniqueKey];
                if ([information noteArray].count == 0) {
                    if (![self chekiCloud:@"Notes" withCategoryEnum:category]) {
                        return;
                    }
                }else
                {
                    if (button.openiCloud) {
                        [button setOpeniCloud:NO];
                        information.noteNeedReload = YES;
                    }
                }
            }else if (category == Category_Bookmarks)
            {
                IMBInformationManager *manager= [IMBInformationManager shareInstance];
                IMBInformation *information = [manager.informationDic objectForKey:_ipod.uniqueKey];
                if ([information bookmarkArray].count == 0) {
                    if (![self chekiCloud:@"Bookmarks" withCategoryEnum:category]) {
                        return;
                    }
                }else
                {
                    if (button.openiCloud) {
                        [button setOpeniCloud:NO];
                        information.bookmarkNeedReload = YES;
                    }
                }
            }
            else if (category == Category_Calendar)
            {
                IMBInformationManager *manager= [IMBInformationManager shareInstance];
                IMBInformation *information = [manager.informationDic objectForKey:_ipod.uniqueKey];
                
                if ([information calendarArray].count == 0) {
                    if (![self chekiCloud:@"Calendars" withCategoryEnum:category]) {
                        return;
                }
                }else
                {
                    if (button.openiCloud) {
                        [button setOpeniCloud:NO];
                        information.calendarNeedReload = YES;
                    }
                }
            }
            
            NSString *countStr = @"";
            if (button.badgeCount == 0) {
                countStr = button.title;
            }else if (button.badgeCount > 1) {
                if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                     countStr = [NSString stringWithFormat:@"%@ ( %d )",button.title,(int)button.badgeCount];
                }else {
                     countStr = [NSString stringWithFormat:@"%@ (%d %@)",button.title,(int)button.badgeCount,CustomLocalizedString(@"MSG_Item_id_4", nil)];
                }
            }else {
                if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                    countStr = [NSString stringWithFormat:@"%@ ( %d )",button.title,(int)button.badgeCount];
                }else {
                    countStr = [NSString stringWithFormat:@"%@ (%d %@)",button.title,(int)button.badgeCount,CustomLocalizedString(@"MSG_Item_id_3", nil)];
                }
            }
            _selectedBtn = button;
            _selectedItem = (IMBMenuItem *)_popUpButton.selectedItem;
            [_popUpButton setTitle:countStr];
            [_occlusionView setFrameOrigin:NSMakePoint(_popUpButton.frame.size.width-_occlusionView.frame.size.width-2, 4)];
            [_popUpButton setNeedsDisplay:YES];
            [this changeView:category];
        }
        
    }];
    
    dispatch_queue_t spatchqueue = dispatch_queue_create("load", NULL);
    [_categoryBtnBarView loadothersData:spatchqueue];
}

- (void)changeView:(CategoryNodesEnum)categoryEnum {
    [_searchFieldBtn setHidden:NO];
    [_mainTopLineView setHidden:NO];
    if (categoryEnum == Category_CameraRoll) {
        IMBInformation *info = [[IMBInformationManager shareInstance].informationDic objectForKey:_ipod.uniqueKey];
        if (_isfirstEnter && info.isiCloudPhoto) {
          [_photoPromptBgView setHidden:NO];
        } else {
          [_photoPromptBgView setHidden:YES];
        }
    } else {
          [_photoPromptBgView setHidden:YES];
    }
    
    
    if (categoryEnum == Category_Summary) {
        [self setShowTopLineView:NO];
        [_detailBox setFrameSize:self.view.frame.size];
        [_toolBar setHidden:YES];
        [_searchFieldBtn setHidden:YES];
         [_mainTopLineView setHidden:YES];
        [_searchFieldBtn setStringValue:@""];
        _isSearch = NO;
        [_detailBox setContentView:_firstCustomView];
        _category = Category_Summary;
    }else {
        [self setShowTopLineView:YES];
        [_mainTopLineView setHidden:NO];
        [_searchFieldBtn setHidden:NO];
        [_detailBox setFrameSize:NSMakeSize(self.view.frame.size.width, self.view.frame.size.height - 39)];
        [_toolBar setHidden:NO];
        [_toolBar setNeedsDisplay:YES];
        IMBBaseViewController *viewController = nil;
        BOOL isViewDisplay = YES;
        int segSelect = 1;
        if (categoryEnum == Category_Music||categoryEnum == Category_CloudMusic||categoryEnum == Category_Movies ||categoryEnum == Category_TVShow||categoryEnum == Category_MusicVideo||categoryEnum == Category_PodCasts||categoryEnum == Category_iTunesU||categoryEnum == Category_Audiobook||categoryEnum == Category_HomeVideo||categoryEnum == Category_CameraRoll||categoryEnum==Category_PhotoStream||categoryEnum==Category_PhotoLibrary || categoryEnum == Category_PhotoVideo||categoryEnum == Category_TimeLapse||categoryEnum == Category_Panoramas||categoryEnum == Category_SlowMove||categoryEnum == Category_LivePhoto||categoryEnum == Category_Screenshot||categoryEnum == Category_PhotoSelfies||categoryEnum == Category_Location||categoryEnum == Category_Favorite) {
            if ([_displayModeDic.allKeys containsObject:[NSNumber numberWithInt:categoryEnum]]) {
                segSelect = [[_displayModeDic objectForKey:[NSNumber numberWithInt:categoryEnum]] intValue];
            }
            if (segSelect == 0) {
                isViewDisplay = NO;
                viewController = [_detailPageDic objectForKey:[NSNumber numberWithInt:categoryEnum]];
            }else if (segSelect == 1) {
                isViewDisplay = YES;
                NSString *key = [NSString stringWithFormat:@"%d-%d",categoryEnum,segSelect];
                viewController = [_detailPageDic objectForKey:key];
            }
        }else {
            isViewDisplay = NO;
            viewController = [_detailPageDic objectForKey:[NSNumber numberWithInt:categoryEnum]];
        }
        if (!viewController) {
            if (categoryEnum == Category_Music||categoryEnum == Category_CloudMusic||categoryEnum == Category_Movies ||categoryEnum == Category_TVShow||categoryEnum == Category_MusicVideo||categoryEnum == Category_PodCasts||categoryEnum == Category_iTunesU||categoryEnum == Category_Audiobook||categoryEnum == Category_Ringtone||categoryEnum == Category_HomeVideo) {
                if (isViewDisplay) {
                    viewController = [[IMBTracksCollectionViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:categoryEnum withDelegate:self];
                }else {
                    viewController = [[IMBTracksListViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:categoryEnum withDelegate:self];
                }
            }else if (categoryEnum == Category_Applications) {
                viewController = [[IMBAppsListViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_MyAlbums||categoryEnum == Category_ContinuousShooting||categoryEnum == Category_PhotoShare) {
                viewController = [[IMBMyAlbumsViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_Playlist) {
                viewController = [[IMBDevicePlaylistsViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_CameraRoll||categoryEnum==Category_PhotoStream||categoryEnum==Category_PhotoLibrary || categoryEnum == Category_PhotoVideo||categoryEnum == Category_TimeLapse||categoryEnum == Category_Panoramas||categoryEnum == Category_SlowMove||categoryEnum == Category_LivePhoto||categoryEnum == Category_Screenshot||categoryEnum == Category_PhotoSelfies||categoryEnum == Category_Location||categoryEnum == Category_Favorite) {
                if (isViewDisplay) {
                    viewController = [[IMBPhotosCollectionViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:categoryEnum withDelegate:self];
                }else {
                    viewController = [[IMBPhotosListViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:categoryEnum withDelegate:self];
                }
            }else if (categoryEnum == Category_VoiceMemos) {
                viewController = [[IMBVoiceMemosViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_iBooks) {
                viewController = [[IMBiBookCollectionViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_Notes) {
                viewController = [[IMBNoteListViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_Message) {
                viewController = [[IMBMessageViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_Calendar){
                viewController = [[IMBCalendarViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_Bookmarks) {
                viewController = [[IMBBookMarkViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:categoryEnum withDelegate:self ];
            }else if (categoryEnum == Category_Contacts){
                viewController = [[IMBContactViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_Voicemail){
                viewController = [[IMBVoiceMailViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_SafariHistory){
                viewController = [[IMBSafariHistoryViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_System||categoryEnum == Category_Storage) {
                viewController = [[IMBSystemCollectionViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:categoryEnum withDelegate:self];
            }
            
            if (categoryEnum == Category_iBooks) {
                [_searchFieldBtn setHidden:YES];
            }else {
                 [_searchFieldBtn setHidden:NO];
            }
            
            if (viewController != nil) {
                HoverButton *button1 = [self.view viewWithTag:200];
                HoverButton *button2 = [self.view viewWithTag:201];
                [button1 setHidden:YES];
                [button2 setHidden:YES];
                [viewController setSearchFieldBtn:_searchFieldBtn];
                _category = categoryEnum;
                //加载工具栏按钮
                [self loadToolBarButton:categoryEnum withIsViewDisplay:isViewDisplay withViewController:viewController];
                if (isViewDisplay) {
                    [_detailPageDic setObject:viewController forKey:[NSString stringWithFormat:@"%d-%d",categoryEnum,segSelect]];
                }else {
                    [_detailPageDic setObject:viewController forKey:[NSNumber numberWithInt:categoryEnum]];
                }
                if ([viewController isKindOfClass:[IMBSystemCollectionViewController class]]) {
                    [viewController reloadTableView];
                }
                [_detailBox setContentView:viewController.view];
                [viewController release];
            }
        }else {
            [(IMBBaseViewController *)viewController reloadTableView];
            HoverButton *button1 = [self.view viewWithTag:200];
            HoverButton *button2 = [self.view viewWithTag:201];
            [button1 setHidden:YES];
            [button2 setHidden:YES];
            _category = categoryEnum;
            
            if (categoryEnum == Category_iBooks) {
                [_searchFieldBtn setHidden:YES];
            }else {
                [_searchFieldBtn setHidden:NO];
            }
            
            //加载工具栏按钮
            if (categoryEnum == Category_MyAlbums||categoryEnum == Category_PhotoShare||categoryEnum == Category_ContinuousShooting) {
                [self loadMyAlbumButton:[(IMBMyAlbumsViewController *)viewController selectedType] withIsViewDisplay:[(IMBMyAlbumsViewController *)viewController currentSelectView] withViewController:viewController];
            }else {
                [self loadToolBarButton:categoryEnum withIsViewDisplay:isViewDisplay withViewController:viewController];
            }
            
            [_detailBox setContentView:viewController.view];
            if (categoryEnum == Category_Notes) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_REFRESH_NOTEVIEW object:nil];
            }
        }
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Device_Content action:ActionNone actionParams:[IMBCommonEnum attrackerCategoryNodesEnumToString:categoryEnum] label:Switch transferCount:0 screenView:[IMBCommonEnum attrackerCategoryNodesEnumToString:categoryEnum] userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    }
}

//加载工具栏按钮
- (void)loadToolBarButton:(CategoryNodesEnum)categoryEnum withIsViewDisplay:(BOOL)isViewDisplay withViewController:(id)viewController {
    if (categoryEnum == Category_Music||categoryEnum == Category_Movies ||categoryEnum == Category_TVShow||categoryEnum == Category_MusicVideo||categoryEnum == Category_PodCasts||categoryEnum == Category_iTunesU||categoryEnum == Category_Audiobook||categoryEnum == Category_HomeVideo) {
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(1),@(2),@(3),@(4),@(5),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];
    }else if (_category == Category_CloudMusic) {
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(4),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];
    }else if (_category == Category_Ringtone) {
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(7),@(1),@(2),@(3),@(4),@(5),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_Applications) {
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(1),@(2),@(3),@(4),@(5),@(13), nil] Target:viewController DisplayMode:NO];   //加载工具栏按钮
    }else if (categoryEnum == Category_MyAlbums||categoryEnum == Category_ContinuousShooting||categoryEnum == Category_PhotoShare) {
        if (categoryEnum == Category_ContinuousShooting||categoryEnum == Category_PhotoShare) {
//            [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(4),@(5),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];   //加载工具栏按钮
        }else if (categoryEnum == Category_MyAlbums)
        {
//            [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(1),@(2),@(4),@(5),@(13), nil] Target:viewController DisplayMode:isViewDisplay];   //加载工具栏按钮
        }
    }else if (categoryEnum == Category_Playlist) {
        if ([(IMBDevicePlaylistsViewController *)viewController isPlaylistType]) {
            [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(1),@(2),@(3),@(4),@(5),@(13), nil] Target:viewController DisplayMode:NO];   //加载工具栏按钮
        }else {
            [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(2),@(3),@(4),@(5),@(13), nil] Target:viewController DisplayMode:NO];   //加载工具栏按钮
        }
    }else if (categoryEnum == Category_CameraRoll||categoryEnum==Category_PhotoStream||categoryEnum==Category_PhotoLibrary || categoryEnum == Category_PhotoVideo||categoryEnum == Category_TimeLapse||categoryEnum == Category_Panoramas||categoryEnum == Category_SlowMove||categoryEnum == Category_LivePhoto||categoryEnum == Category_Screenshot||categoryEnum == Category_PhotoSelfies||categoryEnum == Category_Location||categoryEnum == Category_Favorite) {
        if (categoryEnum == Category_PhotoLibrary) {
            //需要加 @(17)
            [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(7),@(1),@(2),@(4),@(5),@(17),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];   //加载工具栏按钮
        }else if (categoryEnum == Category_CameraRoll || categoryEnum == Category_PhotoVideo||categoryEnum == Category_TimeLapse||categoryEnum==Category_Panoramas||categoryEnum == Category_SlowMove||categoryEnum == Category_LivePhoto||categoryEnum == Category_Screenshot||categoryEnum == Category_PhotoSelfies||categoryEnum == Category_Location||categoryEnum == Category_Favorite){
            //能删除cameraRoll中的图片，需要测试一下所有系统
//            if ([_ipod.deviceInfo.getDeviceFloatVersionNumber isVersionMajorEqual:@"8.3"] || [[SystemHelper getSystemLastNumberString] isVersionAscendingEqual:@"12"]) {
//                if (categoryEnum == Category_CameraRoll || categoryEnum==Category_Panoramas) {
//                    //需要加 @(17)
//                    [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(4),@(5),@(17),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];
//                }else{
//                    [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(4),@(5),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];
//                }
//            }else {
                if (categoryEnum == Category_CameraRoll || categoryEnum==Category_Panoramas||categoryEnum == Category_LivePhoto||categoryEnum == Category_Screenshot||categoryEnum == Category_PhotoSelfies||categoryEnum == Category_Location||categoryEnum == Category_Favorite) {
                    //需要加 @(17)
                    [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(7),@(2),@(4),@(5),@(17),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];
                }else{
                    [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(2),@(4),@(5),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];
                }
//            }
        }else {
            if (_category == Category_PhotoStream) {
                //需要加 @(17)
                [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(7),@(4),@(5),@(17),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];   //加载工具栏按钮
            }else{
                [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(7),@(4),@(5),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];   //加载工具栏按钮
            }
        }
    }else if (categoryEnum == Category_VoiceMemos) {
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(1),@(2),@(3),@(4),@(5),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_iBooks) {
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(1),@(2),@(4),@(5),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_Notes) {
        //需要加 @(17)
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(1),@(7),@(2),@(4),@(5),@(17),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_Message) {
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(7),@(4),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_Calendar){
        //需要加 @(17)
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(7),@(1),@(2),@(4),@(5),@(17),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_Bookmarks) {
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(7),@(1),@(2),@(4),@(5),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_Contacts){
        //需要加 @(17)
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(7),@(1),@(2),@(4),@(5),@(15),@(16),@(17),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_Voicemail){
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(4),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_SafariHistory){
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(7),@(4),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_System) {
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(1),@(2),@(4),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_Storage){
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(1),@(2),@(4),@(9),@(13), nil] Target:viewController DisplayMode:NO];
    }

}

- (void)loadMyAlbumButton:(AlbumTypeEnum)albumEnum withIsViewDisplay:(BOOL)isViewDisplay withViewController:(id)viewController {
    if (_category == Category_MyAlbums) {
        if (albumEnum == CreateAlbum || albumEnum == LivePhoto || albumEnum == Screenshot || albumEnum == PhotoSelfies || albumEnum == Location || albumEnum == Favorite) {
            [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(7),@(2),@(4),@(5),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];   //加载工具栏按钮
        }else if (albumEnum == SyncAlbum) {
            [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(7),@(1),@(2),@(4),@(5),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];   //加载工具栏按钮
        }else {
            [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(7),@(4),@(5),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];   //加载工具栏按钮
        }
    }else if (_category == Category_ContinuousShooting) {
        //需要加 @(17)
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(7),@(2),@(4),@(5),@(17),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];   //加载工具栏按钮
    }else if (_category == Category_PhotoShare) {
        //需要加 @(17)
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(7),@(4),@(5),@(17),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];   //加载工具栏按钮
    }else {
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(4),@(5),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];   //加载工具栏按钮
    }
}

//屏蔽按钮
- (void)disableFunctionBtn:(BOOL)isDisable {
    NSArray *array = _toolBar.subviews;
    for (NSView *btn in array) {
        if (![btn isKindOfClass:[IMBMenuPopupButton class]] && btn.tag != 100) {
            if ([btn isKindOfClass:[IMBSegmentedBtn class]]) {
                IMBSegmentedBtn *segmentBtn = (IMBSegmentedBtn *)btn;
                [segmentBtn setEnabled:isDisable];
            }else {
                HoverButton *hoverBtn = (HoverButton *)btn;
                if (isDisable) {
                    [hoverBtn setStatus:1];
                }else {
                    [hoverBtn setStatus:4];
                }
                [hoverBtn setEnabled:isDisable];
                [hoverBtn setNeedsDisplay:YES];
            }
        }
    }
}

- (void)loadPlaylistButton:(BOOL)isType withViewController:(id)viewController {
    if (isType) {
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(1),@(2),@(3),@(4),@(5),@(13), nil] Target:viewController DisplayMode:NO];   //加载工具栏按钮
    }else {
        [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(2),@(3),@(4),@(5),@(13), nil] Target:viewController DisplayMode:NO];   //加载工具栏按钮
    }
}

- (void)switchView:(HoverButton *)button {
    if (button.tag == 200) {
        [_scrollView setIsdown:NO];
        [self scrollerView:_scrollView withDown:NO];
        
    }else{
        [_scrollView setIsdown:YES];
        [self scrollerView:_scrollView withDown:YES];
    }
    [self configTipPopover:button];
}

- (void)doBackView:(id)sender {
    [self changeView:Category_Summary];
    [self disableFunctionBtn:YES];
    if (_categoryBtnBarView.popUpView.frame.size.height<= ArrowSize) {
        HoverButton *button1 = [self.view viewWithTag:200];
        HoverButton *button2 = [self.view viewWithTag:201];
        [button1 setHidden:NO];
        [button2 setHidden:NO];
    }
}

- (void)doSwitchView:(id)sender {
    IMBSegmentedBtn *segBtn = (IMBSegmentedBtn *)sender;
//    [_searchFieldBtn setStringValue:@""];
//    _isSearch = NO;
    [_displayModeDic setObject:[NSNumber numberWithInteger:segBtn.selectedSegment] forKey:[NSNumber numberWithInt:_category]];
    if (segBtn.selectedSegment == 0) {
        [_searchFieldBtn setHidden:NO];
        IMBBaseViewController *viewController = [_detailPageDic objectForKey:[NSNumber numberWithInt:_category]];
        if (viewController) {
            //加载工具栏按钮
            if ([viewController.view superview]) {
                return;
            }
            [self loadToolBarButton:_category withIsViewDisplay:NO withViewController:viewController];
            [viewController reloadTableView];
            [_detailBox setContentView:viewController.view];
            [viewController setTableViewHeadOrCollectionViewCheck];
        }else {
            if (_category == Category_Music||_category == Category_CloudMusic||_category == Category_Movies ||_category == Category_TVShow||_category == Category_MusicVideo||_category == Category_PodCasts||_category == Category_iTunesU||_category == Category_Audiobook||_category == Category_Ringtone||_category == Category_HomeVideo) {
                viewController = [[IMBTracksListViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:_category withDelegate:self];
                [viewController setSearchFieldBtn:_searchFieldBtn];
            }
            else if (_category == Category_CameraRoll||_category==Category_PhotoStream||_category==Category_PhotoLibrary || _category == Category_PhotoVideo||_category == Category_TimeLapse||_category == Category_Panoramas||_category == Category_SlowMove||_category == Category_LivePhoto||_category == Category_Screenshot||_category == Category_PhotoSelfies||_category == Category_Location||_category == Category_Favorite) {
                viewController = [[IMBPhotosListViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:_category withDelegate:self];
                [viewController setSearchFieldBtn:_searchFieldBtn];
            }
            if (viewController != nil) {
                //加载工具栏按钮
                [self loadToolBarButton:_category withIsViewDisplay:NO withViewController:viewController];
                [_detailPageDic setObject:viewController forKey:[NSNumber numberWithInt:_category]];
                [viewController setTableViewHeadOrCollectionViewCheck];
                [_detailBox setContentView:viewController.view];
                if (_category == Category_CameraRoll||_category==Category_PhotoStream||_category==Category_PhotoLibrary || _category == Category_PhotoVideo||_category == Category_TimeLapse||_category == Category_Panoramas||_category == Category_SlowMove||_category == Category_LivePhoto||_category == Category_Screenshot||_category == Category_PhotoSelfies||_category == Category_Location||_category == Category_Favorite) {
                    [viewController setTableViewHeadCheckBtn];
                }
                [viewController release];
                
            }
        }
    }else if (segBtn.selectedSegment == 1) {
        NSString *key = [NSString stringWithFormat:@"%d-%ld",_category,(long)segBtn.selectedSegment];
        IMBBaseViewController *viewController = [_detailPageDic objectForKey:key];
        if (viewController) {
            if ([viewController.view superview]) {
                return;
            }
            //加载工具栏按钮
            [self loadToolBarButton:_category withIsViewDisplay:YES withViewController:viewController];
            [_detailBox setContentView:viewController.view];
            [viewController setTableViewHeadOrCollectionViewCheck];
        }else {
            if (_category == Category_Music||_category == Category_CloudMusic||_category == Category_Movies ||_category == Category_TVShow||_category == Category_MusicVideo||_category == Category_PodCasts||_category == Category_iTunesU||_category == Category_Audiobook||_category == Category_Ringtone||_category == Category_HomeVideo) {
                viewController = [[IMBTracksCollectionViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:_category withDelegate:self];
                [viewController setSearchFieldBtn:_searchFieldBtn];
            }
            else if (_category == Category_CameraRoll||_category==Category_PhotoStream||_category==Category_PhotoLibrary || _category == Category_PhotoVideo||_category == Category_TimeLapse||_category == Category_Panoramas||_category == Category_SlowMove||_category == Category_LivePhoto||_category == Category_Screenshot||_category == Category_PhotoSelfies||_category == Category_Location||_category == Category_Favorite) {
                viewController = [[IMBPhotosCollectionViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:_category withDelegate:self];
                [viewController setSearchFieldBtn:_searchFieldBtn];
            }
            if (viewController != nil) {
                //加载工具栏按钮
                [self loadToolBarButton:_category withIsViewDisplay:YES withViewController:viewController];
                [_detailPageDic setObject:viewController forKey:key];
                [_detailBox setContentView:viewController.view];
                [viewController setTableViewHeadOrCollectionViewCheck];
                [viewController release];
            }
        }
    }
}

#pragma mark - 六个大按钮动画
- (void)moveMainViewBtnAnimation {
    [_mainFunctionView setFrame:NSMakeRect(0, (self.view.frame.size.height - _mainFunctionView.frame.size.height)/2, self.view.frame.size.width, _mainFunctionView.frame.size.height)];
    
    [_toMacBtn setFrameOrigin:NSMakePoint((self.view.frame.size.width-1000)/2 + 170 + 30, 50)];
    [_addBtn setFrameOrigin:NSMakePoint((self.view.frame.size.width-1000)/2 + 326 + 30, 158)];
    [_toiTunesBtn setFrameOrigin:NSMakePoint((self.view.frame.size.width-1000)/2 + 568 + 30, 100)];
    [_toDevcieBtn setFrameOrigin:NSMakePoint((self.view.frame.size.width-1000)/2 + 714 + 30, 220)];
    [_mainFunctionView addSubview:_toMacBtn];
    [_mainFunctionView addSubview:_addBtn];
    [_mainFunctionView addSubview:_toiTunesBtn];
    [_mainFunctionView addSubview:_toDevcieBtn];

    if (_ipod.deviceInfo.isIOSDevice) {
        [_cloneBtn setFrameOrigin:NSMakePoint((self.view.frame.size.width-1000)/2 + 775 + 30,65)];
        [_mergeBtn setFrameOrigin:NSMakePoint((self.view.frame.size.width-1000)/2 + 60 + 30, 214)];
        [_fastDriverBtn setFrameOrigin:NSMakePoint((self.view.frame.size.width-1000)/2+448 + 30, 20)];
        [_mainFunctionView addSubview:_cloneBtn];
        [_mainFunctionView addSubview:_mergeBtn];
        [_mainFunctionView addSubview:_fastDriverBtn];
    }
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [_addBtn setHidden:NO];
        [_addBtn setWantsLayer:YES];
//        [_toiTunesBtn.layer setMasksToBounds:NO];
        NSPoint point = _addBtn.frame.origin;
        CGMutablePathRef fillPath = CGPathCreateMutable();
        CAKeyframeAnimation *animation = [IMBAnimation keyframeAniamtion:fillPath cp1x:-500 cp1y:point.y-100 cp2x:point.x/2 cp2y:point.y endPointX:point.x endPointY:point.y layer:_addBtn.layer];
        [animation setDuration:1.3];
        animation.autoreverses = NO;
        CABasicAnimation *opAnimation = [IMBAnimation opacityChange_Animation:1 fromValue:[NSNumber numberWithInt:0.2] toValue:[NSNumber numberWithInt:1] durTimes:1.3];
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        group.duration = 1.3;
        group.autoreverses = NO;
        group.removedOnCompletion = NO;
        group.repeatCount = 1;
        group.animations = [NSArray arrayWithObjects:animation,opAnimation,nil];
        [_addBtn.layer addAnimation:group forKey:@"deviceImageView"];
        
        [_toiTunesBtn setHidden:NO];
        [_toiTunesBtn setWantsLayer:YES];
        NSPoint todevicepoint = _toiTunesBtn.frame.origin;
        CGMutablePathRef fillPath1 = CGPathCreateMutable();
        CAKeyframeAnimation *animation1 = [IMBAnimation keyframeAniamtion:fillPath1 cp1x:self.view.frame.size.width cp1y:todevicepoint.y-100 cp2x:self.view.frame.size.width/2+todevicepoint.x/2 cp2y:todevicepoint.y endPointX:todevicepoint.x endPointY:todevicepoint.y layer:_toiTunesBtn.layer];
        [animation1 setDuration:1.3];
        animation1.autoreverses = NO;
        CABasicAnimation *opAnimation1 = [IMBAnimation opacityChange_Animation:1 fromValue:[NSNumber numberWithInt:0.2] toValue:[NSNumber numberWithInt:1] durTimes:1.3];
        CAAnimationGroup *group1 = [CAAnimationGroup animation];
        group1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        group1.duration = 1.3;
        group1.autoreverses = NO;
        group1.removedOnCompletion = NO;
        group1.repeatCount = 1;
        group1.animations = [NSArray arrayWithObjects:animation1,opAnimation1,nil];
        [_toiTunesBtn.layer addAnimation:group1 forKey:@"deviceImageView"];
        
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
            [_toMacBtn setHidden:NO];
            [_toMacBtn setWantsLayer:YES];
            NSPoint point = _toMacBtn.frame.origin;
            
            CGMutablePathRef fillPath = CGPathCreateMutable();
            CAKeyframeAnimation *animation = [IMBAnimation keyframeAniamtion:fillPath cp1x:-500 cp1y:point.y+100 cp2x:point.x/2 cp2y:_toMacBtn.frame.origin.y endPointX:point.x endPointY:point.y layer:_toMacBtn.layer];
            [animation setDuration:1];
            animation.autoreverses = NO;
            CABasicAnimation *opAnimation = [IMBAnimation opacityChange_Animation:1 fromValue:[NSNumber numberWithInt:0.2] toValue:[NSNumber numberWithInt:1] durTimes:1];
            CAAnimationGroup *group = [CAAnimationGroup animation];
            group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            group.duration = 1;
            group.autoreverses = NO;
            group.removedOnCompletion = NO;
            group.repeatCount = 1;
            group.animations = [NSArray arrayWithObjects:animation,opAnimation,nil];
            [_toMacBtn.layer addAnimation:group forKey:@"deviceImageView"];
            
            [_toDevcieBtn setHidden:NO];
            [_toDevcieBtn setWantsLayer:YES];
            NSPoint addpoint = _toDevcieBtn.frame.origin;
            CGMutablePathRef fillPath1 = CGPathCreateMutable();
            CAKeyframeAnimation *animation1 = [IMBAnimation keyframeAniamtion:fillPath1 cp1x:self.view.frame.size.width cp1y:addpoint.y+100 cp2x:self.view.frame.size.width/2+addpoint.x/2 cp2y:addpoint.y endPointX:addpoint.x endPointY:addpoint.y layer:_toDevcieBtn.layer];
            [animation1 setDuration:1];
            animation1.autoreverses = NO;
            CABasicAnimation *opAnimation1 = [IMBAnimation opacityChange_Animation:1 fromValue:[NSNumber numberWithInt:0.2] toValue:[NSNumber numberWithInt:1] durTimes:1];
            CAAnimationGroup *group1 = [CAAnimationGroup animation];
            group1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            group1.duration = 1;
            group1.autoreverses = NO;
            group1.removedOnCompletion = NO;
            group1.repeatCount = 1;
            group1.animations = [NSArray arrayWithObjects:animation1,opAnimation1,nil];
            [_toDevcieBtn.layer addAnimation:group1 forKey:@"deviceImageView"];
            
            if (_ipod.deviceInfo.isIOSDevice) {
                double delayInSeconds = 0.3;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [_mergeBtn setHidden:NO];
                    [_mergeBtn setWantsLayer:YES];
                    NSPoint point = _mergeBtn.frame.origin;
                    CGMutablePathRef fillPath = CGPathCreateMutable();
                    CAKeyframeAnimation *animation = [IMBAnimation keyframeAniamtion:fillPath cp1x:-500 cp1y:point.y cp2x:point.x/2 cp2y:point.y-100 endPointX:point.x endPointY:point.y layer:_mergeBtn.layer];
                    [animation setDuration:0.7];
                    animation.autoreverses = NO;
                    CABasicAnimation *opAnimation = [IMBAnimation opacityChange_Animation:1 fromValue:[NSNumber numberWithInt:0.2] toValue:[NSNumber numberWithInt:1] durTimes:0.7];
                    CAAnimationGroup *group = [CAAnimationGroup animation];
                    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                    group.duration = 0.7;
                    group.autoreverses = NO;
                    group.removedOnCompletion = NO;
                    group.repeatCount = 1;
                    group.animations = [NSArray arrayWithObjects:animation,opAnimation,nil];
                    [_mergeBtn.layer addAnimation:group forKey:@"deviceImageView"];
                    
                    [_cloneBtn setHidden:NO];
                    [_cloneBtn setWantsLayer:YES];
                    NSPoint clonepoint = _cloneBtn.frame.origin;
                    CGMutablePathRef fillPath1 = CGPathCreateMutable();
                    CAKeyframeAnimation *animation1 = [IMBAnimation keyframeAniamtion:fillPath1 cp1x:self.view.frame.size.width cp1y:clonepoint.y cp2x:self.view.frame.size.width/2+clonepoint.x/2 cp2y:clonepoint.y-100 endPointX:clonepoint.x endPointY:clonepoint.y layer:_cloneBtn.layer];
                    [animation1 setDuration:0.7];
                    CABasicAnimation *opAnimation1 = [IMBAnimation opacityChange_Animation:1 fromValue:[NSNumber numberWithInt:0.2] toValue:[NSNumber numberWithInt:1] durTimes:0.7];
                    CAAnimationGroup *group1 = [CAAnimationGroup animation];
                    group1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                    group1.duration = 0.7;
                    group1.autoreverses = NO;
                    group1.removedOnCompletion = NO;
                    group1.repeatCount = 1;
                    group1.animations = [NSArray arrayWithObjects:animation1,opAnimation1,nil];
                    [_cloneBtn.layer addAnimation:group1 forKey:@"deviceImageView"];
                    
                    
                    [_fastDriverBtn setHidden:NO];
                    [_fastDriverBtn setWantsLayer:YES];
                    NSPoint fastDriverpoint = _fastDriverBtn.frame.origin;
                    CGMutablePathRef fillPath2 = CGPathCreateMutable();
                    CAKeyframeAnimation *animation2 = [IMBAnimation keyframeAniamtion:fillPath2 cp1x:self.view.frame.size.width cp1y:fastDriverpoint.y cp2x:self.view.frame.size.width/2+fastDriverpoint.x/2 cp2y:fastDriverpoint.y-100 endPointX:fastDriverpoint.x endPointY:fastDriverpoint.y layer:_fastDriverBtn.layer];
                    [animation2 setDuration:0.7];
                    CABasicAnimation *opAnimation2 = [IMBAnimation opacityChange_Animation:1 fromValue:[NSNumber numberWithInt:0.2] toValue:[NSNumber numberWithInt:1] durTimes:0.7];
                    CAAnimationGroup *group2 = [CAAnimationGroup animation];
                    group2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                    group2.duration = 0.7;
                    group2.autoreverses = NO;
                    group2.removedOnCompletion = NO;
                    group2.repeatCount = 1;
                    group2.animations = [NSArray arrayWithObjects:animation2,opAnimation2,nil];
                    [_fastDriverBtn.layer addAnimation:group2 forKey:@"deviceImageView"];
                });
            }
        });
    } completionHandler:^{
        [_mainFunctionView setFrame:NSMakeRect((self.view.frame.size.width-1060)/2, _mainFunctionView.frame.origin.y, 1060, _mainFunctionView.frame.size.height)];
        [_toMacBtn setFrameOrigin:NSMakePoint(170 + 30, 50)];
        [_addBtn setFrameOrigin:NSMakePoint(326 + 30, 158)];
        [_toiTunesBtn setFrameOrigin:NSMakePoint(568 + 30, 100)];
        [_toDevcieBtn setFrameOrigin:NSMakePoint(714 + 30, 220)];
        if (_ipod.deviceInfo.isIOSDevice) {
            [_cloneBtn setFrameOrigin:NSMakePoint(775 + 30,65)];
            [_mergeBtn setFrameOrigin:NSMakePoint(60 + 30, 214)];
            [_fastDriverBtn setFrameOrigin:NSMakePoint(448 + 30, 20)];
        }
        
        [_toiTunesBtn.layer removeAllAnimations];
        [_toMacBtn.layer removeAllAnimations];
        [_toDevcieBtn.layer removeAllAnimations];
        [_addBtn.layer removeAllAnimations];
        if (_ipod.deviceInfo.isIOSDevice) {
            [_cloneBtn.layer removeAllAnimations];
            [_mergeBtn.layer removeAllAnimations];
            [_fastDriverBtn.layer removeAllAnimations];
        }
        [self startTestBtnAnimation];

    }];
 /*   [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:_toiTunesBtn forKey:NSViewAnimationTargetKey];
        [dict setObject:[NSValue valueWithRect:NSMakeRect(-200,  _toiTunesBtn.frame.origin.y, _toiTunesBtn.frame.size.width, _toiTunesBtn.frame.size.height)] forKey:NSViewAnimationStartFrameKey];
        [dict setObject:[NSValue valueWithRect:NSMakeRect(356,  _toiTunesBtn.frame.origin.y , _toiTunesBtn.frame.size.width, _toiTunesBtn.frame.size.height)] forKey:NSViewAnimationEndFrameKey];
        NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:dict,nil]];
    //    animation.delegate = self;
        [animation setDuration:0.5];
        //启动动画
        [animation startAnimation];
        
        NSMutableDictionary *dictd = [NSMutableDictionary dictionary];
        [dictd setObject:_toDevcieBtn forKey:NSViewAnimationTargetKey];
        [dictd setObject:[NSValue valueWithRect:NSMakeRect(1060,  _toDevcieBtn.frame.origin.y, _toDevcieBtn.frame.size.width, _toDevcieBtn.frame.size.height)] forKey:NSViewAnimationStartFrameKey];
        [dictd setObject:[NSValue valueWithRect:NSMakeRect(540,  _toDevcieBtn.frame.origin.y , _toDevcieBtn.frame.size.width, _toDevcieBtn.frame.size.height)] forKey:NSViewAnimationEndFrameKey];
        NSViewAnimation *animationd = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:dictd,nil]];
        //    animation.delegate = self;
        [animationd setDuration:0.5];
        //启动动画
        [animationd startAnimation];
        
        double delayInSeconds = 0.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
            [dict1 setObject:_toMacBtn forKey:NSViewAnimationTargetKey];
            [dict1 setObject:[NSValue valueWithRect:NSMakeRect(-200,  _toMacBtn.frame.origin.y, _toMacBtn.frame.size.width, _toMacBtn.frame.size.height)] forKey:NSViewAnimationStartFrameKey];
            [dict1 setObject:[NSValue valueWithRect:NSMakeRect(196,  _toMacBtn.frame.origin.y , _toMacBtn.frame.size.width, _toMacBtn.frame.size.height)] forKey:NSViewAnimationEndFrameKey];
            NSViewAnimation *animation1 = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:dict1,nil]];
            //    animation.delegate = self;
            [animation1 setDuration:0.5];
            //启动动画
            [animation1 startAnimation];
            
            NSMutableDictionary *dicta = [NSMutableDictionary dictionary];
            [dicta setObject:_addBtn forKey:NSViewAnimationTargetKey];
            [dicta setObject:[NSValue valueWithRect:NSMakeRect(1060,  _addBtn.frame.origin.y, _addBtn.frame.size.width, _addBtn.frame.size.height)] forKey:NSViewAnimationStartFrameKey];
            [dicta setObject:[NSValue valueWithRect:NSMakeRect(654,  _addBtn.frame.origin.y , _addBtn.frame.size.width, _addBtn.frame.size.height)] forKey:NSViewAnimationEndFrameKey];
            NSViewAnimation *animationa = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:dicta,nil]];
            //    animation.delegate = self;
            [animationa setDuration:0.5];
            //启动动画
            [animationa startAnimation];
            
            double delayInSeconds = 0.2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
                [dict2 setObject:_mergeBtn forKey:NSViewAnimationTargetKey];
                [dict2 setObject:[NSValue valueWithRect:NSMakeRect(-200,  _mergeBtn.frame.origin.y, _mergeBtn.frame.size.width, _mergeBtn.frame.size.height)] forKey:NSViewAnimationStartFrameKey];
                [dict2 setObject:[NSValue valueWithRect:NSMakeRect(80,  _mergeBtn.frame.origin.y , _mergeBtn.frame.size.width, _mergeBtn.frame.size.height)] forKey:NSViewAnimationEndFrameKey];
                NSViewAnimation *animation2 = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:dict2,nil]];
                //    animation.delegate = self;
                [animation2 setDuration:0.5];
                //启动动画
                [animation2 startAnimation];
                
                NSMutableDictionary *dictc = [NSMutableDictionary dictionary];
                [dictc setObject:_cloneBtn forKey:NSViewAnimationTargetKey];
                [dictc setObject:[NSValue valueWithRect:NSMakeRect(1060,  _cloneBtn.frame.origin.y, _cloneBtn.frame.size.width, _cloneBtn.frame.size.height)] forKey:NSViewAnimationStartFrameKey];
                [dictc setObject:[NSValue valueWithRect:NSMakeRect(748,  _cloneBtn.frame.origin.y , _cloneBtn.frame.size.width, _cloneBtn.frame.size.height)] forKey:NSViewAnimationEndFrameKey];
                NSViewAnimation *animationc = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:dictc,nil]];
                //    animation.delegate = self;
                [animationc setDuration:0.5];
                //启动动画
                [animationc startAnimation];
            });
        });
    } completionHandler:^{
        [self startTestBtnAnimation];
    }];*/
}

- (void)startTestBtnAnimation {
   
    if (_ipod.deviceInfo.isIOSDevice) {
        [_mergeBtn.layer setMasksToBounds:NO];
        CABasicAnimation *anima3 = [IMBAnimation moveY:0.96 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-4] repeatCount:1 beginTime:1 isAutoreverses:NO];
        anima3.beginTime=0;
        CABasicAnimation *anima33 = [IMBAnimation moveX:3.84 X:[NSNumber numberWithInt:16] repeatCount:1 beginTime:0];
        anima33.beginTime=0.96;
        CABasicAnimation *anima333 = [IMBAnimation moveY:2.4 X:[NSNumber numberWithInt:-4] Y:[NSNumber numberWithInt:6] repeatCount:1 beginTime:1 isAutoreverses:NO];
        anima333.beginTime=4.8;
        CAAnimationGroup *group3 = [CAAnimationGroup animation];
        group3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        group3.duration = 7.2;
        group3.autoreverses = YES;
        group3.removedOnCompletion = NO;
        group3.repeatCount = NSIntegerMax;
        group3.animations = [NSArray arrayWithObjects:anima3,anima33,anima333,nil];
        [_mergeBtn.layer addAnimation:group3 forKey:@"deviceImageView1"];
    }
 
    [_toMacBtn.layer setMasksToBounds:NO];
    CABasicAnimation *anima2 = [IMBAnimation moveX:2.4 X:[NSNumber numberWithInt:-10] repeatCount:1 beginTime:0];
    anima2.beginTime=0;
    CABasicAnimation *anima22 = [IMBAnimation moveY:1.92 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-8] repeatCount:1 beginTime:1 isAutoreverses:NO];
    anima22.beginTime=2.4;
    CABasicAnimation *anima222 = [IMBAnimation moveX:2.16 X:[NSNumber numberWithInt:-19] repeatCount:1 beginTime:0];
    anima222.beginTime=4.32;
    CABasicAnimation *anima2222 = [IMBAnimation moveY:2.88 X:[NSNumber numberWithInt:-8] Y:[NSNumber numberWithInt:4] repeatCount:1 beginTime:0 isAutoreverses:NO];
    anima2222.beginTime=6.48;
    CABasicAnimation *anima22222 = [IMBAnimation moveX:2.64 X:[NSNumber numberWithInt:-30] repeatCount:1 beginTime:0];
    anima22222.beginTime=9.36;
    CAAnimationGroup *group2 = [CAAnimationGroup animation];
    group2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group2.duration = 12;
    group2.autoreverses = YES;
    group2.removedOnCompletion = NO;
    group2.repeatCount = NSIntegerMax;
    group2.animations = [NSArray arrayWithObjects:anima2,anima22,anima222,anima2222,anima22222, nil];
    [_toMacBtn.layer addAnimation:group2 forKey:@"deviceImageView"];
    
    [_toiTunesBtn.layer setMasksToBounds:NO];
    CABasicAnimation *anima1 = [IMBAnimation moveY:3.12 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-13] repeatCount:1 beginTime:1 isAutoreverses:NO];
    anima1.beginTime=0;
    CABasicAnimation *anima11 = [IMBAnimation moveX:1.68 X:[NSNumber numberWithInt:-7] repeatCount:1 beginTime:0];
    anima11.beginTime=3.12;
    CABasicAnimation *anima111 = [IMBAnimation moveY:3.12 X:[NSNumber numberWithInt:-13] Y:[NSNumber numberWithInt:0] repeatCount:1 beginTime:0 isAutoreverses:NO];
    anima111.beginTime=4.8;
    CABasicAnimation *anima1111 = [IMBAnimation moveX:1.68 X:[NSNumber numberWithInt:7] repeatCount:1 beginTime:0];
    anima1111.beginTime=7.92;
    CAAnimationGroup *group1 = [CAAnimationGroup animation];
    group1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group1.duration = 9.6;
    group1.autoreverses = YES;
    group1.removedOnCompletion = NO;
    group1.repeatCount = NSIntegerMax;
    group1.animations = [NSArray arrayWithObjects:anima1,anima11,anima111,anima1111, nil];
    [_toiTunesBtn.layer addAnimation:group1 forKey:@"deviceImageView"];

   
    [_toDevcieBtn.layer setMasksToBounds:NO];
    CABasicAnimation *anima4 = [IMBAnimation moveY:1.92 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:8] repeatCount:1 beginTime:1 isAutoreverses:NO];
    anima4.beginTime=0;
    CABasicAnimation *anima44 = [IMBAnimation moveX:2.4 X:[NSNumber numberWithInt:10] repeatCount:1 beginTime:0];
    anima44.beginTime=1.92;
    CABasicAnimation *anima444 = [IMBAnimation moveY:2.88 X:[NSNumber numberWithInt:8] Y:[NSNumber numberWithInt:-4] repeatCount:1 beginTime:1 isAutoreverses:NO];
    anima444.beginTime=4.32;
    CABasicAnimation *anima4444 = [IMBAnimation moveX:2.4 X:[NSNumber numberWithInt:20] repeatCount:1 beginTime:0];
    anima4444.beginTime=7.2;
    CAAnimationGroup *group4 = [CAAnimationGroup animation];
    group4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group4.duration = 9.6;
    group4.autoreverses = YES;
    group4.removedOnCompletion = NO;
    group4.repeatCount = NSIntegerMax;
    group4.animations = [NSArray arrayWithObjects:anima4,anima44,anima444,anima4444,nil];
    [_toDevcieBtn.layer addAnimation:group4 forKey:@"deviceImageView"];
    
   
    [_addBtn.layer setMasksToBounds:NO];
    CABasicAnimation *anima5 = [IMBAnimation moveX:2.16 X:[NSNumber numberWithInt:9] repeatCount:1 beginTime:0];
    anima5.beginTime=0;
    CABasicAnimation *anima55 = [IMBAnimation moveY:1.44 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:6] repeatCount:1 beginTime:1 isAutoreverses:NO];
    anima55.beginTime=2.16;
    CABasicAnimation *anima555 = [IMBAnimation moveX:3.6 X:[NSNumber numberWithInt:24] repeatCount:1 beginTime:0];
    anima555.beginTime=3.6;
    CAAnimationGroup *group5 = [CAAnimationGroup animation];
    group5.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group5.duration = 7.2;
    group5.autoreverses = YES;
    group5.removedOnCompletion = NO;
    group5.repeatCount = NSIntegerMax;
    group5.animations = [NSArray arrayWithObjects:anima5,anima55,anima555,nil];
    [_addBtn.layer addAnimation:group5 forKey:@"deviceImageView"];
    
   
    if (_ipod.deviceInfo.isIOSDevice) {
        [_cloneBtn.layer setMasksToBounds:NO];
        CABasicAnimation *anima66 = [IMBAnimation moveX:1.44 X:[NSNumber numberWithInt:-6] repeatCount:1 beginTime:0];
        anima66.beginTime=0;
        CABasicAnimation *anima666 = [IMBAnimation moveY:3.36 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-14] repeatCount:1 beginTime:1 isAutoreverses:NO];
        anima666.beginTime=1.44;
        CABasicAnimation *anima6666 = [IMBAnimation moveX:1.44 X:[NSNumber numberWithInt:6] repeatCount:1 beginTime:0];
        anima6666.beginTime=4.8;
        CABasicAnimation *anima66666 = [IMBAnimation moveY:3.36 X:[NSNumber numberWithInt:-14] Y:[NSNumber numberWithInt:0] repeatCount:1 beginTime:1 isAutoreverses:NO];
        anima66666.beginTime=6.24;
        CAAnimationGroup *group6 = [CAAnimationGroup animation];
        group6.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        group6.duration = 9.6;
        group6.autoreverses = YES;
        group6.removedOnCompletion = NO;
        group6.repeatCount = NSIntegerMax;
        group6.animations = [NSArray arrayWithObjects:anima66,anima666,anima6666,anima66666,nil];
        [_cloneBtn.layer addAnimation:group6 forKey:@"deviceImageView"];
        
        
        CABasicAnimation *anima7 = [IMBAnimation moveY:2.36 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:10] repeatCount:1 beginTime:1 isAutoreverses:NO];
        anima7.beginTime=0;
        CABasicAnimation *anima77 = [IMBAnimation moveY:2.44 X:[NSNumber numberWithInt:10] Y:[NSNumber numberWithInt:0] repeatCount:1 beginTime:1 isAutoreverses:NO];
        anima77.beginTime=2.36;
        CAAnimationGroup *group7 = [CAAnimationGroup animation];
        group7.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        group7.duration = 4.8;
        group7.autoreverses = YES;
        group7.removedOnCompletion = NO;
        group7.repeatCount = NSIntegerMax;
        group7.animations = [NSArray arrayWithObjects:anima7,anima77,nil];
        [_fastDriverBtn.layer setMasksToBounds:NO];
        [_fastDriverBtn.layer addAnimation:group7 forKey:@"deviceImageView"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LOAD_GUIDE_VIEW object:nil];
}

- (void)stopTestBtnAnimation {
    [_toMacBtn.layer removeAllAnimations];
    [_toiTunesBtn.layer removeAllAnimations];
    [_toDevcieBtn.layer removeAllAnimations];
    [_addBtn.layer removeAllAnimations];
    [_fastDriverBtn.layer removeAllAnimations];
    if (_ipod.deviceInfo.isIOSDevice) {
        [_cloneBtn.layer removeAllAnimations];
        [_mergeBtn.layer removeAllAnimations];
    }
}

-(CAKeyframeAnimation *)keyframeAniamtion:(CGFloat)centerX centerY:(CGFloat)centerY radius:(float)radius startAngle:(CGFloat)startA endAngle:(CGFloat)endA clockwise:(BOOL)clockwise duration:(CGFloat)duration repeatCount:(float)count autoreverses:(BOOL)autoreverses beginTime:(float)beginTime {//路径动画
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    //    NSPoint endPoint = NSMakePoint(endPointX, endPointY);
    CGMutablePathRef paths = CGPathCreateMutable();
    //    CGPathMoveToPoint(paths, NULL, firstX, firstY);
    CGPathAddArc(paths, NULL, centerX, centerY, radius, startA, endA, clockwise);
    animation.path = paths;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    CGPathRelease(paths);
    //    [animation setValue:[NSValue valueWithPoint:endPoint] forKey:@"KCKeyframeAnimationProperty_EndPosition"];
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    [animation setDuration:duration];
    [animation setAutoreverses:autoreverses];
    [animation setRepeatCount:count];
    animation.beginTime = CACurrentMediaTime() + beginTime;
    return animation;
}

- (CATransition *)pushAnimation:(NSString *)type withSubType:(NSString *)subType durTimes:(float)time {//推动动画
    CATransition *transition = [CATransition animation];
    transition.duration = time;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = type;
    transition.subtype = subType;
    transition.startProgress = 0.0;
    transition.endProgress = 1.0;
    transition.removedOnCompletion = NO;
    transition.fillMode = kCAFillModeForwards;
    return transition;
}

#pragma mark - IMBScrollerProtocol delegate
- (void)scrollerView:(NSView *)scrollView withDown:(BOOL)isDown {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        HoverButton *button1 = [self.view viewWithTag:200];
        HoverButton *button2 = [self.view viewWithTag:201];
        if (isDown) {
            [button1 setIsSelected:NO];
            [button2 setIsSelected:YES];
            
            [_functionView removeFromSuperview];
            [self stopTestBtnAnimation];
            CATransition *transition = [self pushAnimation:kCATransitionPush withSubType:kCATransitionFromBottom durTimes:0.5];
            
            [_contentBox.layer removeAllAnimations];
            [_contentBox.layer addAnimation:transition forKey:@"animation"];
            [_contentBox setContentView:_contentView];
        }else {
            [button1 setIsSelected:YES];
            [button2 setIsSelected:NO];
            
            [_contentView removeFromSuperview];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self startTestBtnAnimation];
            });
            CATransition *transition = [self pushAnimation:kCATransitionPush withSubType:kCATransitionFromTop durTimes:0.5];
            
            [_contentBox.layer removeAllAnimations];
            [_contentBox.layer addAnimation:transition forKey:@"animation"];
            
            [_contentBox setContentView:_functionView];
        }
    } completionHandler:^{
        [_scrollView setIsScroll:NO];
    }];
}

#pragma mark - 六个大按钮
- (IBAction)merge:(id)sender {
    //检测是否已有两个设备准备好
    if (![self checkDeviceReady:NO]) {
        return;
    }
    if (_ipod.infoLoadFinished) {
        if (_ipod.beingSynchronized) {
            [self showAlertText:CustomLocalizedString(@"AirsyncTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            return;
        }
        IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
        NSArray *array = [connection getConnectedIPods];
        BOOL isLoad = YES;
        for (IMBiPod *ipod in array) {
            if (![ipod.uniqueKey isEqualToString:_ipod.uniqueKey] && ipod.infoLoadFinished && ipod.deviceInfo.isIOSDevice) {
                isLoad = NO;
                break;
            }
        }
        if (isLoad) {
            [self showLoadPromptPopover:CustomLocalizedString(@"MSG_Loading_devicedata", nil) withSuperView:sender];
            return;
        }
    }else {
        [self showLoadPromptPopover:CustomLocalizedString(@"MSG_Loading_devicedata", nil) withSuperView:sender];
        return;
    }
    //检测设备是否是iOS6.0及以上设备
    if ([self checkTargetDevice:NO]) {
        return;
    }
    IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
    [softWare setSelectModular:@"Merge Device"];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Merge_Device action:ToDevice actionParams:@"Merge" label:Click transferCount:0 screenView:@"Merge" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    _isClone = NO;
    _isMerge = YES;
    _isContentToMac = NO;
    _isAddContent = NO;
//    NSViewController *annoyVC = nil;
//    long long result = [self checkNeedAnnoy:&(annoyVC)];
//    if (result == 0) {
//        [self setShowTopLineView:NO];
//        return;
//    }
    NSMutableArray *cagetoryArray = [[NSMutableArray alloc] init];
    if (_categoryBtnBarView.allcategoryArr.count > 0) {
        for (IMBFunctionButton *btn in _categoryBtnBarView.allcategoryArr) {
            if (btn.tag == Category_SafariHistory || btn.tag == Category_PhotoShare|| btn.tag == Category_PhotoVideo || btn.tag == Category_MyAlbums || btn.badgeCount == 0||btn.tag == Category_TimeLapse||btn.tag == Category_ContinuousShooting||btn.tag == Category_SlowMove||btn.tag == Category_Music|| btn.tag == Category_LivePhoto  || btn.tag == Category_Screenshot|| btn.tag == Category_PhotoSelfies|| btn.tag == Category_Location|| btn.tag == Category_TimeLapse|| btn.tag == Category_Favorite) {
                if (btn.tag != Category_Message&&btn.tag != Category_Notes) {
                    continue;
                }
            }
            IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
            model.isSelected = YES;
            if (btn.tag == Category_Playlist) {
                model.categoryName = CustomLocalizedString(@"MenuItem_id_1", nil);
            }else
            {
                model.categoryName = btn.buttonName;
            }
            [model setCategoryNameAttributedString];
            model.categoryImage = btn.selectIcon;
            model.categoryNodes = (CategoryNodesEnum)btn.tag;
            [cagetoryArray addObject:model];
            [model release];
        }
    }
    //追加一个callhistory MenuItem_id_18
    IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
    model.isSelected = YES;
    model.categoryName = CustomLocalizedString(@"MenuItem_id_18", nil);
    [model setCategoryNameAttributedString];
    model.categoryImage = [StringHelper imageNamed:@"select_callhistory"];
    model.categoryNodes = Category_CallHistory;
    [cagetoryArray addObject:model];
    [model release];
    IMBMergeOrCloneViewController *controller = [[IMBMergeOrCloneViewController alloc] initWithiPod:_ipod CategoryInfoModelArrary:cagetoryArray TransferType:MergeType];
    [controller setDelegate:self];
    [self setShowTopLineView:YES];
//    if (result>0) {
//        [self animationAddTransferViewfromRight:controller.view AnnoyVC:annoyVC];
//    }else{
        [controller.view setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
        [controller.view setWantsLayer:YES];
        [self.view addSubview:controller.view];
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-controller.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1];
        [controller.view.layer addAnimation:anima1 forKey:@"deviceImageView"];
//    }
    [cagetoryArray release];
    [self setTrackingAreaEnable:NO];
}

- (IBAction)clone:(id)sender {
    //检测是否已有两个设备准备好
    if (![self checkDeviceReady:NO]) {
        return;
    }
    
    if (_ipod.infoLoadFinished) {
        if (_ipod.beingSynchronized) {
            [self showAlertText:CustomLocalizedString(@"AirsyncTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            return;
        }
        IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
        NSArray *array = [connection getConnectedIPods];
        BOOL isLoad = YES;
        for (IMBiPod *ipod in array) {
            if (![ipod.uniqueKey isEqualToString:_ipod.uniqueKey] && ipod.infoLoadFinished && ipod.deviceInfo.isIOSDevice) {
                isLoad = NO;
                break;
            }
        }
        if (isLoad) {
            [self showLoadPromptPopover:CustomLocalizedString(@"MSG_Loading_devicedata", nil) withSuperView:sender];
            return;
        }
    }else {
        [self showLoadPromptPopover:CustomLocalizedString(@"MSG_Loading_devicedata", nil) withSuperView:sender];
        return;
    }
    
   
    //检测设备是否是iOS6.0及以上设备
    if ([self checkTargetDevice:YES]) {
        return;
    }
    _isClone = YES;
    _isMerge = NO;
    _isContentToMac = NO;
    _isAddContent = NO;
//    NSViewController *annoyVC = nil;
//    long long result = [self checkNeedAnnoy:&(annoyVC)];
//    if (result == 0) {
//        [self setShowTopLineView:NO];
//        return;
//    }
    IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
    [softWare setSelectModular:@"Clone Device"];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Clone_Device action:ToDevice actionParams:@"Clone" label:Start transferCount:0 screenView:@"Clone" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSMutableArray *cagetoryArray = [[NSMutableArray alloc] init];
    if (_categoryBtnBarView.allcategoryArr.count > 0) {
        for (IMBFunctionButton *btn in _categoryBtnBarView.allcategoryArr) {
            if (btn.tag == Category_SafariHistory || btn.tag == Category_PhotoShare|| btn.tag == Category_PhotoVideo || btn.tag == Category_MyAlbums || btn.badgeCount == 0||btn.tag == Category_TimeLapse||btn.tag == Category_ContinuousShooting||btn.tag == Category_SlowMove||btn.tag == Category_Music|| btn.tag == Category_LivePhoto  || btn.tag == Category_Screenshot|| btn.tag == Category_PhotoSelfies|| btn.tag == Category_Location|| btn.tag == Category_TimeLapse|| btn.tag == Category_Favorite) {
                if (btn.tag != Category_Message&&btn.tag != Category_Notes) {
                    continue;
                }
            }
            IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
            if (btn.tag == Category_Playlist) {
                model.categoryName = CustomLocalizedString(@"MenuItem_id_1", nil);
            }else
            {
                model.categoryName = btn.buttonName;
            }
            [model setCategoryNameAttributedString];
            model.categoryImage = btn.selectIcon;
            model.categoryNodes = (CategoryNodesEnum)btn.tag;
            model.isSelected = YES;
            [cagetoryArray addObject:model];
            [model release];
        }
    }
    //追加一个callhistory MenuItem_id_18
    IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
    model.isSelected = YES;
    model.categoryName = CustomLocalizedString(@"MenuItem_id_18", nil);
    [model setCategoryNameAttributedString];
    model.categoryImage = [StringHelper imageNamed:@"select_callhistory"];
    model.categoryNodes = Category_CallHistory;
    [cagetoryArray addObject:model];
    [model release];
    
    //追加Photo，此photo代表所有有关photo的数据
    IMBCategoryInfoModel *photoModel = [[IMBCategoryInfoModel alloc] init];
    photoModel.isSelected = YES;
    photoModel.categoryName = CustomLocalizedString(@"MenuItem_id_9", nil);
    [photoModel setCategoryNameAttributedString];
    photoModel.categoryImage = [StringHelper imageNamed:@"select_photo_cameraroll"];
    photoModel.categoryNodes = Category_Photos;
    [cagetoryArray addObject:photoModel];
    [photoModel release];
    IMBMergeOrCloneViewController *controller = [[IMBMergeOrCloneViewController alloc] initWithiPod:_ipod CategoryInfoModelArrary:cagetoryArray TransferType:CloneType];
    [controller setDelegate:self];
    [self setShowTopLineView:YES];
//    if (result>0) {
//        [self animationAddTransferViewfromRight:controller.view AnnoyVC:annoyVC];
//    }else{
        [controller.view setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
        [controller.view setWantsLayer:YES];
        [self.view addSubview:controller.view];
        
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-controller.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1];
        [controller.view.layer addAnimation:anima1 forKey:@"deviceImageView"];
//    }
    [cagetoryArray release];
    [self setTrackingAreaEnable:NO];

}

- (IBAction)conentToiTunes:(id)sender {
    if (!_ipod.infoLoadFinished) {
        [self showLoadPromptPopover:CustomLocalizedString(@"MSG_Loading_devicedata", nil) withSuperView:sender];
        return;
    }
    _isClone = NO;
    _isMerge = NO;
    _isContentToMac = NO;
    _isAddContent = NO;
    NSViewController *annoyVC = nil;
//    long long result = [self checkNeedAnnoy:&(annoyVC)];
//    if (result == 0) {
//        [self setShowTopLineView:NO];
//        return;
//    }
    IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
    [softWare setSelectModular:@"Content to iTunes"];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Content_To_iTunes action:ToDevice actionParams:@"Conent" label:Start transferCount:0 screenView:@"Conent" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSMutableArray *cagetoryArray = [[NSMutableArray alloc] init];
    if (_categoryBtnBarView.allcategoryArr.count > 0) {
        for (IMBFunctionButton *btn in _categoryBtnBarView.allcategoryArr) {
            if ((btn.tag == Category_Music || btn.tag == Category_Movies || btn.tag == Category_TVShow || btn.tag == Category_Ringtone || btn.tag == Category_PodCasts || btn.tag == Category_iTunesU || btn.tag == Category_Playlist || btn.tag == Category_Applications || btn.tag == Category_Audiobook) && btn.badgeCount > 0) {
                
                if ( btn.tag == Category_Applications && [_ipod.deviceInfo.productVersion isVersionMajorEqual:@"8.3"]) {
                    continue;
                }
                IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
                model.categoryName = btn.buttonName;
                [model setCategoryNameAttributedString];
                model.categoryImage = btn.selectIcon;
                model.categoryNodes = (CategoryNodesEnum)btn.tag;
                model.isSelected = YES;
                [cagetoryArray addObject:model];
                [model release];
            }
            if (btn.tag == Category_iBooks && btn.badgeCount > 0) {
                NSString *version = [SystemHelper getSystemLastNumberString];
                if ([version isVersionAscendingEqual:@"10.9"]) {
                    IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
                    model.categoryName = btn.buttonName;
                    [model setCategoryNameAttributedString];
                    model.categoryImage = btn.selectIcon;
                    model.categoryNodes = (CategoryNodesEnum)btn.tag;
                    model.isSelected = YES;
                    [cagetoryArray addObject:model];
                    [model release];
                }
            }
        }
    }

    IMBToMacViewController *controller = [[IMBToMacViewController alloc] initWithiPod:_ipod CategoryInfoModelArrary:cagetoryArray isToMac:NO WithIsiCoudView:NO];
    [controller setDelegate:self];
    [self setShowTopLineView:YES];
//    if (result>0) {
//        [self animationAddTransferViewfromRight:controller.view AnnoyVC:annoyVC];
//    }else{
        [controller.view setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
        [controller.view setWantsLayer:YES];
        [self.view addSubview:controller.view];
        [controller.view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-controller.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
//    }
    
    [cagetoryArray release];
    [self setTrackingAreaEnable:NO];
}

- (IBAction)conentToDevice:(id)sender {
    //检测是否已有两个设备准备好
    if (![self checkDeviceReady:YES]) {
        return;
    }
    if (_ipod.infoLoadFinished) {
        if (_ipod.beingSynchronized) {
            [self showAlertText:CustomLocalizedString(@"AirsyncTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            return;
        }
        IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
        NSArray *array = [connection getConnectedIPods];
        BOOL isLoad = YES;
        for (IMBiPod *ipod in array) {
            if (![ipod.uniqueKey isEqualToString:_ipod.uniqueKey] && ipod.infoLoadFinished) {
                isLoad = NO;
                break;
            }
        }
        if (isLoad) {
            [self showLoadPromptPopover:CustomLocalizedString(@"MSG_Loading_devicedata", nil) withSuperView:sender];
            return;
        }
    }else {
        [self showLoadPromptPopover:CustomLocalizedString(@"MSG_Loading_devicedata", nil) withSuperView:sender];
        return;
    }
    if (![self checkInternetAvailble]) {
        return;
    }
    IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
    [softWare setSelectModular:@"Content to Device"];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Content_To_Device action:ToDevice actionParams:@"Conent" label:Start transferCount:0 screenView:@"Conent" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    _isClone = NO;
    _isMerge = NO;
    _isContentToMac = NO;
    _isAddContent = NO;
//    NSViewController *annoyVC = nil;
//    long long result = [self checkNeedAnnoy:&(annoyVC)];
//    if (result == 0) {
//        [self setShowTopLineView:NO];
//        return;
//    }
   
    NSMutableArray *cagetoryArray = [[NSMutableArray alloc] init];
    for (IMBFunctionButton *btn in _categoryBtnBarView.allcategoryArr) {
        if (btn.tag == Category_SafariHistory || btn.tag == Category_Message || btn.tag == Category_Calendar || btn.tag == Category_PhotoShare || btn.tag == Category_PhotoVideo || btn.tag == Category_MyAlbums || btn.tag == Category_LivePhoto  || btn.tag == Category_Screenshot|| btn.tag == Category_PhotoSelfies|| btn.tag == Category_Location|| btn.tag == Category_TimeLapse|| btn.tag == Category_Favorite || btn.tag == Category_ContinuousShooting || btn.tag == Category_SlowMove || btn.tag == Category_Panoramas|| btn.badgeCount == 0 ) {
            continue;
        }

        IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
        model.categoryName = btn.buttonName;
        [model setCategoryNameAttributedString];
        model.categoryImage = btn.selectIcon;
        model.categoryNodes = (CategoryNodesEnum)btn.tag;
        model.isSelected = YES;
        [cagetoryArray addObject:model];
        [model release];
    }
    
    IMBMergeOrCloneViewController *controller = [[IMBMergeOrCloneViewController alloc] initWithiPod:_ipod CategoryInfoModelArrary:cagetoryArray TransferType:ToDeviceType];
    [controller setDelegate:self];
    [self setShowTopLineView:YES];
//    if (result>0) {
//        [self animationAddTransferViewfromRight:controller.view AnnoyVC:annoyVC];
//    }else{
        [controller.view setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
        [controller.view setWantsLayer:YES];
        [self.view addSubview:controller.view];
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-controller.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1];
        [controller.view.layer addAnimation:anima1 forKey:@"deviceImageView"];

//    }
    [cagetoryArray release];
    [self setTrackingAreaEnable:NO];
}

- (IBAction)conentToMac:(id)sender {
    if (!_ipod.infoLoadFinished) {
        [self showLoadPromptPopover:CustomLocalizedString(@"MSG_Loading_devicedata", nil) withSuperView:sender];
        return;
    }
    _isClone = NO;
    _isMerge = NO;
    _isContentToMac = YES;
    _isAddContent = NO;
//    NSViewController *annoyVC = nil;
//    long long result = [self checkNeedAnnoy:&(annoyVC)];
//    if (result == 0) {
//        [self setShowTopLineView:NO];
//        return;
//    }
    IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
    [softWare setSelectModular:@"Content to Mac"];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Content_To_Computer action:ContentToMac actionParams:@"Content" label:Click transferCount:0 screenView:@"Content" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSMutableArray *cagetoryArray = [[NSMutableArray alloc] init];
    if (_categoryBtnBarView.allcategoryArr.count > 0) {
        for (IMBFunctionButton *btn in _categoryBtnBarView.allcategoryArr) {
            if (btn.badgeCount == 0) {
                continue;
                
            }
            if ( btn.tag == Category_Applications && [_ipod.deviceInfo.productVersion isVersionMajorEqual:@"8.3"]) {
                continue;
            }
            IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
            model.categoryName = btn.buttonName;
            [model setCategoryNameAttributedString];
            model.categoryImage = btn.selectIcon;
            model.categoryNodes = (CategoryNodesEnum)btn.tag;
            model.isSelected = YES;
            [cagetoryArray addObject:model];
            [model release];
        }
    }
    IMBToMacViewController *controller = [[IMBToMacViewController alloc] initWithiPod:_ipod CategoryInfoModelArrary:cagetoryArray isToMac:YES WithIsiCoudView:NO];
    [controller setDelegate:self];
    [self setShowTopLineView:YES];
//    if (result>0) {
//        [self animationAddTransferViewfromRight:controller.view AnnoyVC:annoyVC];
//    }else{
        [controller.view setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
        [controller.view setWantsLayer:YES];
        [self.view addSubview:controller.view];
        [controller.view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-controller.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
//    }
    [cagetoryArray release];
    [self setTrackingAreaEnable:NO];
}

- (IBAction)addContent:(id)sender {
    if (!_ipod.infoLoadFinished) {
        [self showLoadPromptPopover:CustomLocalizedString(@"MSG_Loading_devicedata", nil) withSuperView:sender];
        return;
    }
    if (![self checkInternetAvailble]) {
        return;
    }
    if (_ipod.beingSynchronized) {
        [self showAlertText:CustomLocalizedString(@"AirsyncTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    _isClone = NO;
    _isMerge = NO;
    _isContentToMac = NO;
    _isAddContent = YES;
    IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
    [softWare setSelectModular:@"Add Content"];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Add_Content action:Import actionParams:@"Add Content" label:Start transferCount:0 screenView:@"Add Content" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSArray *supportFiles = [MediaHelper filterSupportArrayWithIpod:_ipod isSingleImport:NO];//[[MediaHelper
    _openPanel = [NSOpenPanel openPanel];
    _isOpen = YES;
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel setCanChooseFiles:YES];
    [_openPanel setAllowsMultipleSelection:YES];
    [_openPanel setAllowedFileTypes:supportFiles];
    [_openPanel beginSheetModalForWindow:[(IMBDeviceMainPageViewController *)self view].window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSFileHandlingPanelOKButton) {
            NSArray *urlArr = [_openPanel URLs];
            NSMutableArray *paths = [NSMutableArray array];
            
            for (NSURL *url in urlArr) {
                [paths addObject:url.path];
            }
            [self performSelector:@selector(addItemsDelay:) withObject:paths afterDelay:0.1];
            
        }
        _isOpen = NO;
    }];
}

- (void)addItemsDelay:(NSMutableArray *)paths {
//    NSViewController *annoyVC = nil;
//    long long result = [self checkNeedAnnoy:&(annoyVC)];
//    if (result == 0) {
//        [self setShowTopLineView:NO];
//        return;
//    }
    if (_transferController != nil) {
        [_transferController release];
        _transferController = nil;
    }
    
    __block IMBPhotoEntity *albumEntity = nil;
    if (_ipod.deviceInfo.isIOSDevice) {
        if (albumEntity == nil) {
            NSArray *albumArray = [_information myAlbumsArray];
            for (IMBPhotoEntity *entity in albumArray) {
                if ([entity.albumTitle isEqualToString:CustomLocalizedString(@"MSG_AddPhotoToDefaultAlbum", nil)] && entity.albumKind == 1550) {
                    albumEntity = [entity retain];
                    break;
                }
            }
            if (albumEntity == nil) {
                albumEntity = [[IMBPhotoEntity alloc] init];
                albumEntity.albumZpk = -4;
                albumEntity.albumKind = 1550;
                albumEntity.albumTitle = CustomLocalizedString(@"MSG_AddPhotoToDefaultAlbum", nil);
                albumEntity.albumType = SyncAlbum;
            }
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        IMBAddContentViewController  *addController = [[IMBAddContentViewController alloc ]initWithiPod:_ipod withAllPaths:paths WithPhotoAlbum:albumEntity playlistID:0];
        addController.delegate = self;
        [self setShowTopLineView:YES];
//        if (result>0) {
//            [self animationAddTransferViewfromRight:addController.view AnnoyVC:annoyVC];
//        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:NO]];
            [addController.view setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
            [addController.view setWantsLayer:YES];
            [self.view addSubview:addController.view];
            [addController.view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-addController.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
//        }
        if (albumEntity != nil) {
            [albumEntity release];
            albumEntity = nil;
        }
        [self setTrackingAreaEnable:NO];
    });

}

- (IBAction)fastDriver:(id)sender {
    if (!_ipod.infoLoadFinished) {
        [self showLoadPromptPopover:CustomLocalizedString(@"MSG_Loading_devicedata", nil) withSuperView:sender];
        return;
    }
    IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
    [softWare setSelectModular:@"Fast Drive"];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Fast_Drive action:ActionNone actionParams:@"Fast Drive" label:Click transferCount:0 screenView:@"Fast Drive" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    IMBFastDriverSegViewController *fastDriverVC = [[IMBFastDriverSegViewController alloc] initWithIpod:_ipod withDelegate:self];
    [self setShowTopLineView:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:NO]];
    NSString *str = @"close";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    [fastDriverVC.view setFrameOrigin:NSMakePoint(0, 0)];
    [fastDriverVC.view setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
    [fastDriverVC.view setWantsLayer:YES];
    [self.view addSubview:fastDriverVC.view];
    [fastDriverVC.view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-fastDriverVC.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
    [self setTrackingAreaEnable:NO];
}

//- (long long)checkNeedAnnoy:(NSViewController **)annoyVC {
//    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
//    _endRunloop = NO;
//    OperationLImitation *limit = [OperationLImitation singleton];
//    if (!soft.isRegistered && (limit.remainderCount==0 || limit.remainderDays==0 || !soft.isOpenAnnoy || _isMerge || _isClone)) {
//        [self setShowTopLineView:YES];
//        long long redminderCount = (long long)limit.remainderCount;
//        //弹出骚扰窗口
//        if (_isMerge || _isClone) {//clone、merge还是用之前的骚扰界面
//            (*annoyVC) = [[IMBAnnoyViewController alloc] initWithNibName:@"IMBAnnoyViewController" Delegate:self Result:&redminderCount];
//            ((IMBAnnoyViewController *)(*annoyVC)).category = _category;
//            ((IMBAnnoyViewController *)(*annoyVC)).isClone = _isClone;
//            ((IMBAnnoyViewController *)(*annoyVC)).isMerge = _isMerge;
//            ((IMBAnnoyViewController *)(*annoyVC)).isContentToMac = _isContentToMac;
//            ((IMBAnnoyViewController *)(*annoyVC)).isAddContent = _isAddContent;
//        }else {
//            (*annoyVC) = [[IMBNewAnnoyViewController alloc] initWithNibName:@"IMBNewAnnoyViewController" Delegate:self Result:&redminderCount];
//            ((IMBNewAnnoyViewController *)(*annoyVC)).category = _category;
//            ((IMBNewAnnoyViewController *)(*annoyVC)).isClone = _isClone;
//            ((IMBNewAnnoyViewController *)(*annoyVC)).isMerge = _isMerge;
//            ((IMBNewAnnoyViewController *)(*annoyVC)).isContentToMac = _isContentToMac;
//            ((IMBNewAnnoyViewController *)(*annoyVC)).isAddContent = _isAddContent;
//        }
//        [(*annoyVC).view setFrameSize:NSMakeSize(NSWidth([self view].frame), NSHeight([self view].frame))];
//        [(*annoyVC).view setWantsLayer:YES];
//        [[self view] addSubview:(*annoyVC).view];
//        [(*annoyVC).view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-(*annoyVC).view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
//        NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
//        NSInteger result1 = NSRunContinuesResponse;
//        while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
//        {
//            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//        }
//        [NSApp endModalSession:session];
//        _endRunloop = NO;
//        return redminderCount;
//    }else{
//        return -1;
//    }
//}

- (void)showLoadPromptPopover:(NSString *)promptName withSuperView:(NSView *)view {
    if (_loadPopover != nil) {
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
    [loadPopVC.view setFrameSize:NSMakeSize(180, loadPopVC.view.frame.size.height - 10)];

    if (_loadPopover != nil) {
        _loadPopover.contentViewController = loadPopVC;
    }
    [loadPopVC release];
    
    NSRectEdge prefEdge = NSMinYEdge;
    NSRect rect = NSMakeRect(view.bounds.origin.x+18, view.bounds.origin.y + view.bounds.size.height/2, view.bounds.size.width, view.bounds.size.height);
    [_loadPopover showRelativeToRect:rect ofView:view preferredEdge:prefEdge];
}

//检测设备是否是iOS6.0及以上
- (BOOL)checkTargetDevice:(BOOL)isClone {
    IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
    NSArray *array = [connection getConnectedIPods];
    BOOL isshowAlert = YES;
    
    for (IMBiPod *ipod in array) {
        if (ipod.deviceInfo.isIOSDevice) {
            if (![ipod.uniqueKey isEqualToString:_ipod.uniqueKey] && ipod.deviceInfo.getDeviceVersionNumber>=6) {
                isshowAlert = NO;
                break;
            }
        }
    }
    if (!isshowAlert) {
        if (_ipod.deviceInfo.getDeviceVersionNumber>=6) {
            isshowAlert = NO;
            return isshowAlert;
        }else
        {
            isshowAlert = YES;
        }
    }
    if (isshowAlert) {
        if (isClone) {
            [self showAlertText:CustomLocalizedString(@"Clone_id_10", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        }else
        {
            [self showAlertText:CustomLocalizedString(@"Merge_id_11", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        }
        
    }
    return isshowAlert;
}

-(void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn {
    IMBBaseViewController *viewController = nil;
    int segSelect = 1;
    if (_category == Category_Music||_category == Category_CloudMusic||_category == Category_Movies ||_category == Category_TVShow||_category == Category_MusicVideo||_category == Category_PodCasts||_category == Category_iTunesU||_category == Category_Audiobook||_category == Category_HomeVideo||_category == Category_CameraRoll||_category==Category_PhotoStream||_category==Category_PhotoLibrary || _category == Category_PhotoVideo||_category == Category_TimeLapse||_category == Category_Panoramas||_category == Category_SlowMove||_category == Category_LivePhoto||_category == Category_Screenshot||_category == Category_PhotoSelfies||_category == Category_Location||_category == Category_Favorite) {
        if ([_displayModeDic.allKeys containsObject:[NSNumber numberWithInt:_category]]) {
            segSelect = [[_displayModeDic objectForKey:[NSNumber numberWithInt:_category]] intValue];
        }
        if (segSelect == 0) {
            viewController = [_detailPageDic objectForKey:[NSNumber numberWithInt:_category]];
        }else if (segSelect == 1) {
            NSString *key = [NSString stringWithFormat:@"%d-%d",_category,segSelect];
            viewController = [_detailPageDic objectForKey:key];
        }
    }else {
        viewController = [_detailPageDic objectForKey:[NSNumber numberWithInt:_category]];
    }
    [viewController doSearchBtn:searchStr withSearchBtn:searchBtn];
    
}

- (void)setTrackingAreaEnable:(BOOL)enable {
    [self setShowTopLineView:!enable];
    [_mergeBtn setTrackingAreaEnable:enable];
    [_cloneBtn setTrackingAreaEnable:enable];
    [_toiTunesBtn setTrackingAreaEnable:enable];
    [_toDevcieBtn setTrackingAreaEnable:enable];
    [_addBtn setTrackingAreaEnable:enable];
    [_toMacBtn setTrackingAreaEnable:enable];
    [_fastDriverBtn setTrackingAreaEnable:enable];
}

- (void)refeashBadgeConut:(int)badgeConut WithCategory:(CategoryNodesEnum)category {
    for (IMBFunctionButton *btn in _categoryBtnBarView.allBtnArr) {
        if (btn.tag == category) {
            btn.badgeCount = badgeConut;
            [btn setNeedsDisplay:YES];

            NSString *countStr = @"";
            if (btn.badgeCount == 0) {
                countStr = btn.buttonName;
            }else if (btn.badgeCount > 1) {
                if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                    countStr = [NSString stringWithFormat:@"%@ (%d)",btn.title,(int)btn.badgeCount];
                }else {
                    countStr = [NSString stringWithFormat:@"%@ (%d %@)",btn.buttonName,(int)btn.badgeCount,CustomLocalizedString(@"MSG_Item_id_4", nil)];
                }
                
            }else {
                if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                    countStr = [NSString stringWithFormat:@"%@ (%d)",btn.title,(int)btn.badgeCount];
                }else {
                    countStr = [NSString stringWithFormat:@"%@ (%d %@)",btn.buttonName,(int)btn.badgeCount,CustomLocalizedString(@"MSG_Item_id_3", nil)];
                }
            }
            
            if (badgeConut > 0) {
                btn.openiCloud = NO;
            }
            [_popUpButton setTitle:countStr];
            [_occlusionView setFrameOrigin:NSMakePoint(_popUpButton.frame.size.width-_occlusionView.frame.size.width-2, 4)];
            [_popUpButton setNeedsDisplay:YES];
            break;
        }
    }
}

- (void)configTipPopover:(id)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSNumber *number= [ user objectForKey:@"knownScroll"];
    BOOL isknown = [number boolValue];
    if (isknown) {
        return;
    }
    
    if (_tipPopover != nil) {
        [_tipPopover close];
        [_tipPopover release];
        _tipPopover = nil;
    }
    _tipPopover = [[NSPopover alloc] init];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
        _tipPopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];//
        
    }else {
        _tipPopover.appearance = NSPopoverAppearanceMinimal;
    }
    _tipPopover.animates = YES;
    _tipPopover.behavior = NSPopoverBehaviorTransient;
    _tipPopover.delegate = self;
    
    IMBTipPopoverViewController *loadPopVC = [[IMBTipPopoverViewController alloc] initWithNibName:@"IMBTipPopoverViewController" bundle:nil];
    if (_tipPopover != nil) {
        _tipPopover.contentViewController = loadPopVC;
    }
    [loadPopVC release], loadPopVC = nil;
    
    NSRectEdge prefEdge = NSMinYEdge;
    HoverButton * btn = (HoverButton *)sender;
    
    NSRect rect = NSMakeRect(btn.bounds.origin.x, btn.bounds.origin.y - 20, btn.bounds.size.width, btn.bounds.size.height);
    [_tipPopover showRelativeToRect:rect ofView:btn preferredEdge:prefEdge];
}

- (void)closeTipPopover {
    BOOL isknown = YES;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:[NSNumber numberWithBool:isknown] forKey:@"knownScroll"];

    if (_tipPopover != nil) {
        [_tipPopover close];
    }
}

- (float)getColorFromColorString:(NSString *)str WithIndex:(int)index {
    NSString *string = CustomColor(str, nil);
    NSArray *array = [string componentsSeparatedByString:@","];
    if (index <= 2) {
        return [[array objectAtIndex:index] floatValue]/255.0;
    }else {
        return [[array objectAtIndex:index] floatValue];
    }
}

- (void)setAddContentCategoryAryM:(NSMutableArray *)addContentCategoryAryM {
    if (_addContentCategoryAryM != nil) {
        [_addContentCategoryAryM release];
        _addContentCategoryAryM = nil;
    }
    _addContentCategoryAryM = [[NSMutableArray alloc] initWithArray:addContentCategoryAryM];
}

- (void)addContentReload:(NSNotification *)noti {
    if (_addContentCategoryAryM.count > 0) {
        for (NSNumber *num in _addContentCategoryAryM) {
            IMBBaseViewController *viewController = nil;
            viewController = [_detailPageDic objectForKey:num];
            if (viewController == nil) {
                NSString *str = [NSString stringWithFormat:@"%@-1",num];
                viewController = [_detailPageDic objectForKey:str];
            }
            NSArray *baseArray = nil;
            if (viewController == nil) {
                if ([num intValue] == Category_Music) {
                    [_ipod startSync];
                    [_information refreshMedia];
                    baseArray = [_information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_Music]];
                    [_ipod endSync];
                }else if ([num intValue] == Category_Movies) {
                    [_ipod startSync];
                    [_information refreshMedia];
                    baseArray = [_information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_Movies]];
                    [_ipod endSync];
                }else if ([num intValue] == Category_Ringtone) {
                    [_ipod startSync];
                    [_information refreshMedia];
                    baseArray = [_information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_Ringtone]];
                    [_ipod endSync];
                }else if ([num intValue] == Category_VoiceMemos) {
                    [_ipod startSync];
                    baseArray = [[_information recording] recordingArray];
                    [_ipod endSync];
                }else if ([num intValue] == Category_Applications) {
                    [_information.applicationManager refreshAppEntityArray];
                    baseArray = [_information.applicationManager appEntityArray];
                    [_ipod endSync];
                }else if ([num intValue] == Category_PhotoLibrary) {
                    [_information refreshPhotoLibrary];
                     baseArray = [_information photolibraryArray];
                }else if ([num intValue] == Category_Contacts) {
                    [_information loadContact];
                    baseArray = [_information contactArray];
                }else if ([num intValue] == Category_Notes) {
                    [_information loadNote];
                    baseArray = [_information noteArray];
                }
                
                [self refeashBadgeConut:(int)baseArray.count WithCategory:[num intValue]];
            }else {
                [viewController reload:nil];
            }
        }
    }
}

- (void)setShowTopLineView:(BOOL)isShow {
    [self setIsShowLineView:isShow];
    [_delegate setIsShowLineView:isShow];
}

#pragma mark - 图片下的提示语
- (void)configPhotoPromptView {
    [_photoPromptBgView setIsDeviceMain:YES];
    [_photoPromptBgView setHasCorner:YES];
    [_photoPromptBgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"prompt_bgColor", nil)]];
    [_photoPromptString setStringValue:CustomLocalizedString(@"PhotoCloudMsg", nil)];
    [_photoPromptString setTextColor:[StringHelper getColorFromString:CustomColor(@"refreshView_titleColor", nil)]];
    
    [_photoPromptBtn setFontColor:[StringHelper getColorFromString:CustomColor(@"textBtn_normalColor", nil)]];
    [_photoPromptBtn setFontEnterColor:[StringHelper getColorFromString:CustomColor(@"textBtn_enterColor", nil)]];
    [_photoPromptBtn setFontDownColor:[StringHelper getColorFromString:CustomColor(@"textBtn_downColor", nil)]];
    [_photoPromptBtn setButtonTitle:CustomLocalizedString(@"PhotoLoginToCloudMsg", nil)];
    [_photoPromptBtn setFont:[NSFont fontWithName:@"Helvetica Neue" size:13.0]];
    [_photoPromptBtn setIsPromptView:YES];
    [_photoPromptBtn setTarget:self];
    [_photoPromptBtn setAction:@selector(photoPromptBtnClick)];
    
    NSRect strRect = [StringHelper calcuTextBounds:_photoPromptString.stringValue fontSize:13.0];
    NSRect btnRect = [StringHelper calcuTextBounds:_photoPromptBtn.buttonTitle fontSize:13.0];
    [_photoPromptBgView setFrame:NSMakeRect((self.view.frame.size.width - strRect.size.width - btnRect.size.width - 40)/2.0, _photoPromptBgView.frame.origin.y, strRect.size.width + btnRect.size.width + 40, _photoPromptBgView.frame.size.height)];
    [_photoPromptString setFrame:NSMakeRect(14, _photoPromptString.frame.origin.y, strRect.size.width + 2, _photoPromptString.frame.size.height)];
    [_photoPromptBtn setFrame:NSMakeRect(_photoPromptString.frame.origin.x + strRect.size.width + 10, _photoPromptString.frame.origin.y + 2, btnRect.size.width + 10, _photoPromptBtn.frame.size.height)];
    [_photoPromptBgView setNeedsDisplay:YES];
    [_photoPromptString setNeedsDisplay:YES];
    [_photoPromptBtn setNeedsDisplay:YES];
    
}
//提示语点击执行方法
- (void)photoPromptBtnClick {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate goToiCloudView];
        [_photoPromptBgView setHidden:YES];
        _isfirstEnter = NO;
    });
    
}

- (void)dealloc {
    [_loadPopover release],_loadPopover = nil;
    [_tipPopover release], _tipPopover = nil;
    [_detailPageDic release],_detailPageDic = nil;
    [_displayModeDic release],_displayModeDic = nil;
    if (_addContentCategoryAryM != nil) {
        [_addContentCategoryAryM release];
        _addContentCategoryAryM = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_GUIDEVIEW_REMOVEADDBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_GUIDEVIEW_ADDBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_GUIDEVIEW_OPEN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_INFORMATIONDATA_LOADFINISH object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CLOSE_TIP object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_GUIDEVIEW_MAIN_DOWN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_GUIDEVIEW_CLOSE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_IPOD_DISCONTENT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_IPOD_CONTENT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_AddCONTENT_SUCCESSED object:nil];
    [super dealloc];
}

@end
