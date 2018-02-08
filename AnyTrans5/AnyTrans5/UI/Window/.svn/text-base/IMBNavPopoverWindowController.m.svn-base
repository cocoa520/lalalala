//
//  IMBNavPopoverWindowController.m
//  AnyTrans
//
//  Created by m on 11/8/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBNavPopoverWindowController.h"
#import "StringHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "IMBAnimation.h"
#import "IMBSoftWareInfo.h"
#import "SystemHelper.h"
#import "NSString+Compare.h"
static float SKIN_CHANGE_INTEVAL = 1.0;//皮肤动画的间隙
@implementation IMBNavPopoverWindowController
@synthesize  currentType = _currentType;
@synthesize isUP = _isUP;
- (void)windowDidLoad {
    [super windowDidLoad];
}

- (void)awakeFromNib {
    self.window.opaque = NO;
    self.window.backgroundColor=[NSColor clearColor];
    if (![[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
        [self.window setFrame:NSMakeRect(self.window.frame.origin.x, self.window.frame.origin.y, self.window.frame.size.width + 4, self.window.frame.size.height +2) display:YES];
        [_titleView setFrame:NSMakeRect(2, 2, _titleView.frame.size.width , _titleView.frame.size.height)];
        [_titleView setWantsLayer:YES];
        [_titleView.layer setCornerRadius:5];
    }

    _otherLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 50, 190, 22)];
    [_otherLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"nav_mainTitleColor", nil)]];
    [_otherLabel setEditable:NO];
    [_otherLabel setBordered:NO];
    [_otherLabel setBackgroundColor:[NSColor clearColor]];
    [_otherLabel setFont:[NSFont fontWithName:@"Helvetica Neue" size:10]];
    [_otherLabel setStringValue:@"(Copia de Seguridad Inalámbrica)"];//仅仅西语才有
    [_otherLabel setAlignment:NSCenterTextAlignment];
    [self loadContent];
    
    [_mainView setHasSet:YES];
    [_mainView setFrameSize:NSMakeSize(self.window.frame.size.width, self.window.frame.size.height)];
    [_mainView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"popover_bgColor", nil)]];
    [_mainView setWantsLayer:YES];
    [_mainView.layer setCornerRadius:5];
    [_mainView.layer setMasksToBounds:YES];
    _animationView = [[NSView alloc] initWithFrame:NSMakeRect(0, 116, 206, 96)];
    [_animationView setWantsLayer:YES];
    
    _backUpView = [[NSView alloc] initWithFrame:NSMakeRect(0, 116, 206, 96)];
    [_backUpView setWantsLayer:YES];
    
    _iCloudView = [[NSView alloc] initWithFrame:NSMakeRect(0, 116, 206, 96)];
    [_iCloudView setWantsLayer:YES];
    
    _deviceView = [[NSView alloc] initWithFrame:NSMakeRect(0, 116, 206, 96)];
    [_deviceView setWantsLayer:YES];
    
    _downLoadView = [[NSView alloc] initWithFrame:NSMakeRect(0, 116, 206, 96)];
    [_downLoadView setWantsLayer:YES];
    
    _toiOSView = [[NSView alloc] initWithFrame:NSMakeRect(0, 116, 206, 96)];
    [_toiOSView setWantsLayer:YES];
    
    _skinView = [[NSView alloc] initWithFrame:NSMakeRect(0, 116, 206, 96)];
    [_skinView setWantsLayer:YES];
    
    _airBackupView = [[NSView alloc] initWithFrame:NSMakeRect(0, 116, 206, 96)];
    [_airBackupView setWantsLayer:YES];
    
    [self initiTunesAnimationView];
    [self initBackupAnimationView];
    [self initiCloudAnimationView];
    [self initDeviceAnimationView];
    [self initDownLoadAnimationView];
    [self initToiOSAnimationView];
    [self initSkinAnimationView];
    [self initAirBackupAnimationView];
}

- (void)setCurrentType:(FunctionType)currentType{
    _currentType = currentType;
    _mainTitle = nil;
    _subTitle = nil;
    [_mainView setWantsLayer:YES];
    [_mainView.layer setMasksToBounds:YES];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.locations = @[@0, @1.0];

    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = NSMakeRect(0, 116, _mainView.frame.size.width,_mainView.frame.size.height - 116 );
    [_otherLabel removeFromSuperview];
    if (_currentType == iTunesLibraryModule) {
        [_subLabel setFrame:NSMakeRect(5, 0, 196, 76)];
        _mainTitle = CustomLocalizedString(@"Nav_iTunes_Depict_Title", nil);
        _subTitle = CustomLocalizedString(@"Nav_iTunes_Depict_Content", nil);
        gradientLayer.colors = @[(__bridge id)[StringHelper getColorFromString:CustomColor(@"iTunes_gradient_leftColor", nil)].CGColor,  (__bridge id)[StringHelper getColorFromString:CustomColor(@"iTunes_gradient_rightColor", nil)].CGColor];
    }else if (_currentType == BackupModule) {
        if ([[IMBSoftWareInfo singleton] chooseLanguageType] == ArabLanguage) {
            [_subLabel setFrame:NSMakeRect(0, 0, 206, 76)];
        }else {
            [_subLabel setFrame:NSMakeRect(5, 0, 196, 76)];
        }
        _mainTitle = CustomLocalizedString(@"Nav_Backup_Depict_Title", nil);
        _subTitle = CustomLocalizedString(@"Nav_Backup_Depict_Content", nil);
        gradientLayer.colors = @[(__bridge id)[StringHelper getColorFromString:CustomColor(@"backup_gradient_leftColor", nil)].CGColor,  (__bridge id)[StringHelper getColorFromString:CustomColor(@"backup_gradient_rightColor", nil)].CGColor];
    }else if (_currentType == AirBackupModule) {
        _mainTitle = CustomLocalizedString(@"Nav_Airbackup_Depict_Title", nil);
        _subTitle = CustomLocalizedString(@"Nav_AirBackup_Depict_Content", nil);
        if ([IMBSoftWareInfo singleton].chooseLanguageType == SpanishLanguage) {
            [_titleView addSubview:_otherLabel];
            [_otherLabel setFrame:NSMakeRect(5, 60, 196, 20)];
            [_subLabel setFrame:NSMakeRect(5, 0, 196, 66)];
        }else {
            [_subLabel setFrame:NSMakeRect(5, 0, 196, 76)];
        }
        
        [_mainLabel setFrame:NSMakeRect(0, 75, _mainLabel.frame.size.width, 26)];
        gradientLayer.colors = @[(__bridge id)[StringHelper getColorFromString:CustomColor(@"airBackup_gradient_leftColor", nil)].CGColor,  (__bridge id)[StringHelper getColorFromString:CustomColor(@"airBackup_gradient_rightColor", nil)].CGColor];
    }else if (_currentType == iCloudModule) {
        if ([[IMBSoftWareInfo singleton] chooseLanguageType] == FrenchLanguage || [[IMBSoftWareInfo singleton] chooseLanguageType] == ArabLanguage) {
            [_subLabel setFrame:NSMakeRect(0, 0, 206, 76)];
        }else {
            [_subLabel setFrame:NSMakeRect(5, 0, 196, 76)];
        }
        _mainTitle = CustomLocalizedString(@"Nav_iCloud_Depict_Title", nil);
        _subTitle = CustomLocalizedString(@"Nav_iCloud_Depict_Content", nil);
        gradientLayer.colors = @[(__bridge id)[StringHelper getColorFromString:CustomColor(@"iCloud_gradient_leftColor", nil)].CGColor,  (__bridge id)[StringHelper getColorFromString:CustomColor(@"iCloud_gradient_rightColor", nil)].CGColor];
    }else if (_currentType == DeviceModule) {
        _mainTitle = CustomLocalizedString(@"Nav_Device_Depict_Title", nil);
        _subTitle = CustomLocalizedString(@"Nav_Device_Depict_Content", nil);
        if ([[IMBSoftWareInfo singleton] chooseLanguageType] == FrenchLanguage) {
            [_mainLabel setFrame:NSMakeRect(0, 49, _mainLabel.frame.size.width, 52)];
            [_subLabel setFrameSize:NSMakeSize(_subLabel.frame.size.width, 50)];
        }else {
             [_mainLabel setFrame:NSMakeRect(0, 75, _mainLabel.frame.size.width, 26)];
             [_subLabel setFrame:NSMakeRect(5, 0, 196, 76)];
        }
        gradientLayer.colors = @[(__bridge id)[StringHelper getColorFromString:CustomColor(@"device_gradient_leftColor", nil)].CGColor,  (__bridge id)[StringHelper getColorFromString:CustomColor(@"device_gradient_rightColor", nil)].CGColor];
    }else if (_currentType == VideoDownloadModule) {
        if ([[IMBSoftWareInfo singleton] chooseLanguageType] == SpanishLanguage) {
            [_mainLabel setFrame:NSMakeRect(0, 49, _mainLabel.frame.size.width, 52)];
            [_subLabel setFrameSize:NSMakeSize(_subLabel.frame.size.width, 50)];
        }else {
            if ([[IMBSoftWareInfo singleton] chooseLanguageType] == FrenchLanguage) {
                [_subLabel setFrame:NSMakeRect(8, 0, 190, 76)];
            }else {
                [_subLabel setFrame:NSMakeRect(5, 0, 196, 76)];
            }
            [_mainLabel setFrame:NSMakeRect(0, 75, _mainLabel.frame.size.width, 26)];
        }
        _mainTitle = CustomLocalizedString(@"Nav_Download_Depict_Title", nil);
        _subTitle = CustomLocalizedString(@"Nav_Download_Depict_Content", nil);
        gradientLayer.colors = @[(__bridge id)[StringHelper getColorFromString:CustomColor(@"download_gradient_leftColor", nil)].CGColor,  (__bridge id)[StringHelper getColorFromString:CustomColor(@"download_gradient_rightColor", nil)].CGColor];
    }else if (_currentType == SkinModule) {
        if ([[IMBSoftWareInfo singleton] chooseLanguageType] == FrenchLanguage) {
            [_subLabel setFrame:NSMakeRect(2, 0, 202, 76)];
        }else {
            [_subLabel setFrame:NSMakeRect(0, 0, 206, 76)];
        }
        _mainTitle = CustomLocalizedString(@"Nav_Skin_Depict_Title", nil);
        _subTitle = CustomLocalizedString(@"Nav_Skin_Depict_Content", nil);
        gradientLayer.colors = @[(__bridge id)[StringHelper getColorFromString:CustomColor(@"skin_gradient_leftColor", nil)].CGColor,  (__bridge id)[StringHelper getColorFromString:CustomColor(@"skin_gradient_rightColor", nil)].CGColor];
    }else if (_currentType == AndroidModule) {
        if ([[IMBSoftWareInfo singleton] chooseLanguageType] == JapaneseLanguage) {
            [_subLabel setFrame:NSMakeRect(8, 0, 190, 76)];
        }else {
            [_subLabel setFrame:NSMakeRect(5, 0, 196, 76)];
        }
        _mainTitle = CustomLocalizedString(@"Nav_ToiOS_Depict_Title", nil);
        _subTitle = CustomLocalizedString(@"Nav_ToiOS_Depict_Content", nil);
        gradientLayer.colors = @[(__bridge id)[StringHelper getColorFromString:CustomColor(@"android_gradient_leftColor", nil)].CGColor,  (__bridge id)[StringHelper getColorFromString:CustomColor(@"android_gradient_rightColor", nil)].CGColor];
    }
     [_mainView.layer addSublayer:gradientLayer];
     [self loadContent];
    
    [self loadAnimationViewWithType:_currentType];
    [_titleView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"popover_bgColor", nil)]];
}

