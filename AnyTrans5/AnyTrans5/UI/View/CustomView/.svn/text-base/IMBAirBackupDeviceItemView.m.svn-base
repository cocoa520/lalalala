//
//  IMBAirBackupDeviceItemView.m
//  AnyTrans
//
//  Created by smz on 17/10/20.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBAirBackupDeviceItemView.h"
#import <QuartzCore/QuartzCore.h>
#import "StringHelper.h"
#import "IMBSoftWareInfo.h"
#import "IMBAnimation.h"
#import "SimpleNode.h"
#import "DateHelper.h"
#import "IMBAirWifiBackupViewController.h"
#import "IMBAlertViewController.h"

@implementation IMBAirBackupDeviceItemView
@synthesize backupRecord = _backupRecord;
@synthesize isSelected = _isSelected;
@synthesize delegate = _delegate;
@synthesize target = _target;
@synthesize action = _action;
@synthesize isShowLine = _isShowLine;
@synthesize isBackupInfo = _isBackupInfo;
@synthesize isSettingView = _isSettingView;
@synthesize baseInfo = _baseInfo;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _btnStatus = @"ExitStatus";
        nc = [NSNotificationCenter defaultCenter];
        _isSelected = NO;
        _onlineImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(252 - 10 - 16 , 36, 16, 16)];
        [_onlineImageView setImage:[StringHelper imageNamed:@"airbackup_online"]];
        _disOnlineImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(252 - 10 - 16 , 36, 16, 16)];
        [_disOnlineImageView setImage:[StringHelper imageNamed:@"airbackup_outline"]];
        
        _watchBtn = [[IMBSignOutButton alloc] initWithFrame:NSMakeRect(266, 12, 18, 12)];
        [_watchBtn setToolTip:CustomLocalizedString(@"AirBackupDeviceInfo_Forget", nil)];
        _watchBtn.mouseEnteredImage = [StringHelper imageNamed:@"airbackup_view2"];
        _watchBtn.mouseDownImage = [StringHelper imageNamed:@"airbackup_view3"];
        _watchBtn.mouseExitedImage = [StringHelper imageNamed:@"airbackup_view"];
