//
//  IMBBrowserBookMarkViewController.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBrowserBookMarkViewController.h"
#import "IMBAnimation.h"
#import "IMBBookmarkEntity.h"
#import "IMBCustomHeaderCell.h"
#import "IMBImageAndTextCell.h"
#import "ArrowButtonCell.h"
#import "IMBNotificationDefine.h"
#import "HoverButton.h"
#import "IMBSelectBrowserImageView.h"
#import "StringHelper.h"

@implementation IMBBrowserBookMarkViewController
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib {
    [_safariImageView setImage:[StringHelper imageNamed:@"bookmark_choice1"]];
    [_safariImageView setImage:[StringHelper imageNamed:@"bookmark_choice1"]];
    [_safariImageView setImage:[StringHelper imageNamed:@"bookmark_choice1"]];
    [_importFirstSelectImageView setImage:[StringHelper imageNamed:@"safari_icon"]];
    [_importSecondSelectImageView setImage:[StringHelper imageNamed:@"google_icon"]];
    [_importThirdSelectImageView setImage:[StringHelper imageNamed:@"firefox_icon"]];
    _allBookMarkArray = [[NSMutableArray alloc]init];
    [_importFirstSelectImageView setTarget:self];
    [_importFirstSelectImageView setAction:@selector(ClickImage:)];
    _importFirstSelectImageView.backgroundView = _importFirstImageView ;
    [_importSecondSelectImageView setTarget:self];
    [_importSecondSelectImageView setAction:@selector(ClickImage:)];
    _importSecondSelectImageView.backgroundView = _importSecondImageView;
    [_importThirdSelectImageView setTarget:self];
    [_importThirdSelectImageView setAction:@selector(ClickImage:)];
     _importThirdSelectImageView.backgroundView = _importThirdImageView ;
    _importFirstSelectImageView.isSelected = NO;
    _importSecondSelectImageView.isSelected = NO;
    _importThirdSelectImageView.isSelected = NO;
    [_importTitle setStringValue:CustomLocalizedString(@"bookMark_id_19", nil)];
    [_importTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_browerCreateNewFirstInputTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
     [_browerCreateNewSecondInputTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
}

- (void)showBrowserWithAddButton:(NSString *)addText OkButton:(NSString *)OkText CancelButton:(NSString *)cancelText SuperView:(NSView *)superView ImportBookmarkBlock:(ImportBookmarkBlock)block{
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadAlertView:superView alertView:_browserBookMark];
    [_browerCancelBtn reSetInit:cancelText WithPrefixImageName:@"cancal"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:cancelText]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_other_exitColor", nil)] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_browerCancelBtn setAttributedTitle:attributedTitles];
    [_browerCancelBtn setIsReslutVeiw:YES];
    
    NSMutableAttributedString *attributedTitles2 = [[[NSMutableAttributedString alloc]initWithString:addText]autorelease];
    [attributedTitles2 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, addText.length)];
    [attributedTitles2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, addText.length)];
    [attributedTitles2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_other_exitColor", nil)] range:NSMakeRange(0, addText.length)];
    [attributedTitles2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles2.length)];
    [_browerCreateNewAddBtn reSetInit:addText WithPrefixImageName:@"cancal"];
    [_browerCreateNewAddBtn setAttributedTitle:attributedTitles2];
    [_browerCreateNewAddBtn setIsReslutVeiw:YES];
    [_browerCreateNewAddBtn setTarget:self];
    [_browerCreateNewAddBtn setAction:@selector(addBookMark:)];
    
    [_browerOkBtn reSetInit:OkText WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:OkText]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_browerOkBtn setAttributedTitle:attributedTitles1];
    
    [_browerOkBtn setTarget:self];
    [_browerOkBtn setAction:@selector(OkBtnClick:)];
    [_browerCancelBtn setTarget:self];
    [_browerCancelBtn setAction:@selector(cancelBtnClick:)];

    [_segController setSelectedSegment:0];
    [self segClick:nil];
    [_segController setTarget:self];
    [_segController setAction:@selector(segClick:)];
    [_segController setFirstTitle:CustomLocalizedString(@"Seg_First_Title", nil)];
    [_segController setSecondTitle:CustomLocalizedString(@"Menu_Import", nil)];
    [_browserBgView addSubview:_browerCreateNewView];
    [_browserBgView setBorderColor:[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)]];
    [_browserBgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_inside_bgColor", nil)]];
    [self configFritView];
    _block = [block copy];
}