- (void)loadContent {
    if (_mainTitle) {
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:_mainTitle];
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:18] range:NSMakeRange(0, as.length)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        [style setAlignment:NSCenterTextAlignment];
        [as addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, as.length)];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nav_mainTitleColor", nil)] range:NSMakeRange(0, as.length)];
        [_mainLabel setAttributedStringValue:as];
        [as release], as = nil;
        [style release], style = nil;
    }
    if (_subTitle) {
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:_subTitle];
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        [style setAlignment:NSCenterTextAlignment];
        [as addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, as.length)];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nav_subTitleColor", nil)] range:NSMakeRange(0, as.length)];
        [_subLabel setAttributedStringValue:as];
        [as release], as = nil;
        [style release], style = nil;
    }
    [_otherLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"nav_mainTitleColor", nil)]];
}

#pragma 加载不同动画
- (void)loadAnimationViewWithType:(FunctionType)currentType {
    [_animationView removeFromSuperview];
    [_animationView.layer removeAllAnimations];
    [_backUpView removeFromSuperview];
    [_backUpView.layer removeAllAnimations];
    [_iCloudView removeFromSuperview];
    [_iCloudView.layer removeAllAnimations];
    [_deviceView removeFromSuperview];
    [_deviceView.layer removeAllAnimations];
    [_downLoadView removeFromSuperview];
    [_downLoadView.layer removeAllAnimations];
    [_toiOSView removeFromSuperview];
    [_toiOSView.layer removeAllAnimations];
    [_skinView removeFromSuperview];
    [_skinView.layer removeAllAnimations];
    [_airBackupView removeFromSuperview];
    [_airBackupView.layer removeAllAnimations];
    if (currentType == iTunesLibraryModule) {
        [_mainView addSubview:_animationView];
    }else if (currentType == BackupModule) {
        [_mainView addSubview:_backUpView];
    }else if (currentType == iCloudModule) {
        [_mainView addSubview:_iCloudView];
    }else if (currentType == DeviceModule) {
        [_mainView addSubview:_deviceView];
    }else if (currentType == VideoDownloadModule) {
        [_mainView addSubview:_downLoadView];
    }else if (currentType == AndroidModule) {
        [_mainView addSubview:_toiOSView];
    }else if (currentType == SkinModule) {
        [_mainView addSubview:_skinView];
    }else if (currentType == AirBackupModule) {
        [_mainView addSubview:_airBackupView];
    }
}

#pragma iTunes动画
- (void)initiTunesAnimationView {
    NSImage *image = [StringHelper imageNamed:@"box_itunes"];
    NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect((_animationView.frame.size.width - image.size.width) / 2.0, (_animationView.frame.size.height - 6 - image.size.height) / 2.0, image.size.width, image.size.height)];
    [imageView setImage:image];
    [_animationView addSubview:imageView];
    [imageView release], imageView = nil;
    
    _shapeLayer1 = [[CAShapeLayer alloc] init];
    _shapeLayer2 = [[CAShapeLayer alloc] init];
    _shapeLayer3 = [[CAShapeLayer alloc] init];
    
    NSString *colorStr = CustomColor(@"mainView_bgColor", nil);
     NSArray *array = [colorStr componentsSeparatedByString:@","];
    float r = [[array objectAtIndex:0] floatValue];
    float g = [[array objectAtIndex:1] floatValue];
    float b = [[array objectAtIndex:2] floatValue];
    
    NSColor *color = [NSColor colorWithDeviceRed:r green:g blue:b alpha:0.4];
    _shapeLayer1.fillColor = [NSColor clearColor].CGColor;
    _shapeLayer1.frame = CGRectMake(0, 0, _animationView.frame.size.width, _animationView.frame.size.height);
    CGPathRef ref = CGPathCreateWithEllipseInRect(CGRectMake((_animationView.frame.size.width - _animationView.frame.size.height) / 2.0, (_animationView.frame.size.height  - 6 - _animationView.frame.size.height) / 2.0,_animationView.frame.size.height, _animationView.frame.size.height), NULL);
    _shapeLayer1.path = ref;
    _shapeLayer1.lineWidth = 1.0;
    _shapeLayer1.strokeColor = color.CGColor;
    _shapeLayer1.anchorPoint = CGPointMake(0.5, 0.5);
    _shapeLayer1.zPosition = -1;
    
    _shapeLayer2.fillColor = [NSColor clearColor].CGColor;
    _shapeLayer2.frame = CGRectMake(0, 0, _animationView.frame.size.width, _animationView.frame.size.height);
    CGPathRef ref2 = CGPathCreateWithEllipseInRect(CGRectMake((_animationView.frame.size.width - _animationView.frame.size.height) / 2.0, (_animationView.frame.size.height  - 6 - _animationView.frame.size.height) / 2.0,_animationView.frame.size.height, _animationView.frame.size.height), NULL);
    _shapeLayer2.path = ref2;
    _shapeLayer2.lineWidth = 1.0;
    _shapeLayer2.strokeColor = color.CGColor;
    _shapeLayer2.anchorPoint = CGPointMake(0.5, 0.5);
    _shapeLayer2.zPosition = -1;
    
    _shapeLayer3.fillColor = [NSColor clearColor].CGColor;
    _shapeLayer3.frame = CGRectMake(0, 0, _animationView.frame.size.width, _animationView.frame.size.height);
    CGPathRef ref3 = CGPathCreateWithEllipseInRect(CGRectMake((_animationView.frame.size.width - _animationView.frame.size.height) / 2.0, (_animationView.frame.size.height - 6 -  _animationView.frame.size.height) / 2.0 ,_animationView.frame.size.height, _animationView.frame.size.height), NULL);
    _shapeLayer3.path = ref3;
    _shapeLayer3.lineWidth = 1.0;
    _shapeLayer3.strokeColor = color.CGColor;
    _shapeLayer3.anchorPoint = CGPointMake(0.5, 0.5);
    _shapeLayer3.zPosition = -1;
    
    [self loadWaterAnimationWithBeginTime:0.0 WithLayer:_shapeLayer1];
    [_animationView.layer addSublayer:_shapeLayer1];
    [self loadWaterAnimationWithBeginTime:1.0 WithLayer:_shapeLayer2];
    [_animationView.layer addSublayer:_shapeLayer2];
    [self loadWaterAnimationWithBeginTime:2.0 WithLayer:_shapeLayer3];
    [_animationView.layer addSublayer:_shapeLayer3];

    _layer1 = [[CALayer alloc] init];
    NSImage *image1 = [StringHelper imageNamed:@"box_itunesicon1"];
    _layer1.contents = image1;
    [_layer1 setFrame:CGRectMake(_animationView.frame.size.width / 2.0 + 40, 64, image1.size.width, image1.size.height)];
    [_animationView.layer addSublayer:_layer1];
    [self keyframeAniamtionWithCp1x:_animationView.frame.size.width / 2.0 + 40 cp1y:64 cp2x:_animationView.frame.size.width / 2.0 + 50 cp2y:80 endPointX:_animationView.frame.size.width / 2.0 + 120 endPointY: 40 WithBeginTime:0.0f layer:_layer1];

    _layer2 = [[CALayer alloc] init];
    NSImage *image2 = [StringHelper imageNamed:@"box_itunesicon2"];
    _layer2.contents = image2;
    [_layer2 setFrame:CGRectMake(_animationView.frame.size.width / 2.0 + 40, 25, image1.size.width, image1.size.height)];
    [_animationView.layer addSublayer:_layer2];
    [self keyframeAniamtionWithCp1x:_animationView.frame.size.width / 2.0 + 40 cp1y:25 cp2x:_animationView.frame.size.width / 2.0 + 50 cp2y:5 endPointX:_animationView.frame.size.width / 2.0 + 120 endPointY: 30 WithBeginTime:2.0f layer:_layer2];

    _layer3 = [[CALayer alloc] init];
    NSImage *image3 = [StringHelper imageNamed:@"box_itunesicon3"];
    _layer3.contents = image3;
    [_layer3 setFrame:CGRectMake(_animationView.frame.size.width / 2.0 - 46, 45, image1.size.width, image1.size.height)];
    [_animationView.layer addSublayer:_layer3];
    [self keyframeAniamtionWithCp1x:_animationView.frame.size.width / 2.0 - 46 cp1y:45 cp2x:_animationView.frame.size.width / 2.0 - 50 cp2y:30 endPointX:_animationView.frame.size.width / 2.0 - 120 endPointY: 55 WithBeginTime:1.0f layer:_layer3];
}

