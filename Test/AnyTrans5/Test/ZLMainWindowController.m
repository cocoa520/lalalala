//
//  ZLMainWindowController.m
//  AnyTrans
//
//  Created by iMobie on 18/1/3.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "ZLMainWindowController.h"
#import "IMBDeviceConnection.h"
#import "IMBNotificationDefine.h"
#import "IMBiPod.h"
#import "IMBInformation.h"
#import "IMBCommonEnum.h"
#import "IMBInformationManager.h"
#import "IMBTrack.h"
#import "StringHelper.h"


CGFloat const rowH = 40.0f;
CGFloat const labelY = 10.0f;


@interface ZLMainWindowController ()<NSTableViewDelegate,NSTableViewDataSource>

@property (assign) IBOutlet NSTextField *sizeLabel;
@property (assign) IBOutlet NSScrollView *scrollView;
@property (assign) IBOutlet NSTableView *tableView;

@property (assign) NSInteger selectedIndex;
@property (retain) IMBTrack *selectedTrack;


@property (nonatomic, retain) IMBInformation *information;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) NSArray *headerTitleArr;
@property (nonatomic, retain) NSPopover *popover;

@end

@implementation ZLMainWindowController

- (NSPopover *)popover {
    if (!_popover) {
        NSViewController *vc = [[NSViewController alloc] init];
        vc.view.frame = NSMakeRect(0, 0, 400, 200);
        NSPopover *popover = [[NSPopover alloc] init];
        popover.contentViewController = vc;
        popover.appearance = NSPopoverAppearanceMinimal;
        popover.behavior = NSPopoverBehaviorSemitransient;
        _popover = popover;
    }
    return _popover;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    [self setupView];
}

- (void)setupView {
    self.window.title = @"MainWindow";
    self.sizeLabel.stringValue = @"Please Connect Your Device";
    self.selectedIndex = -1;
    self.selectedTrack = nil;
    
    IMBDeviceConnection *dc = [IMBDeviceConnection singleton];
    [dc startListen];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(deviceConnected:) name:DeviceConnectedNotification object:nil];
    [nc addObserver:self selector:@selector(deviceDisconnected:) name:DeviceDisConnectedNotification object:nil];
    [nc addObserver:self selector:@selector(deviceChange:) name:DeviceChangeNotification object:nil];
    [nc addObserver:self selector:@selector(deviceNeedPassword:) name:DeviceNeedPasswordNotification object:nil];
    [nc addObserver:self selector:@selector(deviceIpodLoadComplete:) name:DeviceIpodLoadCompleteNotification object:nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.scrollView.focusRingType = NSFocusRingTypeNone;
    self.tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;
    [self.scrollView setHasHorizontalScroller:NO];
    
    [_tableView removeTableColumn:_tableView.tableColumns[0]];
    [_tableView removeTableColumn:_tableView.tableColumns[0]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HeaderTitleNames.plist" ofType:nil];
    _headerTitleArr = [NSArray arrayWithContentsOfFile:path];
    if (_headerTitleArr.count) {
        NSInteger count = _headerTitleArr.count;
        CGFloat cW = 150.0;//self.tableView.frame.size.width/count;
        for (NSInteger i = 0; i < count; i++) {
            NSCell *cell = [[NSCell alloc] initTextCell:_headerTitleArr[i]];
            cell.alignment = NSCenterTextAlignment;
            NSTableColumn * column = [[NSTableColumn alloc] initWithIdentifier:_headerTitleArr[i]];
            
            [column setHeaderCell:cell];
            [column setWidth:cW];
            [_tableView addTableColumn:column];
        }
        
    }
   
}

- (void)dealloc {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc removeObserver:self name:DeviceConnectedNotification object:nil];
    [nc removeObserver:self name:DeviceDisConnectedNotification object:nil];
    [nc removeObserver:self name:DeviceChangeNotification object:nil];
    [nc removeObserver:self name:DeviceNeedPasswordNotification object:nil];
    [nc removeObserver:self name:DeviceIpodLoadCompleteNotification object:nil];
    
    [super dealloc];
    
}

#pragma mark - DEVICE Notification
- (void)deviceConnected:(NSNotification *)notification
{
    self.sizeLabel.stringValue = @"LoadingData,please wait a minute";
}

