//
//  IMBCommonTool.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/14.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBCommonTool.h"
#import "IMBSingleBtnAlertController.h"
#import "IMBTwoBtnsAlertController.h"
#import "IMBBorderRectAndColorView.h"
#import "IMBViewAnimation.h"
#import "IMBGeneralButton.h"
#import "IMBAlertSupeView.h"
#import "IMBViewManager.h"
#import "IMBiPod.h"
#import "IMBHelper.h"

#import <objc/runtime.h>

static CGFloat IMBAlertShowInterval = 0.2f;



@implementation IMBCommonTool
#pragma mark - 设置view的背景颜色
+ (void)setViewBgWithView:(NSView *)view color:(NSColor *)bgColor delta:(CGFloat)delta radius:(CGFloat)radius dirtyRect:(NSRect)dirtyRect {
    dirtyRect.origin.x = 0;
    dirtyRect.origin.y = 0;
    dirtyRect.size.width = view.frame.size.width;
    dirtyRect.size.height = view.frame.size.height;
    NSRect newRect = NSMakeRect(dirtyRect.origin.x+delta, dirtyRect.origin.y+delta, dirtyRect.size.width-delta*2, dirtyRect.size.height - delta*2);
    NSBezierPath *bgPath = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:radius yRadius:radius];
    [bgColor set];
    [bgPath fill];
}
#pragma mark - 显示单个ok按钮的下拉提示框，当界面是dropbox时，isDetailWindow参数传入 @"DropBox"  当界面是iCloud时，isDetailWindow参数传入 @"iCloud"  当界面是device时，isDetailWindow参数传入 ipod.uniqueKey
+ (void)showSingleBtnAlertInMainWindow:(NSString *)isDetailWindow btnTitle:(NSString *)btnTitle msgText:(NSString *)msgText btnClickedBlock:(void(^)(void))btnClickedBlock {
    [self showSingleBtnAlertInMainWindow:isDetailWindow alertTitle:@"" btnTitle:btnTitle msgText:msgText btnClickedBlock:btnClickedBlock];
}
+ (void)showSingleBtnAlertInMainWindow:(NSString *)isDetailWindow  alertTitle:(NSString *)alertTitle btnTitle:(NSString *)btnTitle msgText:(NSString *)msgText btnClickedBlock:(void (^)(void))btnClickedBlock {
    
    IMBAlertSupeView *inView = nil;
    __block IMBSingleBtnAlertController *alert = [[IMBSingleBtnAlertController alloc] initWithNibName:@"IMBSingleBtnAlertController" bundle:nil];
    if (!isDetailWindow) {
        inView = objc_getAssociatedObject([NSApplication sharedApplication], &kIMBMainWindowAlertView);
    }else {
        NSMutableArray *obArr = objc_getAssociatedObject([NSApplication sharedApplication], &kIMBMainPageWindowAlertView);
        for (NSDictionary *dic in obArr) {
            if ([dic[@"key"] isEqualToString:isDetailWindow]) {
                inView = dic[@"alertView"];
                break;
            }
        }
    }
    
    if (inView == nil) return;
    NSString *viewP = [NSString stringWithFormat:@"%p",inView];
    [inView addSubview:alert.view];
    [inView setHidden:NO];
    [alert.singleBtnViewMsgLabel setStringValue:msgText];
    if (btnTitle) {
        [alert.singleBtnViewOKBtn setTitle:btnTitle];
    }else {
        [alert.singleBtnViewOKBtn setTitle:@"OK"];
    }
    
    [alert.view setFrameOrigin:NSMakePoint((inView.frame.size.width - alert.view.frame.size.width)/2.f, inView.frame.size.height)];
    NSRect newF = alert.view.frame;
    newF.origin.y = inView.frame.size.height - newF.size.height + 10.f;
    [alert.view setWantsLayer:YES];
    [IMBViewAnimation animationWithView:alert.view frame:newF timeInterval:IMBAlertShowInterval disable:NO completion:^{
        
    }];
    alert.singleBtnOKClicked = ^ {
        if (btnClickedBlock) {
            btnClickedBlock();
        }
        NSRect newF = alert.view.frame;
        newF.origin.y = inView.frame.size.height;
        [IMBViewAnimation animationWithView:alert.view frame:newF timeInterval:IMBAlertShowInterval disable:NO completion:^{
            [alert.view removeFromSuperview];
            if (inView.subviews.count == 0) {
                [inView setHidden:YES];
            }
            [alert release];
            alert = nil;
            
        }];
        
    };
}

