//
//  PRHSheet.h
//  PRHSheet
//
//  Created by Peter Hosey on 2011-12-20.
//

#import <Cocoa/Cocoa.h>
#import "IMBPopupButton.h"

typedef void (^PRHSheetCompletionHandler)(NSInteger returnCode);

@interface IMBSheet : NSPanel<NSTextFieldDelegate>
{
    NSTextField *_textFiled;
    NSTimer *_timer;
    NSButton *_okButton;
    NSButton *_cancelButton;
    IMBPopupButton *_poupButton;
    NSTextField *_addCustomLabel;
}
@property (nonatomic,retain) IBOutlet NSTextField *textField;
@property (nonatomic,retain) IBOutlet NSButton *cancelButton;
@property (nonatomic,retain) IBOutlet NSButton *okButton;
@property (nonatomic,retain) IMBPopupButton *poupButton;
@property (assign) IBOutlet NSTextField *_addCustomLabel;

//Your handler does not need to order the sheet out; the sheet will order itself out automatically after calling the handler.
- (void) beginOnWindow:(NSWindow *)window completionHandler:(PRHSheetCompletionHandler)handler;
- (void) end;
- (void) endWithReturnCode:(NSInteger)returnCode;

- (IBAction) ok:(id)sender;
- (IBAction) cancel:(id)sender;

@end

//Returns nil if the return code isn't recognized.
extern NSString *PRHSheetStringForReturnCode(NSInteger returnCode);
//Returns @"???" if the return code isn't recognized.
extern NSString *PRHSheetDebugStringForReturnCode(NSInteger returnCode);
//Returns a given string if the return code isn't recognized.
extern NSString *PRHSheetStringForReturnCodeWithDefault(NSInteger returnCode, NSString *defaultString);