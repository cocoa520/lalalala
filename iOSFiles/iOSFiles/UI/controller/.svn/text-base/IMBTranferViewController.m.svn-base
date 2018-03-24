//
//  IMBTranferViewController.m
//  iOSFiles
//
//  Created by 龙凡 on 2018/3/22.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBTranferViewController.h"
#import "IMBDownloadListViewController.h"
#import "IMBDriveEntity.h"
#import "DriveItem.h"
static id _instance = nil;
@interface IMBTranferViewController ()

@end

@implementation IMBTranferViewController
@synthesize driveBaseManage = _driveBaseManage;
@synthesize selectedAry = _selectedAry;
@synthesize deviceExportPath = _deviceExportPath;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

+ (instancetype)singleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IMBTranferViewController alloc] initWithNibName:@"IMBTranferViewController" bundle:nil];
    });
    return _instance;
}

- (void)awakeFromNib {
//    [_topLeftBtn setTitle:CustomLocalizedString(@"Transfer_Uploading_BtnString", nil)];
//    [_topRightBtn setTitle:CustomLocalizedString(@"Transfer_Downloading_BtnString", nil)];
//    [_topLeftBtn setStringValue:CustomLocalizedString(@"Transfer_Uploading_BtnString", nil)];
//    [_topRightBtn setStringValue:CustomLocalizedString(@"Transfer_Downloading_BtnString", nil)];
    NSMutableParagraphStyle *pghStyle = [[NSMutableParagraphStyle alloc] init];
    pghStyle.alignment = NSTextAlignmentCenter;
    NSMutableDictionary *attrText = [[NSMutableDictionary alloc] init];
    [attrText setValue:COLOR_TEXT_ORDINARY forKey:NSForegroundColorAttributeName];
    [attrText setValue:[NSFont fontWithName:IMBCommonFont size:14.0] forKey:NSFontAttributeName];
    [attrText setValue:pghStyle forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"Transfer_Uploading_BtnString", nil) attributes:attrText];
    [_topLeftBtn setAttributedTitle:attrString];
    
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"Transfer_Downloading_BtnString", nil) attributes:attrText];
    [_topRightBtn setAttributedTitle:attrString2];
    
    
    [_topBottomLine setBackgroundColor:COLOR_LINE_WINDOW];
    [_topView setBorderColor:[NSColor redColor]];
    [_topLeftLine setBackgroundColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT];
    [_topLeftLine setHidden:YES];
    if (_downLoadViewController&&![_downLoadViewController.view superview]) {
        [_boxView setContentView:_downLoadViewController.view];
    }
}

- (void)icloudDriveAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage{
    if (isDown) {
        if (!_downLoadViewController) {
            _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_boxView setContentView:_downLoadViewController.view];
            //                [_downLoadViewController setDeviceManager:_driveBaseManage];
        }
        [_downLoadViewController icloudDriveAddDataSource:addDataSource WithIsDown:isDown WithDriveBaseManage:driveBaseManage];
    }else {
        if (!_upLoadViewController) {
            _upLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_boxView setContentView:_upLoadViewController.view];
//            [_upLoadViewController setDeviceManager:_driveBaseManage ];
        }
        [_upLoadViewController icloudDriveAddDataSource:addDataSource WithIsDown:isDown WithDriveBaseManage:driveBaseManage];
    }
}

- (void)dropBoxAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage{
    if (isDown) {
        if (!_downLoadViewController) {
            _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_boxView setContentView:_downLoadViewController.view];
            //                [_downLoadViewController setDeviceManager:_driveBaseManage];
        }
        [_downLoadViewController dropBoxAddDataSource:addDataSource WithIsDown:isDown WithDriveBaseManage:driveBaseManage];
    }else {
        if (!_upLoadViewController) {
            _upLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_boxView setContentView:_upLoadViewController.view];
            [_upLoadViewController setDeviceManager:_driveBaseManage];
        }
        [_upLoadViewController dropBoxAddDataSource:addDataSource WithIsDown:isDown WithDriveBaseManage:driveBaseManage];
    }
}

