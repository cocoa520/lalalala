//
//  IMBArtworkHelper.m
//  iMobieTrans
//
//  Created by Pallas on 1/10/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBArtworkHelper.h"
#import "IMBIPodImageFormat.h"
#import "MediaHelper.h"
#import "IMBSupportedArtworkFormat.h"
#import "IMBFileSystem.h"
#import "IMBDeviceInfo.h"
#import "IMBFileSystem.h"
#import <Accelerate/Accelerate.h>
#import "NSImage+IMBCropExtensions.h"

@implementation IMBArtworkHelper

+ (NSImage*)loadArtworkBitmapFromIThmb:(IMBiPod*)ipod imageFormat:(IMBIPodImageFormat*)imageFormat {
    NSString *ithmbFileName = nil;
    
    if ([imageFormat isPhoto] == TRUE) {
        ithmbFileName = [MediaHelper getiPodPathToStandardPath:[[[ipod fileSystem] photoFolderPath] stringByAppendingPathComponent:[imageFormat getFileName]]];
    } else {
        ithmbFileName = [MediaHelper getiPodPathToStandardPath:[[[ipod fileSystem] artworkFolderPath] stringByAppendingPathComponent:[imageFormat getFileName]]];
    }
    
    NSData *imageData = nil;
    
    if ([[ipod deviceInfo] isIOSDevice]) {
        AFCFileReference *fileHandle  = [[ipod fileSystem] openForRead:ithmbFileName];
        if (fileHandle != nil) {
            [fileHandle seek:[imageFormat fileOffset] mode:0];
            char *buff = (char*)malloc([imageFormat imageSize] + 1);
            memset(buff, 0, [imageFormat imageSize]);
            [fileHandle readN:[imageFormat imageSize] bytes:buff];
            imageData = [[NSData dataWithBytes:buff length:[imageFormat imageSize]] retain];
            free(buff);
        }
    } else {
        NSFileHandle *fileHandle = [[ipod fileSystem] openForRead:ithmbFileName];
        if (fileHandle != nil) {
            NSLog(@"imageFormat fileOffset %d",[imageFormat fileOffset]);
            NSLog(@"imageFormat imageSize %d",[imageFormat imageSize]);
            [fileHandle seekToFileOffset:[imageFormat fileOffset]];
            NSData *imgData = [fileHandle readDataOfLength:[imageFormat imageSize]];
            imageData = [imgData retain];
            [fileHandle closeFile];
        }
    }
    
    NSMutableArray *supportedFormats = nil;
    
    if ([imageFormat isPhoto] == TRUE) {
        supportedFormats = [[ipod deviceInfo] supportedPhoteFormats];
        NSLog(@"supportedPhoteFormats %lu", (unsigned long)supportedFormats.count);
    } else {
        supportedFormats = [[ipod deviceInfo] supportedArtworkFormats];
        NSLog(@"supportedFormats %lu", (unsigned long)supportedFormats.count);
    }
    
    IMBSupportedArtworkFormat *supportedFormat = nil;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSLog(@"evaluatedObject formatID %d",[(IMBIPodImageFormat*)evaluatedObject formatID]);
        NSLog(@"imageFormat formatID %d",[imageFormat formatID]);
        return ([(IMBIPodImageFormat*)evaluatedObject formatID] == [imageFormat formatID]);
    }];
    NSArray *preArray = [supportedFormats filteredArrayUsingPredicate:pre];
    if (preArray != nil && [preArray count] > 0) {
        supportedFormat = [preArray objectAtIndex:0];
    }
    
    NSImage *image = nil;
    if ([imageFormat formatID] == 1) {
        image = [[[NSImage alloc] initWithData:imageData] autorelease];
    } else {
        //[imageData writeToFile:@"/Users/hotdog19/Desktop/bg/artwork.png" atomically:true];
        //image = [[[NSImage alloc] initWithData:imageData] autorelease];
        if (supportedFormat == nil) {
            return nil;
        }
        if ([imageData length] > 0) {
            unsigned char data[imageData.length];
            [imageData getBytes:data length:imageData.length];
            
            NSData* data1 = RGB565DataToRGBAData(data, supportedFormat.width, supportedFormat.height);
            //[data1 writeToFile:@"/Users/hotdog19/Desktop/bg/artworkRGBA.bmp" atomically:true];
            //unsigned char data2 [4 * supportedFormat.width * supportedFormat.height];
            void* data2 = malloc((supportedFormat.width * 4) * supportedFormat.height);
            [data1 getBytes:data2 length:4 * supportedFormat.width * supportedFormat.height];
            
            NSBitmapImageRep * bitmap = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:(unsigned char **)&data2
                                                                                  pixelsWide:supportedFormat.width pixelsHigh:supportedFormat.height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:supportedFormat.width * 4 bitsPerPixel:32];

            
            
            //NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithData:data1];
            if (bitmap != nil) {
                NSLog(@"dadadfaf");
            } else {
                NSLog(@"dadfa11");
            }
            
            image = [[[NSImage alloc] initWithSize:NSMakeSize(supportedFormat.width, supportedFormat.height)] autorelease];
            [image addRepresentation:bitmap];
            [bitmap release];
            
            free(data2);
            /*
            if (supportedFormat.pixelFormat == Format16bppRgb555) {
                image = ConvertRGB555ToNSImage(data, supportedFormat.width, supportedFormat.height);
            } else {
                image = ConvertRGB565ToNSImage(data, supportedFormat.width, supportedFormat.height);
            }
            */
            
            
            /*
            [NSGraphicsContext saveGraphicsState];
            [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:[self getBitmapImageRep:[supportedFormat pixelFormat] :[supportedFormat width] :[supportedFormat height]]]];
            
            NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithData:imageData];
            NSImage *image = [[NSImage alloc] init];
            [image addRepresentation:bitmapRep];
            [bitmapRep release];
            [image drawAtPoint:NSMakePoint(0.0, 0.0)
                      fromRect:NSMakeRect(0.0, 0.0, [supportedFormat width], [supportedFormat height])
                     operation:NSCompositeSourceOver
                      fraction:1.0];
            [NSGraphicsContext restoreGraphicsState];
            */
        }
        
    }
    //[image autorelease];
    return image;
}