- (void)deviceDisconnected:(NSNotification *)notification
{
    self.sizeLabel.stringValue = @"Please Connect Your Device";
}

- (void)deviceNeedPassword:(NSNotification *)notification
{
   
}

//设备切换通知
- (void)deviceChange:(NSNotification *)notification {
//    IMBBaseInfo *baseInfo = notification.object;
    
}

- (void)deviceIpodLoadComplete:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    IMBBaseInfo *baseInfo = userInfo[@"DeviceInfo"];
    
    self.sizeLabel.stringValue = [NSString stringWithFormat:@"%@: %.01f GB Free/%.01f GB Total",baseInfo.deviceName,baseInfo.kyDeviceSize/1024.0f/1024.0f/1024.0f,baseInfo.allDeviceSize/1024.0f/1024.0f/1024.0f];
    
    
    IMBiPod *ipod = [[IMBDeviceConnection singleton] getIPodByKey:baseInfo.uniqueKey];
    if (ipod) {
        _information = [[IMBInformation alloc] initWithiPod:ipod];
        _dataArray = [[NSMutableArray alloc] initWithArray:[_information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_Music]]];
        [_tableView reloadData];
        
    }
}

#pragma mark --- NSTableViewDelegate,NSTableViewDataSource


- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    return nil;
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return rowH;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    return YES;
}

- (NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes {
    if ([proposedSelectionIndexes count] == 1) {
        [proposedSelectionIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            self.selectedIndex = idx;
            self.selectedTrack = [self.dataArray objectAtIndex:idx];
        }];
    }else {
        self.selectedIndex = -1;
    }
    return proposedSelectionIndexes;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *strIdt = [tableColumn identifier];
    NSTableCellView *aView = [tableView makeViewWithIdentifier:strIdt owner:self];
    if (!aView)
        aView = [[NSTableCellView alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, rowH)];
    else
        for (NSView *view in aView.subviews)[view removeFromSuperview];
    
    IMBTrack *track = [self.dataArray objectAtIndex:row];
    NSTextField *textField = [[NSTextField alloc] initWithFrame:CGRectMake(0, labelY, tableColumn.width, rowH - 2*labelY)];
    if (track) {
        if ([@"Name" isEqualToString:tableColumn.identifier] ) {
            textField.stringValue = track.title;
        }else if ([@"Time" isEqualToString:tableColumn.identifier]) {
            textField.stringValue = [[StringHelper getTimeString:track.length] stringByAppendingString:@" "];
        }else if ([@"Artist" isEqualToString:tableColumn.identifier]) {
            textField.stringValue = track.artist;
        }else if ([@"Album" isEqualToString:tableColumn.identifier]) {
            textField.stringValue = track.album;
        }else if ([@"Genre" isEqualToString:tableColumn.identifier]) {
            textField.stringValue = track.genre;
        }else if ([@"Rating" isEqualToString:tableColumn.identifier]) {
            textField.stringValue = @"";
        }else if ([@"Size" isEqualToString:tableColumn.identifier]) {
            textField.stringValue = [StringHelper getFileSizeString:track.fileSize reserved:2];
        }
    }
    
    textField.font = [NSFont systemFontOfSize:12.0f];
    textField.alignment = NSCenterTextAlignment;
    textField.drawsBackground = NO;
    textField.bordered = NO;
    textField.focusRingType = NSFocusRingTypeNone;
    textField.editable = NO;
    [aView addSubview:textField];
    return aView;
}


- (void)showPopoverView:(NSView *)view {
    
    [self.popover close];
    [self.popover showRelativeToRect:view.bounds ofView:view preferredEdge:NSMaxYEdge];
}

- (IBAction)sendToMac:(NSButton *)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = NO;
    openPanel.allowsMultipleSelection = NO;
    openPanel.canChooseDirectories = YES;
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (NSFileHandlingPanelOKButton == result) {
            [self performSelector:@selector(contentToMac:) withObject:openPanel afterDelay:0.1];
        }
    }];
}

- (void)contentToMac:(NSOpenPanel *)openPanel {
    NSString *path = openPanel.URL.path;
    if (path) {
        
    }
}

@end