- (void)loadWaterAnimationWithBeginTime:(float)beginTime WithLayer:(CAShapeLayer *)layer  {
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @0.8;
    animation.toValue = @2.0;
    animation.duration = 3.0;
    animation.repeatCount = NSIntegerMax;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *animation2=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue=[NSNumber numberWithFloat:1.0];
    animation2.toValue=[NSNumber numberWithFloat:0.0];
    animation2.autoreverses=NO;
    animation2.duration=3.0;
    animation2.repeatCount=NSIntegerMax;
    animation2.removedOnCompletion=NO;
    animation2.fillMode=kCAFillModeForwards;
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    group.animations=@[animation,animation2];
    group.duration=3.0;
    group.repeatCount=NSIntegerMax;
    group.removedOnCompletion=NO;
    group.fillMode=kCAFillModeForwards;
    group.beginTime = CACurrentMediaTime() + beginTime;
    [layer addAnimation:group forKey:@""];
}

- (void)keyframeAniamtionWithCp1x:(CGFloat)firstX cp1y:(CGFloat)firstY cp2x:(CGFloat)secondX cp2y:(CGFloat)secondY endPointX:(float)endPointX endPointY:(float)endPointY WithBeginTime:(float)beginTime layer:(CALayer *)layer{//路径动画
    CGMutablePathRef fillPath = CGPathCreateMutable();
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSPoint endPoint = NSMakePoint(endPointX, endPointY);
    CGPathMoveToPoint(fillPath, NULL, firstX, firstY);
    CGPathAddCurveToPoint(fillPath, NULL, firstX, firstY, secondX, secondY, endPoint.x, endPoint.y);
    animation.path = fillPath;
    animation.duration = 3.0;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.repeatCount = NSIntegerMax;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    CGPathRelease(fillPath);
    [animation setValue:[NSValue valueWithPoint:endPoint] forKey:@"KCKeyframeAnimationProperty_EndPosition"];
    
    CABasicAnimation *animation2=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue=[NSNumber numberWithFloat:1.0];
    animation2.toValue=[NSNumber numberWithFloat:0.0];
    animation2.autoreverses=NO;
    animation2.duration=3.0;
    animation2.repeatCount=NSIntegerMax;
    animation2.removedOnCompletion=NO;
    animation2.fillMode=kCAFillModeForwards;
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    group.animations=@[animation,animation2];
    group.duration=3.0;
    group.repeatCount=NSIntegerMax;
    group.removedOnCompletion=NO;
    group.fillMode=kCAFillModeForwards;
    group.beginTime = CACurrentMediaTime() + beginTime;
    
    [layer addAnimation:group forKey:@""];
}

#pragma backUp动画
- (void)initBackupAnimationView {
    _backUpLayer = [[CALayer alloc] init];
    NSImage *image1 = [StringHelper imageNamed:@"box_backupoutline"];
    _backUpLayer.contents = image1;
    [_backUpLayer setFrame:CGRectMake((_backUpView.frame.size.width - image1.size.width) / 2.0, (_backUpView.frame.size.height - 6 - image1.size.height) / 2.0, image1.size.width, image1.size.height)];
    [_backUpView.layer addSublayer:_backUpLayer];
    CAAnimation *animation = [IMBAnimation rotation:NSIntegerMax toValue:[NSNumber numberWithFloat:2 *M_PI] durTimes:3];
    [_backUpLayer setAnchorPoint:NSMakePoint(0.5, 0.5)];
    [_backUpLayer addAnimation:animation forKey:@""];

    NSImage *image2 = [StringHelper imageNamed:@"box_backupin"];
    NSImageView *imageView2 = [[NSImageView alloc] initWithFrame:NSMakeRect((_backUpView.frame.size.width - image2.size.width) / 2.0, (_backUpView.frame.size.height - 6 - image2.size.height) / 2.0, image2.size.width, image2.size.height)];
    [imageView2 setImage:image2];
    [_backUpView addSubview:imageView2];
    [imageView2 release], imageView2 = nil;
    
    _backUpLayer1 = [[CALayer alloc] init];
    NSImage *textImage = [StringHelper imageNamed:@"box_backutext"];
    _backUpLayer1.contents = textImage;
    [_backUpLayer1 setFrame:CGRectMake(-64, 10, textImage.size.width, textImage.size.height)];
    _backUpLayer1.opacity = 0.5;
    [_backUpView.layer addSublayer:_backUpLayer1];
    CAAnimation *animation1 = [IMBAnimation moveX:5.0 fromX:@-40 toX:@300 repeatCount:NSIntegerMax beginTime:0.0f];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_backUpLayer1 addAnimation:animation1 forKey:@""];
    
    _backUpLayer2 = [[CALayer alloc] init];
    _backUpLayer2.contents = textImage;
    [_backUpLayer2 setFrame:CGRectMake(-64, 30, textImage.size.width, textImage.size.height)];
    _backUpLayer2.opacity = 0.5;
    [_backUpView.layer addSublayer:_backUpLayer2];
    CAAnimation *animation2 = [IMBAnimation moveX:5.0 fromX:@-40 toX:@300 repeatCount:NSIntegerMax beginTime:0.9];
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_backUpLayer2 addAnimation:animation2 forKey:@""];
    
    _backUpLayer3 = [[CALayer alloc] init];
    _backUpLayer3.contents = textImage;
    [_backUpLayer3 setFrame:CGRectMake(-64, 50, textImage.size.width, textImage.size.height)];
    _backUpLayer3.opacity = 0.5;
    [_backUpView.layer addSublayer:_backUpLayer3];
    CAAnimation *animation3 = [IMBAnimation moveX:5.0 fromX:@-40 toX:@300 repeatCount:NSIntegerMax beginTime:0.3];
    animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_backUpLayer3 addAnimation:animation3 forKey:@""];
    
    _backUpLayer4 = [[CALayer alloc] init];
    _backUpLayer4.contents = textImage;
    [_backUpLayer4 setFrame:CGRectMake(-64, 70, textImage.size.width, textImage.size.height)];
    _backUpLayer4.opacity = 0.5;
    [_backUpView.layer addSublayer:_backUpLayer4];
    CAAnimation *animation4 = [IMBAnimation moveX:5.0 fromX:@-40 toX:@300 repeatCount:NSIntegerMax beginTime:0.5];
    animation4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_backUpLayer4 addAnimation:animation4 forKey:@""];
    
    _backUpLayer5 = [[CALayer alloc] init];
    _backUpLayer5.contents = textImage;
    [_backUpLayer5 setFrame:CGRectMake(-64, 10, textImage.size.width, textImage.size.height)];
    _backUpLayer5.opacity = 0.5;
    [_backUpView.layer addSublayer:_backUpLayer5];
    CAAnimation *animation5 = [IMBAnimation moveX:5.0 fromX:@-40 toX:@300 repeatCount:NSIntegerMax beginTime:2.0f];
    animation5.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_backUpLayer5 addAnimation:animation5 forKey:@""];
    
    _backUpLayer6 = [[CALayer alloc] init];
    _backUpLayer6.contents = textImage;
    [_backUpLayer6 setFrame:CGRectMake(-64, 30, textImage.size.width, textImage.size.height)];
    _backUpLayer6.opacity = 0.5;
    [_backUpView.layer addSublayer:_backUpLayer6];
    CAAnimation *animation6 = [IMBAnimation moveX:5.0 fromX:@-40 toX:@300 repeatCount:NSIntegerMax beginTime:2.5];
    animation6.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_backUpLayer6 addAnimation:animation6 forKey:@""];
    
    _backUpLayer7 = [[CALayer alloc] init];
    _backUpLayer7.contents = textImage;
    [_backUpLayer7 setFrame:CGRectMake(-64, 50, textImage.size.width, textImage.size.height)];
    _backUpLayer7.opacity = 0.5;
    [_backUpView.layer addSublayer:_backUpLayer7];
    CAAnimation *animation7 = [IMBAnimation moveX:5.0 fromX:@-40 toX:@300 repeatCount:NSIntegerMax beginTime:2.3];
    animation7.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_backUpLayer7 addAnimation:animation7 forKey:@""];
    
    _backUpLayer8 = [[CALayer alloc] init];
    _backUpLayer8.contents = textImage;
    [_backUpLayer8 setFrame:CGRectMake(-64, 70, textImage.size.width, textImage.size.height)];
    _backUpLayer8.opacity = 0.5;
    [_backUpView.layer addSublayer:_backUpLayer8];
    CAAnimation *animation8 = [IMBAnimation moveX:5.0 fromX:@-40 toX:@300 repeatCount:NSIntegerMax beginTime:1.9];
    animation8.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_backUpLayer8 addAnimation:animation8 forKey:@""];
    
    _backUpLayer9 = [[CALayer alloc] init];
    _backUpLayer9.contents = textImage;
    [_backUpLayer9 setFrame:CGRectMake(-64, 10, textImage.size.width, textImage.size.height)];
    _backUpLayer9.opacity = 0.5;
    [_backUpView.layer addSublayer:_backUpLayer9];
    CAAnimation *animation9 = [IMBAnimation moveX:5.0 fromX:@-40 toX:@300 repeatCount:NSIntegerMax beginTime:4.0];
    animation9.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_backUpLayer9 addAnimation:animation9 forKey:@""];
    
    _backUpLayer10 = [[CALayer alloc] init];
    _backUpLayer10.contents = textImage;
    [_backUpLayer10 setFrame:CGRectMake(-64, 30, textImage.size.width, textImage.size.height)];
    _backUpLayer10.opacity = 0.5;
    [_backUpView.layer addSublayer:_backUpLayer10];
    CAAnimation *animation10 = [IMBAnimation moveX:5.0 fromX:@-40 toX:@300 repeatCount:NSIntegerMax beginTime:3.6];
    animation10.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_backUpLayer10 addAnimation:animation10 forKey:@""];
    
    _backUpLayer11 = [[CALayer alloc] init];
    _backUpLayer11.contents = textImage;
    [_backUpLayer11 setFrame:CGRectMake(-64, 50, textImage.size.width, textImage.size.height)];
    _backUpLayer11.opacity = 0.5;
    [_backUpView.layer addSublayer:_backUpLayer11];
    CAAnimation *animation11 = [IMBAnimation moveX:5.0 fromX:@-40 toX:@300 repeatCount:NSIntegerMax beginTime:3.8];
    animation11.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_backUpLayer11 addAnimation:animation11 forKey:@""];
    
    _backUpLayer12 = [[CALayer alloc] init];
    _backUpLayer12.contents = textImage;
    [_backUpLayer12 setFrame:CGRectMake(-64, 70, textImage.size.width, textImage.size.height)];
    _backUpLayer12.opacity = 0.5;
    [_backUpView.layer addSublayer:_backUpLayer12];
    CAAnimation *animation12 = [IMBAnimation moveX:5.0 fromX:@-40 toX:@300 repeatCount:NSIntegerMax beginTime:4.2];
    animation12.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_backUpLayer12 addAnimation:animation12 forKey:@""];
    
}