- (void)deviceAddDataSoure:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithiPod:(IMBiPod *) ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum isExportPath:(NSString *) exportPath{
    if (isDown) {
        if (!_downLoadViewController) {
            _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_boxView setContentView:_downLoadViewController.view];
            //                [_downLoadViewController setDeviceManager:_driveBaseManage];
        }
        [_downLoadViewController deviceAddDataSoure:addDataSource WithIsDown:isDown WithiPod:ipod withCategoryNodesEnum:categoryNodesEnum];
    }else {
        if (!_upLoadViewController) {
            _upLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_boxView setContentView:_upLoadViewController.view];
            [_upLoadViewController setDeviceManager:_driveBaseManage];
        }
        [_upLoadViewController deviceAddDataSoure:addDataSource WithIsDown:isDown WithiPod:ipod withCategoryNodesEnum:categoryNodesEnum];
    }
}


- (void)loadDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withSelectedAry:(NSMutableArray *)selectedAry withIsDownItem:(BOOL)isDownItem withiPod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum withIsiCloudDrive:(BOOL)isiCloudDrive{
        _driveBaseManage = [driveBaseManage retain];
        if (isDownItem) {
            if (!_downLoadViewController) {
                _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
                [_boxView setContentView:_downLoadViewController.view];
//                [_downLoadViewController setDeviceManager:_driveBaseManage];
            }
            if (isiCloudDrive) {
                [_downLoadViewController addDataSource:selectedAry withIsDown:isDownItem withCategoryNodesEnum:categoryNodesEnum withipod:nil withIsiCloudDrive:YES];
            }else if (ipod){
                [_downLoadViewController addDataSource:selectedAry withIsDown:isDownItem withCategoryNodesEnum:categoryNodesEnum withipod:ipod withIsiCloudDrive:NO];
                [_downLoadViewController setExportPath:_deviceExportPath];
            }else {
                [_downLoadViewController addDataSource:selectedAry withIsDown:isDownItem withCategoryNodesEnum:categoryNodesEnum withipod:nil withIsiCloudDrive:NO];
            }
        }else{
            if (!_upLoadViewController) {
                _upLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
                [_boxView setContentView:_upLoadViewController.view];
                [_upLoadViewController setDeviceManager:_driveBaseManage];
            }
            if (isiCloudDrive) {
                [_upLoadViewController addDataSource:selectedAry withIsDown:isDownItem withCategoryNodesEnum:categoryNodesEnum withipod:nil withIsiCloudDrive:YES];
            }else if (ipod){
                [_upLoadViewController addDataSource:selectedAry withIsDown:isDownItem withCategoryNodesEnum:categoryNodesEnum withipod:ipod withIsiCloudDrive:NO];
            }else {
                [_upLoadViewController addDataSource:selectedAry withIsDown:isDownItem withCategoryNodesEnum:categoryNodesEnum withipod:nil withIsiCloudDrive:NO];
            }
        }
}

- (IBAction)upLoadBtn:(id)sender {
    [_topLeftLine setBackgroundColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT];
    [_topRightLine setHidden:YES];
    [_topLeftLine setHidden:NO];
    [_boxView setContentView:_upLoadViewController.view];
}

- (IBAction)downLoadBtn:(id)sender {
    [_topRightLine setBackgroundColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT];
    [_topLeftLine setHidden:YES];
    [_topRightLine setHidden:NO];
    if (!_downLoadViewController) {
        _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
        [_boxView addSubview:_downLoadViewController.view];
//        [_downLoadViewController setDeviceManager:_driveBaseManage];
    }
    [_boxView setContentView:_downLoadViewController.view];
}

-(void)dealloc  {
    [_downAry release],_downAry = nil;
    [_upAry release],_upAry = nil;
    [_driveBaseManage release],_driveBaseManage = nil;
    [super dealloc];
}

@end
