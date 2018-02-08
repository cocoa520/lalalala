//
//  IMBPhotosPreviewWindowController.m
//  iMobieTrans
//
//  Created by iMobie on 10/15/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBPhotosPreviewWindowController.h"
#import "IMBSoftWareInfo.h"
#import "IMBToolbarWindow.h"
#import "IMBFileSystem.h"
//#import "IMBiPodPool.h"
#import "IMBNotificationDefine.h"
#import "StringHelper.h"
#define ZOOM_IN_FACTOR  1.414214
#define ZOOM_OUT_FACTOR 0.7071068

@interface IMBPhotosPreviewWindowController ()

@end

@implementation IMBPhotosPreviewWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithArray:(NSArray *)array withIpod:(IMBiPod *)iPod WithPhotoEntity:(IMBPhotoEntity *)entity {
    self = [super initWithWindowNibName:@"IMBPhotosPreviewWindowController"];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDisconnected:) name:DeviceDisConnectedNotification object:nil];
        _photoArray = [array retain];
        _iPod = [iPod retain];
        _curPhotoEntity = entity;
        _isMsgImage = NO;
        _processQueue = [[NSOperationQueue alloc]init];
        [_processQueue setMaxConcurrentOperationCount:3];
    }
    return self;
}

- (id)initWithPicture:(NSImage *)picture {
    self = [super initWithWindowNibName:@"IMBPhotosPreviewWindowController"];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDisconnected:) name:DeviceDisConnectedNotification object:nil];
        _curPicture = [picture retain];
        _isMsgImage = YES;
        _processQueue = [[NSOperationQueue alloc]init];
        [_processQueue setMaxConcurrentOperationCount:3];
    }
    return self;
}

- (void)deviceDisconnected:(NSNotification *)notification
{
    [self.window close];
}

- (void)releaseObject {
//    [self stopAnimation];
    if (_scalingBtn != nil) {
        [_scalingBtn release];
        _scalingBtn = nil;
    }
    if (_whirlBtn != nil) {
        [_whirlBtn release];
        _whirlBtn = nil;
    }
    if (_nextBtn != nil) {
        [_nextBtn release];
        _nextBtn = nil;
    }
    if (_photoArray != nil) {
        [_photoArray release];
        _photoArray = nil;
    }
    if (_iPod != nil) {
        [_iPod release];
        _iPod = nil;
    }
    if (_curPicture != nil) {
        [_curPicture release];
        _curPicture = nil;
    }
    if (_processQueue != nil) {
        [_processQueue release];
        _processQueue = nil;
    }
//    if (_whirlImage != nil) {
//        [_whirlImage release];
//        _whirlImage = nil;
//    }
//    if (_scalingIamge != nil) {
//        [_scalingIamge release];
//        _scalingIamge = nil;
//    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DeviceDisConnectedNotification object:nil];
    [self releaseObject];
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)openImageData: (NSData*)data
{
    // use ImageIO to get the CGImage, image properties, and the image-UTType
    //
    CGImageRef          image = NULL;
//    CGImageSourceRef    isr = CGImageSourceCreateWithURL( (__bridge CFURLRef)url, NULL);
    CGImageSourceRef    isr = CGImageSourceCreateWithData( (__bridge CFDataRef)data, NULL);
    
    if (isr)
    {
		NSDictionary *options = [NSDictionary dictionaryWithObject: (id)kCFBooleanTrue  forKey: (id) kCGImageSourceShouldCache];
        image = CGImageSourceCreateImageAtIndex(isr, 0, (__bridge CFDictionaryRef)options);
        
        if (image)
        {
            _imageProperties = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(isr, 0, (__bridge CFDictionaryRef)_imageProperties));
            
            _imageUTType = (__bridge NSString*)CGImageSourceGetType(isr);
        }
		CFRelease(isr);
        
    }
    
    if (image)
    {
        [_imageView setImage: image
             imageProperties: _imageProperties];
//        if (CGImageGetWidth(image) > 794) {
//            [_imageView setHasHorizontalScroller:YES];
//        }else {
//            [_imageView setHasHorizontalScroller:NO];
//        }
//        if (CGImageGetHeight(image) > 891) {
//            [_imageView setHasVerticalScroller:YES];
//        }else {
//            [_imageView setHasVerticalScroller:NO];
//        }
        CGImageRelease(image);
//        [self.window setTitleWithRepresentedFilename: [url path]];
    }
}

