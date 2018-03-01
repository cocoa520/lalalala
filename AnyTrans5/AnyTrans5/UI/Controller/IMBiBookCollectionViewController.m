//
//  IMBiBookCollectionViewController.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/30.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBiBookCollectionViewController.h"
#import "IMBBGColoerView.h"
#import "IMBBookCollection.h"
#import "IMBImageAndTextCell.h"
#import "IMBTracksCollectionViewController.h"
#import "IMBBookEntity.h"
#import "LoadingView.h"
#import "IMBDeleteTrack.h"
#import "StringHelper.h"
@implementation IMBiBookCollectionViewController
@synthesize itemArry = _itemArry;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    self = [super initWithIpod:ipod withCategoryNodesEnum:category withDelegate:delegate];
    if (self) {
        //获取数据
        _playlistArray = [[_information collecitonArray] retain];
        _dataSourceArray = [[_information allBooksArray] retain];
        
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        [self configNoDataView];
    });
}

- (void)changeSkin:(NSNotification *)notification {
    [_bookBackImageView setImage:[StringHelper imageNamed:@"ibook_bookback"]];
    [_selectImageView setImage:[StringHelper imageNamed:@"ibook_selected"]];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
//    [_playlistTableView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"playlist_bgColor", nil)]];
    [_playlistTableView setBackgroundColor:[NSColor clearColor]];
    [_collectionView setBackgroundColors:[NSArray arrayWithObjects:[NSColor clearColor], nil]];
    [self configNoDataView];
    [_animationView setNeedsDisplay:YES];
    NSIndexSet *set = [_collectionView selectionIndexes];
    [_arrayController removeObjects:_dataSourceArray];
    [_arrayController addObjects:_dataSourceArray];
    [_arrayController setSelectionIndexes:set];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_bookBackImageView setImage:[StringHelper imageNamed:@"ibook_bookback"]];
    [_selectImageView setImage:[StringHelper imageNamed:@"ibook_selected"]];
    [_collectionView setBackgroundColors:[NSArray arrayWithObjects:[NSColor clearColor], nil]];
    [_collectionView setFocusRingType:NSFocusRingTypeNone];
    self.itemArry = [NSMutableArray arrayWithArray:_dataSourceArray];
    queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:2];
//    _detailView.isNOCanDraw = YES;
    _alertView = [[IMBAlertViewController alloc]initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_mainTitle setStringValue:CustomLocalizedString(@"Collections_id", nil)];
//    [_bgView setBackground:[NSColor whiteColor]];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
//    _bgView.rightBorder = NO;
//    _bgView.bottomBorder = YES;
//    _bgView.topBorder = NO;
//    _bgView.isBorder = YES;
   
    [_collectionView setSelectionIndexes:nil];
//    [_playlistTableView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"playlist_bgColor", nil)]];
    [_playlistTableView setBackgroundColor:[NSColor clearColor]];
    [_playlistTableView setFocusRingType:NSFocusRingTypeNone];
    [_playlistTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_mainBox setContentView:_detailView];
    }

    [self loadbookCover:_itemArry];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
}

#pragma mark - NSTextView
- (void)configNoDataView {
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_book"]];
    [_textView setDelegate:self];
    NSString *promptStr = @"";
    NSString *overStr = CustomLocalizedString(@"NO_DATA_TITLE_2", nil);
    promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_55", nil)] stringByAppendingString:overStr];
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_textView setLinkTextAttributes:linkAttributes];
    
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
    [[_textView textStorage] setAttributedString:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_playlistArray.count > 0)
    {
        return [_playlistArray count];
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (row < _playlistArray.count) {
        IMBBookCollection *item = [_playlistArray objectAtIndex:row];
        if ([@"PlaylistName" isEqualToString:tableColumn.identifier] ) {
            return item.collectionName;
        }
    }
    return @"";
}

