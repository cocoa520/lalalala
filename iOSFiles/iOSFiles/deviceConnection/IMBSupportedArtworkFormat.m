//
//  IMBSupportedArtworkFormat.m
//  iMobieTrans
//
//  Created by Pallas on 1/8/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBSupportedArtworkFormat.h"

@implementation IMBSupportedArtworkFormat
@synthesize videoOnly = _videoOnly;
@synthesize formatID = _formatID;
@synthesize height = _height;
@synthesize width = _width;
@synthesize iThmbBlockSize = _iThmbBlockSize;
@synthesize pixelFormat = _pixelFormat;

- (id)initWithiThmbBlockLength:(uint)formatID pixelFormat:(PixelFormateEnum)pixelFormat ithmbBlockLength:(uint)ithmbBlockLength {
    self = [self initWithPixelFormat:formatID pixelFormat:pixelFormat];
    if (self) {
        _iThmbBlockSize = ithmbBlockLength;
    }
    return self;
}

- (id)initWithPixelFormat:(uint)formatID pixelFormat:(PixelFormateEnum)pixelFormat {
    self = [super init];
    if (self) {
        _formatID = formatID;
        _pixelFormat = pixelFormat;
        [IMBSupportedArtworkFormat getArtworkDimensions:_formatID width:&_width height:&_height];
    }
    return self;
}

- (id)initWithImageSize:(uint)formatID pixelFormat:(PixelFormateEnum)pixelFormat width:(uint)width heigth:(uint)heigth {
    self = [super init];
    if (self) {
        _formatID = formatID;
        _pixelFormat = pixelFormat;
        _width = width;
        _height = heigth;
    }
    return self;
}

// NSMutableArray保存的是IMBSupportedArtworkFormat对象
+ (IMBSupportedArtworkFormat*)getFormatByFormatID:(uint)formatID formats:(NSMutableArray*)formats {
    for (IMBSupportedArtworkFormat *format in formats) {
        if ([format formatID] == formatID) {
            return format;
        }
    }
    return nil;
}

+ (void)getArtworkDimensions:(uint)formatID width:(uint*)width height:(uint*)height {
    switch (formatID)
    {
        case 1:  //full resolution image
            *width = 1000; *height = 1000;
            break;
            
        case 1009:
            *width = 42; *height = 30;
            break;
            
        case 1013:
            *width = 220; *height = 176;
            break;
            
        case 1015:
            *width = 130; *height = 88;
            break;
            
        case 1016:
            *width = 140; *height = 140;
            break;
            
        case 1017:
            *width = 56; *height = 56;
            break;
            
        case 1019:
            *width = 720; *height = 480;
            break;
            
        case 1023:
            *width = 176; *height = 132;
            break;
            
        case 1024:
            *width = 320; *height = 240;
            break;
            
        case 1027:
            *width = 100; *height = 100;
            break;
            
        case 1028:
            *width = 100; *height = 100;
            break;
            
        case 1029:
            *width = 200; *height = 200;
            break;
            
        case 1031:
            *width = 42; *height = 42;
            break;
            
        case 1032:
            *width = 42; *height = 37;
            break;
            
        case 1036:
            *width = 50; *height = 41;
            break;
            
        case 1055:
            *width = 128; *height = 128;
            break;
            
        case 1056:
            *width = 80; *height = 80;
            break;
            
        case 1060:
            *width = 320; *height = 320;
            break;
            
        case 1061:
            *width = 56; *height = 55;
            break;
            
        case 1062:
            *width = 56; *height = 56;
            break;
            
        case 1066:
            *width = 64; *height = 64;
            break;
            
        case 1068:
            *width = 128; *height = 128;
            break;
            
        case 1071:
            *width = 240; *height = 240;
            break;
            
        case 1073:
            *width = 50; *height = 50;
            break;
            
        case 1074:
            *width = 50; *height = 50;
            break;
            
        case 1078:
            *width = 80; *height = 80;
            break;
            
        case 1079:
            *width = 80; *height = 80;
            break;
            
        case 1081:
            *width = 640; *height = 480;
            break;
            
        case 1084:
            *width = 240; *height = 240;
            break;
            
        case 1087:
            *width = 384; *height = 384;
            break;
            
        case 3001:
            *width = 256; *height = 256;
            break;
            
        case 3002:
            *width = 128; *height = 128;
            break;
            
        case 3003:
            *width = 64; *height = 64;
            break;
            
        case 3004:
            *width = 56; *height = 55;
            break;
            
        case 3005:
            *width = 320; *height = 320;
            break;
            
        case 3006:
            *width = 55; *height = 55;
            break;
            
        case 3007:
            *width = 88; *height = 88;
            break;
            
        case 3008:
            *width = 640; *height = 480;
            break;
            
        case 3009:
            *width = 160; *height = 120;
            break;
            
        case 3011:
            *width = 80; *height = 79;
            break;
            
        default:
            *width = 0; *height = 0;
            break;
    }
}

@end