+ (NSData*)generateResizedImageData:(NSImage*)origImage  SupportedFormat:(IMBSupportedArtworkFormat*)format {
    //NSImage *image = nil;
    /*
    [origImage lockFocus];
    NSRect imageRect = NSMakeRect(0, 0, format.width, format.height);
    NSJPEGFileType
    NSBitmapImageRep *myBitmapImageRep = [[[NSBitmapImageRep alloc] initWithFocusedViewRect:imageRect] autorelease];
    [origImage unlockFocus];
    image = [[NSImage alloc] init];
    [image addRepresentation:myBitmapImageRep];
    [image autorelease];
    return image;
    */
    
    
    int width = format.width;
    int height = format.height;
    NSImage *croppedImage = [origImage imageToFitRect:NSMakeRect(0, 0, width, height) method:IMBImageResizeCrop];
    NSData *data =[IMBArtworkHelper convertToArtworkData:croppedImage Format:format.pixelFormat];
    return data;
}



/*
+ (NSImage*)generateResizedImage:(NSImage*)origImage:(IMBSupportedArtworkFormat*)format {
    NSImage *image = nil;
    [origImage lockFocus];
    NSRect imageRect = NSMakeRect(0, 0, format.width, format.height);
    NSBitmapImageRep *myBitmapImageRep = [[[NSBitmapImageRep alloc] initWithFocusedViewRect:imageRect] autorelease];
    [origImage unlockFocus];
    image = [[NSImage alloc] init];
    [image addRepresentation:myBitmapImageRep];
    [image autorelease];
    return image;
}
*/


+ (NSData*)getByteData:(NSImage*)image {
    return [image TIFFRepresentation];
}

/*
+ (NSBitmapImageRep*)getBitmapImageRep:(PixelFormateEnum)pixelFormat:(uint16)width:(uint)height {
    NSBitmapImageRep *bitmapRep = nil;
    switch (pixelFormat) {
        case Format16bppRgb555:
           bitmapRep = [[NSBitmapImageRep alloc]
                        initWithBitmapDataPlanes:nil
                        pixelsWide:width
                        pixelsHigh:height
                        bitsPerSample:5
                        samplesPerPixel:3
                        hasAlpha:NO
                        isPlanar:NO
                        colorSpaceName:NSDeviceRGBColorSpace
                        bytesPerRow:width * 3
                        bitsPerPixel:15];
            break;
            
        case Format16bppRgb565:
            bitmapRep = [[NSBitmapImageRep alloc]
                         initWithBitmapDataPlanes:nil
                         pixelsWide:width
                         pixelsHigh:height
                         bitsPerSample:5
                         samplesPerPixel:3
                         hasAlpha:NO
                         isPlanar:NO
                         colorSpaceName:NSDeviceRGBColorSpace
                         bytesPerRow:width * 3
                         bitsPerPixel:16];
            break;
            
        default:
            break;
    }
    return bitmapRep;
}

*/





//这部分先头测试的部分，转换后的数值不是太对。

