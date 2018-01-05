//
//  IMBAirBackupAnimationView.m
//  AnyTrans
//
//  Created by m on 17/10/18.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBAirBackupAnimationView.h"
#import "StringHelper.h"
#import "IMBAnimation.h"
#import "IMBNotificationDefine.h"
#import "IMBSocketClient.h"
#import "IMBHelper.h"
#import "IMBDeviceConnection.h"
#import "ATTracker.h"
#import "TempHelper.h"
#import "IMBSoftWareInfo.h"
#import "IMBAirWifiBackupViewController.h"

static float waterDrurationTime = 2.0;
static float waterWidth = 1.5;

@implementation IMBAirBackupAnimationView
@synthesize haveAirBackup = _haveAirBackup;
@synthesize isRunning = _isRunning;
@synthesize delegate = _delegate;

- (void)awakeFromNib {
    [self setFrameSize:NSMakeSize(400, 400)];
    [self setWantsLayer:YES];
    
    [_backinglabel setDrawsBackground:NO];

    _wifiBgLayer = [[CALayer alloc] init];
    NSImage *bgImage = [StringHelper imageNamed:@"airbackup_wifibg"];
    _wifiBgLayer.contents = bgImage;
    [_wifiBgLayer setFrame:CGRectMake((self.frame.size.width - bgImage.size.width) / 2.0, (self.frame.size.height - bgImage.size.height) / 2.0, bgImage.size.width, bgImage.size.height)];
    [self.layer addSublayer:_wifiBgLayer];
    
    _wifiLayer = [[CALayer alloc] init];
    NSImage *wifiImage = [StringHelper imageNamed:@"airbackup_wifi1"];
    _wifiLayer.contents = wifiImage;
    [_wifiLayer setFrame:CGRectMake((self.frame.size.width - wifiImage.size.width) / 2.0, (self.frame.size.height - wifiImage.size.height) / 2.0, wifiImage.size.width, wifiImage.size.height)];
    
    _completeLayer = [[CALayer alloc] init];
    NSImage *completeImage = [StringHelper imageNamed:@"airbackup_complete"];
    _completeLayer.contents = completeImage;
    [_completeLayer setFrame:CGRectMake((self.frame.size.width - completeImage.size.width) / 2.0, (self.frame.size.height - completeImage.size.height) / 2.0 + 14, completeImage.size.width, completeImage.size.height)];
    _wifiBackupCircle = [[CALayer alloc] init];
    NSImage *backupCircleImage = [StringHelper imageNamed:@"airbackup_wificircle"];
    _wifiBackupCircle.contents = backupCircleImage;
    [_wifiBackupCircle setFrame:CGRectMake((self.frame.size.width - backupCircleImage.size.width) / 2.0, (self.frame.size.height - backupCircleImage.size.height) / 2.0, backupCircleImage.size.width, backupCircleImage.size.height)];
    
    [self configWaterCircleLayer];
    [self configCompleteLayer];
    [self configCompleteLabel];

    if (_haveAirBackup) {
        [self.layer addSublayer:_completeLayer];
        [self.layer addSublayer:_wifiCompleteCircle];
        [self addSubview:_titleLabel];
        [self addSubview:_sizeLabel];
        [self addSubview:_dateLabel];
        [self addSubview:_moreBackup];
    }else {
        [self.layer addSublayer:_wifiLayer];
        [self.layer addSublayer:_wifiBackupCircle];
    }

    NSString *stopStr = CustomLocalizedString(@"AirBackupStopBackupDevice", nil);
    _stopBackupText = [[IMBCanClickText alloc] initWithFrame:NSMakeRect(0, self.frame.size.height / 2.0 - 200, self.frame.size.width, 20)];
    [_stopBackupText setNormalString:stopStr WithLinkString:stopStr WithNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    [_stopBackupText setAlignment:NSCenterTextAlignment];
    [_stopBackupText setDrawsBackground:NO];
    [_stopBackupText setDelegate:self];
    [_stopBackupText setSelectable:YES];
    [_stopBackupText setEditable:NO];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
}

- (void)setHaveAirBackup:(BOOL)haveAirBackup {
    if (haveAirBackup) {
        [self endAnimation];
    }else {
        [_completeLayer removeAllAnimations];
        [_completeLayer removeFromSuperlayer];
        [_wifiCompleteCircle removeFromSuperlayer];
        [_staticWaterLayer1 removeFromSuperlayer];
        [_staticWaterLayer2 removeFromSuperlayer];
        [_titleLabel removeFromSuperview];
        [_sizeLabel removeFromSuperview];
        [_dateLabel removeFromSuperview];
        [_moreBackup removeFromSuperview];
        
        if(![self.layer.sublayers containsObject:_wifiLayer]) {
            [self.layer addSublayer:_wifiLayer];
        }
        if (![self.layer.sublayers containsObject:_wifiBackupCircle]) {
            [self.layer addSublayer:_wifiBackupCircle];
        }
    }
}

- (void)configCompleteLabel {
    _titleLabel = [[NSTextField alloc] init];
    [_titleLabel setBordered:NO];
    [_titleLabel setDrawsBackground:NO];
    [_titleLabel setFrame:NSMakeRect((self.frame.size.width - 160) / 2.0, self.frame.size.height / 2.0 + 84, 160, 20)];
    [_titleLabel setAlignment:NSCenterTextAlignment];
    [_titleLabel setFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
    [_titleLabel setEditable:NO];
    [_titleLabel setFocusRingType:NSFocusRingTypeNone];
    NSMutableAttributedString *as1 = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"AirBackupCompleted_Title", nil)];
    NSRange range1 = NSMakeRange(0, as1.length);
    [as1 setAlignment:NSCenterTextAlignment range:range1];
    [as1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:range1];
    [_titleLabel setAttributedStringValue:as1];
    [as1 release], as1 = nil;
    
    _sizeLabel = [[NSTextField alloc] init];
    [_sizeLabel setBordered:NO];
    [_sizeLabel setDrawsBackground:NO];
    [_sizeLabel setFrame:NSMakeRect((self.frame.size.width - 160) / 2.0, self.frame.size.height / 2.0 - 74, 160, 20)];
    [_sizeLabel setAlignment:NSCenterTextAlignment];
    [_sizeLabel setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [_sizeLabel setEditable:NO];
    [_sizeLabel setFocusRingType:NSFocusRingTypeNone];

    
    _dateLabel = [[NSTextField alloc] init];
    [_dateLabel setBordered:NO];
    [_dateLabel setDrawsBackground:NO];
    [_dateLabel setFrame:NSMakeRect((self.frame.size.width - 160) / 2.0, self.frame.size.height / 2.0 - 92, 160, 20)];
    [_dateLabel setAlignment:NSCenterTextAlignment];
    [_dateLabel setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [_dateLabel setEditable:NO];
    [_dateLabel setFocusRingType:NSFocusRingTypeNone];
    
    _moreBackup = [[NSTextView alloc] init];
    _moreBackup.delegate = self;
    [_moreBackup setEditable:NO];
    [_moreBackup setSelectable:YES];
    [_moreBackup setDrawsBackground:NO];
    [_moreBackup setFrame:NSMakeRect((self.frame.size.width - 160) / 2.0, self.frame.size.height / 2.0 - 110, 160, 20)];

    _backinglabel = [[NSTextField alloc] init];
    [_backinglabel setBordered:NO];
    [_backinglabel setDrawsBackground:NO];
    [_backinglabel setFrame:NSMakeRect(0, self.frame.size.height / 2.0 - 170, self.frame.size.width, 20)];
    [_backinglabel setAlignment:NSCenterTextAlignment];
    [_backinglabel setFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
    [_backinglabel setEditable:NO];
    [_backinglabel setFocusRingType:NSFocusRingTypeNone];
    
}

- (void)configWaterCircleLayer {
    _staticWaterLayer1 = [[CAShapeLayer alloc] init];
    CGMutablePathRef ref1 = CGPathCreateMutable();
    [_staticWaterLayer1 setFrame:self.bounds];
    CGPathAddEllipseInRect(ref1, NULL, CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height));
    _staticWaterLayer1.path = ref1;
    _staticWaterLayer1.fillColor = [NSColor clearColor].CGColor;
    _staticWaterLayer1.strokeColor = [StringHelper getColorFromString:CustomColor(@"airbackup_waterUpColor", nil)].CGColor;
    _staticWaterLayer1.lineWidth = waterWidth;
    CGPathRelease(ref1);
    [_staticWaterLayer1 setTransform:CATransform3DMakeScale(0.785, 0.785, 1)];
    [self.layer addSublayer:_staticWaterLayer1];

    _staticWaterLayer2 = [[CAShapeLayer alloc] init];
    CGMutablePathRef ref2 = CGPathCreateMutable();
    [_staticWaterLayer2 setFrame:self.bounds];
    CGPathAddEllipseInRect(ref2, NULL, CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height));
    _staticWaterLayer2.path = ref2;
    _staticWaterLayer2.fillColor = [NSColor clearColor].CGColor;
    _staticWaterLayer2.strokeColor = [StringHelper getColorFromString:CustomColor(@"airbackup_waterUpColor", nil)].CGColor;
    _staticWaterLayer2.lineWidth = waterWidth;
    CGPathRelease(ref2);
    [_staticWaterLayer2 setTransform:CATransform3DMakeScale(0.94, 0.94, 1)];
    [self.layer addSublayer:_staticWaterLayer2];
    
    _waterLayer1 = [[CAShapeLayer alloc] init];
    CGMutablePathRef ref11 = CGPathCreateMutable();
    [_waterLayer1 setFrame:self.bounds];
    CGPathAddEllipseInRect(ref11, NULL, CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height));
    _waterLayer1.path = ref11;
    _waterLayer1.fillColor = [NSColor clearColor].CGColor;
    _waterLayer1.strokeColor = [StringHelper getColorFromString:CustomColor(@"airbackup_waterUpColor", nil)].CGColor;
    _waterLayer1.lineWidth = waterWidth;
    CGPathRelease(ref11);

    _waterLayer2 = [[CAShapeLayer alloc] init];
    CGMutablePathRef ref22 = CGPathCreateMutable();
    [_waterLayer2 setFrame:self.bounds];
    CGPathAddEllipseInRect(ref22, NULL, CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height));
    _waterLayer2.path = ref22;
    _waterLayer2.fillColor = [NSColor clearColor].CGColor;
    _waterLayer2.strokeColor = [StringHelper getColorFromString:CustomColor(@"airbackup_waterUpColor", nil)].CGColor;
    _waterLayer2.lineWidth = waterWidth;
    CGPathRelease(ref22);
}