#pragma mark - 显示单个两个按钮的下拉提示框，当界面是dropbox时，isDetailWindow参数传入 @"DropBox"  当界面是iCloud时，isDetailWindow参数传入 @"iCloud"  当界面是device时，isDetailWindow参数传入 ipod.uniqueKey
+ (void)showTwoBtnsAlertInMainWindow:(NSString *)isDetailWindow firstBtnTitle:(NSString *)firstTitle secondBtnTitle:(NSString *)secondTitle msgText:(NSString *)msgText firstBtnClickedBlock:(void(^)(void))firstBtnClickedBlock secondBtnClickedBlock:(void(^)(void))secondBtnClickedBlock {
    [self showTwoBtnsAlertInMainWindow:isDetailWindow alertTitle:@"" firstBtnTitle:firstTitle secondBtnTitle:secondTitle msgText:msgText firstBtnClickedBlock:firstBtnClickedBlock secondBtnClickedBlock:secondBtnClickedBlock];
}
+ (void)showTwoBtnsAlertInMainWindow:(NSString *)isDetailWindow  alertTitle:(NSString *)alertTitle firstBtnTitle:(NSString *)firstTitle secondBtnTitle:(NSString *)secondTitle msgText:(NSString *)msgText firstBtnClickedBlock:(void (^)(void))firstBtnClickedBlock secondBtnClickedBlock:(void (^)(void))secondBtnClickedBlock {
    IMBAlertSupeView *inView = nil;
    __block IMBTwoBtnsAlertController *alert = [[IMBTwoBtnsAlertController alloc] initWithNibName:@"IMBTwoBtnsAlertController" bundle:nil];
    if (!isDetailWindow) {
        inView = objc_getAssociatedObject([NSApplication sharedApplication], &kIMBMainWindowAlertView);
    }else {
        NSMutableArray *obArr = objc_getAssociatedObject([NSApplication sharedApplication], &kIMBMainPageWindowAlertView);
        for (NSDictionary *dic in obArr) {
            if ([dic[@"key"] isEqualToString:isDetailWindow]) {
                inView = dic[@"alertView"];
                break;
            }
        }
    }
    
    if (inView == nil) return;
    [inView addSubview:alert.view];
    [inView setHidden:NO];
    [alert.twoBtnsViewMsgView setStringValue:msgText];
    if (secondTitle) {
        [alert.twoBtnsViewOKBtn setTitle:secondTitle];
    }else {
        [alert.twoBtnsViewOKBtn setTitle:@"OK"];
    }
    if (firstTitle) {
        [alert.twoBtnsViewCancelBtn setTitle:firstTitle];
    }else {
        [alert.twoBtnsViewCancelBtn setTitle:@"Cancel"];
    }
    [alert.view setFrameOrigin:NSMakePoint((inView.frame.size.width - alert.view.frame.size.width)/2.f, inView.frame.size.height)];
    NSRect newF = alert.view.frame;
    newF.origin.y = inView.frame.size.height - newF.size.height + 10.f;
    [alert.view setWantsLayer:YES];
    [IMBViewAnimation animationWithView:alert.view frame:newF timeInterval:IMBAlertShowInterval disable:NO completion:^{
        
    }];
    
    alert.twoBtnsViewOKClicked = ^ {
        if (secondBtnClickedBlock) {
            secondBtnClickedBlock();
        }
        
        NSRect newF = alert.view.frame;
        newF.origin.y = inView.frame.size.height;
        [IMBViewAnimation animationWithView:alert.view frame:newF timeInterval:IMBAlertShowInterval disable:NO completion:^{
            [alert.view removeFromSuperview];
            if (inView.subviews.count == 0) {
                [inView setHidden:YES];
            }
            [alert release];
            alert = nil;
            
        }];
        
    };
    
    alert.twoBtnsViewCancelClicked = ^ {
        if (firstBtnClickedBlock) {
            firstBtnClickedBlock();
        }
        
        NSRect newF = alert.view.frame;
        newF.origin.y = inView.frame.size.height;
        [IMBViewAnimation animationWithView:alert.view frame:newF timeInterval:IMBAlertShowInterval disable:NO completion:^{
            [alert.view removeFromSuperview];
            if (inView.subviews.count == 0) {
                [inView setHidden:YES];
            }
            [alert release];
            alert = nil;
        }];
        
    };
    
}

