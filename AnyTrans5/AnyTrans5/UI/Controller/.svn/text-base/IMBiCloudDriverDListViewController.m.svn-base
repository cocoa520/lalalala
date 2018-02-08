//
//  IMBiCloudDriverDListViewController.m
//  AnyTrans
//
//  Created by LuoLei on 2017-02-17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBiCloudDriverDListViewController.h"
#import "StringHelper.h"
#import "DriverDownloadCellView.h"
#import "ObjectTableRowView.h"
#import "IMBAnimation.h"
#import "IMBiCloudDriveRootFolderEntity.h"
#import "IMBScrollView.h"
#import "IMBBackgroundBorderView.h"
#import "IMBNotificationDefine.h"
#define TableViewRowWidth 560
#define TableViewRowHight 70


@implementation IMBiCloudDriverDListViewController
@synthesize dataSourceArray = _dataSourceArray;
@synthesize target = _target;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    }
    return self;
}


- (void)loadView
{
    [super loadView];
    [_tableView setCanSelect:NO];
    [_bgView setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_tableView setBackgroundColor:[NSColor clearColor]];
    [_bgView setIsDrawFrame:YES];
    [_bgView setBorderColor:[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)]];
//    [_bgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_inside_bgColor", nil)]];
    [_bgView setNeedsDisplay:YES];
    _allCheckBoxButton = [[IMBCheckButton alloc] initWithCheckImg:[StringHelper imageNamed:@"sel_all"] unCheckImg:[StringHelper imageNamed:@"sel_non"] mixImg:[StringHelper imageNamed:@"sel_sem"]];
    [_allCheckBoxButton setFrame:NSMakeRect(28, 22, 14, 14)];
    [_allCheckBoxButton setButtonType:NSSwitchButton];
    [_allCheckBoxButton setState:NSOnState];
    [_continueDownListView addSubview:_allCheckBoxButton];
    [_allCheckBoxButton setTarget:self];
    [_allCheckBoxButton setAction:@selector(selectAll:)];
    [_titleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_subTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_selectAllTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_selectAllTextField setStringValue:CustomLocalizedString(@"Menu_SelectAll", nil)];
    [_cancelButton setTarget:_target];
    [_cancelButton setAction:@selector(cancelContinuDown:)];

    [_cDownloadButton setTarget:_target];
    [_cDownloadButton setAction:@selector(continueDown:)];

    [_cDownloadButton setLeftnormalFillColor:[StringHelper getColorFromString:CustomColor(@"download_normal_leftcolor", nil)]];
    [_cDownloadButton setLeftenterFillColor:[StringHelper getColorFromString:CustomColor(@"download_enter_leftcolor", nil)]];
    [_cDownloadButton setLeftdownFillColor:[StringHelper getColorFromString:CustomColor(@"download_down_leftcolor", nil)]];
    [_cDownloadButton setRightnormalFillColor:[StringHelper getColorFromString:CustomColor(@"download_normal_rightcolor", nil)]];
    [_cDownloadButton setRightenterFillColor:[StringHelper getColorFromString:CustomColor(@"download_enter_rightcolor", nil)]];
    [_cDownloadButton setRightdownFillColor:[StringHelper getColorFromString:CustomColor(@"download_down_rightcolor", nil)]];
    _cDownloadButton.fontEnterColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    _cDownloadButton.fontDownColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    _cDownloadButton.fontColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    _cDownloadButton.font = [NSFont fontWithName:@"Helvetica Neue" size:12.0];
    [_cDownloadButton setTitle:CustomLocalizedString(@"driver_record_resume", nil)];
    [_cDownloadButton setFrameOrigin:NSMakePoint(NSWidth(_continueDownListView.frame) - NSWidth(_cDownloadButton.frame) - 28, NSMinY(_cDownloadButton.frame))];
    _cancelButton.isleftright = NO;
    [_cancelButton setBorderColor:[StringHelper getColorFromString:CustomColor(@"general_border_color", nil)]];
    [_cancelButton setLeftnormalFillColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_cancelButton setLeftenterFillColor:[StringHelper getColorFromString:CustomColor(@"general_enter_upFillColor", nil)]];
    [_cancelButton setLeftdownFillColor:[StringHelper getColorFromString:CustomColor(@"general_down_upFillColor", nil)]];
    [_cancelButton setRightnormalFillColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_cancelButton setRightenterFillColor:[StringHelper getColorFromString:CustomColor(@"general_enter_downFillColor", nil)]];
    [_cancelButton setRightdownFillColor:[StringHelper getColorFromString:CustomColor(@"general_down_downFillColor", nil)]];
    _cancelButton.fontEnterColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    _cancelButton.fontDownColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    _cancelButton.fontColor = [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)];
    _cancelButton.font = [NSFont fontWithName:@"Helvetica Neue" size:12.0];
    [_cancelButton setTitle:CustomLocalizedString(@"Button_Cancel", nil)];
    [_cancelButton setFrameOrigin:NSMakePoint(NSMinX(_cDownloadButton.frame) - 10 - NSWidth(_cancelButton.frame), NSMinY(_cancelButton.frame))];
    [_titleField setStringValue:CustomLocalizedString(@"driver_record_title", nil)];
    
    

}

