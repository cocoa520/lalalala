//
//  IMBSoftWareInfo.m
//  iMobieTrans
//
//  Created by zhang yang on 13-6-23.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBSoftWareInfo.h"
#import "TempHelper.h"
@implementation IMBSoftWareInfo
@synthesize isFirstRun = _isFirstRun;
@synthesize buildDate = _buildDate;
@synthesize productName = _productName;
@synthesize version = _version;
@synthesize mustUpdate = _mustUpdate;
@synthesize isRegistered = _isRegistered;
@synthesize registeredCode = _registeredCode;
@synthesize registeredDate = _registeredDate;
@synthesize systemDateFormatter = _systemDateFormatter;
@synthesize chooseLanguageType = _chooseLanguageType;

+ (IMBSoftWareInfo*)singleton {
    static IMBSoftWareInfo *_singleton = nil;
	@synchronized(self) {
		if (_singleton == nil) {
			_singleton = [[IMBSoftWareInfo alloc] init];
		}
	}
	return _singleton;
}

- (id)init {
    self = [super init];
    if (self) {
        _productName = @"AnyTrans";
        _buildDate = @"20180403";
        
        [self checkSystemDateFormatter];
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        _version = [appVersion retain];
        NSString *path = [TempHelper resourcePathOfAppDir:@"IMBSoftware-Info" ofType:@"plist"];
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSArray *allKeys = dic.allKeys;
        if ([allKeys containsObject:@"ProductName"]) {
            _productName = [[dic objectForKey:@"ProductName"] retain];
        }
        if ([allKeys containsObject:@"IsRegistered"]) {
            _isRegistered = [[dic objectForKey:@"IsRegistered"] boolValue];
        }
        if ([allKeys containsObject:@"RegisteredCode"]) {
            _registeredCode = [[dic objectForKey:@"RegisteredCode"] retain];
        }
        if ([allKeys containsObject:@"RegisteredDate"]) {
            _registeredDate = [[dic objectForKey:@"RegisteredDate"] retain];
        }
        if ([allKeys containsObject:@"MustUpdate"]) {
            _mustUpdate = [(NSNumber*)[dic objectForKey:@"MustUpdate"] boolValue];
        }
        if ([allKeys containsObject:@"FirstOpen"]) {
            _isFirstRun = [[dic objectForKey:@"FirstOpen"] boolValue];
        }
        
        //第一次打开之后，把FirstOpen设置为NO，保存到文件中
        [dic setValue:[NSNumber numberWithBool:NO] forKey:@"FirstOpen"];
        [dic writeToFile:path atomically:YES];
        [dic release];
    }
    
    return self;
}

- (void)checkSystemDateFormatter {
    if (_chooseLanguageType == GermanLanguage || _chooseLanguageType == FrenchLanguage || _chooseLanguageType == SpanishLanguage ||  _chooseLanguageType == ArabLanguage) {
        _systemDateFormatter = @"dd/MM/yyyy";
    }else if (_chooseLanguageType == JapaneseLanguage || _chooseLanguageType == ChinaLanguage) {
        _systemDateFormatter = @"yyyy/MM/dd";
    }else {
        _systemDateFormatter = @"MM/dd/yyyy";
    }
}

- (void)setChooseLanguageType:(LanguageTypeEnum)chooseLanguageType {
    _chooseLanguageType = chooseLanguageType;
    [self checkSystemDateFormatter];
}

- (void)dealloc {
    if (_productName != nil) {
        [_productName release];
    }
    if (_buildDate != nil) {
        [_buildDate release];
    }
    if (_version != nil) {
        [_version release];
    }
    if (_registeredCode != nil) {
        [_registeredCode release];
    }
    if (_registeredDate != nil) {
        [_registeredDate release];
    }
    [super dealloc];
}

@end