- (void)loadAlertView:(NSView *)view alertView:(IMBBorderRectAndColorView *)alertView {
    [self setupAlertRect:alertView];
    if (![self.view.subviews containsObject:alertView]) {
        [self.view addSubview:alertView];
    }
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [alertView.layer addAnimation:[IMBAnimation moveY:0.2 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-400] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [alertView.layer removeAnimationForKey:@"moveY"];
        [alertView setFrame:NSMakeRect(ceil((NSMaxX(view.bounds) - NSWidth(alertView.frame)) / 2), NSMaxY(view.bounds) - NSHeight(alertView.frame) + 10, NSWidth(alertView.frame), NSHeight(alertView.frame))];
    }];
}

- (void)setupAlertRect:(IMBBorderRectAndColorView *)alertView {
    [alertView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    NSRect rect = [alertView frame];
    [alertView setWantsLayer:YES];
    [alertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - NSWidth(rect)) / 2), NSMaxY(self.view.bounds), NSWidth(rect), NSHeight(rect))];
}

- (void)unloadAlertView:(IMBBorderRectAndColorView *)alertView {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [alertView.layer addAnimation:[IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:400] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [alertView.layer removeAnimationForKey:@"moveY"];
        [alertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - alertView.frame.size.width) / 2), NSMaxY(self.view.bounds), alertView.frame.size.width, alertView.frame.size.height)];
        [self.view removeFromSuperview];
    }];
}

- (void)addBookMark:(id)sender {
    IMBBookmarkEntity *bookMark = [[IMBBookmarkEntity alloc] init];
    bookMark.delegate = self;
    if ([_browerCreateNewFirstInputTextFiled.stringValue isEqualToString:@""] ||[_browerCreateNewSecondInputTextFiled.stringValue isEqualToString:@""] ) {
        [_browserCreatNewtipTitle setHidden:NO];
        return;
    }else {
        if (![self isUrlString:_browerCreateNewSecondInputTextFiled.stringValue]) {
            [_browerCreateNewSecondInputTextFiled setStringValue:@""];
            return;
        }
        HoverButton *btn = [[[HoverButton alloc]init] autorelease];
        [btn setMouseEnteredImage:[StringHelper imageNamed:@"bookmark_close2"] mouseExitImage:[StringHelper imageNamed:@"bookmark_close1"] mouseDownImage:[StringHelper imageNamed:@"bookmark_close3"]];
        [btn setFrame:NSMakeRect(0, 0, 20, 20)];
        if(_browerCreateNewFirstInputTextFiled.stringValue.length > 20) {
            [_browerCreateNewFirstInputTextFiled setStringValue:[_browerCreateNewFirstInputTextFiled.stringValue substringToIndex:20]];
        }
        bookMark.name = _browerCreateNewFirstInputTextFiled.stringValue;
        bookMark.url = _browerCreateNewSecondInputTextFiled.stringValue;
        bookMark.isFolder = NO;
        [bookMark setBtn:btn];
        
        for (IMBBookmarkEntity *entity in _allBookMarkArray) {
            if ([entity.name isEqualToString:bookMark.name] && [entity.url isEqualToString:bookMark.url]) {
                [_browserCreatNewtipTitle setStringValue:CustomLocalizedString(@"bookMark_id_18", nil)];
                [_browserCreatNewtipTitle setHidden:NO];
                return ;
            }
        }
        
        [_allBookMarkArray addObject:bookMark];
        [_browserCreatNewtipTitle setHidden:YES];
        [_browerCreateNewTableView reloadData];
        [_browerCreateNewFirstInputTextFiled setStringValue:@""];
        [_browerCreateNewSecondInputTextFiled setStringValue:@""];
        [_browerCreateNewFirstInputTextFiled becomeFirstResponder];
    }
}