//完成备份渐变的外圈
- (void)configCompleteLayer {
    NSImage *bgImage = [StringHelper imageNamed:@"airbackup_wifibg2"];
    _wifiBgLayer.contents = bgImage;
    _wifiCompleteCircle = [[CALayer alloc] init];
    [_wifiCompleteCircle setFrame:CGRectMake((self.frame.size.width - 282) / 2.0, (self.frame.size.height - 282) / 2.0, 282, 282)];

    _gradientLayer =  [[CAGradientLayer alloc] init];
    _gradientLayer.frame = CGRectMake(0, 0, 282, 282);
    [_gradientLayer setColors:[NSArray arrayWithObjects:(id)[[StringHelper getColorFromString:CustomColor(@"airbackup_completeDownColor", nil)] CGColor],(id)[[StringHelper getColorFromString:CustomColor(@"airbackup_completeUpColor", nil)] CGColor], nil]];
    [_gradientLayer setLocations:@[@0,@1]];
    [_gradientLayer setStartPoint:CGPointMake(0.5, 0)];
    [_gradientLayer setEndPoint:CGPointMake(0.5, 1)];

    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef ref = CGPathCreateMutable();
    [shapeLayer setFrame:self.bounds];
    CGPathAddEllipseInRect(ref, NULL, CGRectMake(3,3,276,276));
    shapeLayer.path = ref;
    shapeLayer.fillColor = [NSColor clearColor].CGColor;
    shapeLayer.strokeColor = [NSColor redColor].CGColor;
    shapeLayer.lineWidth = 6.0;
    CGPathRelease(ref);

    [_gradientLayer setMask:shapeLayer]; //用shapeLayer来截取渐变层
    [_wifiCompleteCircle addSublayer:_gradientLayer];
    [shapeLayer release], shapeLayer = nil;
 
}