#pragma iCloud动画
- (void)initiCloudAnimationView {
    _iCloudLayer1 = [[CALayer alloc] init];
    NSImage *icloudImage1 = [StringHelper imageNamed:@"box_icloudbg2"];
    _iCloudLayer1.contents = icloudImage1;
    [_iCloudLayer1 setFrame:CGRectMake(-54, 10, icloudImage1.size.width, icloudImage1.size.height)];
    [_iCloudView.layer addSublayer:_iCloudLayer1];
    CAAnimation *animation1 = [IMBAnimation moveX:5.0 fromX:@0 toX:@300 repeatCount:NSIntegerMax beginTime:0.0];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_iCloudLayer1 addAnimation:animation1 forKey:@""];
    
    _iCloudLayer2 = [[CALayer alloc] init];
    NSImage *icloudImage2 = [StringHelper imageNamed:@"box_icloudbg3"];
    _iCloudLayer2.contents = icloudImage2;
    [_iCloudLayer2 setFrame:CGRectMake(-42, 25, icloudImage2.size.width, icloudImage2.size.height)];
    [_iCloudView.layer addSublayer:_iCloudLayer2];
    CAAnimation *animation2 = [IMBAnimation moveX:5.0 fromX:@0 toX:@300 repeatCount:NSIntegerMax beginTime:2.5];
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_iCloudLayer2 addAnimation:animation2 forKey:@""];
    
    _iCloudLayer3 = [[CALayer alloc] init];
    NSImage *icloudImage3 = [StringHelper imageNamed:@"box_icloudbg4"];
    _iCloudLayer3.contents = icloudImage3;
    [_iCloudLayer3 setFrame:CGRectMake(-36, 40, icloudImage3.size.width, icloudImage3.size.height)];
    [_iCloudView.layer addSublayer:_iCloudLayer3];
    CAAnimation *animation3 = [IMBAnimation moveX:5.0 fromX:@0 toX:@300 repeatCount:NSIntegerMax beginTime:1.1];
    animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_iCloudLayer3 addAnimation:animation3 forKey:@""];
    
    _iCloudLayer4 = [[CALayer alloc] init];
    NSImage *icloudImage4= [StringHelper imageNamed:@"box_icloudbg5"];
    _iCloudLayer4.contents = icloudImage4;
    [_iCloudLayer4 setFrame:CGRectMake(-36, 60, icloudImage4.size.width, icloudImage4.size.height)];
    [_iCloudView.layer addSublayer:_iCloudLayer4];
    CAAnimation *animation4 = [IMBAnimation moveX:5.0 fromX:@0 toX:@300 repeatCount:NSIntegerMax beginTime:4.0];
    animation4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_iCloudLayer4 addAnimation:animation4 forKey:@""];
    
    NSImage *image1 = [StringHelper imageNamed:@"box_icloudbg"];
    NSImageView *imageView1 = [[NSImageView alloc] initWithFrame:NSMakeRect((_backUpView.frame.size.width - image1.size.width) / 2.0, (_backUpView.frame.size.height - 6 - image1.size.height) / 2.0 - 2, image1.size.width, image1.size.height)];
    [imageView1 setImage:image1];
    [_iCloudView addSubview:imageView1];
    [imageView1 release], imageView1 = nil;
}

- (void)keyframeAniamtionWithEllipseRect:(NSRect)ellip WithBeginTime:(float)beginTime layer:(CALayer *)layer{//路径动画
    CGMutablePathRef fillPath = CGPathCreateMutable();
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPathAddEllipseInRect(fillPath, NULL, ellip);
    animation.path = fillPath;
    animation.duration = 10.0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = NSIntegerMax;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    CGPathRelease(fillPath);
    animation.calculationMode = kCAAnimationCubicPaced;
    animation.beginTime = CACurrentMediaTime() + beginTime;
    [layer addAnimation:animation forKey:@""];
}

#pragma device动画
- (void)initDeviceAnimationView {
    _deviceSubLayer1 = [[CALayer alloc] init];
    NSImage *iConImage1 = [StringHelper imageNamed:@"box_deviceicon1"];
    _deviceSubLayer1.contents = iConImage1;
    _deviceSubLayer1.frame = NSMakeRect(-30, 5, iConImage1.size.width, iConImage1.size.height);
    [_deviceView.layer addSublayer:_deviceSubLayer1];
    CAAnimation *animation1 = [IMBAnimation moveX:3.0 fromX:@0 toX:@120 repeatCount:NSIntegerMax beginTime:0.0];
     animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_deviceSubLayer1 addAnimation:animation1 forKey:@""];
    
    _deviceSubLayer2 = [[CALayer alloc] init];
    NSImage *iConImage2 = [StringHelper imageNamed:@"box_deviceicon2"];
    _deviceSubLayer2.contents = iConImage2;
    _deviceSubLayer2.frame = NSMakeRect(-30, 25, iConImage2.size.width, iConImage2.size.height);
    [_deviceView.layer addSublayer:_deviceSubLayer2];
    CAAnimation *animation2 = [IMBAnimation moveX:3.0 fromX:@0 toX:@120 repeatCount:NSIntegerMax beginTime:2.0];
     animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_deviceSubLayer2 addAnimation:animation2 forKey:@""];
    
    _deviceSubLayer3 = [[CALayer alloc] init];
    NSImage *iConImage3 = [StringHelper imageNamed:@"box_deviceicon3"];
    _deviceSubLayer3.contents = iConImage3;
    _deviceSubLayer3.frame = NSMakeRect(-30, 45, iConImage3.size.width, iConImage3.size.height);
    [_deviceView.layer addSublayer:_deviceSubLayer3];
    CAAnimation *animation3 = [IMBAnimation moveX:3.0 fromX:@0 toX:@120 repeatCount:NSIntegerMax beginTime:1.0];
     animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_deviceSubLayer3 addAnimation:animation3 forKey:@""];
    
    _deviceSubLayer4 = [[CALayer alloc] init];
    NSImage *iConImage4 = [StringHelper imageNamed:@"box_deviceicon3"];
    _deviceSubLayer4.contents = iConImage4;
    _deviceSubLayer4.frame = NSMakeRect(-30, 5, iConImage4.size.width, iConImage4.size.height);
    [_deviceView.layer addSublayer:_deviceSubLayer4];
    CAAnimation *animation4 = [IMBAnimation moveX:3.0 fromX:@240 toX:@120 repeatCount:NSIntegerMax beginTime:1.0];
     animation4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_deviceSubLayer4 addAnimation:animation4 forKey:@""];
    
    _deviceSubLayer5 = [[CALayer alloc] init];
    NSImage *iConImage5 = [StringHelper imageNamed:@"box_deviceicon1"];
    _deviceSubLayer5.contents = iConImage5;
    _deviceSubLayer5.frame = NSMakeRect(-30, 25, iConImage5.size.width, iConImage5.size.height);
    [_deviceView.layer addSublayer:_deviceSubLayer5];
    CAAnimation *animation5 = [IMBAnimation moveX:3.0 fromX:@240 toX:@120 repeatCount:NSIntegerMax beginTime:0.0];
     animation5.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_deviceSubLayer5 addAnimation:animation5 forKey:@""];

    _deviceSubLayer6 = [[CALayer alloc] init];
    NSImage *iConImage6 = [StringHelper imageNamed:@"box_deviceicon2"];
    _deviceSubLayer6.contents = iConImage6;
    _deviceSubLayer6.frame = NSMakeRect(-30, 45, iConImage6.size.width, iConImage6.size.height);
    [_deviceView.layer addSublayer:_deviceSubLayer6];
    CAAnimation *animation6 = [IMBAnimation moveX:3.0 fromX:@240 toX:@120 repeatCount:NSIntegerMax beginTime:2.0];
     animation6.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_deviceSubLayer6 addAnimation:animation6 forKey:@""];

    _deviceLayer = [[CALayer alloc] init];
    NSImage *image = [StringHelper imageNamed:@"box_device1"];
    _deviceLayer.contents = image;
    [_deviceLayer setFrame:NSMakeRect((_deviceView.frame.size.width - image.size.width)/2.0, 0, image.size.width, image.size.height)];
    [_deviceView.layer addSublayer:_deviceLayer];
    _timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(changeImageView) userInfo:nil repeats:YES];
    count = 0;
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)changeImageView {
    if (count == 0) {
        _deviceLayer.contents = [StringHelper imageNamed:@"box_device1"];
        count = 1;
    }else if (count == 1) {
        _deviceLayer.contents = [StringHelper imageNamed:@"box_device2"];
        count = 2;
    }else if (count == 2) {
       _deviceLayer.contents = [StringHelper imageNamed:@"box_device3"];
        count = 0;
    }else {
        count = 0;
    }
}

