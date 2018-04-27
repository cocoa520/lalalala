//
//  IMBSupportedArtworkFormat.h
//  iMobieTrans
//
//  Created by Pallas on 1/8/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum PixelFormate {
    // Summary:
    //     Specifies that the format is 16 bits per pixel; 5 bits each are used for
    //     the red, green, and blue components. The remaining bit is not used.
    Format16bppRgb555 = 135173,
    //
    // Summary:
    //     Specifies that the format is 16 bits per pixel; 5 bits are used for the red
    //     component, 6 bits are used for the green component, and 5 bits are used for
    //     the blue component.
    Format16bppRgb565 = 135174,
} PixelFormateEnum;

@interface IMBSupportedArtworkFormat : NSObject {
@private
    uint _formatID;
    uint _width, _height, _iThmbBlockSize;
    PixelFormateEnum _pixelFormat;
    BOOL _videoOnly;
}

@property (nonatomic, readwrite) BOOL videoOnly;
@property (nonatomic, readonly) uint formatID;
@property (nonatomic, readonly) uint height;
@property (nonatomic, readonly) uint width;
@property (nonatomic, readonly) uint iThmbBlockSize;
@property (nonatomic, readonly) PixelFormateEnum pixelFormat;

- (id)initWithiThmbBlockLength:(uint)formatID pixelFormat:(PixelFormateEnum)pixelFormat ithmbBlockLength:(uint)ithmbBlockLength;
- (id)initWithPixelFormat:(uint)formatID pixelFormat:(PixelFormateEnum)pixelFormat;
- (id)initWithImageSize:(uint)formatID pixelFormat:(PixelFormateEnum)pixelFormat width:(uint)width heigth:(uint)heigth;

// formats保存的是IMBSupportedArtworkFormat对象
+ (IMBSupportedArtworkFormat*)getFormatByFormatID:(uint)formatID formats:(NSMutableArray*)formats;
+ (void)getArtworkDimensions:(uint)formatID width:(uint*)width height:(uint*)height;

@end
