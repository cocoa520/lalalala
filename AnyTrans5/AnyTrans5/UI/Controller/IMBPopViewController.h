//
//  IMBPopViewController.h
//  AnyTrans
//
//  Created by iMobie on 8/30/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBPopViewController : NSViewController<NSTextViewDelegate> {
    IBOutlet NSTextView *_textView;
    NSString *_promptName;
    BOOL _isSkin;
    NSString *_str1;
    NSString *_str2;
}
@property (nonatomic, assign) BOOL isSkin;
- (id)initWithPromptName:(NSString *)name;
- (void)setPromptNameFrame:(NSRect)rect;

@end