#pragma downLoad动画
- (void)initDownLoadAnimationView {
    NSImage *image1 = [StringHelper imageNamed:@"box_videoicon"];
    NSImageView *imageView1 = [[NSImageView alloc] initWithFrame:NSMakeRect((_backUpView.frame.size.width - image1.size.width) / 2.0, (_backUpView.frame.size.height - 6 - image1.size.height) / 2.0, image1.size.width, image1.size.height)];
    [imageView1 setImage:image1];
    [_downLoadView addSubview:imageView1];
    [imageView1 release], imageView1 = nil;
    
    _downLoadLayer1 = [[CALayer alloc] init];
    NSImage *textImage = [StringHelper imageNamed:@"box_videodownload1"];
    _downLoadLayer1.contents = textImage;
    [_downLoadLayer1 setFrame:CGRectMake(20, 90, textImage.size.width, textImage.size.height)];
    [_downLoadView.layer addSublayer:_downLoadLayer1];
    CAAnimation *animation1 = [IMBAnimation moveY:2.5 X:@0 Y:@-120 repeatCount:NSIntegerMax beginTime:0.0 isAutoreverses:NO];
    [_downLoadLayer1 addAnimation:animation1 forKey:@""];
    
    _downLoadLayer2 = [[CALayer alloc] init];
    NSImage *textImage2 = [StringHelper imageNamed:@"box_videodownload2"];
    _downLoadLayer2.contents = textImage2;
    [_downLoadLayer2 setFrame:CGRectMake(45, 90, textImage2.size.width, textImage2.size.height)];
    [_downLoadView.layer addSublayer:_downLoadLayer2];
    CAAnimation *animation2 = [IMBAnimation moveY:2.5 X:@0 Y:@-120 repeatCount:NSIntegerMax beginTime:1.5 isAutoreverses:NO];
    [_downLoadLayer2 addAnimation:animation2 forKey:@""];
    
    _downLoadLayer3 = [[CALayer alloc] init];
    NSImage *textImage3 = [StringHelper imageNamed:@"box_videodownload2"];
    _downLoadLayer3.contents = textImage3;
    [_downLoadLayer3 setFrame:CGRectMake(146, 90, textImage3.size.width, textImage3.size.height)];
    [_downLoadView.layer addSublayer:_downLoadLayer3];
    CAAnimation *animation3 = [IMBAnimation moveY:2.5 X:@0 Y:@-120 repeatCount:NSIntegerMax beginTime:2.0 isAutoreverses:NO];
    [_downLoadLayer3 addAnimation:animation3 forKey:@""];
    
    _downLoadLayer4 = [[CALayer alloc] init];
    NSImage *textImage4 = [StringHelper imageNamed:@"box_videodownload3"];
    _downLoadLayer4.contents = textImage4;
    [_downLoadLayer4 setFrame:CGRectMake(174, 90, textImage4.size.width, textImage4.size.height)];
    [_downLoadView.layer addSublayer:_downLoadLayer4];
    CAAnimation *animation4 = [IMBAnimation moveY:2.5 X:@0 Y:@-120 repeatCount:NSIntegerMax beginTime:0.5 isAutoreverses:NO];
    [_downLoadLayer4 addAnimation:animation4 forKey:@""];
}

#pragma toiOS动画
- (void)initToiOSAnimationView {
    _toiOSLayer1 = [[CALayer alloc] init];
    NSImage *iConImage1 = [StringHelper imageNamed:@"box_toios_icon1"];
    _toiOSLayer1.contents = iConImage1;
    _toiOSLayer1.frame = NSMakeRect(48, 5, iConImage1.size.width, iConImage1.size.height);
    [_toiOSView.layer addSublayer:_toiOSLayer1];
    CAAnimation *animation1 = [IMBAnimation moveX:2.5 fromX:@0 toX:@124 repeatCount:NSIntegerMax beginTime:0.0];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_toiOSLayer1 addAnimation:animation1 forKey:@""];
    
    _toiOSLayer2 = [[CALayer alloc] init];
    NSImage *iConImage2 = [StringHelper imageNamed:@"box_toios_icon2"];
    _toiOSLayer2.contents = iConImage2;
    _toiOSLayer2.frame = NSMakeRect(0, 5, iConImage2.size.width, iConImage2.size.height);
    [_toiOSView.layer addSublayer:_toiOSLayer2];
    CAAnimation *animation2 = [IMBAnimation moveX:2.0 fromX:@0 toX:@124 repeatCount:NSIntegerMax beginTime:0.0];
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_toiOSLayer2 addAnimation:animation2 forKey:@""];
    
    _toiOSLayer3 = [[CALayer alloc] init];
    _toiOSLayer3.contents = iConImage1;
    _toiOSLayer3.frame = NSMakeRect(48, 20, iConImage1.size.width, iConImage1.size.height);
    [_toiOSView.layer addSublayer:_toiOSLayer3];
    CAAnimation *animation3 = [IMBAnimation moveX:2.5 fromX:@0 toX:@124 repeatCount:NSIntegerMax beginTime:1.8];
    animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_toiOSLayer3 addAnimation:animation3 forKey:@""];
    _toiOSLayer4 = [[CALayer alloc] init];
    _toiOSLayer4.contents = iConImage2;
    _toiOSLayer4.frame = NSMakeRect(0, 22, iConImage2.size.width, iConImage2.size.height);
    [_toiOSView.layer addSublayer:_toiOSLayer4];
    CAAnimation *animation4 = [IMBAnimation moveX:2.0 fromX:@0 toX:@124 repeatCount:NSIntegerMax beginTime:1.4];
    animation4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_toiOSLayer4 addAnimation:animation4 forKey:@""];
    
    _toiOSLayer5 = [[CALayer alloc] init];
    _toiOSLayer5.contents = iConImage1;
    _toiOSLayer5.frame = NSMakeRect(48, 36, iConImage1.size.width, iConImage1.size.height);
    [_toiOSView.layer addSublayer:_toiOSLayer5];
    CAAnimation *animation5 = [IMBAnimation moveX:2.5 fromX:@0 toX:@124 repeatCount:NSIntegerMax beginTime:0.9];
    animation5.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_toiOSLayer5 addAnimation:animation5 forKey:@""];
    
    _toiOSLayer6 = [[CALayer alloc] init];
    _toiOSLayer6.contents = iConImage2;
    _toiOSLayer6.frame = NSMakeRect(0, 32, iConImage2.size.width, iConImage2.size.height);
    [_toiOSView.layer addSublayer:_toiOSLayer6];
    CAAnimation *animation6 = [IMBAnimation moveX:2.0 fromX:@0 toX:@124 repeatCount:NSIntegerMax beginTime:0.7];
    animation6.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_toiOSLayer6 addAnimation:animation6 forKey:@""];
    
    _androidLayer = [[CALayer alloc] init];
    NSImage *androidImage = [StringHelper imageNamed:@"box_toios_android"];
    _androidLayer.contents = androidImage;
    [_androidLayer setFrame:NSMakeRect(16, 0, androidImage.size.width, androidImage.size.height)];
    [_toiOSView.layer addSublayer:_androidLayer];
    
    _iOSLayer = [[CALayer alloc] init];
    NSImage *iOSImage = [StringHelper imageNamed:@"box_toios_ios"];
    _iOSLayer.contents = iOSImage;
    [_iOSLayer setFrame:NSMakeRect(140, 0, iOSImage.size.width, iOSImage.size.height)];
    [_toiOSView.layer addSublayer:_iOSLayer];
}

#pragma skin动画 
- (void)initSkinAnimationView {
    _skinTimer = [NSTimer timerWithTimeInterval:4 *(SKIN_CHANGE_INTEVAL + 1.0) target:self selector:@selector(changeSkinAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_skinTimer forMode:NSRunLoopCommonModes];
    [_skinTimer fire];
    _skinLayer1 = [[CALayer alloc] init];
    NSImage *image3 = [StringHelper imageNamed:@"box_skin"];
    [_skinLayer1 setFrame:NSMakeRect(36, 17, image3.size.width, image3.size.height)];
    _skinLayer1.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(0.3, 0.3));
    _skinLayer1.opacity = 0.0;
    _skinLayer1.contents = image3;
    [_skinView.layer addSublayer:_skinLayer1];
//
    _skinLayer2 = [[CALayer alloc] init];
    NSImage *image1 = [StringHelper imageNamed:@"box_skin2"];
    _skinLayer2.contents = image1;
    [_skinLayer2 setFrame:NSMakeRect(16, 17, image1.size.width, image1.size.height)];
    _skinLayer2.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(0.7, 0.7));
    _skinLayer2.opacity = 0.7;
    [_skinView.layer addSublayer:_skinLayer2];
