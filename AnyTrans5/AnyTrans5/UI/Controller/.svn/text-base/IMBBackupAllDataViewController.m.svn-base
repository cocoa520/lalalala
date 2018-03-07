//
//  IMBBackupAllDataViewController.m
//  AnyTrans
//
//  Created by long on 16-7-26.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBackupAllDataViewController.h"
#import "IMBBackupShowEntity.h"
#import "IMBImageAndTextCell.h"
#import "IMBBackupExplorerViewController.h"
#import "IMBBackupManager.h"
#import "IMBBackupNoteViewController.h"
#import "IMBNoteSqliteManager.h"
#import "IMBBackupContactViewController.h"
#import "IMBContactSqliteManager.h"
#import "IMBBookMarkViewController.h"
#import "IMBBookMarkSqliteManager.h"
#import "IMBHistorySqliteManager.h"
#import "IMBBackupCalendarViewController.h"
#import "IMBCalendarSqliteManager.h"
#import "IMBVoiceMailViewController.h"
#import "IMBVoiceMailSqliteManager.h"
#import "IMBMessageViewController.h"
#import "IMBMessageSqliteManager.h"
#import "IMBBackupCallHistoryViewController.h"
#import "IMBCallHistorySqliteManager.h"
#import "IMBSafariHistoryViewController.h"
#import "IMBBackupViewController.h"
#import "IMBNotificationDefine.h"
#import "IMBPhotosCollectionViewController.h"
#import "IMBBackupCollectionViewController.h"
@interface IMBBackupAllDataViewController ()

@end

@implementation IMBBackupAllDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(id)initWithSimpleNode:(SimpleNode *)simpNode withDelegate:(id)delegate withAcove4:(IMBBackupDecryptAbove4 *)dAbove4{
    if ([self initWithNibName:@"IMBBackupAllDataViewController" bundle:nil]) {
        node = [simpNode retain];
        _delegate = delegate;
        _isiCloud = NO;
        if (dAbove4 != nil) {
            _backUpDecrypt = [dAbove4 retain];
        }
    }
    return self;
}

-(id)initWithIMBiCloudBackup:(IMBiCloudBackup *)icloudBackup WithDelegate:(id)delegate{
    if ([self initWithNibName:@"IMBBackupAllDataViewController" bundle:nil]) {
        _delegate = delegate;
        _isiCloud = YES;
        _icloudbackUp = icloudBackup;
    }
    return self;
}

-(void)dealloc{
    if (operationQueue != nil) {
        [operationQueue release];
        operationQueue = nil;
    }
    if (node != nil) {
        [node release];
        node = nil;
    }
    if (_containerDic != nil) {
        [_containerDic release];
        _containerDic = nil;
    }
    if (_dataAry != nil) {
        [_dataAry release];
        _dataAry = nil;
    }
    if (_backUpDecrypt != nil) {
        [_backUpDecrypt release];
        _backUpDecrypt = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [super dealloc];
}

- (void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_toolBar changeBtnTooltipStr];
        [_dataAry removeAllObjects];
        [self loadLeftTableViewData];
        [_itemTableView reloadData];
    });
}