#pragma mark - NSTableViewdelegate
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    IMBImageAndTextCell *cell1 = (IMBImageAndTextCell*)cell;
    cell1.imageSize = NSMakeSize(18, 18);
    cell1.marginX = 20;
    cell1.paddingX = 0;

    IMBBookCollection *bookCollection = [_playlistArray objectAtIndex:row];
    if ([bookCollection.collectionName isEqualToString:@"Books"]&& ![tableView isRowSelected:row]) {
        cell1.image = [StringHelper imageNamed:@"menu_book"];
        cell1.imageName = @"menu_book";
    }else if ([bookCollection.collectionName isEqualToString:@"Books"]&& [tableView isRowSelected:row])
    {
        cell1.image = [StringHelper imageNamed:@"menu_book"];
        cell1.imageName = @"menu_book";
    }else if ([bookCollection.collectionName isEqualToString:@"PDFs"]&& ![tableView isRowSelected:row])
    {
        cell1.image = [StringHelper imageNamed:@"menu_pdf1"];
        cell1.imageName = @"menu_pdf1";
    }else if ([bookCollection.collectionName isEqualToString:@"PDFs"]&& [tableView isRowSelected:row])
    {
        cell1.image = [StringHelper imageNamed:@"menu_pdf2"];
        cell1.imageName = @"menu_pdf2";
    }else if ([bookCollection.collectionName isEqualToString:CustomLocalizedString(@"iBook_id_2", nil)]&& ![tableView isRowSelected:row])
    {
        cell1.image = [StringHelper imageNamed:@"menu_buy1"];
        cell1.imageName = @"menu_buy1";
    }else if ([bookCollection.collectionName isEqualToString:CustomLocalizedString(@"iBook_id_2", nil)]&& [tableView isRowSelected:row])
    {
        cell1.image = [StringHelper imageNamed:@"menu_buy2"];
        cell1.imageName = @"menu_buy2";
    }else if ([bookCollection.collectionName isEqualToString:CustomLocalizedString(@"iBook_id_1", nil)]&& ![tableView isRowSelected:row])
    {
        cell1.image = [StringHelper imageNamed:@"menu_book"];
        cell1.imageName = @"menu_book";
    }else if ([bookCollection.collectionName isEqualToString:CustomLocalizedString(@"iBook_id_1", nil)]&& [tableView isRowSelected:row])
    {
        cell1.image = [StringHelper imageNamed:@"menu_book"];
        cell1.imageName = @"menu_book";
    }else if (![tableView isRowSelected:row])
    {
        cell1.image = [StringHelper imageNamed:@"menu_book"];
        cell1.imageName = @"menu_book";
    }else if ([tableView isRowSelected:row])
    {
        cell1.image = [StringHelper imageNamed:@"menu_book"];
        cell1.imageName = @"menu_book";
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView *tab = [notification object];
    NSInteger selectrow = [tab selectedRow];
    IMBBookCollection *collection = nil;
    if (selectrow != -1) {
        collection = [_playlistArray objectAtIndex:selectrow];
    }
    NSPredicate *cate = nil;
    if (![collection.collectionName isEqualToString:CustomLocalizedString(@"iBook_id_1", nil)]) {
        
        cate = [NSPredicate predicateWithFormat:@"collectionID == %@",collection.collectionID];
    }
    [_arrayController setFilterPredicate:cate];
}

- (void)loadbookCover:(NSArray *)array {
    loadFinished = NO;
    [queue addOperationWithBlock:^{
        for (IMBBookEntity *book in array ) {
            
            __block NSString *filePath = nil;
            @synchronized(self){
                NSData *data = nil;
                if ([book.extension isEqualToString:@"epub"]) {
                    filePath = book.coverPath;
                    data = [self loadEpubCover:filePath];
                }else if ([book.extension isEqualToString:@"pdf"]&&!book.isPurchase)
                {
                    filePath = [NSString stringWithFormat:@"Books/%@",book.path];
                    data = [self loadPdfCover:filePath];
                }else
                {
                    filePath = [NSString stringWithFormat:@"Books/Purchases/%@",book.path];
                    data = [self loadPdfCover:filePath];
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSImage *image = [[NSImage alloc] initWithData:data];
                    if (image != nil) {
                        [image setSize:NSMakeSize(110, 168)];
                        book.coverImage = image;
                    }else
                    {
                        book.bookTitle = book.bookName;
                    }
                    [image release];
                    
                });
            }
        }
        loadFinished = YES;
    }];
}

//加载epub的封面
- (NSData *)loadEpubCover:(NSString *)filePath {
    AFCDirectoryAccess *afcDir = [_ipod.deviceHandle newAFCMediaDirectory];
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
- (NSMutableData *)loadPdfCover:(NSString *)filePath {
    
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
    
    AFCDirectoryAccess *afcDir = [_ipod.deviceHandle newAFCMediaDirectory];
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
                page++;
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

//获得选中的item
- (NSIndexSet *)selectedItems {
    NSIndexSet *selectedItems = nil;
    if (_collectionView != nil) {
        selectedItems = [_arrayController selectionIndexes];
    }
    return selectedItems;
}

- (void)reload:(id)sender {
    [self disableFunctionBtn:NO];
    [_mainBox setContentView:_loadingView];
    [_animationView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_information loadiBook];
       dispatch_async(dispatch_get_main_queue(), ^{
           [self disableFunctionBtn:YES];
           if (_playlistArray != nil) {
               [_playlistArray release];
               _playlistArray = nil;
           }
           if (_dataSourceArray != nil) {
               [_dataSourceArray release];
               _dataSourceArray = nil;
           }
           
           _playlistArray = [[_information collecitonArray] retain];
           _dataSourceArray = [[_information allBooksArray] retain];
           self.itemArry = [NSMutableArray arrayWithArray:_dataSourceArray];
           if (_dataSourceArray.count == 0) {
               [_mainBox setContentView:_noDataView];
               [self configNoDataView];
           }else {
               [_mainBox setContentView:_detailView];
           }
           if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
               [_delegate refeashBadgeConut:_dataSourceArray.count WithCategory:_category];
           }
           [self loadbookCover:_itemArry];
           [_collectionView setSelectionIndexes:nil];
           [_animationView endAnimation];
       });
    });
}

@end

@implementation IMBiBookCollectionViewItem

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    IMBCollectionItemView *itemView = (IMBCollectionItemView *)self.view;
    IMBCollectionImageView *collectionImageView = [itemView viewWithTag:101];
    IMBCollectionImageView *selectImageView = [itemView viewWithTag:102];
    
    [selectImageView.image setSize:NSMakeSize(110, 168)];
    collectionImageView.isSelected = selected;
    
    [collectionImageView setNeedsDisplay:YES];
    if (selected) {
        [selectImageView setHidden:NO];
    }else
    {
        [selectImageView setHidden:YES];
    }
}

-(void)dealloc {
    [super dealloc];
}

@end