////
    _skinLayer3 = [[CALayer alloc] init];
    NSImage *image2 = [StringHelper imageNamed:@"box_skin3"];
    _skinLayer3.contents = image2;
    [_skinLayer3 setFrame:NSMakeRect((_skinView.frame.size.width - image2.size.width) / 2.0 , (_skinView.frame.size.height - 6 - image2.size.height) / 2.0, image2.size.width, image2.size.height)];
    [_skinView.layer addSublayer:_skinLayer3];
//    //
    _skinLayer4 = [[CALayer alloc] init];
    [_skinLayer4 setFrame:NSMakeRect(138, 17, image3.size.width, image3.size.height)];
     NSImage *image4 = [StringHelper imageNamed:@"box_skin4"];
    _skinLayer4.contents = image4;
    _skinLayer4.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(0.7, 0.7));
    _skinLayer4.opacity = 0.7;
    [_skinView.layer addSublayer:_skinLayer4];
}

#pragma mark - airBackup动画
- (void)initAirBackupAnimationView {
    _airBackupLayer1 = [[CALayer alloc] init];
    NSImage *backupCircleImage = [StringHelper imageNamed:@"nav_aircircle"];
    _airBackupLayer1.contents = backupCircleImage;
    [_airBackupLayer1 setFrame:CGRectMake((_airBackupView.frame.size.width - backupCircleImage.size.width) / 2.0, (_airBackupView.frame.size.height  - 6 - backupCircleImage.size.height) / 2.0, backupCircleImage.size.width, backupCircleImage.size.height)];
    
    //转圈
    CABasicAnimation *rotationAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @0;
    rotationAnimation.toValue = @(2 * M_PI);
    rotationAnimation.duration = 3.0;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode=kCAFillModeForwards;
    rotationAnimation.repeatCount = NSIntegerMax;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_airBackupLayer1 addAnimation:rotationAnimation forKey:@""];
    [_airBackupView.layer addSublayer:_airBackupLayer1];
    
    _airBackupLayer2 = [[CALayer alloc] init];
    NSImage *wifiImage = [StringHelper imageNamed:@"nav_airwifi4"];
    _airBackupLayer2.contents = wifiImage;
    [_airBackupLayer2 setFrame:CGRectMake((_airBackupView.frame.size.width - wifiImage.size.width) / 2.0, (_airBackupView.frame.size.height - 6 - wifiImage.size.height) / 2.0, wifiImage.size.width, wifiImage.size.height)];
    _airCount = 1;
//    _airBackupTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeWifiImage) userInfo:nil repeats:YES];
    [_airBackupView.layer addSublayer:_airBackupLayer2];
    
    _airBackupLayer3 = [[CALayer alloc] init];
    NSImage *image3 = [StringHelper imageNamed:@"nav_aircircle_s6"];
    _airBackupLayer3.contents = image3;
    [_airBackupLayer3 setFrame:CGRectMake(_airBackupView.frame.size.width + image3.size.width, (_airBackupView.frame.size.height  - 6) - 10, image3.size.width, image3.size.height)];
    [_airBackupView.layer addSublayer:_airBackupLayer3];
    [self keyframeAniamtionWithCp1x:_airBackupView.frame.size.width + image3.size.width cp1y:(_airBackupView.frame.size.height  - 6) - 10 cp2x:_airBackupView.frame.size.width / 2.0 + 10 cp2y:(_airBackupView.frame.size.height - 6) / 2.0 + 6 endPointX:_airBackupView.frame.size.width / 2.0  endPointY: (_airBackupView.frame.size.height - 6) / 2.0 WithBeginTime:0.4f layer:_airBackupLayer3];
    
    _airBackupLayer4 = [[CALayer alloc] init];
    NSImage *image4 = [StringHelper imageNamed:@"nav_aircircle_s3"];
    _airBackupLayer4.contents = image4;
    [_airBackupLayer4 setFrame:CGRectMake(-image4.size.width, (_airBackupView.frame.size.height  - 6) - 10, image4.size.width, image4.size.height)];
    [_airBackupView.layer addSublayer:_airBackupLayer4];
    [self keyframeAniamtionWithCp1x:-image4.size.width cp1y: (_airBackupView.frame.size.height  - 6) - 10 cp2x: 20 cp2y:(_airBackupView.frame.size.height - 6) / 2.0 + 10 endPointX:_airBackupView.frame.size.width / 2.0  endPointY: (_airBackupView.frame.size.height - 6) / 2.0 WithBeginTime:0.8f layer:_airBackupLayer4];
    
    
    _airBackupLayer5 = [[CALayer alloc] init];
    NSImage *image5 = [StringHelper imageNamed:@"nav_aircircle_s2"];
    _airBackupLayer5.contents = image5;
    [_airBackupLayer5 setFrame:CGRectMake(-image5.size.width, 10, image5.size.width, image5.size.height)];
    [_airBackupView.layer addSublayer:_airBackupLayer5];
    [self keyframeAniamtionWithCp1x:-image5.size.width cp1y: + 10 cp2x: 20 cp2y:(_airBackupView.frame.size.height - 6) / 2.0 - 10 endPointX:_airBackupView.frame.size.width / 2.0  endPointY: (_airBackupView.frame.size.height - 6) / 2.0 WithBeginTime:1.6f layer:_airBackupLayer5];
    
    _airBackupLayer6 = [[CALayer alloc] init];
    NSImage *image6 = [StringHelper imageNamed:@"nav_aircircle_s5"];
    _airBackupLayer6.contents = image6;
    [_airBackupLayer6 setFrame:CGRectMake(_airBackupView.frame.size.width + image6.size.width, 10, image6.size.width, image6.size.height)];
    [_airBackupView.layer addSublayer:_airBackupLayer6];
    [self keyframeAniamtionWithCp1x:_airBackupView.frame.size.width + image6.size.width cp1y:10 cp2x:_airBackupView.frame.size.width / 2.0 - 10 cp2y:(_airBackupView.frame.size.height - 6) / 2.0 + 6 endPointX:_airBackupView.frame.size.width / 2.0  endPointY: (_airBackupView.frame.size.height - 6) / 2.0 WithBeginTime:2.4 layer:_airBackupLayer6];
    
    _airBackupLayer7 = [[CALayer alloc] init];
    NSImage *image7 = [StringHelper imageNamed:@"nav_aircircle_s1"];
    _airBackupLayer7.contents = image7;
    [_airBackupLayer7 setFrame:CGRectMake(_airBackupView.frame.size.width + image7.size.width, (_airBackupView.frame.size.height -6)/2.0, image7.size.width, image7.size.height)];
    [_airBackupView.layer addSublayer:_airBackupLayer7];
    [self keyframeAniamtionWithCp1x:_airBackupView.frame.size.width + image7.size.width cp1y:(_airBackupView.frame.size.height -6)/2.0 cp2x:_airBackupView.frame.size.width / 2.0 + 20 cp2y:(_airBackupView.frame.size.height - 6) / 2.0 + 6 endPointX:_airBackupView.frame.size.width / 2.0  endPointY: (_airBackupView.frame.size.height - 6) / 2.0 WithBeginTime:1.0 layer:_airBackupLayer7];
    
    _airBackupLayer8 = [[CALayer alloc] init];
    NSImage *image8 = [StringHelper imageNamed:@"nav_aircircle_s1"];
    _airBackupLayer8.contents = image8;
    [_airBackupLayer8 setFrame:CGRectMake(-image8.size.width, (_airBackupView.frame.size.height -6)/2.0, image8.size.width, image8.size.height)];
    [_airBackupView.layer addSublayer:_airBackupLayer8];
    [self keyframeAniamtionWithCp1x:-image8.size.width cp1y:(_airBackupView.frame.size.height -6)/2.0 cp2x:20 cp2y:(_airBackupView.frame.size.height - 6) / 2.0 + 6 endPointX:_airBackupView.frame.size.width / 2.0  endPointY: (_airBackupView.frame.size.height - 6) / 2.0 WithBeginTime:2.0 layer:_airBackupLayer8];
}

- (void)changeWifiImage {
    NSImage *wifiImage = nil;
    if (_airCount == 1) {
        wifiImage = [StringHelper imageNamed:@"nav_airwifi1"];
    }else if (_airCount == 2) {
        wifiImage = [StringHelper imageNamed:@"nav_airwifi2"];
    }else if (_airCount == 3) {
        wifiImage = [StringHelper imageNamed:@"nav_airwifi3"];
    }else if (_airCount == 4) {
        wifiImage = [StringHelper imageNamed:@"nav_airwifi4"];
        _airCount = 0;
    }
    _airBackupLayer2.contents = wifiImage;
    _airCount ++;
}

- (CABasicAnimation *)moveXWithDuraTime:(float)duraTime WithStartX:(NSNumber *)start WithEndX:(NSNumber *)end {
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue=start;
    animation.toValue=end;
    animation.duration=duraTime;
    animation.repeatCount = 0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

- (CABasicAnimation *)scaleWithDuraTime:(float)duraTime WithStartX:(float)start WithEndX:(float)end {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(start, start, 1.0)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(end, end, 1.0)];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.duration = duraTime;
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.repeatCount = 0;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    return animation;
}

- (CABasicAnimation *)opacityWithDuraTime:(float)duraTime WithStartOpacity:(NSNumber *)start WithEndOpacity:(NSNumber *)end {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = start;
    animation.toValue = end;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.duration = duraTime;
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.repeatCount = 0;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    return animation;
}