uint32_t RGB565toRGBA(uint16_t rgb565)
{
	uint16_t temp = CFSwapInt16BigToHost(rgb565); // swap bytes for Big-Endian (data[0] = 0xRRRRRGGG, data[1] = 0xGGGBBBBB) bitmap
	uint8_t red, green, blue; //these only need to be one byte each
	red = (temp >> 11) & 0x1F;
	green = (temp >> 5) & 0x3F;
	blue = (temp & 0x001F);
	red = (red << 3) | (red >> 2);// RRRRR -> RRRRR000 00RRR
	green = (green << 2) | (green >> 4); //GGGGGG -> GGGGGG00 -> GG
	blue = (blue << 3) | (blue >> 2);
	return CFSwapInt32BigToHost((red << 24) | (green << 16) | (blue << 8) | 0xFF);
}

uint32_t RGB555toRGBA(uint16_t rgb555)
{
	uint16_t temp = CFSwapInt16BigToHost(rgb555); // swap bytes for Big-Endian (data[0] = 0x0RRRRRGG, data[1] = 0xGGGBBBBB) bitmap
	uint8_t red, green, blue; //these only need to be one byte each
	red = (temp >> 10) & 0x1F;
	green = (temp >> 5) & 0x1F;
	blue = (temp & 0x001F);
	red = (red << 3) | (red >> 2);// RRRRR -> RRRRR000 00RRR
	green = (green << 3) | (green >> 2); //GGGGGG -> GGGGGG00 -> GG
	blue = (blue << 3) | (blue >> 2);
	return CFSwapInt32BigToHost((red << 24) | (green << 16) | (blue << 8) | 0xFF);
}

/*
char* RGB555toRGBA(uint16_t rgb555)
{
	uint16_t temp = CFSwapInt16BigToHost(rgb555); // swap bytes for Big-Endian (data[0] = 0x0RRRRRGG, data[1] = 0xGGGBBBBB) bitmap
	uint8_t red, green, blue; //these only need to be one byte each
	red = (temp >> 10) & 0x1F;
	green = (temp >> 5) & 0x1F;
	blue = (temp & 0x001F);
	red = (red << 3) | (red >> 2);// RRRRR -> RRRRR000 00RRR
	green = (green << 3) | (green >> 2); //GGGGGG -> GGGGGG00 -> GG
	blue = (blue << 3) | (blue >> 2);
    char rgb[4];
    rgb[0] = red;
    rgb[1] = green;
    rgb[2] = blue;
    rgb[3] = 0xFF;
    return rgb;
	//return CFSwapInt32BigToHost((red << 24) | (green << 16) | (blue << 8) | 0xFF);
}
*/

NSImage* ConvertRGB555ToNSImage(unsigned char *data, int width, int height)
{
	unsigned short *src;
	unsigned long *dest;
	NSImage* image;
	NSBitmapImageRep* bitmap;
	int dstRowBytes;
    	
	bitmap = [[NSBitmapImageRep alloc]
              initWithBitmapDataPlanes: nil
              pixelsWide: width
              pixelsHigh: height
              bitsPerSample: 8
              samplesPerPixel: 4
              hasAlpha: YES
              isPlanar: NO
              colorSpaceName: NSCalibratedRGBColorSpace
              bytesPerRow: width * 4
              bitsPerPixel: 32];
	
	src = (unsigned short *) (data);
	dest = (unsigned long *) [bitmap bitmapData];
	dstRowBytes = [bitmap bytesPerRow];
	int i, end = width * height;
    unsigned long buffers[end];
	for (i=0; i<end; i++)
	{
		unsigned short *pixel = src;
		unsigned long destPixel = RGB555toRGBA(*pixel);
		*dest = destPixel;
        buffers[i] = destPixel;
		dest++;
		src++;
	}
    NSData *imgData = [[NSData alloc] initWithBytes:buffers length:end * 4];
    [imgData release];
	image = [[[NSImage alloc] initWithSize:NSMakeSize(width, height)] autorelease];
	[image addRepresentation:bitmap];
	[bitmap release];
	return image;
}



NSImage* ConvertRGB565ToNSImage(unsigned char *data, int width, int height)
{
	unsigned short *src;
	unsigned long *dest;
	NSImage* image;
	NSBitmapImageRep* bitmap;
	int dstRowBytes;
	
	bitmap = [[NSBitmapImageRep alloc]
              initWithBitmapDataPlanes: nil
              pixelsWide: width
              pixelsHigh: height
              bitsPerSample: 8
              samplesPerPixel: 4
              hasAlpha: YES
              isPlanar: NO
              colorSpaceName: NSCalibratedRGBColorSpace
              bytesPerRow: width * 4
              bitsPerPixel: 32];
	
	src = (unsigned short *) (data);
	dest = (unsigned long *) [bitmap bitmapData];
	dstRowBytes = [bitmap bytesPerRow];
	int i, end = width * height;
	for (i=0; i<end; i++)
	{
		unsigned short *pixel = src;
		unsigned long destPixel = RGB565toRGBA(*pixel);
		*dest = destPixel;
		dest++;
		src++;
	}
	image = [[[NSImage alloc] initWithSize:NSMakeSize(width, height)] autorelease];
	[image addRepresentation:bitmap];
	[bitmap release];
	return image;
}