//判断是否为网址
- (BOOL)isUrlString:(NSString *)url {
    NSString *emailRegex = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:url];
}

- (void)cancelBookMark:(IMBBookmarkEntity *)bookMark {
    [_allBookMarkArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IMBBookmarkEntity *entity = obj;
        if ([entity.name isEqualToString:bookMark.name] && [entity.url isEqualToString:bookMark.url]) {
            [entity.btn removeFromSuperview];
            [_allBookMarkArray removeObject:entity];
        }
    }];
     [_browerCreateNewTableView reloadData];
}

- (void)segClick:(id)sender {
    _segSelectTag = (int)[_segController selectedSegment];
    if ([_segController selectedSegment] == 0) {
        [_importView removeFromSuperview];
        [_browserBgView addSubview:_browerCreateNewView];
    }else if ([_segController selectedSegment] == 1) {
        [_browerCreateNewView removeFromSuperview];
        [_browserBgView addSubview:_importView];
    }
}

- (void)configFritView{
    [browerCreateNewTitle setStringValue:CustomLocalizedString(@"Bookmark_id_8", nil)];
    [browerCreateNewTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_browerCreateNewTableBgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_inside_bgColor", nil)]];
    [_browerCreateNewTableBgView setWantsLayer:YES];
    [_browerCreateNewTableBgView.layer setBorderWidth:1.0];
    [_browerCreateNewTableBgView.layer setBorderColor:[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)].CGColor];
    [_browerCreateNewTableView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_inside_bgColor", nil)]];
    
    [_browerCreateNewFirstBgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_inside_bgColor", nil)]];
    [_browerCreateNewFirstBgView setWantsLayer:YES];
    [_browerCreateNewFirstBgView.layer setBorderWidth:1.0];
    [_browerCreateNewFirstBgView.layer setCornerRadius:3.0];
    [_browerCreateNewFirstBgView.layer setBorderColor:[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)].CGColor];
    [_browerCreateNewSecondBgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_inside_bgColor", nil)]];
    [_browerCreateNewSecondBgView setWantsLayer:YES];
    [_browerCreateNewSecondBgView.layer setBorderWidth:1.0];
    [_browerCreateNewSecondBgView.layer setCornerRadius:3.0];
    [_browerCreateNewSecondBgView.layer setBorderColor:[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)].CGColor];
    
    NSArray *array = [_browerCreateNewTableView tableColumns];
    for (NSTableColumn  *column in array) {
        if ([column.headerCell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *columnHeadercell = (IMBCustomHeaderCell *)column.headerCell;
            NSArray* colorArray = [NSArray arrayWithObjects:
                                   [StringHelper getColorFromString:CustomColor(@"alert_inside_bgColor", nil)],
                                   [StringHelper getColorFromString:CustomColor(@"alert_inside_bgColor", nil)],
                                   [StringHelper getColorFromString:CustomColor(@"alert_inside_bgColor", nil)],
                                   nil];
            NSGradient *backgroundgradient = [[NSGradient alloc] initWithColors:colorArray];
            [columnHeadercell setBackgroundgradient:backgroundgradient];
            if ([column.identifier isEqualToString:@"Empty"]) {
                [columnHeadercell setStringValue:@""];
            }
        }
    }
    
    [_browserCreatNewtipTitle setStringValue:CustomLocalizedString(@"Bookmark_id_7", nil)];
    [_browserCreatNewtipTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"tableView_drag_bgColor", nil)]];
    [_browserCreatNewtipTitle setHidden:YES];
}

