//
//  IMBFastDriverSegViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-12-5.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBFastDriverSegViewController.h"
#import "IMBFastDriverCollectionViewController.h"
#import "IMBBackgroundBorderView.h"
#import "IMBNotificationDefine.h"
#import "IMBAnimation.h"
#import "IMBDeviceMainPageViewController.h"
#import "IMBFastDriverTreeViewController.h"
#import "IMBSoftWareInfo.h"
@interface IMBFastDriverSegViewController ()

@end

@implementation IMBFastDriverSegViewController

- (id)initWithIpod:(IMBiPod *)ipod withDelegate:(id)delegate {
    if (self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil]) {
        _ipod = [ipod retain];
        _delegate = delegate;
        _threadCount = 0;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart4:YES];
    [(IMBWhiteView *)self.view setNeedsDisplay:YES];
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_alertViewController setDelegate:self];
    [_backButton setMouseEnteredImage:[StringHelper imageNamed:@"fastdriver_arrow_left2"]  mouseExitImage:[StringHelper imageNamed:@"fastdriver_arrow_left1"] mouseDownImage:[StringHelper imageNamed:@"fastdriver_arrow_left3"]  forBidImage:[StringHelper imageNamed:@"fastdriver_arrow_left4"]];
    [_nextButton setMouseEnteredImage:[StringHelper imageNamed:@"fastdriver_arrow_right2"]  mouseExitImage:[StringHelper imageNamed:@"fastdriver_arrow_right1"] mouseDownImage:[StringHelper imageNamed:@"fastdriver_arrow_right3"]  forBidImage:[StringHelper imageNamed:@"fastdriver_arrow_right4"]];
    [_homePage setMouseEnteredImage:[StringHelper imageNamed:@"fastdriver_home2"]  mouseExitImage:[StringHelper imageNamed:@"fastdriver_home1"] mouseDownImage:[StringHelper imageNamed:@"fastdriver_home3"]  forBidImage:[StringHelper imageNamed:@"fastdriver_home4"]];
    [_homePage setTarget:self];
    [_homePage setAction:@selector(closeWindow:)];
    NSMutableArray *nextContainer = [NSMutableArray array];
    NSMutableArray *backContainer = [NSMutableArray array];
    _fastDriverCollecitonVC = [[IMBFastDriverCollectionViewController alloc] initWithIpod:_ipod withDelegate:self];
    _fastDriverCollecitonVC.advanceButton = _nextButton;
    _fastDriverCollecitonVC.backButton = _backButton;
    _fastDriverCollecitonVC->_pathField = _pathFiled;

    _curViewId = 1;
    _fastDriverCollecitonVC.nextContainer = nextContainer;
    _fastDriverCollecitonVC.backContainer = backContainer;
    [_contentBox setContentView:_fastDriverCollecitonVC.view];
    
    [_contentBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _totalSize = _ipod.deviceInfo.availableFreeSpace;
        [_fastDriverCollecitonVC getSystemFile];
    });
    
    [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(1),@(2),@(4),@(9),@(12), nil] Target:self DisplayMode:YES];
    [_backButton setTarget:_fastDriverCollecitonVC];
    [_backButton setAction:@selector(backAction:)];
    [_nextButton setTarget:_fastDriverCollecitonVC];
    [_nextButton setAction:@selector(nextAction:)];
    
//    [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(1),@(2),@(4),@(9),@(12), nil] Target:_fastDriverCollecitonVC DisplayMode:YES];
    [_toolBar addSubview:_backButton];
    [_toolBar addSubview:_nextButton];
    [_toolBar addSubview:_homePage];
    
    [separateLine setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    _fastDriverTreeVC = [[IMBFastDriverTreeViewController alloc] initWithIpod:_ipod withDelegate:self];
    _fastDriverTreeVC->_pathField = _pathFiled;
    _fastDriverTreeVC->_arrayController = _fastDriverCollecitonVC->_arrayController;
    [_pathFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"graySkin"]) {
        [_selectPromptView setBackgroundColor:[NSColor clearColor]];
    }else {
        [_selectPromptView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    }
    [_selectPromptView setNeedsDisplay:YES];
    [_selectPromptView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewWidthSizable];
    [self.view addSubview:_selectPromptView];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    
}

- (void)loadFastDriverCollecitonVC {
    [_loadingAnimationView endAnimation];
    [_contentBox setContentView:_fastDriverCollecitonVC.view];
}