//RGB565Data
+ (NSData*)convertToArtworkData:(NSImage*)image Format:(PixelFormateEnum)format
{
    CGImageRef cgimage = [image CGImageForProposedRect:NULL context:[NSGraphicsContext currentContext] hints:nil];
    CGContextRef cgctx = CreateARGBBitmapContext(cgimage);
    if (cgctx == NULL)
        return nil;
    
    size_t w = CGImageGetWidth(cgimage);
    size_t h = CGImageGetHeight(cgimage);
    CGRect rect = {{0,0},{w,h}};
    CGContextDrawImage(cgctx, rect, cgimage);
    
    void *data = CGBitmapContextGetData (cgctx);
    CGContextRelease(cgctx);
    
    if (!data)
        return nil;
    
    vImage_Buffer src;
    src.data = data;
    src.width = w;
    src.height = h;
    src.rowBytes = (w * 4);
    
    void* destData = malloc((w * 2) * h);
    
    vImage_Buffer dst;
    dst.data = destData;
    dst.width = w;
    dst.height = h;
    dst.rowBytes = (w * 2);
    
    if (format == Format16bppRgb555) {
        vImageConvert_ARGB8888toARGB1555(&src, &dst, 0);
    } else {
        vImageConvert_ARGB8888toRGB565(&src, &dst, 0);
    }
    
    size_t dataSize = 2 * w * h; // RGB565 = 2 5-bit components and 1 6-bit (16 bits/2 bytes)
    NSData *RGB565Data = [NSData dataWithBytes:dst.data length:dataSize];
    free(destData);
    return RGB565Data;
}

CGContextRef CreateARGBBitmapContext (CGImageRef inImage)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow   = (int)(pixelsWide * 4);
    bitmapByteCount     = (int)(bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
        return nil;
    
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease( colorSpace );
        return nil;
    }
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    
    return context;
}



//经过测试这个地方是对的，就是保存的时候需要再转换一次了。
NSData* RGB565DataToRGBAData(unsigned char *data, int width, int height) {
    vImage_Buffer src;
    src.data = data;
    src.width = width;
    src.height = height;
    src.rowBytes = (width * 2);
    
    void* destData = malloc((width * 4) * height);
    
    vImage_Buffer dst;
    dst.data = destData;
    dst.width = width;
    dst.height = height;
    dst.rowBytes = (width * 4);
    
    vImageConvert_RGB565toARGB8888(0xFF, &src, &dst, 0);
    static uint8_t channels[4] = {1,2,3,0};
    vImagePermuteChannels_ARGB8888(&dst, &dst, channels, kvImageDoNotTile);
    
    /*
    vImageConvert_ARGB8888toRGB565(&src, &dst, 0);
    */
    
    size_t dataSize = 4 * width * height; // RGB565 = 2 5-bit components and 1 6-bit (16 bits/2 bytes)
    NSData *RGBAData = [NSData dataWithBytes:dst.data length:dataSize];
    
    free(destData);
    
    return RGBAData;
}


/*
- (NSData *)RGB565Data
{
    CGContextRef cgctx = CreateARGBBitmapContext(self.CGImage);
    if (cgctx == NULL)
        return nil;
    
    size_t w = CGImageGetWidth(self.CGImage);
    size_t h = CGImageGetHeight(self.CGImage);
    CGRect rect = {{0,0},{w,h}};
    CGContextDrawImage(cgctx, rect, self.CGImage);
    
    void *data = CGBitmapContextGetData (cgctx);
    CGContextRelease(cgctx);
    
    if (!data)
        return nil;
    
    vImage_Buffer src;
    src.data = data;
    src.width = w;
    src.height = h;
    src.rowBytes = (w * 4);
    
    void* destData = malloc((w * 2) * h);
    
    vImage_Buffer dst;
    dst.data = destData;
    dst.width = w;
    dst.height = h;
    dst.rowBytes = (w * 2);
    
    vImageConvert_ARGB8888toRGB565(&src, &dst, 0);
    
    size_t dataSize = 2 * w * h; // RGB565 = 2 5-bit components and 1 6-bit (16 bits/2 bytes)
    NSData *RGB565Data = [NSData dataWithBytes:dst.data length:dataSize];
    
    free(destData);
    
    return RGB565Data;
}

- (CGImageRef)CGImage
{
    return [self CGImageForProposedRect:NULL context:[NSGraphicsContext currentContext] hints:nil];
}

CGContextRef CreateARGBBitmapContext (CGImageRef inImage)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow   = (int)(pixelsWide * 4);
    bitmapByteCount     = (int)(bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
        return nil;
    
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease( colorSpace );
        return nil;
    }
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    
    return context;
}
*/






@end