//        [_watchBtn setTarget:self];
//        [_watchBtn setAction:@selector(watchBtnClick)];
        
        NSRect titleRect = [StringHelper calcuTextBounds:CustomLocalizedString(@"AirBackupDeviceInfo_Forget", nil) fontSize:12.0];
        _textButton = [[IMBTextLinkButton alloc] initWithFrame:NSMakeRect(278 - titleRect.size.width - 10, (30 - titleRect.size.height)/2.0 + 1, titleRect.size.width, titleRect.size.height)];
        [_textButton setButtonWithTitle:CustomLocalizedString(@"AirBackupDeviceInfo_Forget", nil) WithFontSize:12.0 WithTitleColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithTitleEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithTitleDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)]];
        [_textButton setTarget:self];
        [_textButton setAction:@selector(forgotBtnClick)];
        
        
        NSButton *btn = [[NSButton alloc] initWithFrame:NSMakeRect(240, 12, 18, 12)];
        [btn setBordered:NO];
        [btn setImagePosition:NSImageOnly];
        [btn setTarget:self];
        [btn setAction:@selector(watchBtnClick)];
        [self addSubview:btn];
    }
    return self;
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea)
    {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)doChangeLanguage {
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (_isBackupInfo) {
        //背景
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
        if (_mouseStatus == MouseEnter || _mouseStatus == MouseUp) {
            [[StringHelper getColorFromString:CustomColor(@"deviceItemView_enter_bgColor", nil)] set];
        }else if (_mouseStatus == MouseDown) {
            [[StringHelper getColorFromString:CustomColor(@"deviceItemView_down_bgColor", nil)] set];
        }else {
            [[NSColor clearColor] set];
        }
        [path fill];
        [path closePath];
        
        NSImage *iconImg = nil;
        int xPos;
        int yPos;
        if (_backupRecord.encryptBackup) {
            iconImg = [StringHelper imageNamed:@"airbackup_lock"];
        }else {
            //设备图片
            iconImg = [StringHelper getBackupDevcieImage:_backupRecord.connectType];
        }
        if (iconImg != nil) {
            xPos = 12;
            yPos = (36 - iconImg.size.height)/2.0;
            NSRect drawingRect;
            // 用来苗素图片信息
            NSRect imageRect;
            imageRect.origin = NSZeroPoint;
            imageRect.size = iconImg.size;
            drawingRect.origin.x = xPos;
            drawingRect.origin.y = yPos;
            drawingRect.size.width = imageRect.size.width;
            drawingRect.size.height = imageRect.size.height;
            [iconImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        }
        //备份时间
        NSSize size ;
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_backupRecord.time longValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
        NSString *confromTimespStr = [dateFormatter stringFromDate:confromTimesp];
        [dateFormatter release], dateFormatter = nil;
        
        NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:confromTimespStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:0 withMaxWidth:165 withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withAlignment:NSLeftTextAlignment];
        NSRect textRect2 = NSMakeRect(12 + iconImg.size.width + 8 , (36 - size.height)/2.0 , size.width, 18);
        [attrStr drawInRect:textRect2];
        
        //备份大小
        NSSize size1;
        NSMutableAttributedString *attrStr1 = [StringHelper TruncatingTailForStringDrawing:[StringHelper getFileSizeString:[_backupRecord.size longLongValue] reserved:2] withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:0 withMaxWidth:80 withSize:&size1 withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] withAlignment:NSLeftTextAlignment];
        NSRect textRect1 = NSMakeRect(266 - 8 - size1.width , (36 - size1.height)/2.0 , size1.width, 18);
        [attrStr1 drawInRect:textRect1];
    
    //查看按钮
    [self addSubview:_watchBtn];
        
    } else if (_isSettingView) {
        
        //背景
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
        if (_mouseStatus == MouseEnter || _mouseStatus == MouseUp) {
            [[StringHelper getColorFromString:CustomColor(@"deviceItemView_enter_bgColor", nil)] set];
        }else if (_mouseStatus == MouseDown) {
            [[StringHelper getColorFromString:CustomColor(@"deviceItemView_down_bgColor", nil)] set];
        }else {
            [[NSColor clearColor] set];
        }
        [path fill];
        [path closePath];
        
        //设备图片
        NSImage *iconImg = nil;
        iconImg = [StringHelper getBackupDevcieImage:_baseInfo.connectType];
        int xPos;
        int yPos;
        if (iconImg != nil) {
            xPos = 10;
            yPos = (30 - iconImg.size.height)/2.0;
            NSRect drawingRect;
            // 用来苗素图片信息
            NSRect imageRect;
            imageRect.origin = NSZeroPoint;
            imageRect.size = iconImg.size;
            drawingRect.origin.x = xPos;
            drawingRect.origin.y = yPos;
            drawingRect.size.width = imageRect.size.width;
            drawingRect.size.height = imageRect.size.height;
            [iconImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        }
        
        //画设备的名字
        if (_baseInfo.deviceName != nil) {
            NSSize size ;
            NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:_baseInfo.deviceName withFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0] withLineSpacing:0 withMaxWidth:174 withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withAlignment:NSLeftTextAlignment];
            NSRect textRect2 = NSMakeRect(10 + iconImg.size.width + 6, (30 - size.height)/2.0, size.width, 18);
            [attrStr drawInRect:textRect2];
        }
        
        [self addSubview:_textButton];
        
        
    } else {
        //背景
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
        [path addClip];
        [path setWindingRule:NSEvenOddWindingRule];
        if (_mouseStatus == MouseEnter || _mouseStatus == MouseUp) {
            [[StringHelper getColorFromString:CustomColor(@"deviceItemView_enter_bgColor", nil)] set];
        }else if (_mouseStatus == MouseDown) {
            [[StringHelper getColorFromString:CustomColor(@"deviceItemView_down_bgColor", nil)] set];
        }else {
            [[NSColor clearColor] set];
        }
        [path fill];
        [path closePath];
        
        //设备图片
        NSImage *iconImg = nil;
        iconImg = [StringHelper getDeviceImage:_baseInfo.connectType];
        int xPos;
        int yPos;
        if (iconImg != nil) {
            xPos = 8;
            yPos = ceil((dirtyRect.size.height - iconImg.size.height)/2.0);
            NSRect drawingRect;
            // 用来苗素图片信息
            NSRect imageRect;
            imageRect.origin = NSZeroPoint;
            imageRect.size = iconImg.size;
            drawingRect.origin.x = xPos;
            drawingRect.origin.y = yPos;
            drawingRect.size.width = imageRect.size.width;
            drawingRect.size.height = imageRect.size.height;
            [iconImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
            
            int xPosSelect;
            int yPosSelect;
            NSImage *iconSelectImg = nil;
            //选中图片
            if (_isSelected) {
                iconSelectImg = [StringHelper imageNamed:@"device_selete"];
                xPosSelect = 9;
                yPosSelect = 12;
                NSRect drawingRectWithSelected;
                // 用来苗素图片信息
                NSRect imageRectWithSelected;
                imageRectWithSelected.origin = NSZeroPoint;
                imageRectWithSelected.size = iconSelectImg.size;
                drawingRectWithSelected.origin.x = NSMaxX(drawingRect) - xPosSelect;
                drawingRectWithSelected.origin.y = NSMaxY(drawingRect) - yPosSelect;
                drawingRectWithSelected.size.width = imageRectWithSelected.size.width;
                drawingRectWithSelected.size.height = imageRectWithSelected.size.height;
                [iconSelectImg drawInRect:drawingRectWithSelected fromRect:imageRectWithSelected operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
            }
            
        }
        
        xPos = 14;
        yPos = 0;
        
        //画设备的名字
        if (_baseInfo.deviceName != nil) {
            NSSize size ;
            NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:_baseInfo.deviceName withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0 withMaxWidth:112 withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withAlignment:NSLeftTextAlignment];
            NSRect textRect2 = NSMakeRect(64 , 31, size.width, 22);
            [attrStr drawInRect:textRect2];
        }
        //最后的备份时间
        NSSize size ;
        NSString *backupTime = @"";
        if ([_baseInfo.backupTime intValue] > 0) {
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_baseInfo.backupTime longValue]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
            NSString *confromTimespStr = [dateFormatter stringFromDate:confromTimesp];
            [dateFormatter release], dateFormatter = nil;
            backupTime = [[CustomLocalizedString(@"AirBackupDeviceInfo_BackupTitle", nil) stringByAppendingString:@" "] stringByAppendingString:confromTimespStr];
            
        } else {
            backupTime = CustomLocalizedString(@"AirBackupDeviceInfo_NoBackup", nil);
        }
        
        NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:backupTime withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:0 withMaxWidth:196 withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] withAlignment:NSLeftTextAlignment];
        NSRect textRect2 = NSMakeRect(52 , 10 , size.width, 18);
        [attrStr drawInRect:textRect2];
        if (_baseInfo.deviceConnectMode != WifiRecordDevice) {
            [self addSubview:_onlineImageView];
        }else {
            [self addSubview:_disOnlineImageView];
        }