- (void)doSwitchView:(id)sender
{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    NSSegmentedControl *controll = (NSSegmentedControl *)sender;
    if (controll.selectedSegment == 1) {
        [ATTracker event:Fast_Drive action:ActionNone actionParams:@"Collect View" label:Switch transferCount:0 screenView:@"Collect View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        _curViewId = 1;
        [_backButton setTarget:_fastDriverCollecitonVC];
        [_nextButton setTarget:_fastDriverCollecitonVC];
        [_contentBox setContentView:_fastDriverCollecitonVC.view];
        [_fastDriverCollecitonVC reload:nil];
    }else{
        [ATTracker event:Fast_Drive action:ActionNone actionParams:@"List View" label:Switch transferCount:0 screenView:@"List View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        _curViewId = 2;
        [_backButton setTarget:_fastDriverTreeVC];
        [_nextButton setTarget:_fastDriverTreeVC];
        [_contentBox setContentView:_fastDriverTreeVC.view];
        [_fastDriverTreeVC reload:nil];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
}


#pragma mark -Actions
- (void)treeDoubleClick:(NSInteger)index
{
    [_fastDriverCollecitonVC doubleClick:index];
}

- (void)treeBack
{
    [_fastDriverCollecitonVC backAction:nil];
    [_fastDriverTreeVC reload:nil];
}

- (void)treeNext
{
    [_fastDriverCollecitonVC nextAction:nil];
    [_fastDriverTreeVC reload:nil];
}

- (void)collectionLoadDataComplete
{
    [_fastDriverTreeVC reload:nil];
}

- (void)reloadSize
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_fastDriverTreeVC->_itemTableView reloadData];
    });
}

- (void)setSelectWord:(int)totalCount withSelectCount:(int)selectCount {
    NSString *wordStr = @"";
    if (_totalSize < 0) {
        _totalSize = 0;
    }
    if (selectCount == 0) {
        NSString *subStr = [_fastDriverCollecitonVC.currentDevicePath substringFromIndex:16];
        NSString *path = [[NSString stringWithFormat:@"/%@" ,CustomLocalizedString(@"Fast_Drive_id_1", nil)] stringByAppendingString:subStr];
        [_pathFiled setStringValue:path];
        if (totalCount <= 1) {
            wordStr = [NSString stringWithFormat:CustomLocalizedString(@"Fast_Drive_id_2", nil),totalCount,[StringHelper getFileSizeString:_totalSize reserved:1]];
        }else {
            wordStr = [NSString stringWithFormat:CustomLocalizedString(@"Fast_Drive_id_3", nil),totalCount,[StringHelper getFileSizeString:_totalSize reserved:1]];
        }
    }else {
        if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
            wordStr = [NSString stringWithFormat:CustomLocalizedString(@"Fast_Drive_id_4", nil),totalCount,selectCount,[StringHelper getFileSizeString:_totalSize reserved:1]];
        }else {
            wordStr = [NSString stringWithFormat:CustomLocalizedString(@"Fast_Drive_id_4", nil),selectCount,totalCount,[StringHelper getFileSizeString:_totalSize reserved:1]];
        }
    }
    
//    NSRect textRect = [StringHelper calcuTextBounds:wordStr fontSize:14];
    
    [_selectPromptView initWithLuCorner:NO LbCorner:YES RuCorner:NO RbConer:YES CornerRadius:5];
    
    [_selectPromptTitle setStringValue:wordStr];
    [_selectPromptTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
//    [_selectPromptView setFrame:NSMakeRect(((self.view.bounds.size.width) - (textRect.size.width + 100))/2, 0, (textRect.size.width + 100), 30)];
//    [_selectPromptTitle setFrame:NSMakeRect(0, 10, _selectPromptView.frame.size.width, _selectPromptTitle.frame.size.height)];
}

- (void)closeCopy:(SimpleNode *)node
{
    if (node.isStop&&!node.transfer) {
        [_fastDriverCollecitonVC->_arrayController removeObject:node];
        [_fastDriverTreeVC reload:nil];
        node.isCoping = NO;
        [node.listprogressBar removeFromSuperview];
        [node.coprogressBar removeFromSuperview];
        [node.listCloseButton removeFromSuperview];
        [node.coCloseButton removeFromSuperview];
    }
}
- (NSArray *)doDelete:(NSArray *)selectedTracks {
    [_fastDriverCollecitonVC doDelete:selectedTracks];
    _totalSize = _ipod.deviceInfo.availableFreeSpace;
    return nil;
}

