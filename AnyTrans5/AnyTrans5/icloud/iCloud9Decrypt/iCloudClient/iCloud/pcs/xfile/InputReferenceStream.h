//
//  InputReferenceStream.h
//
//
//  Created by JGehry on 8/8/16.
//
//
//  Complete

#import <Foundation/Foundation.h>
#import "DigestInputStream.h"

@class NSFileHandle;

@interface InputReferenceStream : Stream {
@private
    Stream *                            _inputStream;
    id                                  _reference;
}

- (id)reference;

- (id)initWithInputStream:(Stream*)inputStream reference:(id)reference;

- (int)read;

@end