- (void)skinLayerOneAnimation {
    CABasicAnimation *animation11 = [self moveXWithDuraTime:1.0 WithStartX:@0 WithEndX:@-20];
    animation11.beginTime = 0.0;
    CABasicAnimation *animation12 = [self opacityWithDuraTime:1.0 WithStartOpacity:@0 WithEndOpacity:@0.7];
    animation12.beginTime = 0.0f;
    CABasicAnimation *animation13 = [self scaleWithDuraTime:1.0 WithStartX:0.3 WithEndX:0.7];
    animation13.beginTime = 0.0f;
    
    CABasicAnimation *animation21 = [self moveXWithDuraTime:1.0 WithStartX:@-20 WithEndX:@40];
    animation21.beginTime = SKIN_CHANGE_INTEVAL + 1.0;
    CABasicAnimation *animation22 = [self opacityWithDuraTime:1.0 WithStartOpacity:@0.7 WithEndOpacity:@1];
    animation22.beginTime = SKIN_CHANGE_INTEVAL + 1.0;
    CABasicAnimation *animation23 = [self scaleWithDuraTime:1.0 WithStartX:0.7 WithEndX:1];
    animation23.beginTime = SKIN_CHANGE_INTEVAL + 1.0;
    
    CABasicAnimation *animation31 = [self moveXWithDuraTime:1.0 WithStartX:@40 WithEndX:@101];
    animation31.beginTime = 2 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation32 = [self opacityWithDuraTime:1.0 WithStartOpacity:@1 WithEndOpacity:@0.7];
    animation32.beginTime = 2 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation33 = [self scaleWithDuraTime:1.0 WithStartX:1 WithEndX:0.7];
    animation33.beginTime = 2 *(SKIN_CHANGE_INTEVAL + 1.0);
    
    CABasicAnimation *animation41 = [self moveXWithDuraTime:1.0 WithStartX:@101 WithEndX:@80];
    animation41.beginTime = 3 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation42 = [self opacityWithDuraTime:1.0 WithStartOpacity:@0.7 WithEndOpacity:@0];
    animation42.beginTime = 3 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation43 = [self scaleWithDuraTime:1.0 WithStartX:0.7 WithEndX:0.3];
    animation43.beginTime = 3 *(SKIN_CHANGE_INTEVAL + 1.0);
    
    CAAnimationGroup *group1 = [CAAnimationGroup animation];
    group1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group1.duration = 4 *(SKIN_CHANGE_INTEVAL + 1.0);
    group1.autoreverses = NO;
    group1.removedOnCompletion = NO;
    group1.repeatCount = 0;
    group1.fillMode = kCAFillModeForwards;
    group1.beginTime = 0.0;
    group1.animations = [NSArray arrayWithObjects:animation11,animation12,animation13,animation21,animation22,animation23,animation31,animation32,animation33,animation41,animation42,animation43,nil];
    [_skinLayer1 addAnimation:group1 forKey:@""];
}

- (void)skinLayerTwoAnimation {
    CABasicAnimation *animation21 = [self moveXWithDuraTime:1.0 WithStartX:@0 WithEndX:@61];
    animation21.beginTime = 0.0;
    CABasicAnimation *animation22 = [self opacityWithDuraTime:1.0 WithStartOpacity:@0.7 WithEndOpacity:@1];
    animation22.beginTime = 0.0;
    CABasicAnimation *animation23 = [self scaleWithDuraTime:1.0 WithStartX:0.7 WithEndX:1];
    animation23.beginTime = 0.0;
    
    CABasicAnimation *animation31 = [self moveXWithDuraTime:1.0 WithStartX:@61 WithEndX:@121];
    animation31.beginTime = 1 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation32 = [self opacityWithDuraTime:1.0 WithStartOpacity:@1 WithEndOpacity:@0.7];
    animation32.beginTime = 1 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation33 = [self scaleWithDuraTime:1.0 WithStartX:1 WithEndX:0.7];
    animation33.beginTime = 1 *(SKIN_CHANGE_INTEVAL + 1.0);
    
    CABasicAnimation *animation41 = [self moveXWithDuraTime:1.0 WithStartX:@121 WithEndX:@100];
    animation41.beginTime = 2 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation42 = [self opacityWithDuraTime:1.0 WithStartOpacity:@0.7 WithEndOpacity:@0];
    animation42.beginTime = 2 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation43 = [self scaleWithDuraTime:1.0 WithStartX:0.7 WithEndX:0.3];
    animation43.beginTime = 2 *(SKIN_CHANGE_INTEVAL + 1.0);
    
    CABasicAnimation *animation11 = [self moveXWithDuraTime:1.0 WithStartX:@20 WithEndX:@0];
    animation11.beginTime = 3 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation12 = [self opacityWithDuraTime:1.0 WithStartOpacity:@0 WithEndOpacity:@0.7];
    animation12.beginTime = 3 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation13 = [self scaleWithDuraTime:1.0 WithStartX:0.3 WithEndX:0.7];
    animation13.beginTime = 3 *(SKIN_CHANGE_INTEVAL + 1.0);
    
    CAAnimationGroup *group1 = [CAAnimationGroup animation];
    group1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group1.duration = 4 *(SKIN_CHANGE_INTEVAL + 1.0);
    group1.autoreverses = NO;
    group1.removedOnCompletion = NO;
    group1.repeatCount = 0;
    group1.fillMode = kCAFillModeForwards;
    group1.beginTime = 0.0;
    group1.animations = [NSArray arrayWithObjects:animation21,animation22,animation23,animation31,animation32,animation33,animation41,animation42,animation43,animation11,animation12,animation13,nil];
    [_skinLayer2 addAnimation:group1 forKey:@""];
}

- (void)skinLayerThreeAnimation {
    CABasicAnimation *animation31 = [self moveXWithDuraTime:1.0 WithStartX:@0 WithEndX:@60];
    animation31.beginTime = 0;
    CABasicAnimation *animation32 = [self opacityWithDuraTime:1.0 WithStartOpacity:@1 WithEndOpacity:@0.7];
    animation32.beginTime = 0;
    CABasicAnimation *animation33 = [self scaleWithDuraTime:1.0 WithStartX:1 WithEndX:0.7];
    animation33.beginTime = 0;
    
    CABasicAnimation *animation41 = [self moveXWithDuraTime:1.0 WithStartX:@60 WithEndX:@40];
    animation41.beginTime = 1 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation42 = [self opacityWithDuraTime:1.0 WithStartOpacity:@0.7 WithEndOpacity:@0];
    animation42.beginTime = 1 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation43 = [self scaleWithDuraTime:1.0 WithStartX:0.7 WithEndX:0.3];
    animation43.beginTime = 1 *(SKIN_CHANGE_INTEVAL + 1.0);
    
    CABasicAnimation *animation11 = [self moveXWithDuraTime:1.0 WithStartX:@-40 WithEndX:@-60];
    animation11.beginTime = 2 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation12 = [self opacityWithDuraTime:1.0 WithStartOpacity:@0 WithEndOpacity:@0.7];
    animation12.beginTime = 2 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation13 = [self scaleWithDuraTime:1.0 WithStartX:0.3 WithEndX:0.7];
    animation13.beginTime = 2 *(SKIN_CHANGE_INTEVAL + 1.0);
    
    CABasicAnimation *animation21 = [self moveXWithDuraTime:1.0 WithStartX:@-60 WithEndX:@0];
    animation21.beginTime = 3 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation22 = [self opacityWithDuraTime:1.0 WithStartOpacity:@0.7 WithEndOpacity:@1];
    animation22.beginTime = 3 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation23 = [self scaleWithDuraTime:1.0 WithStartX:0.7 WithEndX:1];
    animation23.beginTime = 3 *(SKIN_CHANGE_INTEVAL + 1.0);
    
    CAAnimationGroup *group1 = [CAAnimationGroup animation];
    group1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group1.duration = 4 *(SKIN_CHANGE_INTEVAL + 1.0);
    group1.autoreverses = NO;
    group1.removedOnCompletion = NO;
    group1.repeatCount = 0;
    group1.fillMode = kCAFillModeForwards;
    group1.beginTime = 0.0;
    group1.animations = [NSArray arrayWithObjects:animation31,animation32,animation33,animation41,animation42,animation43,animation11,animation12,animation13,animation21,animation22,animation23,nil];
    [_skinLayer3 addAnimation:group1 forKey:@""];
}

- (void)skinLayerFourAnimation {
    CABasicAnimation *animation41 = [self moveXWithDuraTime:1.0 WithStartX:@0 WithEndX:@-20];
    animation41.beginTime = 0;
    CABasicAnimation *animation42 = [self opacityWithDuraTime:1.0 WithStartOpacity:@0.7 WithEndOpacity:@0];
    animation42.beginTime = 0;
    CABasicAnimation *animation43 = [self scaleWithDuraTime:1.0 WithStartX:0.7 WithEndX:0.3];
    animation43.beginTime = 0;
    
    CABasicAnimation *animation11 = [self moveXWithDuraTime:1.0 WithStartX:@-100 WithEndX:@-120];
    animation11.beginTime = 1 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation12 = [self opacityWithDuraTime:1.0 WithStartOpacity:@0 WithEndOpacity:@0.7];
    animation12.beginTime = 1 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation13 = [self scaleWithDuraTime:1.0 WithStartX:0.3 WithEndX:0.7];
    animation13.beginTime = 1 *(SKIN_CHANGE_INTEVAL + 1.0);
    
    CABasicAnimation *animation21 = [self moveXWithDuraTime:1.0 WithStartX:@-120 WithEndX:@-60];
    animation21.beginTime = 2 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation22 = [self opacityWithDuraTime:1.0 WithStartOpacity:@0.7 WithEndOpacity:@1];
    animation22.beginTime = 2 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation23 = [self scaleWithDuraTime:1.0 WithStartX:0.7 WithEndX:1];
    animation23.beginTime = 2 *(SKIN_CHANGE_INTEVAL + 1.0);
    
    CABasicAnimation *animation31 = [self moveXWithDuraTime:1.0 WithStartX:@-60 WithEndX:@0];
    animation31.beginTime = 3 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation32 = [self opacityWithDuraTime:1.0 WithStartOpacity:@1 WithEndOpacity:@0.7];
    animation32.beginTime = 3 *(SKIN_CHANGE_INTEVAL + 1.0);
    CABasicAnimation *animation33 = [self scaleWithDuraTime:1.0 WithStartX:1 WithEndX:0.7];
    animation33.beginTime = 3 *(SKIN_CHANGE_INTEVAL + 1.0);
    
    CAAnimationGroup *group1 = [CAAnimationGroup animation];
    group1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group1.duration = 4 *(SKIN_CHANGE_INTEVAL + 1.0);
    group1.autoreverses = NO;
    group1.removedOnCompletion = NO;
    group1.repeatCount = 0;
    group1.fillMode = kCAFillModeForwards;
    group1.beginTime = 0.0;
    group1.animations = [NSArray arrayWithObjects:animation41,animation42,animation43,animation11,animation12,animation13,animation21,animation22,animation23,animation31,animation32,animation33,nil];
    [_skinLayer4 addAnimation:group1 forKey:@""];
}

