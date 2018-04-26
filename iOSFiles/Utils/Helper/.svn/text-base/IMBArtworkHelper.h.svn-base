//
//  IMBArtworkHelper.h
//  iMobieTrans
//
//  Created by Pallas on 1/10/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBSupportedArtworkFormat.h"

@class IMBiPod;
@class IMBIPodImageFormat;
@class IMBSupportedArtworkFormat;

#define ALPHA_BITS_555 1
#define ALPHA_SHIFT_555 15
#define ALPHA_MASK_555 (((1 << ALPHA_BITS_555) - 1) << ALPHA_SHIFT_555)

#define RED_BITS_555 5
#define RED_SHIFT_555 10
#define RED_MASK_555 (((1 << RED_BITS_555) - 1) << RED_SHIFT_555)

#define GREEN_BITS_555 5
#define GREEN_SHIFT_555 5
#define GREEN_MASK_555 (((1 << GREEN_BITS_555) - 1) << GREEN_SHIFT_555)

#define BLUE_BITS_555 5
#define BLUE_SHIFT_555 0
#define BLUE_MASK_555 (((1 << BLUE_BITS_555) - 1) << BLUE_SHIFT_555)

@interface IMBArtworkHelper : NSObject

+ (NSImage*)loadArtworkBitmapFromIThmb:(IMBiPod*)ipod imageFormat:(IMBIPodImageFormat*)imageFormat;
+ (NSData*)getByteData:(NSImage*)image;
+ (NSData *)convertToArtworkData:(NSImage*)image Format:(PixelFormateEnum)format;
+ (NSData*)generateResizedImageData:(NSImage*)origImage  SupportedFormat:(IMBSupportedArtworkFormat*)format;
@end