#pragma mark - 上传文件时，对于openpanel能打开什么样的文件进行判断返回
+ (NSArray<NSString *> *)getOpenPanelSuffxiWithCategory:(CategoryNodesEnum)category {
    switch (category) {
        case Category_PhotoLibrary:
        {
            return @[@"png",@"jpg",@"gif",@"bmp",@"tiff",@"jpeg"];
        }
            break;
        case Category_iBooks:
        {
            return @[@"pdf",@"epub"];
        }
            break;
        case Category_Media:
        {
            return @[@"mp3",@"m4a",@"wma",@"wav",@"rm",@"mdi",@"m4r",@"m4b",@"m4p",@"flac",@"amr",@"ogg",@"ac3",@"ape",@"aac",@"mka"];
        }
            break;
        case Category_Applications:
        {
            return @[@"ipa"];
        }
            break;
        case Category_Video:
        {
            return @[@"mp4",@"m4v",@"mov",@"wmv",@"rmvb",@"avi",@"flv",@"rm",@"3gp",@"mpg",@"webm"];
        }
            break;
        default:
            return nil;
            break;
    }
    return nil;
}
#pragma mark - 加载book封面

+ (void)loadbookCover:(NSArray *)array ipod:(IMBiPod *)ipod {
    for (IMBBookEntity *book in array ) {
        
        __block NSString *filePath = nil;
        @synchronized(self){
            NSData *data = nil;
            if ([book.extension isEqualToString:@"epub"]) {
                filePath = book.coverPath;
                data = [self loadEpubCoverWithIpod:ipod filePath:filePath];
            }else if ([book.extension isEqualToString:@"pdf"]&&!book.isPurchase)
            {
                filePath = [NSString stringWithFormat:@"Books/%@",book.path];
                data = [self loadPdfCover:filePath ipod:ipod];
            }else
            {
                filePath = [NSString stringWithFormat:@"Books/Purchases/%@",book.path];
                data = [self loadPdfCover:filePath ipod:ipod];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                NSImage *sourceImage = [[NSImage alloc] initWithData:data];
                NSData *imageData = [IMBHelper createThumbnail:sourceImage withWidth:80 withHeight:60];
                NSImage *image = [[NSImage alloc] initWithData:imageData];
                
                if (image != nil) {
                    book.coverImage = image;
                }else {
                    book.coverImage = [NSImage imageNamed:@"cnt_fileicon_books"];
                }
                book.bookTitle = book.bookName;
                [image release];
                [sourceImage release];
                
            });
        }
    }
}
//加载epub的封面
+ (NSData *)loadEpubCoverWithIpod:(IMBiPod *)ipod filePath:(NSString *)filePath {
    AFCDirectoryAccess *afcDir = [ipod.deviceHandle newAFCMediaDirectory];
    AFCFileReference *infile = [afcDir openForRead:filePath];
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    const uint32_t bufsz = 10240;
    char *buff = malloc(bufsz);
    uint32_t done = 0;
    while (1) {
        uint64_t n = [infile readN:bufsz bytes:buff];
        if (n==0) break;
        NSData *b2 = [[NSData alloc]
                      initWithBytesNoCopy:buff length:n freeWhenDone:NO];
        [data appendData:b2];
        [b2 release];
        done += n;
    }
    
    free(buff);
    // close output file
    [infile closeFile];
    [afcDir close];
    return data;
}