- (void)doReloadDelete:(NSArray *)newArray {
    [_fastDriverCollecitonVC doReloadDelete:newArray];
}

- (void)doRename:(SimpleNode *)seletednode withName:(NSString *)name {
    [_fastDriverCollecitonVC doRename:seletednode withName:name];
}

- (void)dealloc
{
    [_fastDriverCollecitonVC release],_fastDriverCollecitonVC = nil;
    [_fastDriverTreeVC release],_fastDriverTreeVC = nil;
    [super dealloc];
}

- (IBAction)closeWindow:(id)sender {
    if (_threadCount > 0) {
        [_alertViewController setIsStopPan:YES];
        int result = [self showAlertText:CustomLocalizedString(@"Main_Window_Stop_Tips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)];
        [_alertViewController setIsStopPan:NO];
        if (result) {
            _threadCount = 0;
            //执行停止操作,关闭窗口
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
            [self animationRemoveToMacView];
        }
    }else {
        _threadCount = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
        [self animationRemoveToMacView];
    }
}

- (void)animationRemoveToMacView {
    //放开语言设置按钮-----long
    NSString *str = @"open";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    
    [self.view setFrame: NSMakeRect(0, -20, NSWidth(self.view.frame), NSHeight(self.view.frame)+20)];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:@(0) Y:@(20) repeatCount:1];
        anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.view.layer addAnimation:anima1 forKey:@"moveY"];
    } completionHandler:^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:@(20) Y:@(-NSHeight(self.view.frame)) repeatCount:1];
            anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [self.view.layer addAnimation:anima1 forKey:@"moveY"];
            if (_delegate && [_delegate respondsToSelector:@selector(setTrackingAreaEnable:)]) {
                [_delegate setTrackingAreaEnable:YES];
            }
        } completionHandler:^{
            [self.view removeFromSuperview];
            [self release];
        }];
    }];
}

#pragma mark - 功能实现方法
- (void)reload:(id)sender {
    [self disableFunctionBtn:NO];
    [_contentBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *array = nil;
        if (_fastDriverCollecitonVC != nil) {
            array = [_fastDriverCollecitonVC doReloadMode];
        }
        _totalSize = _ipod.deviceInfo.availableFreeSpace;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self disableFunctionBtn:YES];
            if (_fastDriverCollecitonVC != nil) {
                [_fastDriverCollecitonVC reloadView:array];
            }
            [_loadingAnimationView endAnimation];
            if (_curViewId == 1) {
                if (_fastDriverCollecitonVC != nil) {
                    [_contentBox setContentView:_fastDriverCollecitonVC.view];
                }
            }else {
                if (_fastDriverTreeVC != nil) {
                    [_contentBox setContentView:_fastDriverTreeVC.view];
                }
            }
            [self setSelectWord:(int)[_fastDriverCollecitonVC->_arrayController.content count] withSelectCount:(int)[_fastDriverCollecitonVC->_arrayController selectionIndexes].count];
            
        });
    });
}

- (void)deleteItems:(id)sender {
    if (_curViewId == 1) {
        if (_fastDriverCollecitonVC != nil) {
            [_fastDriverCollecitonVC deleteSelectedItems];
        }
    }else {
        if (_fastDriverTreeVC != nil) {
            [_fastDriverTreeVC deleteSelectedItems];
        }
    }
}

- (void)toMac:(id)sender {
    NSIndexSet *selectedSet = nil;
    if (_curViewId == 1) {
        if (_fastDriverCollecitonVC != nil) {
            selectedSet = [_fastDriverCollecitonVC selectedItems];
        }
    }else {
        if (_fastDriverTreeVC != nil) {
            selectedSet = [_fastDriverTreeVC selectedItems];
        }
    }
    if ([selectedSet count] <= 0) {
        //弹出警告确认框
        NSString *str = CustomLocalizedString(@"Export_View_Selected_Tips", nil);
        
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }else {
        //弹出路径选择框
        _openPanel = [IMBOpenPanel openPanel];
        _isOpen = YES;
        [_openPanel setAllowsMultipleSelection:NO];
        [_openPanel setCanChooseFiles:NO];
        [_openPanel setCanChooseDirectories:YES];
        [_openPanel beginSheetModalForWindow:[(IMBDeviceMainPageViewController *)_delegate view].window completionHandler:^(NSInteger result) {
            if (result== NSFileHandlingPanelOKButton) {
                [self performSelector:@selector(fastDrivetoMacDelay:) withObject:_openPanel afterDelay:0.1];
            }else{
                NSLog(@"other other other");
            }
            _isOpen = NO;
        }];
    }
}