- (void)startAnimationWithBaseInfo:(IMBBaseInfo *)baseInfo {
    if (_baseInfo != nil) {
        [_baseInfo release];
        _baseInfo = nil;
    }
    _baseInfo = [baseInfo retain];
    
    _isRunning = YES;
    _count = 2;
    [_completeLayer removeAllAnimations];
    [_completeLayer removeFromSuperlayer];
    [_wifiCompleteCircle removeFromSuperlayer];
    [_staticWaterLayer1 removeFromSuperlayer];
    [_staticWaterLayer2 removeFromSuperlayer];
    [_titleLabel removeFromSuperview];
    [_sizeLabel removeFromSuperview];
    [_dateLabel removeFromSuperview];
    [_moreBackup removeFromSuperview];
    
    NSImage *bgImage = [StringHelper imageNamed:@"airbackup_wifibg"];
    _wifiBgLayer.contents = bgImage;
    
    if(![self.layer.sublayers containsObject:_wifiLayer]) {
        [self.layer addSublayer:_wifiLayer];
    }
    if (![self.layer.sublayers containsObject:_wifiBackupCircle]) {
        [self.layer addSublayer:_wifiBackupCircle];
    }
    if (![self.subviews containsObject:_stopBackupText]) {
        [self addSubview:_stopBackupText];
    }
    //转圈
    CABasicAnimation *rotationAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @0;
    rotationAnimation.toValue = @(2 * M_PI);
    rotationAnimation.duration = 3.0;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode=kCAFillModeForwards;
    rotationAnimation.repeatCount = NSIntegerMax;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_wifiBackupCircle addAnimation:rotationAnimation forKey:@""];
    
    //wifi图片的变化
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeWifiImage) userInfo:nil repeats:YES];
    
    //扩散水波
    [self configSpreadWaterLayerAimation];
    
}

