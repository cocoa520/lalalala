//
//  CocosSudo.h
//  CleanMac-OC
//
//  Created by iMobie on 11/28/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(* excutecallback)(char *);

int sudo(int argc, char *argv[]);
int cocosSudo(int argc, char *argv[]);
int useCocos(int argc, char *argv[], excutecallback callback);