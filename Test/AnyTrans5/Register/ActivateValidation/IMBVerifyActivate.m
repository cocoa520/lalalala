//
//  IMBVerifyActivate.m
//  PhoneClean3.0
//
//  Created by Pallas on 6/21/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBVerifyActivate.h"

const char mainkey[31] = {
    'O', 'Y', 'U', 'K', '8', 'E', 'L', 'S', 'T', '4', 'Z', '3', 'G', 'W', 'N', '7', 'A', 'M', 'J', 'B', 'F', 'I', 'V', 'D', 'H', 'R', '6', 'X', 'Q', 'P', 'C'
};

const char subkey[31][31] =
{
    {'E', 'M', 'D', '7', 'X', 'Y', '8', 'T', 'K', 'Z', 'G', '4', 'F', '6', 'W', 'A', '3', 'H', 'S', 'L', 'C', 'I', 'R', 'B', 'N', 'O', 'U', 'P', 'J', 'Q', 'V'},
    {'B', 'H', 'L', 'P', 'E', 'T', 'I', '7', 'G', 'X', '3', 'Q', 'N', 'F', 'K', 'U', 'W', 'V', 'J', 'S', '6', 'M', 'C', 'O', 'A', '4', '8', 'Z', 'R', 'Y', 'D'},
    {'H', 'B', '8', 'G', 'M', 'T', 'R', 'W', 'X', 'F', 'Y', 'K', 'E', 'L', 'C', 'S', '6', '3', 'P', 'D', 'N', '4', 'Z', 'I', 'A', '7', 'O', 'Q', 'J', 'U', 'V'},
    {'6', 'F', '4', 'H', 'X', '3', 'V', 'D', 'U', 'L', 'A', 'P', 'M', 'B', 'T', 'C', 'G', 'O', 'W', 'Z', 'N', 'Y', '8', 'E', 'I', 'J', '7', 'S', 'Q', 'R', 'K'},
    {'V', '6', 'F', 'U', 'T', 'X', 'B', 'N', 'A', 'Y', 'E', 'J', 'K', 'L', 'W', 'H', '4', '7', 'D', 'C', '8', 'P', 'R', 'O', '3', 'Q', 'I', 'G', 'M', 'Z', 'S'},
    {'A', 'F', 'J', 'W', 'N', 'B', 'X', 'O', '8', 'T', 'U', 'C', '7', 'G', '4', 'M', 'S', 'Z', 'H', 'R', 'P', 'E', '3', 'D', 'I', 'V', 'L', 'Q', '6', 'Y', 'K'},
    {'I', 'S', 'T', 'G', 'A', 'L', 'Z', 'Y', 'O', '7', 'N', 'H', 'J', '3', 'D', 'X', '4', 'M', 'F', 'Q', 'W', 'R', 'C', 'U', 'B', 'V', 'E', 'K', '8', '6', 'P'},
    {'K', 'B', 'H', '7', 'Q', '6', 'G', 'I', 'Y', 'N', 'M', 'S', 'Z', 'O', 'E', 'U', 'A', '8', 'P', 'T', 'R', '4', 'D', 'L', 'F', 'X', 'V', 'W', '3', 'C', 'J'},
    {'R', 'Q', 'Y', '3', '7', 'C', 'O', 'W', 'D', '4', 'H', 'K', 'E', 'B', '6', 'F', 'V', 'N', 'M', 'A', 'P', 'S', 'Z', 'J', 'T', 'U', '8', 'G', 'L', 'I', 'X'},
    {'X', 'Y', 'T', 'I', 'D', 'K', 'C', '7', 'Z', 'V', 'U', 'L', '8', 'B', 'F', 'S', 'R', 'E', 'G', 'P', 'W', 'M', 'N', '4', 'A', 'Q', 'J', '3', '6', 'O', 'H'},
    
    {'3', '4', 'Q', 'N', 'W', 'Z', 'M', 'A', 'K', 'T', 'S', 'G', 'Y', 'O', 'E', 'R', 'C', 'U', 'P', 'F', 'I', 'H', 'B', 'L', 'V', '6', '8', 'X', 'D', 'J', '7'},
    {'J', '6', 'T', 'Y', 'P', 'I', 'S', 'C', '7', 'D', 'B', 'Z', 'W', 'A', 'H', 'U', 'V', 'M', 'E', '3', 'Q', 'N', 'F', '8', 'L', '4', 'G', 'K', 'R', 'X', 'O'},
    {'4', 'C', 'Y', 'A', '8', 'R', '3', 'N', 'P', 'S', 'E', 'F', 'O', 'T', 'Z', 'V', 'B', 'L', 'X', 'J', 'U', 'D', 'W', 'K', 'M', '6', 'Q', '7', 'H', 'G', 'I'},
    {'T', 'K', 'H', 'U', 'R', 'M', '3', 'X', 'G', '6', 'Z', 'B', 'E', 'W', 'O', 'Y', 'P', 'V', '7', 'C', '4', 'D', '8', 'I', 'S', 'J', 'A', 'Q', 'F', 'N', 'L'},
    {'D', 'T', '8', 'A', 'G', 'M', 'Z', 'O', 'W', 'P', 'I', 'H', 'N', 'K', 'X', '4', 'Y', '7', 'C', 'F', 'R', '6', 'S', 'L', 'B', 'V', 'E', 'J', '3', 'U', 'Q'},
    {'6', 'P', 'T', 'N', 'E', 'Q', 'K', 'Y', 'V', 'W', 'I', 'L', 'D', '8', 'B', 'A', 'X', 'R', '7', 'F', 'S', 'U', 'O', '3', 'C', 'G', 'J', 'H', 'M', '4', 'Z'},
    {'J', 'N', 'X', 'F', 'T', 'Z', 'D', '6', 'K', 'A', 'Q', 'M', 'G', 'E', 'W', 'P', 'S', 'L', 'C', '3', 'O', 'B', 'Y', '4', 'I', 'R', 'U', 'H', 'V', '8', '7'},
    {'C', 'J', '7', 'X', 'V', 'K', 'R', 'Q', 'S', 'B', '3', 'Z', 'G', 'O', 'E', 'M', '4', 'T', 'Y', '6', 'L', 'I', 'H', 'N', 'W', 'D', '8', 'F', 'U', 'A', 'P'},
    {'H', '4', '3', 'M', '7', 'V', 'T', 'Z', 'A', 'R', 'I', 'J', 'W', 'P', 'D', 'G', 'Q', 'E', 'N', 'C', 'X', '8', 'Y', 'L', 'F', 'B', 'O', 'U', 'K', 'S', '6'},
    {'H', '3', 'J', '6', 'S', 'R', 'O', 'D', 'B', 'E', 'V', 'Z', 'Y', 'G', '8', 'U', 'W', 'A', '7', 'F', 'N', 'M', '4', 'L', 'P', 'T', 'C', 'I', 'K', 'X', 'Q'},
    
    {'V', 'U', 'A', '6', 'I', '7', 'B', 'M', 'G', 'X', 'Z', 'H', 'P', 'W', 'S', 'R', 'E', '3', 'J', 'F', 'C', '8', 'Q', 'K', 'D', 'L', 'O', 'T', 'N', '4', 'Y'},
    {'I', 'Q', 'B', 'H', 'P', '4', 'D', '7', 'C', 'G', '3', 'K', 'L', 'R', 'M', 'W', 'U', 'V', 'Y', 'A', '6', 'N', 'O', 'X', 'Z', 'J', 'T', 'E', 'S', 'F', '8'},
    {'I', 'D', 'E', 'A', 'S', 'V', 'C', 'Y', 'J', 'X', '4', 'L', 'O', 'T', 'H', 'F', '8', '7', 'Z', '3', 'W', 'K', 'B', 'Q', 'U', 'M', 'G', '6', 'N', 'R', 'P'},
    {'U', '3', 'C', 'R', 'J', '6', 'Z', 'P', 'I', 'V', '4', '8', 'E', 'B', 'D', 'F', 'K', 'G', 'L', 'Y', 'A', 'O', 'T', 'W', 'N', 'X', '7', 'Q', 'S', 'M', 'H'},
    {'W', 'Q', '8', 'P', 'J', 'X', 'Z', 'A', 'D', '7', 'N', 'R', '6', 'T', 'K', 'H', 'F', 'I', 'L', 'G', 'C', 'U', 'B', 'V', 'M', 'S', 'Y', 'E', '3', '4', 'O'},
    {'M', 'H', 'I', 'G', 'D', 'O', 'V', '4', '3', 'Y', 'E', 'Z', 'Q', '6', 'F', 'N', '8', '7', 'P', 'C', 'S', 'K', 'B', 'J', 'X', 'T', 'U', 'L', 'A', 'W', 'R'},
    {'L', 'S', 'N', 'I', 'K', 'H', 'V', 'E', 'M', 'T', '4', 'B', 'F', '6', 'G', 'W', 'P', '7', 'Q', 'X', 'J', '3', 'R', 'U', 'O', 'D', 'C', 'Y', 'Z', '8', 'A'},
    {'E', 'N', 'W', '7', 'Z', 'R', 'K', 'I', 'S', 'G', 'H', 'O', '6', 'B', '8', 'V', '4', 'M', 'F', 'X', 'T', 'C', 'L', 'J', 'P', 'A', '3', 'Y', 'D', 'Q', 'U'},
    {'P', 'U', 'A', 'N', '4', 'C', 'D', 'Q', 'Z', '7', 'F', 'J', 'V', 'E', '6', '3', 'M', 'H', 'G', 'Y', 'T', 'L', '8', 'O', 'R', 'S', 'X', 'W', 'B', 'K', 'I'},
    {'G', '8', 'I', '6', 'U', 'T', 'X', 'Z', 'Q', 'C', 'E', 'Y', 'W', 'F', 'B', 'H', 'J', 'O', '3', 'A', 'D', 'R', 'L', 'K', '4', '7', 'P', 'S', 'M', 'V', 'N'},
    
    {'N', 'P', 'H', '8', 'M', 'D', 'L', '7', 'I', 'S', 'A', 'Z', 'K', 'C', 'J', 'R', 'G', '4', 'U', 'W', 'O', 'E', 'V', 'Y', 'Q', 'B', 'T', '3', 'X', '6', 'F'}
};

