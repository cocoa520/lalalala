//
//  AppDelegate.m
//  iOS File
//
//  Created by 龙凡 on 2018/1/15.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "AppDelegate.h"
#import "IMBSoftWareInfo.h"
#import "StringHelper.h"


@implementation AppDelegate

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return TRUE;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSMutableArray *chooseLang = [[NSMutableArray alloc] init];
    [chooseLang addObject:@"ja"];
    [[NSUserDefaults standardUserDefaults] setObject:chooseLang forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Insert code here to initialize your application
    _mainWindowController = [[IMBMainWindowController alloc] initWithWindowNibName:@"IMBMainWindowController"];
//    [self.window setContentSize:NSMakeSize(1060, 635)];
    [_mainWindowController.window setContentSize:NSMakeSize(592, 430)];
    [_mainWindowController showWindow:nil];
    
    [self checkLanguage];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)dealloc {
    [super dealloc];
    if (_mainWindowController) {
        [_mainWindowController release];
        _mainWindowController = nil;
    }
}

- (void)checkLanguage {
    NSArray *defineLang = @[@"en", @"ja", @"de", @"fr", @"es",@"ar",@"zh"];
    NSArray *checkLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSMutableArray *chooseLang = [[NSMutableArray alloc] init];
    NSString *_langStr = @"";
    for (NSString *langStr in checkLang) {
        if (![defineLang containsObject:langStr]) {
            continue;
        }
        _langStr = langStr;
        break;
    }
    NSString *langPath = [[NSBundle mainBundle] pathForResource:_langStr ofType:@".lproj"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:langPath]) {
        _langStr = @"en";
    }
    if ([StringHelper stringIsNilOrEmpty:_langStr]) {
        _langStr = @"en";
    }
    [chooseLang addObject:_langStr];
    [[NSUserDefaults standardUserDefaults] setObject:chooseLang forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
#if !__has_feature(objc_arc)
    if (chooseLang) [chooseLang release]; chooseLang = nil;
#endif
    if ([_langStr isEqualToString:@"en"]) {
        [[IMBSoftWareInfo singleton] setChooseLanguageType:EnglishLanguage];
    }else if ([_langStr isEqualToString:@"ja"]) {
        [[IMBSoftWareInfo singleton] setChooseLanguageType:JapaneseLanguage];
    }else if ([_langStr isEqualToString:@"de"]) {
        [[IMBSoftWareInfo singleton] setChooseLanguageType:GermanLanguage];
    }else if ([_langStr isEqualToString:@"fr"]) {
        [[IMBSoftWareInfo singleton] setChooseLanguageType:FrenchLanguage];
    }else if ([_langStr isEqualToString:@"es"]) {
        [[IMBSoftWareInfo singleton] setChooseLanguageType:SpanishLanguage];
    }else if ([_langStr isEqualToString:@"ar"]) {
        [[IMBSoftWareInfo singleton] setChooseLanguageType:ArabLanguage];
    }else if ([_langStr isEqualToString:@"zh"]) {
        [[IMBSoftWareInfo singleton] setChooseLanguageType:ChinaLanguage];
    }else {
        [[IMBSoftWareInfo singleton] setChooseLanguageType:EnglishLanguage];
    }
}
@end