//        52 , 31, size.width, 22
        NSBezierPath *circle = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(52, 36, 8, 8) xRadius:4 yRadius:4];
        if (_baseInfo.deviceConnectMode == WifiRecordDevice) {
            [[StringHelper getColorFromString:CustomColor(@"airWifi_device_disonline", nil)] setFill];
        }else {
            [[StringHelper getColorFromString:CustomColor(@"airWifi_device_online", nil)] setFill];
        }
        [circle setClip];
        [circle fill];
    }
    
}

- (void)drawLeftText:(NSString *)text withFrame:(NSRect)frame withFontSize:(float)withFontSize withColor:(NSColor *)color {
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSFont *sysFont = [NSFont fontWithName:@"Helvetica Neue" size:withFontSize];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSLeftTextAlignment];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName ,sysFont ,NSFontAttributeName,style,NSParagraphStyleAttributeName, nil];
    
    NSSize textSize = [as.string sizeWithAttributes:attributes];
    NSSize maxSize = NSMakeSize(140, 20);
    if (textSize.width > maxSize.width ) {
        textSize = maxSize;
        NSAttributedString *as2 = [[NSAttributedString alloc]initWithString:@"..."];
        NSRect rect = NSMakeRect(frame.origin.x + textSize.width, frame.origin.y + (frame.size.height - textSize.height) / 2, 20, textSize.height);
        [as2.string drawInRect:rect withAttributes:attributes];
    }
    NSRect f = NSMakeRect(frame.origin.x , frame.origin.y + (frame.size.height - textSize.height) / 2, textSize.width, textSize.height);
    [as.string drawInRect:f withAttributes:attributes];
    
    [as release];
    [style release];
}