static const int d_1 = 4;
static const int e_1 = 5;
static const int f_1 = 10;
static const int g_1 = 9;
static const int h_1 = 4;
static const int i_1 = 4;
static const int j_1 = 10;
static const int k_1 = 10;
static const int l_1 = 10;
static const int m_1 = 2013;

@implementation IMBVerifyActivate

static KeyStateStruct ks;

+ (KeyStateStruct *)activate:(NSString *)key id1:(char)id1 id2:(char)id2 {
    int a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t;
    char A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T;
    
    ks.activiate = 0;
    ks.license = 0;
    ks.quota = 0;
    ks.duration = 0;
    ks.timelimitation = 0;
    ks.versiolimitation = 0;
    ks.version1 = 0;
    ks.version2 = 0;
    ks.version3 = 0;
    ks.year = 0;
    ks.month = 0;
    ks.day = 0;
    ks.valid = false;
	ks.reserved1 = 0;
	ks.reserved2 = 0;
	ks.reserved3 = 0;
    
    char* key1 = NULL;
    char* key2 = NULL;
    char* key3 = NULL;
    if ([key length] != 24) {
        return &ks;
    }
    
    const char *keyChar = [key UTF8String];
    A = keyChar[0];B = keyChar[1];C = keyChar[2];D = keyChar[3];
    E = keyChar[5];F = keyChar[6];G = keyChar[7];H = keyChar[8];
    I = keyChar[10];J = keyChar[11];K = keyChar[12];L = keyChar[13];
    M = keyChar[15];N = keyChar[16];O = keyChar[17];P = keyChar[18];
    Q = keyChar[20];R = keyChar[21];S = keyChar[22];T = keyChar[23];
    
    if ([self getPosByChar:id1 list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:id2 list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:A list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:B list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:C list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:D list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:E list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:F list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:G list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:H list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:I list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:J list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:K list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:L list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:M list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:N list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:O list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:P list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:Q list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:R list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:S list:mainkey len:31] == -1) {
        return &ks;
    }
    if ([self getPosByChar:T list:mainkey len:31] == -1) {
        return &ks;
    }
    
    a = [self getPosByChar:id1 list:mainkey len:31];
    key1 = (char*)subkey[a];
    a = [self getPosByChar:A list:key1 len:31];
    if (a != 0) {
        return &ks;
    }
    b = [self getPosByChar:id2 list:mainkey len:31];
    key2 = (char*)subkey[b];
    b = [self getPosByChar:B list:key2 len:31];
    if (b != 30) {
        return &ks;
    }
    c = [self getPosByChar:C list:mainkey len:31];
    key3 = (char*)subkey[c];
    d = [self getPosByChar:D list:key2 len:31];
    
    e = [self getPosByChar:E list:key1 len:31];
    f = [self getPosByChar:F list:key1 len:31];
    g = [self getPosByChar:G list:key1 len:31];
    h = [self getPosByChar:H list:key2 len:31];
    
    i = [self getPosByChar:I list:key2 len:31];
    j = [self getPosByChar:J list:key3 len:31];
    k = [self getPosByChar:K list:key3 len:31];
    l = [self getPosByChar:L list:key3 len:31];
    
    m = [self getPosByChar:M list:key3 len:31];
    n = [self getPosByChar:N list:key3 len:31];
    o = [self getPosByChar:O list:key3 len:31];
    p = [self getPosByChar:P list:key3 len:31];
    
    int sum = (a + b + c + d + e + f + g + h + i + j + k + l + m + n + o + p) % 31;
    q = [self getPosByChar:Q list:key1 len:31];
    r = [self getPosByChar:R list:key2 len:31];
    s = [self getPosByChar:S list:key3 len:31];
    t = [self getPosByChar:T list:mainkey len:31];
    if(q != sum)return &ks;
    if(r != sum)return &ks;
    if(s != sum)return &ks;
    if(t != sum)return &ks;
    
    ks.activiate = d % d_1;
    ks.license = e % e_1;
    ks.quota = f % f_1;
    ks.duration = g % g_1;
    ks.timelimitation = h % h_1;
    ks.versiolimitation = i % i_1;
    ks.version1 = j % j_1;
    ks.version2 = k % k_1;
    ks.version3 = l % l_1;
    ks.year = m + m_1;
    ks.month = n + 1;
    ks.day = o + 1;
    ks.valid = true;
    
    return &ks;
}

+ (KeyStateStruct *)verify:(NSString *)key id1:(char)id1 id2:(char)id2 {
    return [self activate:key id1:id1 id2:id2];
}

+ (int)getPosByChar:(char)key list:(const char*)list len:(int)len {
    for(int i = 0; i < len; i++)
    {
        if(list[i] == key)return i;
    }
    return -1;
}

@end