- (void)changeSkin:(NSNotification *)notification {
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
//    [_itemTableView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_itemTableView setBackgroundColor:[NSColor clearColor]];
    [_titleLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_arrowwhiteImageView setImage:[StringHelper imageNamed:@"mainFrame_arrow"]];
    [self loadLeftTableViewData];
    [_itemTableView reloadData];
    [_arrowWhiteView setNeedsDisplay:YES];
    [_popUpButton setNeedsDisplay:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
    [_toolBar setNeedsDisplay:YES];
}

-(void)awakeFromNib{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
//    [_itemTableView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_itemTableView setBackgroundColor:[NSColor clearColor]];
    _dataAry = [[NSMutableArray alloc]init];
    [self loadLeftTableViewData];
    _itemTableView.dataSource = self;
    _itemTableView.delegate = self;
    [_itemTableView setListener:self];
    operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue setMaxConcurrentOperationCount:20];
    _containerDic = [[NSMutableDictionary alloc]init];
    //    [indicatorView setHidden:YES];
    [self.view setWantsLayer:YES];
    [self.view.layer setMasksToBounds:YES];
    [self.view.layer setCornerRadius:5];
    if (_isiCloud){
        [progressView setHidden:NO];
        [indicatorView setHidden:NO];
        [indicatorView startAnimation:self];
        [_titleLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [_titleLable setStringValue:_icloudbackUp.deviceName];
    }
    
    [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    [_toolBar loadButtons:[NSArray arrayWithObjects:@(7),@(4),@(13), nil] Target:self DisplayMode:NO];
//    [self changeTableViewRow:0];
    _popUpButton.menu = ((IMBBackupViewController *)_delegate)->_navMainMenu;
    [_popUpButton setFrame:NSMakeRect(16+4+36, ceil((NSHeight(_toolBar.frame) - NSHeight(_popUpButton.frame))/2.0),100,22)];
    [_popUpButton setTitle:node.deviceName];
    if (!_isiCloud) {
        [_arrowWhiteView setFrameOrigin:NSMakePoint(_popUpButton.frame.size.width-_arrowWhiteView.frame.size.width-2, 4)];
        [_popUpButton addSubview:_arrowWhiteView];
        [_toolBar addSubview:_popUpButton];
    }
    [_arrowwhiteImageView setImage:[StringHelper imageNamed:@"mainFrame_arrow"]];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
    [_titleLable setAlignment:NSLeftTextAlignment];
}

-(void)loadLeftTableViewData{
    [_dataAry removeAllObjects];
    if (!_icloudbackUp) {
        IMBBackupShowEntity *showData = [[IMBBackupShowEntity alloc]init];
        showData.name = CustomLocalizedString(@"MenuItem_id_31", nil);
        showData.image = [StringHelper imageNamed:@"explore"];
        showData.imageName = @"explore";
        showData.categoryEnum = Category_Explorer;
        [_dataAry addObject:showData];
        [showData release];
    }
    IMBBackupShowEntity *showData1 = [[IMBBackupShowEntity alloc]init];
    showData1.name = CustomLocalizedString(@"MenuItem_id_17", nil);
    showData1.image = [StringHelper imageNamed:@"note"];
    showData1.imageName = @"note";
    showData1.categoryEnum = Category_Notes;
    [_dataAry addObject:showData1];
    [showData1 release];
    
    IMBBackupShowEntity *showData2 = [[IMBBackupShowEntity alloc]init];
    showData2.name = CustomLocalizedString(@"MenuItem_id_20", nil);
    showData2.image = [StringHelper imageNamed:@"contact"];
    showData2.imageName = @"contact";
    showData2.categoryEnum = Category_Contacts;
    [_dataAry addObject:showData2];
    [showData2 release];
    
    IMBBackupShowEntity *showData3 = [[IMBBackupShowEntity alloc]init];
    showData3.name = CustomLocalizedString(@"MenuItem_id_21", nil);
    showData3.image = [StringHelper imageNamed:@"bookmark"];
    showData3.categoryEnum = Category_Bookmarks;
    showData3.imageName = @"bookmark";
    [_dataAry addObject:showData3];
    [showData3 release];
    
    IMBBackupShowEntity *showData4 = [[IMBBackupShowEntity alloc]init];
    showData4.name = CustomLocalizedString(@"MenuItem_id_22", nil);
    showData4.image = [StringHelper imageNamed:@"calendar"];
    showData4.imageName = @"calendar";
    showData4.categoryEnum = Category_Calendar;
    [_dataAry addObject:showData4];
    [showData4 release];
    
    IMBBackupShowEntity *showData5 = [[IMBBackupShowEntity alloc]init];
    showData5.name = CustomLocalizedString(@"MenuItem_id_27", nil);
    showData5.image = [StringHelper imageNamed:@"voicemail"];
    showData5.imageName = @"voicemail";
    showData5.categoryEnum = Category_Voicemail;
    [_dataAry addObject:showData5];
    [showData5 release];
    
    IMBBackupShowEntity *showData6 = [[IMBBackupShowEntity alloc]init];
    showData6.name = CustomLocalizedString(@"MenuItem_id_19", nil);
    showData6.image = [StringHelper imageNamed:@"message"];
    showData6.imageName = @"message";
    showData6.categoryEnum = Category_Message;
    [_dataAry addObject:showData6];
    [showData6 release];
    
    IMBBackupShowEntity *showData7 = [[IMBBackupShowEntity alloc]init];
    showData7.name = CustomLocalizedString(@"MenuItem_id_18", nil);
    showData7.image = [StringHelper imageNamed:@"callhistory"];
    showData7.imageName = @"callhistory";
    showData7.categoryEnum = Category_CallHistory;
    [_dataAry addObject:showData7];
    [showData7 release];
    
    IMBBackupShowEntity *showData8 = [[IMBBackupShowEntity alloc]init];
    showData8.name = CustomLocalizedString(@"MenuItem_id_37", nil);
    showData8.image = [StringHelper imageNamed:@"history"];
    showData8.imageName = @"history";
    showData8.categoryEnum = Category_SafariHistory;
    [_dataAry addObject:showData8];
    [showData8 release];
    
//    if (!_icloudbackUp) {
    IMBBackupShowEntity *showData9 = [[IMBBackupShowEntity alloc]init];
    showData9.name = CustomLocalizedString(@"MenuItem_id_9", nil);
    showData9.image = [StringHelper imageNamed:@"photo"];
    showData9.imageName = @"photo";
    showData9.categoryEnum = Category_CameraRoll;
    [_dataAry addObject:showData9];
    [showData9 release];
    
    IMBBackupShowEntity *showData10 = [[IMBBackupShowEntity alloc]init];
    showData10.name = CustomLocalizedString(@"MenuItem_id_24", nil);
    showData10.image = [StringHelper imageNamed:@"Photo_video"];
    showData10.imageName = @"Photo_video";
    showData10.categoryEnum = Category_PhotoVideo;
    [_dataAry addObject:showData10];
    [showData10 release];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return _dataAry.count;
    
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 40;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    IMBBackupShowEntity *entity = [_dataAry objectAtIndex:row];
    if ([[tableColumn identifier] isEqualToString:@"Name"]) {
        return entity.name;
    }
    return @"";
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    IMBBackupShowEntity *entity = [_dataAry objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:@"Name"]){
        IMBImageAndTextCell *text = (IMBImageAndTextCell *)cell;
        [text setMarginX:20];
        [text setPaddingX:0];
        [text setImageSize:NSMakeSize(26, 26)];
        text.image = entity.image;
        text.imageName = entity.imageName;
    }
}

-(void)changeTableViewRow:(int)row{
    IMBBackupShowEntity *entity = [_dataAry objectAtIndex:row];
    NSViewController *controller = [_containerDic objectForKey:[NSNumber numberWithInt:entity.categoryEnum]];
    IMBBackupManager *backup = [IMBBackupManager shareInstance];
    [backup setIosVersion:node.productVersion];
    [[IMBLogManager singleton]writeInfoLog:[NSString stringWithFormat:@"scan ViewCategoryEnum:%d",entity.categoryEnum]];
    _category = entity.categoryEnum;
    if (controller == nil) {
        if (entity.categoryEnum == Category_Explorer) {
            controller = [[IMBBackupExplorerViewController alloc] initWithProductVersion:node withDelegate:self WithIMBBackupDecryptAbove4:_backUpDecrypt];
        }else if (entity.categoryEnum == Category_Notes){
            if (_isiCloud) {
                controller  = [[IMBBackupNoteViewController alloc]initiCloudWithiCloudBackUp:_icloudbackUp WithDelegate:self];
            }else{
                controller = [[IMBBackupNoteViewController alloc]initWithProductVersion:node withDelegate:self WithIMBBackupDecryptAbove4:_backUpDecrypt];
            }
        }else if (entity.categoryEnum == Category_Contacts){
            if (_isiCloud) {
                controller = [[IMBBackupContactViewController alloc]initiCloudWithiCloudBackUp:_icloudbackUp WithDelegate:self];
            }else{
                controller = [[IMBBackupContactViewController alloc]initWithProductVersion:node withDelegate:self WithIMBBackupDecryptAbove4:_backUpDecrypt];
            }
        }else if (entity.categoryEnum == Category_Bookmarks){
            if (_isiCloud) {
                controller = [[IMBBookMarkViewController alloc]initiCloudWithiCloudBackUp:_icloudbackUp WithDelegate:self];
            }else{
                controller = [[IMBBookMarkViewController alloc]initWithProductVersion:node withDelegate:self WithIMBBackupDecryptAbove4:_backUpDecrypt];
            }
        }else if (entity.categoryEnum == Category_Calendar){
            if (_isiCloud) {
                 controller = [[IMBBackupCalendarViewController alloc]initiCloudWithiCloudBackUp:_icloudbackUp WithDelegate:self];
            }else{
                controller = [[IMBBackupCalendarViewController alloc]initWithProductVersion:node withDelegate:self WithIMBBackupDecryptAbove4:_backUpDecrypt];
            }
        }else if (entity.categoryEnum == Category_Voicemail){
            if (_isiCloud) {
                controller = [[IMBVoiceMailViewController alloc]initiCloudWithiCloudBackUp:_icloudbackUp WithDelegate:self];
            }else{
                controller = [[IMBVoiceMailViewController alloc]initWithProductVersion:node withDelegate:self WithIMBBackupDecryptAbove4:_backUpDecrypt];
            }
        }else if (entity.categoryEnum == Category_Message){
            if (_isiCloud) {
                 controller = [[IMBMessageViewController alloc]initiCloudWithiCloudBackUp:_icloudbackUp WithDelegate:self];
            }else{
                controller = [[IMBMessageViewController alloc]initWithProductVersion:node withDelegate:self WithIMBBackupDecryptAbove4:_backUpDecrypt];
            }
        }else if (entity.categoryEnum == Category_CallHistory){
            if (_isiCloud) {
                controller = [[IMBBackupCallHistoryViewController alloc]initiCloudWithiCloudBackUp:_icloudbackUp WithDelegate:self];
            }else{
                controller = [[IMBBackupCallHistoryViewController alloc]initWithProductVersion:node withDelegate:self WithIMBBackupDecryptAbove4:_backUpDecrypt];
            }
        }else if (entity.categoryEnum == Category_SafariHistory){
            if (_isiCloud) {
                controller = [[IMBSafariHistoryViewController alloc] initiCloudWithiCloudBackUp:_icloudbackUp WithDelegate:self ];
            }else{
                controller = [[IMBSafariHistoryViewController alloc] initWithProductVersion:node withDelegate:self WithIMBBackupDecryptAbove4:_backUpDecrypt];
            }
        }else if (entity.categoryEnum == Category_CameraRoll){
            if (_isiCloud){
                controller = [[IMBPhotosCollectionViewController alloc]initiCloudWithiCloudBackUp:_icloudbackUp WithDelegate:self withCategoryNodesEnum:Category_CameraRoll];
            }else{
                controller = [[IMBBackupCollectionViewController alloc]initWithNodesEnum:Category_CameraRoll withDelegate:self WithProductVersion:node WithIMBBackupDecryptAbove4:_backUpDecrypt];
            }

        }else if (entity.categoryEnum == Category_PhotoVideo){
            if (_isiCloud){
                controller = [[IMBPhotosCollectionViewController alloc]initiCloudWithiCloudBackUp:_icloudbackUp WithDelegate:self withCategoryNodesEnum:Category_PhotoVideo];
            }else{
                controller = [[IMBBackupCollectionViewController alloc]initWithNodesEnum:Category_PhotoVideo withDelegate:self WithProductVersion:node WithIMBBackupDecryptAbove4:_backUpDecrypt];
            }
        }else if (entity.categoryEnum == Category_Thumil){
            if (_isiCloud){
                controller = [[IMBPhotosCollectionViewController alloc]initiCloudWithiCloudBackUp:_icloudbackUp WithDelegate:self withCategoryNodesEnum:Category_Thumil];
            }else{
                controller = [[IMBBackupCollectionViewController alloc]initWithNodesEnum:Category_Thumil withDelegate:self WithProductVersion:node WithIMBBackupDecryptAbove4:_backUpDecrypt];
            }
        }
        [_containerDic setObject:controller forKey:[NSNumber numberWithInt:entity.categoryEnum]];
        [_boxContainer setContentView:controller.view];
        [controller release];
    }else{
        [(IMBBaseViewController *)controller reloadTableView];
        [_boxContainer setContentView:controller.view];
    }
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    _isSearch = NO;
    NSInteger row = [_itemTableView selectedRow];
    [self changeTableViewRow:(int)row];
    [_searchFieldBtn setStringValue:@""];
}

- (void)doBack:(id)sender{
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    [_searchFieldBtn setHidden:NO];
    if (_isiCloud) {
        [_delegate backBackUpView];
    }else{
        [_delegate backBackUpView];
    }
}

- (void)reload:(id)sender
{

}

- (void)toMac:(id)sender {
    NSInteger row = [_itemTableView selectedRow];
    IMBBackupShowEntity *entity = [_dataAry objectAtIndex:row];
    IMBBaseViewController *controller = [_containerDic objectForKey:[NSNumber numberWithInt:entity.categoryEnum]];
    if (controller != nil) {
        [controller toMac:sender];
    }
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _searchFieldBtn = searchBtn;
    NSInteger row = [_itemTableView selectedRow];
    IMBBackupShowEntity *entity = [_dataAry objectAtIndex:row];
    IMBBaseViewController *controller =[_containerDic objectForKey:[NSNumber numberWithInt:entity.categoryEnum]];
    [controller doSearchBtn:searchStr withSearchBtn:searchBtn];
}

@end