- (void)fastDrivetoMacDelay:(NSOpenPanel *)openPanel
{
    NSViewController *annoyVC = nil;
    long long result1 = [self checkNeedAnnoy:&(annoyVC)];
    if (result1 == 0) {
        return;
    }
    [((IMBNewAnnoyViewController *)annoyVC) closeWindow:nil];
    NSString *path = [[openPanel URL] path];
    NSString *filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:CustomLocalizedString(@"Fast_Drive_id_1", nil)];
//    [self copyCollectionContentToMac:filePath Result:result1 AnnoyVC:annoyVC];
    if (_curViewId == 1) {
        if (_fastDriverCollecitonVC != nil) {
            [_fastDriverCollecitonVC exportSelectedItems:filePath];
        }
    }else {
        if (_fastDriverTreeVC != nil) {
            [_fastDriverTreeVC exportSelectedItems:filePath];
        }
    }
}

- (void)doEdit:(id)sender {
    if (_curViewId == 1) {
        if (_fastDriverCollecitonVC != nil) {
            [_fastDriverCollecitonVC editFileName];
        }
    }else {
        if (_fastDriverTreeVC != nil) {
            [_fastDriverTreeVC editFileName];
        }
    }
}

- (void)addItems:(id)sender
{
    _openPanel = [NSOpenPanel openPanel];
    _isOpen = YES;
    [_openPanel setAllowsMultipleSelection:YES];
    [_openPanel setCanChooseFiles:YES];
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode== NSFileHandlingPanelOKButton) {
            _threadCount ++;
            NSArray *urlArr = [_openPanel URLs];
            NSMutableArray *paths = [NSMutableArray array];
            for (NSURL *url in urlArr) {
                [paths addObject:url.path];
            }
            [self performSelector:@selector(startTransfer:) withObject:paths afterDelay:0.3];
        }
        _isOpen = NO;
    }];
}

- (void)startTransfer:(NSMutableArray *)paths
{
    if (_totalSize <=0) {
        [self showAlertText:[NSString stringWithFormat:CustomLocalizedString(@"Ex_OutOfDiskSpace", nil),_ipod.deviceInfo.deviceName]  OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        _threadCount --;
        return;
    }
    NSViewController *annoyVC = nil;
    long long result = [self checkNeedAnnoy:&(annoyVC)];
    if (result == 0) {
        _threadCount --;
        return;
    }
    [((IMBNewAnnoyViewController *)annoyVC) closeWindow:nil];
    [_fastDriverCollecitonVC setCollectionView];
    //构造simpleNode对象
    NSMutableArray *simnodeArray = [self createSimnode:paths];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Fast_Drive action:Import actionParams:@"Fast Drive" label:Start transferCount:0 screenView:@"Fast Drive" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSIndexSet *cset = [[_fastDriverCollecitonVC->_collectionView selectionIndexes] copy];
    [_fastDriverCollecitonVC->_arrayController addObjects:simnodeArray];
    [_fastDriverCollecitonVC->_arrayController setSelectionIndexes:cset];
    [cset release];
    [_fastDriverTreeVC reload:nil];
    NSButton *refreshButton = [_toolBar viewWithTag:1000];
    [refreshButton setEnabled:NO];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            IMBBaseTransfer *baseTransfer = [[IMBBaseTransfer alloc] initWithIPodkey:_ipod.uniqueKey importTracks:nil withCurrentPath:_fastDriverCollecitonVC.currentDevicePath withDelegate:nil];
            for (SimpleNode *node in simnodeArray) {
                
                if (_threadCount == 0 || _totalSize<=0) {
                    baseTransfer.isStop = YES;
                }
                if (!node.isStop) {
                    baseTransfer.isStop = NO;
                    if (_threadCount == 0 || _totalSize<=0) {
                        baseTransfer.isStop = YES;
                    }
                    baseTransfer->_transferDelegate = node;
                    baseTransfer->_exportTracks = [NSMutableArray arrayWithObject:node.sourcePath];
                    node.transfer = baseTransfer;
                    @try {
                        [baseTransfer startTransfer];
                        _totalSize -= baseTransfer->_totalSize;
                    }
                    @catch (NSException *exception) {
                    }
                    @finally {
                    }
                }
            }
            _threadCount --;
            if (_threadCount == 0) {
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:Fast_Drive action:Import actionParams:@"Fast Drive" label:Finish transferCount:0 screenView:@"Fast Drive" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                _totalSize = _ipod.deviceInfo.availableFreeSpace;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![IMBSoftWareInfo singleton].isRegistered) {
                        [self reload:nil];
                    }
                    [self setSelectWord:[_fastDriverCollecitonVC->_arrayController.content count] withSelectCount:[_fastDriverCollecitonVC->_arrayController selectionIndexes].count];
                    [refreshButton setEnabled:YES];
                });
            }
        }
    });

}