// ---------------------------------------------------------------------------------------------------------------------
- (void)awakeFromNib
{
    [self.window center];
    IMBToolbarWindow *toolWindow = (IMBToolbarWindow *)self.window;
    [toolWindow setShowsTitle:YES];
    toolWindow.titleBarHeight = 54.0;
    [self.window setTitle:[[IMBSoftWareInfo singleton] getProductTitle]];
    [self.window setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    
    NSView *titleBarView = toolWindow.titleBarView;
    
    _whirlBtn = [[NSSegmentedControl alloc] initWithFrame:NSMakeRect(98, 6, 68, 24)];
    [_whirlBtn setEnabled:YES];
    [[_whirlBtn cell] setSegmentStyle:NSSegmentStyleTexturedSquare];
    [[_whirlBtn cell] setTrackingMode:NSSegmentSwitchTrackingMomentary];
    [_whirlBtn setSegmentCount:2];
    
    [_whirlBtn setImage:[StringHelper imageNamed:@"whirl_left"] forSegment:0];
    [_whirlBtn setImage:[StringHelper imageNamed:@"whirl_right"] forSegment:1];
    [_whirlBtn setWidth:32 forSegment:0];
    [_whirlBtn setWidth:32 forSegment:1];
    [_whirlBtn setTarget:self];
    [_whirlBtn setAction:@selector(doWhirl:)];
    [titleBarView addSubview:_whirlBtn];
    
    _scalingBtn = [[NSSegmentedControl alloc] initWithFrame:NSMakeRect(196, 6, 100, 24)];
    [_scalingBtn setEnabled:YES];
    [[_scalingBtn cell] setSegmentStyle:NSSegmentStyleTexturedSquare];
    [[_scalingBtn cell] setTrackingMode:NSSegmentSwitchTrackingMomentary];
    [_scalingBtn setSegmentCount:3];
    [_scalingBtn setImage:[StringHelper imageNamed:@"reduce"] forSegment:0];
    [_scalingBtn setImage:[StringHelper imageNamed:@"normal"] forSegment:1];
    [_scalingBtn setImage:[StringHelper imageNamed:@"enlarge"] forSegment:2];
    [_scalingBtn setWidth:32 forSegment:0];
    [_scalingBtn setWidth:32 forSegment:1];
    [_scalingBtn setWidth:32 forSegment:2];
    [_scalingBtn setTarget:self];
    [_scalingBtn setAction:@selector(doZoom:)];
    [titleBarView addSubview:_scalingBtn];
    
    if (_photoArray != nil && _photoArray.count > 0 && _isMsgImage == NO) {
        _nextBtn = [[NSSegmentedControl alloc] initWithFrame:NSMakeRect(10, 6, 68, 24)];
        [_nextBtn setEnabled:YES];
        [[_nextBtn cell] setSegmentStyle:NSSegmentStyleTexturedSquare];
        [[_nextBtn cell] setTrackingMode:NSSegmentSwitchTrackingMomentary];
        [_nextBtn setSegmentCount:2];
        //TODO改按钮图片；
        [_nextBtn setImage:[StringHelper imageNamed:@"preview_back"] forSegment:0];
        [_nextBtn setImage:[StringHelper imageNamed:@"preview_advance"] forSegment:1];
        [_nextBtn setWidth:32 forSegment:0];
        [_nextBtn setWidth:32 forSegment:1];
        [_nextBtn setTarget:self];
        [_nextBtn setAction:@selector(doNext:)];
        [titleBarView addSubview:_nextBtn];
        
        int index = 0;
        index = [_photoArray indexOfObject:_curPhotoEntity];
        if (index == 0) {
            [_nextBtn setEnabled:NO forSegment:0];
        }
        if (index == _photoArray.count - 1) {
            [_nextBtn setEnabled:NO forSegment:1];
        }
    }else {
        [_whirlBtn setFrameOrigin:NSMakePoint(10, 6)];
        [_scalingBtn setFrameOrigin:NSMakePoint(98, 6)];
    }
    
    [self loadPreviewPicture];
}

//加载等待界面
-(void)loadPreviewPicture{
    [_loadingView setFrameOrigin:NSMakePoint((_bgWhiteView.frame.size.width - _loadingView.frame.size.width) / 2, (_bgWhiteView.frame.size.height - _loadingView.frame.size.height) / 2)];
    //    for (NSView *subView in _bgWhiteView.subviews) {
    //        [subView removeFromSuperview];
    //    }
    [_loadingView removeFromSuperview];
    [_loadingView setHidden:NO];
    [_loadingIndicator startAnimation:nil];
    [_bgWhiteView addSubview:_loadingView];
    [_processQueue addOperationWithBlock:^(void){
        [self performSelectorOnMainThread:@selector(getOriginalPicture) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(showPhotos) withObject:nil waitUntilDone:YES];
    }];
}
-(void)showPhotos{
    if (_imageView.imageSize.width > _bgWhiteView.frame.size.width || _imageView.imageSize.height > _bgWhiteView.frame.size.height) {
        [_imageView zoomImageToFit: self];
        _imageView.hasHorizontalScroller = NO;
        _imageView.hasVerticalScroller = NO;
    }
    [_loadingIndicator stopAnimation:nil];
    [_loadingView setHidden:YES];
    [_loadingView removeFromSuperview];
}

//获取原始图片
-(void)getOriginalPicture{
    if (_isMsgImage == YES) {
        _photoData = [_curPicture TIFFRepresentation];
    }else {
        if (_curPhotoEntity.photoKind == 0) {
            NSImage *photoImage = nil;
            if (_iPod) {
                NSString *surFilePath = [_curPhotoEntity.photoPath stringByAppendingPathComponent:_curPhotoEntity.photoName];
                //判断图片是否在设备上被剪切过
                if ([_curPhotoEntity.photoPath isEqualToString:@"DCIM/100APPLE"]) {
                    NSString *cutFilePath = [@"PhotoData/Metadata/" stringByAppendingPathComponent:surFilePath];
                    if ([_iPod.fileSystem fileExistsAtPath:cutFilePath]) {
                        surFilePath = cutFilePath;
                    }
                }
                _photoData = [self readFileData:surFilePath];
            }else{
                 photoImage = [[NSImage alloc] initWithContentsOfFile:_curPhotoEntity.thumbImagePath] ;
                _photoData = [photoImage TIFFRepresentation];
            }
        }
    }
    
    [self openImageData:_photoData];
    
    // customize the IKImageView...
    [_imageView setDoubleClickOpensImageEditPanel: YES];
    [_imageView setCurrentToolMode: IKToolModeMove];
    [_imageView zoomImageToActualSize: self];
    [_imageView setDelegate: self];
    _imageView.editable = YES;
    _imageView.autoresizes = NO;
    _imageView.autohidesScrollers = NO;
    _imageView.hasHorizontalScroller = NO;
    _imageView.hasVerticalScroller = NO;
    
    [[_imageView enclosingScrollView] reflectScrolledClipView:
     [[_imageView enclosingScrollView] contentView]];
}

- (void)doWhirl:(id)sender {
    NSSegmentedControl *segmentedControl = (NSSegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegment;
    if (selectedSegment == 0) {
        [self rotateLeft:sender];
    }else {
        [self rotateRight:sender];
    }
}

- (void)rotateLeft:(id)sender{
    float rotation = _imageView.rotationAngle;
    rotation += 90*M_PI/180.0;
    [_imageView setRotationAngle:rotation];
}

- (void)rotateRight:(id)sender{
    float rotation = _imageView.rotationAngle;
    rotation -= 90*M_PI/180.0;
    [_imageView setRotationAngle:rotation];
    
}

- (void)doNext:(id)sender {
    NSSegmentedControl *segmentedControl = (NSSegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegment;
    if (selectedSegment == 0) {
        [self doOnTheButton:sender];
    }else {
        [self doNextButton:sender];
    }
}

- (void)doNextButton:(id)sender {
    [_nextBtn setEnabled:YES forSegment:0];
    int index = 0;
    index = [_photoArray indexOfObject:_curPhotoEntity];
    if (index + 1 <= _photoArray.count - 1) {
        _curPhotoEntity = [_photoArray objectAtIndex:index +1];
    }
    if (index + 1 == _photoArray.count - 1) {
        [_nextBtn setEnabled:NO forSegment:1];
    }else if(index + 1 < _photoArray.count - 1){
        [_nextBtn setEnabled:YES forSegment:1];
    }
    [self loadPreviewPicture];
}

- (void)doOnTheButton:(id)sender {
    [_nextBtn setEnabled:YES forSegment:1];
    int index = 0;
    index = [_photoArray indexOfObject:_curPhotoEntity];
    if (index - 1 == 0) {
        [_nextBtn setEnabled:NO forSegment:0];
    }else if (index - 1 > 0) {
        [_nextBtn setEnabled:YES forSegment:0];
    }
    if (index - 1 >= 0) {
        _curPhotoEntity = [_photoArray objectAtIndex:index - 1];
    }
    [self loadPreviewPicture];
}

- (IBAction)switchToolMode: (id)sender
{
    // switch the tool mode...
    
    NSInteger newTool;
    
    if ([sender isKindOfClass: [NSSegmentedControl class]])
        newTool = [sender selectedSegment];
    else
        newTool = [sender tag];
    
    switch (newTool)
    {
        case 0:
            [_imageView setCurrentToolMode: IKToolModeMove];
            break;
        case 1:
            [_imageView setCurrentToolMode: IKToolModeSelect];
            break;
        case 2:
            [_imageView setCurrentToolMode: IKToolModeCrop];
            break;
        case 3:
            [_imageView setCurrentToolMode: IKToolModeRotate];
            break;
        case 4:
            [_imageView setCurrentToolMode: IKToolModeAnnotate];
            break;
    }
}

// ---------------------------------------------------------------------------------------------------------------------
- (IBAction)doZoom: (id)sender
{
    // handle zoom tool...
    
    NSInteger zoom;
    CGFloat   zoomFactor;
    
    if ([sender isKindOfClass: [NSSegmentedControl class]])
        zoom = [sender selectedSegment];
    else
        zoom = [sender tag];
    
    switch (zoom)
    {
        case 0:
            zoomFactor = [_imageView zoomFactor];
            [_imageView setZoomFactor:zoomFactor * ZOOM_OUT_FACTOR];
            break;
        case 1:
            [_imageView zoomImageToFit: self];
            _imageView.hasHorizontalScroller = NO;
            _imageView.hasVerticalScroller = NO;
            break;
        case 2:
            zoomFactor = [_imageView zoomFactor];
            [_imageView setZoomFactor:zoomFactor * ZOOM_IN_FACTOR];
            break;
        case 3:
            [_imageView zoomImageToActualSize: self];
            break;
    }
    
}

//读取设备里图片的data；
- (NSData *)readFileData:(NSString *)filePath {
    if (![_iPod.fileSystem fileExistsAtPath:filePath]) {
        return nil;
    }
    else{
        long long fileLength = [_iPod.fileSystem getFileLength:filePath];
        AFCFileReference *openFile = [_iPod.fileSystem openForRead:filePath];
        const uint32_t bufsz = 10240;
        char *buff = (char*)malloc(bufsz);
        NSMutableData *totalData = [[[NSMutableData alloc] init] autorelease];
        while (1) {
            uint32_t n = [openFile readN:bufsz bytes:buff];
            if (n==0) break;
            //将字节数据转化为NSdata
            NSData *b2 = [[NSData alloc]
                          initWithBytesNoCopy:buff length:n freeWhenDone:NO];
            [totalData appendData:b2];
            [b2 release];
        }
        if (totalData.length == fileLength) {
            // NSLog(@"success readData 1111");
        }
        free(buff);
        [openFile closeFile];
        return totalData;
    }
}

- (void)windowWillClose:(NSNotification *)notification {
    [NSApp stopModal];
    [self releaseObject];
}

@end