- (void)changeWifiImage {
    NSImage *wifiImage = nil;
    if (_count == 1) {
        wifiImage = [StringHelper imageNamed:@"airbackup_wifi1"];
    }else if (_count == 2) {
        wifiImage = [StringHelper imageNamed:@"airbackup_wifi2"];
    }else if (_count == 3) {
        wifiImage = [StringHelper imageNamed:@"airbackup_wifi3"];
    }else if (_count == 4) {
        wifiImage = [StringHelper imageNamed:@"airbackup_wifi4"];
    }else if (_count == 5) {
        wifiImage = [StringHelper imageNamed:@"airbackup_wifi5"];
        _count = 0;
    }
    _wifiLayer.contents = wifiImage;
    _count ++;
}

- (void)configSpreadWaterLayerAimation {
    [self setGroupAnimaitonForLayer:_waterLayer1 withAnimationBeinTime:0.1];
    [self setGroupAnimaitonForLayer:_waterLayer2 withAnimationBeinTime:1.1];
    [self.layer addSublayer:_waterLayer1];
    [self.layer addSublayer:_waterLayer2];

}

- (void)setGroupAnimaitonForLayer:(CAShapeLayer *)layer withAnimationBeinTime:(float)beinTime {
    CABasicAnimation *animation1=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation1.fromValue = @0.7;
    animation1.toValue = @1;
    animation1.duration = waterDrurationTime;
    animation1.repeatCount = NSIntegerMax;
    animation1.removedOnCompletion = NO;
    animation1.fillMode = kCAFillModeForwards;
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation1.beginTime = 0.0;
    
    CABasicAnimation *animation2=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = [NSNumber numberWithFloat:1.0];
    animation2.toValue = [NSNumber numberWithFloat:0.0];
    animation2.duration = waterDrurationTime;
    animation2.repeatCount = NSIntegerMax;
    animation2.removedOnCompletion = NO;
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation2.fillMode = kCAFillModeForwards;
    animation2.beginTime = 0.0;
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    group.animations = @[animation1,animation2];
    group.duration = waterDrurationTime;
    group.repeatCount = NSIntegerMax;
    group.removedOnCompletion=NO;
    group.fillMode=kCAFillModeForwards;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group.beginTime = beinTime;
    
    [layer addAnimation:group forKey:@""];
}

