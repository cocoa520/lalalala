//
//  IMBHash72.cpp
//  iMobieTrans
//
//  Created by Pallas on 1/17/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#include "IMBHash72.h"
#include <cstdio>
#include <cstring>
#include <openssl/sha.h>
extern "C"
{
    #include "rijndael.h"
}

const uint8_t aes_key[16] = { 0x61, 0x8c, 0xa1, 0x0d, 0xc7, 0xf5, 0x7f, 0xd3, 0xb4, 0x72, 0x3e, 0x08, 0x15, 0x74, 0x63, 0xd7};

struct Hash78Info {
    uint8_t header[6];
    uint8_t uuid[20];
    uint8_t rndpart[12];
    uint8_t iv[16];
};

int hash_extract(const uint8_t signature[46], const uint8_t sha1[20], uint8_t iv[16], uint8_t random_bytes[12]) {
    uint8_t plaintext[32] = { 0x00 }, output[32] = { 0x00 };
    if (signature[0] != 0x01 || signature[1] != 0x00) {
        return -1;
    }
    memcpy(plaintext, sha1, 20);
    memcpy(&plaintext[20], &signature[2], 12);
    
    memcpy(output, plaintext, 32);
    aes_set_key((uint8_t*)aes_key);
    aes_encrypt(plaintext, (uint8_t*)&signature[14], output, 16);
    if (memcmp(&plaintext[16], &output[16], 16)) {
		return -1;
	}
    memcpy(iv, output, 16);
    memcpy(random_bytes, &signature[2], 12);
    return 0;
}

struct Hash78Info fill_hash_info(uint8_t iv[16], uint8_t rndpart[12], const char uuid[]) {
    struct Hash78Info hash_info;
    const char header[] = "HASHv0";
    memcpy(hash_info.header, header, sizeof(hash_info.header));
    memcpy(hash_info.uuid, uuid, sizeof(hash_info.uuid));
    memcpy(hash_info.iv, iv, sizeof(hash_info.iv));
    memcpy(hash_info.rndpart, rndpart, sizeof(hash_info.rndpart));
    return hash_info;
}

struct Hash78Info* get_hash_info(const uint8_t signature[46], uint8_t sha1[20], char *uuid) {
    struct Hash78Info *info = NULL;
    uint8_t iv[16] = { 0x00 };
    uint8_t random_bytes[12] = { 0x00 };
    hash_extract(signature, sha1, iv, random_bytes);
    Hash78Info temp = fill_hash_info(iv, random_bytes, uuid);
    info = &temp;
    return info;
}

void hash72ComputeSha1(uint8_t *buf, int len, uint8_t sha1[20]) {
    SHA_CTX content;
    SHA1_Init(&content);
    SHA1_Update(&content, buf, len);
    SHA1_Final(sha1, &content);
}

void hash72Generate(uint8_t signature[46], uint8_t sha1[20], uint8_t iv[16], uint8_t random_bytes[12]) {
    uint8_t output[32] = { 0x00 };
    uint8_t plaintext[32] = { 0x00 };
    memcmp(plaintext, sha1, 20);
    memcmp(&plaintext[20], random_bytes, 12);
    signature[0] = 0x01;
    signature[1] = 0x00;
    memcpy(&signature[2], random_bytes, 12);
    aes_set_key((uint8_t*)aes_key);
    aes_encrypt(iv, plaintext, output, 32);
    memcpy(&signature[14], output, 32);
}

bool hash72ComputeHashForSha1(uint8_t *buf, uint8_t sha1[20], uint8_t preSignature[46], uint8_t signature[46], char *uuid) {
    struct Hash78Info *hash_info;
    hash_info = get_hash_info(preSignature,sha1, uuid);
    if (hash_info == NULL) {
        return false;
    }
    hash72Generate(signature, sha1, hash_info->iv, hash_info->rndpart);
    return true;
}

void Hash72File(uint8_t *buf, uint8_t preSignature[46], uint8_t signature[46], int len, char *uuid) {
    uint8_t sha1[20] = { 0x00 };
    if (len < 0x6c) {
        return;
    }
    hash72ComputeSha1(buf, len, sha1);
    hash72ComputeHashForSha1(buf, sha1, preSignature, signature, uuid);
}