- (void)changeSkinAnimation {
    [self skinLayerOneAnimation];
    [self skinLayerTwoAnimation];
    [self skinLayerThreeAnimation];
    [self skinLayerFourAnimation];
}

- (void)setIsUP:(BOOL)isUP {
    if (!isUP) {
        [_mainView setIsUP:NO];
//        NSRect oringnFrame = _lable.frame;
//        oringnFrame.origin.y -= 7;
//        [_lable setFrame:oringnFrame];
//        [_lable setNeedsDisplay:YES];
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    
}

- (void)mouseEntered:(NSEvent *)theEvent {
    
}

- (void)dealloc {
    if (_animationView != nil) {
        [_animationView release];
        _animationView = nil;
    }
    if (_shapeLayer1 != nil) {
        [_shapeLayer1 release];
        _shapeLayer1 = nil;
    }
    if (_shapeLayer2 != nil) {
        [_shapeLayer2 release];
        _shapeLayer2 = nil;
    }
    if (_shapeLayer3 != nil) {
        [_shapeLayer3 release];
        _shapeLayer3 = nil;
    }
    if (_layer1 != nil) {
        [_layer1 release];
        _layer1 = nil;
    }
    if (_layer2 != nil) {
        [_layer2 release];
        _layer2 = nil;
    }
    if (_layer3 != nil) {
        [_layer3 release];
        _layer3 = nil;
    }
    
    if (_backUpView != nil) {
        [_backUpView release];
        _backUpView = nil;
    }
    if (_backUpLayer != nil) {
        [_backUpLayer release];
        _backUpLayer = nil;
    }
    if (_backUpLayer1 != nil) {
        [_backUpLayer1 release];
        _backUpLayer1 = nil;
    }
    if (_backUpLayer2 != nil) {
        [_backUpLayer2 release];
        _backUpLayer2 = nil;
    }
    if (_backUpLayer3 != nil) {
        [_backUpLayer3 release];
        _backUpLayer3 = nil;
    }
    if (_backUpLayer4 != nil) {
        [_backUpLayer4 release];
        _backUpLayer4 = nil;
    }
    if (_backUpLayer5 != nil) {
        [_backUpLayer5 release];
        _backUpLayer5 = nil;
    }
    if (_backUpLayer6 != nil) {
        [_backUpLayer6 release];
        _backUpLayer6 = nil;
    }
    if (_backUpLayer7 != nil) {
        [_backUpLayer7 release];
        _backUpLayer7 = nil;
    }
    if (_backUpLayer8 != nil) {
        [_backUpLayer8 release];
        _backUpLayer8 = nil;
    }
    if (_backUpLayer9 != nil) {
        [_backUpLayer9 release];
        _backUpLayer9 = nil;
    }
    if (_backUpLayer10 != nil) {
        [_backUpLayer10 release];
        _backUpLayer10 = nil;
    }
    if (_backUpLayer11 != nil) {
        [_backUpLayer11 release];
        _backUpLayer11 = nil;
    }
    if (_backUpLayer12 != nil) {
        [_backUpLayer12 release];
        _backUpLayer12 = nil;
    }
    
    if (_iCloudView != nil) {
        [_iCloudView release];
        _iCloudView = nil;
    }
    if (_iCloudLayer1 != nil) {
        [_iCloudLayer1 release];
        _iCloudLayer1 = nil;
    }
    if (_iCloudLayer2 != nil) {
        [_iCloudLayer2 release];
        _iCloudLayer2 = nil;
    }
    if (_iCloudLayer3 != nil) {
        [_iCloudLayer3 release];
        _iCloudLayer3 = nil;
    }
    if (_iCloudLayer4 != nil) {
        [_iCloudLayer4 release];
        _iCloudLayer4 = nil;
    }
    
    if (_deviceView != nil) {
        [_deviceView release];
        _deviceView = nil;
    }
    if (_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
    if (_deviceLayer != nil) {
        [_deviceLayer release];
        _deviceLayer = nil;
    }
    if (_deviceSubLayer1 != nil) {
        [_deviceSubLayer1 release];
        _deviceSubLayer1 = nil;
    }
    if (_deviceSubLayer2 != nil) {
        [_deviceSubLayer2 release];
        _deviceSubLayer2 = nil;
    }
    if (_deviceSubLayer3 != nil) {
        [_deviceSubLayer3 release];
        _deviceSubLayer3 = nil;
    }
    if (_deviceSubLayer4 != nil) {
        [_deviceSubLayer4 release];
        _deviceSubLayer4 = nil;
    }
    if (_deviceSubLayer5 != nil) {
        [_deviceSubLayer5 release];
        _deviceSubLayer5 = nil;
    }
    if (_deviceSubLayer6 != nil) {
        [_deviceSubLayer6 release];
        _deviceSubLayer6 = nil;
    }
    
    if (_downLoadView != nil) {
        [_downLoadView release];
        _downLoadView = nil;
    }
    if (_downLoadLayer1 != nil) {
        [_downLoadLayer1 release];
        _downLoadLayer1 = nil;
    }
    if (_downLoadLayer2 != nil) {
        [_downLoadLayer2 release];
        _downLoadLayer2 = nil;
    }
    if (_downLoadLayer3 != nil) {
        [_downLoadLayer3 release];
        _downLoadLayer3 = nil;
    }
    if (_downLoadLayer4 != nil) {
        [_downLoadLayer4 release];
        _downLoadLayer4 = nil;
    }
    
    if (_toiOSView != nil) {
        [_toiOSView release];
        _toiOSView = nil;
    }
    if (_androidLayer != nil) {
        [_androidLayer release];
        _androidLayer = nil;
    }
    if (_iOSLayer != nil) {
        [_iOSLayer release];
        _iOSLayer = nil;
    }
    if (_toiOSLayer1 != nil) {
        [_toiOSLayer1 release];
        _toiOSLayer1 = nil;
    }
    if (_toiOSLayer2 != nil) {
        [_toiOSLayer2 release];
        _toiOSLayer2 = nil;
    }
    if (_toiOSLayer3 != nil) {
        [_toiOSLayer3 release];
        _toiOSLayer3 = nil;
    }
    if (_toiOSLayer4 != nil) {
        [_toiOSLayer4 release];
        _toiOSLayer4 = nil;
    }
    if (_toiOSLayer5 != nil) {
        [_toiOSLayer5 release];
        _toiOSLayer5 = nil;
    }
    if (_toiOSLayer6 != nil) {
        [_toiOSLayer6 release];
        _toiOSLayer6 = nil;
    }
    
    if (_skinView != nil) {
        [_skinView release];
        _skinView = nil;
    }
    if (_skinLayer1 != nil) {
        [_skinLayer1 release];
        _skinLayer1 = nil;
    }
    if (_skinLayer2 != nil) {
        [_skinLayer2 release];
        _skinLayer2 = nil;
    }
    if (_skinLayer3 != nil) {
        [_skinLayer3 release];
        _skinLayer3 = nil;
    }
    if (_skinLayer4 != nil) {
        [_skinLayer4 release];
        _skinLayer4 = nil;
    }
    if (_skinTimer.isValid) {
        [_skinTimer invalidate];
        _skinTimer = nil;
    }
    
    if (_airBackupTimer.isValid) {
        [_airBackupTimer invalidate];
        _airBackupTimer = nil;
    }
    if (_airBackupView != nil) {
        [_airBackupView release];
        _airBackupView = nil;
    }
    if (_airBackupLayer1 != nil) {
        [_airBackupLayer1 release];
        _airBackupLayer1 = nil;
    }
    if (_airBackupLayer2 != nil) {
        [_airBackupLayer2 release];
        _airBackupLayer2 = nil;
    }
    if (_airBackupLayer3 != nil) {
        [_airBackupLayer3 release];
        _airBackupLayer3 = nil;
    }
    if (_airBackupLayer4 != nil) {
        [_airBackupLayer4 release];
        _airBackupLayer4 = nil;
    }
    if (_airBackupLayer5 != nil) {
        [_airBackupLayer5 release];
        _airBackupLayer5 = nil;
    }
    if (_airBackupLayer6 != nil) {
        [_airBackupLayer6 release];
        _airBackupLayer6 = nil;
    }
    if (_airBackupLayer7 != nil) {
        [_airBackupLayer7 release];
        _airBackupLayer7 = nil;
    }
    if (_airBackupLayer8 != nil) {
        [_airBackupLayer8 release];
        _airBackupLayer8 = nil;
    }
    [super dealloc];
}

@end