- (void)endAnimation {
    _isRunning = NO;
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    [_stopBackupText removeFromSuperview];
    [_backinglabel removeFromSuperview];
    [_wifiLayer removeFromSuperlayer];
    [_wifiBackupCircle removeAllAnimations];
    [_wifiBackupCircle removeFromSuperlayer];
    [_waterLayer1 removeAllAnimations];
    [_waterLayer1 removeFromSuperlayer];
    [_waterLayer2 removeAllAnimations];
    [_waterLayer2 removeFromSuperlayer];
    
    [self.layer addSublayer:_completeLayer];
    [self.layer addSublayer:_wifiCompleteCircle];
    [self.layer addSublayer:_staticWaterLayer1];
    [self.layer addSublayer:_staticWaterLayer2];
    [self addSubview:_titleLabel];
    [self addSubview:_sizeLabel];
    [self addSubview:_dateLabel];
    [self addSubview:_moreBackup];
}

- (void)recoverBeginState {
    [_completeLayer removeAllAnimations];
    [_completeLayer removeFromSuperlayer];
    [_wifiCompleteCircle removeFromSuperlayer];
    [_staticWaterLayer1 removeFromSuperlayer];
    [_staticWaterLayer2 removeFromSuperlayer];
    [_titleLabel removeFromSuperview];
    [_sizeLabel removeFromSuperview];
    [_dateLabel removeFromSuperview];
    [_moreBackup removeFromSuperview];
    
    if(![self.layer.sublayers containsObject:_wifiLayer]) {
        [self.layer addSublayer:_wifiLayer];
    }
    if (![self.layer.sublayers containsObject:_wifiBackupCircle]) {
        [_wifiBackupCircle removeAllAnimations];
        [self.layer addSublayer:_wifiBackupCircle];
    }
    if (![self.layer.sublayers containsObject:_wifiBgLayer]) {
        [self.layer addSublayer:_wifiBgLayer];
    }
    if (![self.layer.sublayers containsObject:_staticWaterLayer1]) {
        [self.layer addSublayer:_staticWaterLayer1];
    }
    if (![self.layer.sublayers containsObject:_staticWaterLayer2]) {
         [self.layer addSublayer:_staticWaterLayer2];
    }
}

#pragma mark 备份进度
- (void)setBackupProgress:(float)progress {
    if (![self.subviews containsObject:_backinglabel]) {
        [self addSubview:_backinglabel];
    }
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"AirBackupSettingAlert_BackingupProgress", nil),progress];
    NSMutableAttributedString *as1 = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range1 = NSMakeRange(0, as1.length);
    [as1 setAlignment:NSCenterTextAlignment range:range1];
    [as1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:range1];
    [_backinglabel setAttributedStringValue:as1];
    [as1 release], as1 = nil;
}

- (void)setBackupStart {
    if (![self.subviews containsObject:_stopBackupText]) {
        [self addSubview:_stopBackupText];
    }
    if (![self.subviews containsObject:_backinglabel]) {
        [self addSubview:_backinglabel];
    }
    NSMutableAttributedString *as1 = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"AirBackup_PrepareBackupTips", nil)];
    NSRange range1 = NSMakeRange(0, as1.length);
    [as1 setAlignment:NSCenterTextAlignment range:range1];
    [as1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:range1];
    [_backinglabel setAttributedStringValue:as1];
    [as1 release], as1 = nil;
}