- (void)setDataSourceArray:(NSMutableArray *)dataSourceArray
{
    if (_dataSourceArray != dataSourceArray) {
        for (IMBiCloudDriveFolderEntity *entity in _dataSourceArray) {
            [entity unbind:@"checkState"];
        }
        [_dataSourceArray release];
        NSSortDescriptor *sortDescripto = [[NSSortDescriptor alloc] initWithKey:@"finishSize" ascending:NO];
       
         _dataSourceArray = [dataSourceArray retain];
        for (IMBiCloudDriveFolderEntity *entity in _dataSourceArray) {
            [entity setCheckState:NSOnState];
        }
        [_allCheckBoxButton setState:NSOnState];
        [_dataSourceArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescripto]];
        if ([_dataSourceArray count] == 1) {
            [_subTitleField setStringValue:CustomLocalizedString(@"driver_record_description", nil)];
        }else{
            [_subTitleField setStringValue:CustomLocalizedString(@"driver_record_descriptions", nil)];
        }
        [[NSApplication sharedApplication].mainWindow makeFirstResponder:_tableView];
        [_tableView setNeedsDisplay:YES];
        [sortDescripto release];
    }
    [self performSelectorOnMainThread:@selector(wakeup:) withObject:nil waitUntilDone:NO];
    [_tableView reloadData];

}

- (void)wakeup:(id)sender
{
    
}

- (void)cancelContinuDown:(id)sender
{
    [self unloadAlertView:_continueDownListView];
}

- (void)showDownListView:(NSView *)superView
{
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadView:superView alertView:_continueDownListView];
}

- (void)setupAlertRect:(IMBBorderRectAndColorView *)alertView {
    [alertView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    NSRect rect = [alertView frame];
    [alertView setWantsLayer:YES];
    [alertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - NSWidth(rect)) / 2), NSMaxY(self.view.bounds), NSWidth(rect), NSHeight(rect))];
}

- (void)loadView:(NSView *)view alertView:(IMBBorderRectAndColorView *)alertView
{
    [self setupAlertRect:alertView];
    if (![self.view.subviews containsObject:alertView]) {
        [self.view addSubview:alertView];
    }
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [alertView.layer addAnimation:[IMBAnimation moveY:0.2 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-415] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [alertView.layer removeAnimationForKey:@"moveY"];
        [alertView setFrame:NSMakeRect(ceil((NSMaxX(view.bounds) - NSWidth(alertView.frame)) / 2), NSMaxY(view.bounds) - NSHeight(alertView.frame) + 10, NSWidth(alertView.frame), NSHeight(alertView.frame))];
    }];
}


- (void)unloadAlertView:(IMBBorderRectAndColorView *)alertView {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [alertView.layer addAnimation:[IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:425] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [alertView.layer removeAnimationForKey:@"moveY"];
        [alertView setFrame:NSMakeRect(ceil((NSMaxX(_mainView.bounds) - alertView.frame.size.width) / 2), NSMaxY(_mainView.bounds), alertView.frame.size.width, alertView.frame.size.height)];
        [self.view removeFromSuperview];
    }];
}


#pragma mark - NSTableView DataSource And Delegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 70;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_dataSourceArray count];
}