- (void)mouseUp:(NSEvent *)theEvent {
    _btnStatus = @"ExitStatus";
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
    if (inner) {
        if (self.target != nil && self.action != nil) {
            if ([self.target respondsToSelector:self.action]) {
                if (_isBackupInfo) {
                    [self.target performSelector:self.action withObject:self.backupRecord];
                } else {
                    [self.target performSelector:self.action withObject:self.baseInfo];
                }
                
            }
        }
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseStatus = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent{
    _mouseStatus = MouseOut;
    [self setNeedsDisplay:YES];
    [NSAnimationContext endGrouping];
    if (_isBackupInfo) {
        [self setWantsLayer:YES];
        CABasicAnimation *animation = [IMBAnimation moveX:0.5 X:@0 repeatCount:0 beginTime:0.0];
        [self.layer addAnimation:animation forKey:@"1"];
    }
    
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseStatus = MouseEnter;
    [self setNeedsDisplay:YES];
    [NSAnimationContext endGrouping];
    if (_isBackupInfo) {
        [self setWantsLayer:YES];
        [self.layer removeAllAnimations];
        CABasicAnimation *animation = [IMBAnimation moveX:0.5 X:@-30 repeatCount:0 beginTime:0.0];
        [self.layer addAnimation:animation forKey:@"2"];
    }
}

- (void)mouseMoveOutView:(NSNotification *)sender {
    NSDictionary *userInfo= [sender userInfo];
    NSEvent *event = [userInfo objectForKey:@"MouseEvent"];
    [self mouseMoved:event];
}

- (void)mouseMoved:(NSEvent *)theEvent {
    NSPoint mouseLocation = [self.window mouseLocationOutsideOfEventStream];
    mouseLocation = [self convertPoint: mouseLocation fromView: nil];
    
    if (NSPointInRect(mouseLocation, [self bounds])) {
        _btnStatus = @"EnteredStatus";
        [self setNeedsDisplay:YES];
    } else {
        _btnStatus = @"ExitStatus";
        [self setNeedsDisplay:YES];
    }
}

#pragma mark - forgot按钮点击
- (void)forgotBtnClick {
    [_delegate deleteConfigFileWithDeviceKey:_baseInfo.uniqueKey];
}

#pragma mark - watch按钮点击
- (void)watchBtnClick {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Air_Backup action:ActionNone actionParams:@"Backup Manager" label:Switch transferCount:0 screenView:@"Backup Manager View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    SimpleNode *node = [self getSingleBackupRootNode:_backupRecord.path];
    if (node) {
        NSDictionary *dic = @{@"node":node};
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_JUMP_BACKUP_VIEW object:nil userInfo:dic];
    }else {
        //弹出提示窗口
    }
}

- (SimpleNode *)getSingleBackupRootNode:(NSString *)filePath {
    BOOL isDir = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath isDirectory:&isDir]) {
        if (isDir) {
            //得到所有的备份node
            NSString *manifestplistPath = [filePath stringByAppendingPathComponent:@"Manifest.plist"];
            if ([fm fileExistsAtPath:manifestplistPath]) {
                NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:manifestplistPath];
                //过滤掉4代一下备份文件
                if (![dic.allKeys containsObject:@"BackupKeyBag"]) {
                    return nil;
                }
                //分别取出udid backupdata deviceName
                NSDate *backupDate = [dic objectForKey:@"Date"];
                NSDictionary *lockdown = [dic objectForKey:@"Lockdown"];
                NSString *udid = [lockdown objectForKey:@"UniqueDeviceID"];
                NSString *deviceName = [lockdown objectForKey:@"DeviceName"];
                NSString *productVersion = [lockdown objectForKey:@"ProductVersion"];
                NSString *productType = [lockdown objectForKey:@"ProductType"];
                SimpleNode *node = [[[SimpleNode alloc] init] autorelease];
                node.udid = udid;
                node.deviceName = deviceName;
                
                NSString *infoFilePath = [filePath stringByAppendingPathComponent:@"Info.plist"];
                NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:infoFilePath];
                if (infoDic.count != 0) {
                    [node setSerialNumber:[infoDic objectForKey:@"Serial Number"]];
                }
                NSString *infoFilePath1 = [filePath stringByAppendingPathComponent:@"Manifest.plist"];
                NSDictionary *infoDic1 = [NSDictionary dictionaryWithContentsOfFile:infoFilePath1];
                if (infoDic1.count != 0&&node.serialNumber == nil) {
                    NSDictionary *lockdownDic = [infoDic1 objectForKey:@"Lockdown"];
                    [node setSerialNumber:[lockdownDic objectForKey:@"SerialNumber"]];
                }
                if (infoDic1.count != 0) {
                    [node setIsEncrypt:[[infoDic1 objectForKey:@"IsEncrypted"] boolValue]];
                }
                
                node.backupDate = [DateHelper stringFromFomate:backupDate formate:@"yyyy-MM-dd HH:mm"];
                node.fileName = node.backupDate;
                node.backupPath = filePath;
                node.container = NO;
                node.isDeviceNode = NO;
                node.isBackupNode = YES;
                NSString *reg = @"iPad";
                NSString *reg1 = @"iPhone";
                NSString *reg2 = @"iPod";
                NSRange foundObj=[productType rangeOfString:reg options:NSCaseInsensitiveSearch];
                NSRange foundObj1=[productType rangeOfString:reg1 options:NSCaseInsensitiveSearch];
                NSRange foundObj2=[productType rangeOfString:reg2 options:NSCaseInsensitiveSearch];
                
                if (foundObj.length >0) {
                    
                    node.productType = iPadType;
                    
                }else if (foundObj1.length >0)
                {
                    node.productType = iPhoneType;
                    
                }else if (foundObj2.length >0)
                {
                    node.productType = iPodTouchType;
                }
                node.itemSize = [self getFolderSize:node.backupPath];
                node.productVersion = productVersion;
                node.childrenArray = [self supportedBackupItems:node];
                node.uniqueID = [NSString stringWithFormat:@"%@%@",node.udid,node.backupDate];
                node.isDeviceNode = YES;
                return node;
            }
        }
    }
    return nil;
}