//加载pdf的封面 pdf的封面默认是第一页
+ (NSMutableData *)loadPdfCover:(NSString *)filePath ipod:(IMBiPod *)ipod {
    
    NSMutableData *pdfData = [NSMutableData data];
    int desiredResolution = 200; // in DPI
    
    BOOL morePages = YES;
    int page = 1;
    
    // Package all arguments as NSStrings in an NSArray
    NSMutableArray* args = [NSMutableArray array];
    [args addObject:@"--page"];
    [args addObject:@"1"];
    // If we have a "--dpi" along with a corresponding argument ...
    NSUInteger index = NSNotFound;
    if ( (index = [args indexOfObject: @"--dpi"]) != NSNotFound && index + 1 < [args count] )
    {
        // Parse it as an integer
        desiredResolution = [[args objectAtIndex: index + 1] intValue];
        [args removeObjectAtIndex: index + 1];
        [args removeObjectAtIndex: index];
    }
    // If we have a "--page" along with a corresponding argument ...
    if ( (index = [args indexOfObject: @"--page"]) != NSNotFound && index + 1 < [args count] )
    {
        // Parse it as an integer
        page = [[args objectAtIndex: index + 1] intValue];
        morePages = NO;
        [args removeObjectAtIndex: index + 1];
        [args removeObjectAtIndex: index];
    }
    // --transparent    Do not fill background white color, keep transparency from PDF.
    BOOL keepTransparent = NO;
    if ( (index = [args indexOfObject: @"--transparent"]) != NSNotFound )
    {
        keepTransparent = YES;
        [args removeObjectAtIndex: index];
    }
    
    AFCDirectoryAccess *afcDir = [ipod.deviceHandle newAFCMediaDirectory];
    AFCFileReference *infile = [afcDir openForRead:filePath];
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    const uint32_t bufsz = 10240;
    char *buff = malloc(bufsz);
    uint32_t done = 0;
    while (1) {
        uint64_t n = [infile readN:bufsz bytes:buff];
        if (n==0) break;
        NSData *b2 = [[NSData alloc]
                      initWithBytesNoCopy:buff length:n freeWhenDone:NO];
        [data appendData:b2];
        [b2 release];
        done += n;
    }
    
    free(buff);
    // close output file
    [infile closeFile];
    [afcDir close];
    
    
    NSImage* source = [ [NSImage alloc] initWithData:data];
    [source setScalesWhenResized: YES];
    
    
    // Allows setCurrentPage to do anything
    [source setDataRetained: YES];
    
    if ( source == nil )
    {
        return nil;
    }
    
    // The output file name
    NSString* outputFileFormat = @"%@-p%01d";
    
    // Find the PDF representation
    NSPDFImageRep* pdfSource = NULL;
    NSArray* reps = [source representations];
    [source release];
    for ( int i = 0; i < [reps count] && pdfSource == NULL; ++ i )
    {
        if ( [[reps objectAtIndex: i] isKindOfClass: [NSPDFImageRep class]] )
        {
            pdfSource = [reps objectAtIndex: i];
            [pdfSource setCurrentPage: page-1];
            
            // Set the output format to have the correct number of leading zeros
            NSString *string0 = [NSString stringWithFormat: @"%ld", (long)[pdfSource pageCount]];
            long numDigits = [string0 length];
            outputFileFormat = [NSString stringWithFormat: @"%%@-p%%0%ldd", numDigits];
        }
    }
    
    [NSApplication sharedApplication];
    [[NSGraphicsContext currentContext] setImageInterpolation: NSImageInterpolationHigh];
    NSSize sourceSize = [pdfSource size];
    if (sourceSize.height == 0 && sourceSize.width == 0) {
        return nil;
    }
    do
    {
        // Set up a temporary release pool so memory will get cleaned up properly
        NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init];
        NSSize sourceSize = [pdfSource size];
        // int pixels = [ [source bestRepresentationForDevice: nil] pixelsWide];
        // if ( pixels != 0 ) sourceResolution = ((double)pixels / sourceSize.width) * 72.0;
        
        NSSize size = NSMakeSize( sourceSize.width * 0.2, sourceSize.width * 0.2*159/104 );
        
        //	[source setSize: size];
        NSRect sourceRect = NSMakeRect( 0, 0, sourceSize.width, sourceSize.height );
        NSRect destinationRect = NSMakeRect( 0, 0, size.width, size.height );
        
        NSImage* image = [[NSImage alloc] initWithSize:size];
        [image lockFocus];
        
        
        if (keepTransparent) {
            [pdfSource drawInRect: destinationRect
                         fromRect: sourceRect
                        operation: NSCompositeCopy fraction: 1.0 respectFlipped: NO hints: [NSDictionary dictionary] ];
        } else {
            [[NSColor whiteColor] set];
            NSRectFill( destinationRect );
            [pdfSource drawInRect: destinationRect
                         fromRect: sourceRect
                        operation: NSCompositeSourceOver fraction: 1.0 respectFlipped: NO hints: [NSDictionary dictionary] ];
        }
        
        NSBitmapImageRep* bitmap = [ [NSBitmapImageRep alloc]
                                    initWithFocusedViewRect: destinationRect ];
        
        [pdfData appendData:[bitmap representationUsingType:NSPNGFileType properties:nil]];
        [bitmap release];
        if ( morePages == YES )
        {
            // Go get the next page
            if ( pdfSource != NULL && page < [pdfSource pageCount] )
            {
                [pdfSource setCurrentPage: page];
                [source recache];
                page ++;
            }
            else
            {
                morePages = NO;
            }
        }
        
        [image unlockFocus];
        [image release];
        [loopPool release];
    }
    while ( morePages == YES );
    return pdfData;
    
}


@end
