//
//  curve25519.h
//  BackupTool_Mac
//
//  Created by Pallas on 1/15/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#ifndef BackupTool_Mac_curve25519_h
#define BackupTool_Mac_curve25519_h

#include <stdio.h>
#include <string.h>
#include <stdint.h>

typedef uint8_t u8;
typedef int64_t felem;

void curve25519(u8 *mypublic, const u8 *secret, const u8 *basepoint);

#endif