- (NSMutableArray *)createSimnode:(NSMutableArray *)paths
{
    NSMutableArray *simpleNodeArray = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *path in paths) {
        NSString *fileName = [path lastPathComponent];
        NSString *destinationPath = [_fastDriverCollecitonVC.currentDevicePath stringByAppendingPathComponent:fileName];
        
        SimpleNode *node = [[SimpleNode alloc] initWithName:fileName];
        node.creatDate = [DateHelper stringFromFomate:[NSDate date] formate:@"yyyy-MM-dd HH:mm"];
        node.controller = self;
        [node createProgressBar];
        node.path = destinationPath;
        node.sourcePath = path;
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:path isDirectory:&isDir]) {
            if (isDir) {
                if ([[_ipod.fileSystem afcMediaDirectory] fileExistsAtPath:destinationPath]) {
                    destinationPath = [IMBFastDriverSegViewController getFolderPathAlias:destinationPath iPod:_ipod];
                }
                OSType code = UTGetOSTypeFromString((CFStringRef)@"fldr");
                NSImage *picture = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(code)];
                [picture setSize:NSMakeSize(74, 74)];
                node.image = picture;
                node.container = YES;
                node.fileName = [destinationPath lastPathComponent];
            }else{
                if ([[_ipod.fileSystem afcMediaDirectory] fileExistsAtPath:destinationPath]) {
                    destinationPath = [IMBFastDriverSegViewController getFilePathAlias:destinationPath iPod:_ipod];
                }
                node.container = NO;
                NSString *extension = [node.path pathExtension];
                NSWorkspace *workSpace = [[NSWorkspace alloc] init];
                NSImage *icon = [workSpace iconForFileType:extension];
                [icon setSize:NSMakeSize(64, 60)];
                node.image = icon;
                node.fileName = [destinationPath lastPathComponent];
                [workSpace release];
            }
            [simpleNodeArray addObject:node];
            [node release];
        }
        
    }
    return simpleNodeArray;
}

+(NSString*)getFilePathAlias:(NSString*)filePath iPod:(IMBiPod *)ipod{
    NSString *newPath = filePath;
    int i = 1;
    NSString *filePathWithOutExt = [filePath stringByDeletingPathExtension];
    NSString *fileExtension = [filePath pathExtension];
    while ([[ipod.fileSystem afcMediaDirectory]  fileExistsAtPath:newPath]) {
        newPath = [NSString stringWithFormat:@"%@(%d).%@",filePathWithOutExt,i++,fileExtension];
    }
    return newPath;
}

//文件夹存在，生成别名
+ (NSString *)getFolderPathAlias:(NSString *)folderPath iPod:(IMBiPod *)ipod{
    NSString *newPath = folderPath;
    int i = 1;
    while ([[ipod.fileSystem afcMediaDirectory]  fileExistsAtPath:newPath]) {
        newPath = [NSString stringWithFormat:@"%@-%d",folderPath,i++];
    }
    return newPath;
}


#pragma mark - drop and drag
- (void)dropToTabView:(NSTableView *)tableView paths:(NSArray *)pathArray
{
    _threadCount ++;
    [self performSelector:@selector(startTransfer:) withObject:pathArray afterDelay:0.3];
}

- (void)dropToCollectionView:(NSCollectionView *)collectionView paths:(NSMutableArray *)pathArray
{
    [self performSelector:@selector(startTransfer:) withObject:pathArray afterDelay:0.3];
    _threadCount ++;
}


@end