- (int64_t)getFolderSize:(NSString *)backupFolderPath {
    int64_t folderSize = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:backupFolderPath]) {
        [self recursionFolder:backupFolderPath folderSize:&folderSize];
    }
    return folderSize;
}

- (void)recursionFolder:(NSString *)folderPath folderSize:(int64_t *)folderSize {
    NSArray *tempArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    for (NSString *fileName in tempArray) {
        BOOL flag = YES;
        NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                *folderSize += [self fileSizeAtPath:fullPath];
            }
            else {
                [self recursionFolder:fullPath folderSize:folderSize];
            }
        }
    }
}

- (long long)fileSizeAtPath:(NSString*)filePath {
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}

- (NSMutableArray *)supportedBackupItems:(SimpleNode *)nnode
{
    NSMutableArray *supportedArr = [NSMutableArray array];
    //判断是否支持备份,notes,contacts,bookmarks,calendar
    
    SimpleNode *backupnode = [[SimpleNode alloc] init];
    backupnode.fileName = CustomLocalizedString(@"MenuItem_id_31",nil);
    backupnode.deviceName = nnode.deviceName;
    backupnode.udid = nnode.udid;
    backupnode.backupDate = nnode.backupDate;
    backupnode.backupPath = nnode.backupPath;
    backupnode.snapshotID = nnode.snapshotID;
    backupnode.productVersion = nnode.productVersion;
    backupnode.container = NO;
    backupnode.type = @"Explorer";
    backupnode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,backupnode.fileName];
    [supportedArr addObject:backupnode];
    [backupnode release];
    
    SimpleNode *notesnode = [[SimpleNode alloc] init];
    notesnode.fileName = CustomLocalizedString(@"MenuItem_id_17",nil);
    notesnode.deviceName = nnode.deviceName;
    notesnode.udid = nnode.udid;
    notesnode.backupDate = nnode.backupDate;
    notesnode.backupPath = nnode.backupPath;
    notesnode.snapshotID = nnode.snapshotID;
    notesnode.productVersion = nnode.productVersion;
    notesnode.container = NO;
    notesnode.type = @"Notes";
    notesnode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,notesnode.fileName];
    [supportedArr addObject:notesnode];
    [notesnode release];
    
    SimpleNode *contactsnode = [[SimpleNode alloc] init];
    contactsnode.fileName = CustomLocalizedString(@"MenuItem_id_20",nil);
    contactsnode.deviceName = nnode.deviceName;
    contactsnode.udid = nnode.udid;
    contactsnode.backupDate = nnode.backupDate;
    contactsnode.backupPath = nnode.backupPath;
    contactsnode.snapshotID = nnode.snapshotID;
    contactsnode.productVersion = nnode.productVersion;
    contactsnode.container = NO;
    contactsnode.type = @"Contact";
    contactsnode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,contactsnode.fileName];
    [supportedArr addObject:contactsnode];
    [contactsnode release];
    
    
    SimpleNode *bookmarksnode = [[SimpleNode alloc] init];
    bookmarksnode.fileName = CustomLocalizedString(@"MenuItem_id_21",nil);
    bookmarksnode.deviceName = nnode.deviceName;
    bookmarksnode.udid = nnode.udid;
    bookmarksnode.backupDate = nnode.backupDate;
    bookmarksnode.backupPath = nnode.backupPath;
    bookmarksnode.snapshotID = nnode.snapshotID;
    bookmarksnode.productVersion = nnode.productVersion;
    bookmarksnode.container = NO;
    bookmarksnode.type = @"Bookmarks";
    bookmarksnode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,bookmarksnode.fileName];
    [supportedArr addObject:bookmarksnode];
    [bookmarksnode release];
    
    SimpleNode *calendarnode = [[SimpleNode alloc] init];
    calendarnode.fileName = CustomLocalizedString(@"MenuItem_id_22",nil);
    calendarnode.deviceName = nnode.deviceName;
    calendarnode.udid = nnode.udid;
    calendarnode.backupDate = nnode.backupDate;
    calendarnode.backupPath = nnode.backupPath;
    calendarnode.snapshotID = nnode.snapshotID;
    calendarnode.productVersion = nnode.productVersion;
    calendarnode.type = @"Calendar";
    calendarnode.container = NO;
    calendarnode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,calendarnode.fileName];
    [supportedArr addObject:calendarnode];
    [calendarnode release];
    
    
    if (nnode.productType == iPhoneType) {
        
        SimpleNode *voicemailnode = [[SimpleNode alloc] init];
        voicemailnode.fileName = CustomLocalizedString(@"MenuItem_id_27",nil);
        voicemailnode.deviceName = nnode.deviceName;
        voicemailnode.udid = nnode.udid;
        voicemailnode.backupDate = nnode.backupDate;
        voicemailnode.backupPath = nnode.backupPath;
        voicemailnode.snapshotID = nnode.snapshotID;
        voicemailnode.productVersion = nnode.productVersion;
        voicemailnode.container = NO;
        voicemailnode.type = @"Voicemail";
        voicemailnode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,voicemailnode.fileName];
        [supportedArr addObject:voicemailnode];
        [voicemailnode release];
    }
    
    NSString *version = nnode.productVersion;
    NSString *versionstr = nil;
    if (version.length>0) {
        NSRange range;
        range.length = 1;
        range.location = 0;
        versionstr = [version substringWithRange:range];
        
    }
    if ([versionstr intValue]>=4) {
        
        SimpleNode *messagenode = [[SimpleNode alloc] init];
        messagenode.fileName = CustomLocalizedString(@"MenuItem_id_19",nil);
        messagenode.deviceName = nnode.deviceName;
        messagenode.udid = nnode.udid;
        messagenode.backupDate = nnode.backupDate;
        messagenode.backupPath = nnode.backupPath;
        messagenode.snapshotID = nnode.snapshotID;
        messagenode.productVersion = nnode.productVersion;
        messagenode.container = NO;
        messagenode.type = @"Message";
        messagenode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,messagenode.fileName];
        [supportedArr addObject:messagenode];
        [messagenode release];
        
    }
    
    if (nnode.productType == iPhoneType) {
        
        SimpleNode *callHistorynode = [[SimpleNode alloc] init];
        callHistorynode.fileName = CustomLocalizedString(@"MenuItem_id_18",nil);
        callHistorynode.deviceName = nnode.deviceName;
        callHistorynode.udid = nnode.udid;
        callHistorynode.backupDate = nnode.backupDate;
        callHistorynode.backupPath = nnode.backupPath;
        callHistorynode.snapshotID = nnode.snapshotID;
        callHistorynode.productVersion = nnode.productVersion;
        callHistorynode.container = NO;
        callHistorynode.type = @"CallHistory";
        callHistorynode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,callHistorynode.fileName];
        [supportedArr addObject:callHistorynode];
        [callHistorynode release];
    }
    //默认支持safarihistory
    
    SimpleNode *safarinode = [[SimpleNode alloc] init];
    safarinode.fileName = CustomLocalizedString(@"MenuItem_id_37",nil);
    safarinode.deviceName = nnode.deviceName;
    safarinode.udid = nnode.udid;
    safarinode.backupDate = nnode.backupDate;
    safarinode.backupPath = nnode.backupPath;
    safarinode.snapshotID = nnode.snapshotID;
    safarinode.productVersion = nnode.productVersion;
    safarinode.container = NO;
    safarinode.type = @"SafariHistory";
    safarinode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,safarinode.fileName];
    [supportedArr addObject:safarinode];
    [safarinode release];
    
    return supportedArr;
}


- (void)dealloc {
    [_trackingArea release],_trackingArea = nil;
    [_onlineImageView release], _onlineImageView = nil;
    [_disOnlineImageView release], _disOnlineImageView = nil;
    [super dealloc];
}

@end
