//
//  PRHSheet.m
//  PRHSheet
//
//  Created by Peter Hosey on 2011-12-20.
//

#import "IMBSheet.h"

@interface IMBSheet ()
- (void) sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
@end
@implementation IMBSheet
@synthesize textField = _textFiled;
@synthesize okButton = _okButton;
@synthesize cancelButton = _cancelButton;
@synthesize poupButton = _poupButton;
@synthesize _addCustomLabel;

- (id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen {
	aStyle &= ~((NSUInteger)NSTitledWindowMask|(NSUInteger)NSMiniaturizableWindowMask);
	aStyle |= (NSUInteger)NSClosableWindowMask;
	return [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag screen:screen];
}


- (BOOL) canBecomeKeyWindow {
	return YES;
}

#pragma mark -

- (void) beginOnWindow:(NSWindow *)window completionHandler:(PRHSheetCompletionHandler)handler {
    [self.textField setStringValue:@""];
    [self.okButton setEnabled:false];
    [self.okButton setTitle:CustomLocalizedString(@"Button_Ok", nil)];
    [self.cancelButton setTitle:CustomLocalizedString(@"Button_Cancel", nil)];
    [_addCustomLabel setStringValue:CustomLocalizedString(@"contact_id_60", nil)];
    _timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(setButtonEnabled) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
	[NSApp beginSheet:self modalForWindow:window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:(void *)handler];
}

- (void)setButtonEnabled{
    if (self.textField.stringValue.length > 0) {
        if (![self.okButton isEnabled]) {
            [self.okButton setEnabled:YES];
        }
    }
    else{
        if ([self.okButton isEnabled]) {
            [self.okButton setEnabled:false];
        }
    }
}

- (void) end {
	[NSApp endSheet:self];
}

- (void) endWithReturnCode:(NSInteger)returnCode {
	[NSApp endSheet:self returnCode:returnCode];
    [_timer invalidate];
}

- (void) sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	PRHSheetCompletionHandler handler = (PRHSheetCompletionHandler)contextInfo;

	if (handler)
		handler(returnCode);

	[self orderOut:nil];
}

#pragma mark Actions

- (IBAction) ok:(id)sender {
    NSArray *titleArr = [self.poupButton titlesArr];
    NSString *string = self.textField.stringValue;
    if([titleArr containsObject:string] || string.length == 0){
        return;
    }
    else{
        NSMutableArray *newTitleArr = [NSMutableArray arrayWithArray:titleArr];
        if (newTitleArr.count > 1) {
            [newTitleArr insertObject:string atIndex:newTitleArr.count - 1];
        }
        [self.poupButton setTitlesArr:newTitleArr];
        [self.poupButton setTitle:string];
    }
    
	[self endWithReturnCode:NSOKButton];
}
- (IBAction) cancel:(id)sender {
	[self endWithReturnCode:NSCancelButton];
}

@end

NSString *PRHSheetStringForReturnCodeWithDefault(NSInteger returnCode, NSString *defaultString) {
	switch (returnCode) {
		case NSOKButton:
			return CustomLocalizedString(@"Button_Ok", nil);

		case NSCancelButton:
			return CustomLocalizedString(@"Button_Cancel", nil);
			
		default:
			return defaultString;
	}
}
NSString *PRHSheetStringForReturnCode(NSInteger returnCode) {
	return PRHSheetStringForReturnCodeWithDefault(returnCode, nil);
}
NSString *PRHSheetDebugStringForReturnCode(NSInteger returnCode) {
	return PRHSheetStringForReturnCodeWithDefault(returnCode, @"???");
}
