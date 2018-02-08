//
//  FileDecrypterInputStreams.m
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import "FileDecrypterInputStreams.h"
#import "BlockDecrypter.h"
#import "BlockDecrypters.h"
#import "CategoryExtend.h"
#import "FileDecrypterInputStream.h"

@implementation FileDecrypterInputStreams

+ (FileDecrypterInputStream*)create:(Stream*)input key:(NSMutableData*)key {
    BlockDecrypter *blockDecrypter = [BlockDecrypters create:key];
    return [[[FileDecrypterInputStream alloc] initWithInput:input withBlockDecrypter:blockDecrypter] autorelease];
}

@end