- (void)tableView:(NSTableView *)tableView didRemoveRowView:(ObjectTableRowView *)rowView forRow:(NSInteger)row {
    if ([rowView.subviews count]>0) {
        DriverDownloadCellView *cellView = (DriverDownloadCellView *)[[rowView subviews] objectAtIndex:0];
        IMBCheckButton *checkBoxButton = [cellView viewWithTag:101];
        [checkBoxButton unbind:@"state"];
    }
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    ObjectTableRowView *result = [[ObjectTableRowView alloc] initWithFrame:NSMakeRect(0, 0, TableViewRowWidth, TableViewRowHight)];
    result.objectValue = [_dataSourceArray objectAtIndex:row];
    return [result autorelease];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    DriverDownloadCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
    IMBiCloudDriveFolderEntity *entity = [_dataSourceArray objectAtIndex:row];
    NSControl *control = [cellView viewWithTag:101];
    if (control == nil) {
        IMBCheckButton *checkBoxButton = [[IMBCheckButton alloc] initWithCheckImg:[StringHelper imageNamed:@"sel_all"] unCheckImg:[StringHelper imageNamed:@"sel_non"] mixImg:[StringHelper imageNamed:@"sel_sem"]];
        [checkBoxButton setFrame:NSMakeRect(16, 28, 14, 14)];
        [cellView addSubview:checkBoxButton];
        checkBoxButton.tag = 101;
        [checkBoxButton bind:@"state" toObject:entity withKeyPath:@"checkState" options:nil];
        [entity bind:@"checkState" toObject:checkBoxButton withKeyPath:@"state" options:nil];
        [checkBoxButton setState:NSOnState];
        [checkBoxButton setTarget:self];
        [checkBoxButton setAction:@selector(clickCheckBox:)];
    }else{
        [control bind:@"state" toObject:entity withKeyPath:@"checkState" options:nil];
        [entity bind:@"checkState" toObject:control withKeyPath:@"state" options:nil];
        [control setTarget:self];
        [control setAction:@selector(clickCheckBox:)];
    }
    [cellView.icon setImage:entity.image];
    [cellView.titleField setStringValue:entity.name?:@""];
    if (![entity.type isEqualToString:@"FILE"]) {
        [cellView.sizeField setStringValue:@"--"];
    }else{
        [cellView.sizeField setStringValue:[StringHelper getFileSizeString:entity.size reserved:2]];

    }
    if (entity.finishSize == 0 || entity.finishSize > entity.size) {
        [cellView.progressField setStringValue:CustomLocalizedString(@"driver_record_nodownloadtips", nil)];
    }else{
        if (entity.size != 0) {
            [cellView.progressField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"driver_record_downloadtips", nil),(entity.finishSize/(entity.size*1.0))*100]];
        }
    }
    return cellView;
}


- (void)clickCheckBox:(id)sender
{
    NSPredicate *cate = [NSPredicate predicateWithFormat:@"self.checkState == %d",Check];
    NSArray *dataArray = [_dataSourceArray filteredArrayUsingPredicate:cate];
    if ([dataArray count] == 0) {
        [_cDownloadButton setEnabled:NO];
        [_allCheckBoxButton setState:NSOffState];
    }else if ([dataArray count] ==  [_dataSourceArray count]) {
        [_cDownloadButton setEnabled:YES];
        [_allCheckBoxButton setState:NSOnState];
    }else{
        [_cDownloadButton setEnabled:YES];
        [_allCheckBoxButton setState:NSMixedState];
    }
}

- (void)selectAll:(id)sender
{
    if (_allCheckBoxButton.state == NSOnState) {
        for (IMBiCloudDriveFolderEntity *entity in _dataSourceArray) {
            [entity setCheckState:NSOnState];
        }
        [_cDownloadButton setEnabled:YES];
    }else if (_allCheckBoxButton.state == NSOffState){
        for (IMBiCloudDriveFolderEntity *entity in _dataSourceArray) {
            [entity setCheckState:NSOffState];
        }
        [_cDownloadButton setEnabled:NO];
    
    }
}


- (void)dealloc
{
    [_dataSourceArray release],_dataSourceArray = nil;
    for (IMBiCloudDriveFolderEntity *entity in _dataSourceArray) {
        [entity unbind:@"checkState"];
    }
    [super dealloc];
}
@end