//点击more Backup
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex{
    if([link isEqualToString:CustomLocalizedString(@"AirBackupMoreBackup", nil)] ||[link isEqualToString:CustomLocalizedString(@"AirBackupMoreBackups", nil)]  ){
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Air_Backup action:ActionNone actionParams:@"More backup" label:Click transferCount:0 screenView:@"More backup View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTITY_OPEN_MOREBACKUP object:nil userInfo:@{@"moreBackup":_moreBackup}];
    }else if ([link isEqualToString:CustomLocalizedString(@"AirBackupStopBackupDevice", nil)]) {//停止备份
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Air_Backup action:AirBackup actionParams:@"Backup" label:Stop transferCount:0 screenView:@"Backup View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        IMBSocketClient *socketClient = [IMBSocketClient singleton];
        NSDictionary *dic = @{@"MsgType":@"StopAirBackup",@"SerialNumber":_baseInfo.uniqueKey};
        NSString *str2 = [IMBHelper dictionaryToJson:dic];
        [socketClient sendData:str2];
        
        if (_baseInfo.backupRecordAryM.count > 0) {
            [self setHaveAirBackup:YES];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_baseInfo.backupTime longValue]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
            NSString *confromTimespStr = [dateFormatter stringFromDate:confromTimesp];
            [dateFormatter release], dateFormatter = nil;
            [self setBackupSize:[StringHelper getFileSizeString:[_baseInfo.backupSize longLongValue] reserved:2] WithBcakupDate:confromTimespStr WithRecordAry:_baseInfo.backupRecordAryM];
        }else {
            [self endAnimation];
            [self setHaveAirBackup:NO];
        }
        [_delegate setBackupButtonAndDevicePopBtn];
    }
    return YES;
}

- (void)setBackupSize:(NSString *)sizeStr WithBcakupDate:(NSString *)dateStr WithRecordAry:(NSMutableArray *)records {
    NSString *str = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"List_Header_id_Size", nil),sizeStr];
    NSMutableAttributedString *as1 = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range1 = NSMakeRange(0, as1.length);
    [as1 setAlignment:NSCenterTextAlignment range:range1];
    [as1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:range1];
    [_sizeLabel setAttributedStringValue:as1];
    [as1 release], as1 = nil;
    
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc] initWithString:dateStr];
    NSRange range2 = NSMakeRange(0, as2.length);
    [as2 setAlignment:NSCenterTextAlignment range:range2];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:range2];
    [_dateLabel setAttributedStringValue:as2];
    [as2 release], as2 = nil;
    
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_moreBackup setLinkTextAttributes:linkAttributes];
    NSString *promptStr = nil;
    NSString *overStr = nil;
    if (records.count > 1) {
        promptStr = CustomLocalizedString(@"AirBackupMoreBackups", nil);
        overStr = CustomLocalizedString(@"AirBackupMoreBackups", nil);
    }else {
        promptStr = CustomLocalizedString(@"AirBackupMoreBackup", nil);
        overStr = CustomLocalizedString(@"AirBackupMoreBackup", nil);
    }

    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = [promptStr rangeOfString:overStr];
    [promptAs addAttribute:NSLinkAttributeName value:overStr range:infoRange];
    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_moreBackup textStorage] setAttributedString:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;
    
}

#pragma mark - 切换皮肤和语言
- (void)doChangeLanguage:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *stopStr = CustomLocalizedString(@"AirBackupStopBackupDevice", nil);
        [_stopBackupText setNormalString:stopStr WithLinkString:stopStr WithNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
        [_stopBackupText setNeedsDisplay:YES];
        NSMutableAttributedString *as1 = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"AirBackupCompleted_Title", nil)];
        NSRange range1 = NSMakeRange(0, as1.length);
        [as1 setAlignment:NSCenterTextAlignment range:range1];
        [as1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:range1];
        [_titleLabel setAttributedStringValue:as1];
        [as1 release], as1 = nil;
    });
    
}

