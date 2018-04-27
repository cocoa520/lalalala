//
//  IMBPlaylistPositionMHOD.h
//  MediaTrans
//
//  Created by Pallas on 12/17/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBBaseMHODElement.h"

@interface IMBPlaylistPositionMHOD : IMBBaseMHODElement{
@private
    Byte *_byteData;
    int byteDataLength;
    
@protected
    int _position;
}

@property (nonatomic,readwrite) int position;

-(void)create;

@end