- (void)cancelBtnClick:(id)sender {
    [self unloadAlertView:_browserBookMark];
    for (IMBBookmarkEntity *bookMark in _allBookMarkArray) {
        [bookMark.btn removeFromSuperview];
    }
    [_allBookMarkArray removeAllObjects];
    
    _importFirstSelectImageView.isSelected = NO;
    _importSecondSelectImageView.isSelected = NO;
    _importThirdSelectImageView.isSelected = NO;
    [_browerCreateNewFirstInputTextFiled setStringValue:@""];
    [_browerCreateNewSecondInputTextFiled setStringValue:@""];
    [_browerCreateNewFirstInputTextFiled becomeFirstResponder];
}

- (void)OkBtnClick:(id)sender {
    [self unloadAlertView:_browserBookMark];
    NSMutableArray *Array  = [[[NSMutableArray alloc] initWithArray:_allBookMarkArray] autorelease];
    _block(_selectBrowserTag,Array,_segSelectTag);
    Block_release(_block);
    _block = nil;

    for (IMBBookmarkEntity *bookMark in _allBookMarkArray) {
        [bookMark.btn removeFromSuperview];
    }
    [_allBookMarkArray removeAllObjects];
    
    _importFirstSelectImageView.isSelected = NO;
    _importSecondSelectImageView.isSelected = NO;
    _importThirdSelectImageView.isSelected = NO;
    [_browerCreateNewFirstInputTextFiled setStringValue:@""];
    [_browerCreateNewSecondInputTextFiled setStringValue:@""];
    [_browerCreateNewFirstInputTextFiled becomeFirstResponder];
}

- (void)ClickImage:(IMBSelectBrowserImageView*)imageView {
    NSInteger tag = imageView.tag;
    _selectBrowserTag = imageView.tag;
    if (tag == 1) {
        _importFirstSelectImageView.isSelected = YES;
        _importSecondSelectImageView.isSelected = NO;
        _importThirdSelectImageView.isSelected = NO;
    }else if (tag == 2) {
        _importFirstSelectImageView.isSelected = NO;
        _importSecondSelectImageView.isSelected = YES;
        _importThirdSelectImageView.isSelected = NO;
    }else if (tag == 3) {
        _importFirstSelectImageView.isSelected = NO;
        _importSecondSelectImageView.isSelected = NO;
        _importThirdSelectImageView.isSelected = YES;
    }
}

#pragma mark - tableViewDataSource、delegate方法
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_allBookMarkArray.count > 0) {
        return _allBookMarkArray.count;
    }else {
        return 0;
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (row < _allBookMarkArray.count) {
        IMBBookmarkEntity *bookmark = [_allBookMarkArray objectAtIndex:row];
        if ([@"Name" isEqualToString:tableColumn.identifier] ) {
            return bookmark.name;
        }else if ([@"URL" isEqualToString:tableColumn.identifier])
        {
            return bookmark.url;
        }
    }
    return @"";
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (row < _allBookMarkArray.count) {
        if ([@"Name" isEqualToString:tableColumn.identifier] ) {
            IMBBookmarkEntity *bookmark = [_allBookMarkArray objectAtIndex:row];
            IMBImageAndTextCell *curCell = (IMBImageAndTextCell*)cell;
            NSImage *image = nil;
            if (bookmark.isFolder) {
                image = [StringHelper imageNamed:@"nav_folder"];
                curCell.imageName = @"nav_folder";
            }else
            {
                image = [StringHelper imageNamed:@"nav_bookmark"];
                curCell.imageName = @"nav_bookmark";
            }
            [curCell setImageSize:NSMakeSize(16, 16)];
            curCell.image = image;
            curCell.paddingX = 2;
            curCell.marginX = 6;
            return;
        }else if ([@"Empty" isEqualToString:tableColumn.identifier])
        {
            IMBBookmarkEntity *bookmark = [_allBookMarkArray objectAtIndex:row];
            ArrowButtonCell *arrowCell = (ArrowButtonCell *)cell;
            arrowCell.btn = bookmark.btn;
            return;
        }
    }
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return NO;
}

@end