- (void)changeSkin:(NSNotification *)noti {

    NSImage *bgImage = [StringHelper imageNamed:@"airbackup_wifibg"];
    _wifiBgLayer.contents = bgImage;
    NSImage *completeImage = [StringHelper imageNamed:@"airbackup_complete"];
    _completeLayer.contents = completeImage;
    NSImage *backupCircleImage = [StringHelper imageNamed:@"airbackup_wificircle"];
    _wifiBackupCircle.contents = backupCircleImage;
    _staticWaterLayer1.strokeColor = [StringHelper getColorFromString:CustomColor(@"airbackup_waterUpColor", nil)].CGColor;
    _staticWaterLayer2.strokeColor = [StringHelper getColorFromString:CustomColor(@"airbackup_waterUpColor", nil)].CGColor;
    
    NSImage *wifiImage = [StringHelper imageNamed:@"airbackup_wifi1"];
    _wifiLayer.contents = wifiImage;
    
    _staticWaterLayer1 = [[CAShapeLayer alloc] init];
    CGMutablePathRef ref1 = CGPathCreateMutable();
    [_staticWaterLayer1 setFrame:self.bounds];
    CGPathAddEllipseInRect(ref1, NULL, CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height));
    _staticWaterLayer1.path = ref1;
    _staticWaterLayer1.fillColor = [NSColor clearColor].CGColor;
    _staticWaterLayer1.strokeColor = [StringHelper getColorFromString:CustomColor(@"airbackup_waterUpColor", nil)].CGColor;
    _staticWaterLayer1.lineWidth = waterWidth;
    CGPathRelease(ref1);
    [_staticWaterLayer1 setTransform:CATransform3DMakeScale(0.785, 0.785, 1)];
    [self.layer addSublayer:_staticWaterLayer1];
    
    _staticWaterLayer2.strokeColor = [StringHelper getColorFromString:CustomColor(@"airbackup_waterUpColor", nil)].CGColor;
    _waterLayer1.strokeColor = [StringHelper getColorFromString:CustomColor(@"airbackup_waterUpColor", nil)].CGColor;
    _waterLayer2.strokeColor = [StringHelper getColorFromString:CustomColor(@"airbackup_waterUpColor", nil)].CGColor;
    
    NSMutableAttributedString *as1 = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"AirBackupCompleted_Title", nil)];
    NSRange range1 = NSMakeRange(0, as1.length);
    [as1 setAlignment:NSCenterTextAlignment range:range1];
    [as1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:range1];
    [_titleLabel setAttributedStringValue:as1];
    [as1 release], as1 = nil;

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    if (_wifiBgLayer != nil) {
        [_wifiBgLayer release];
        _wifiBgLayer = nil;
    }
    if (_wifiLayer != nil) {
        [_wifiLayer release];
        _wifiLayer = nil;
    }
    if (_wifiBackupCircle != nil) {
        [_wifiBackupCircle release];
        _wifiBackupCircle = nil;
    }
    if (_completeLayer != nil) {
        [_completeLayer release];
        _completeLayer = nil;
    }
    if (_wifiCompleteCircle != nil) {
        [_wifiCompleteCircle release];
        _wifiCompleteCircle = nil;
    }
    if (_staticWaterLayer1 != nil) {
        [_staticWaterLayer1 release];
        _staticWaterLayer1 = nil;
    }
    if (_staticWaterLayer2 != nil) {
        [_staticWaterLayer2 release];
        _staticWaterLayer2 = nil;
    }
    if (_waterLayer1 != nil) {
        [_waterLayer1 release];
        _waterLayer1 = nil;
    }
    if (_waterLayer2 != nil) {
        [_waterLayer2 release];
        _waterLayer2 = nil;
    }
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    if (_titleLabel != nil) {
        [_titleLabel release];
        _titleLabel = nil;
    }
    if (_sizeLabel != nil) {
        [_sizeLabel release];
        _sizeLabel = nil;
    }
    if (_dateLabel != nil) {
        [_dateLabel release];
        _dateLabel = nil;
    }
    if (_moreBackup != nil) {
        [_moreBackup release];
        _moreBackup = nil;
    }
    if (_backinglabel != nil) {
        [_backinglabel release];
        _backinglabel = nil;
    }
    if (_baseInfo != nil) {
        [_baseInfo release];
        _baseInfo = nil;
    }
    if (_stopBackupText != nil) {
        [_stopBackupText release];
        _stopBackupText = nil;
    }
    if (_gradientLayer != nil) {
        [_gradientLayer release];
        _gradientLayer = nil;
    }
    
    [super dealloc];
}

@end
