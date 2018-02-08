//
//  fileutility.c
//  
//
//  Created by Pallas on 11/2/15.
//
//

#include <stdio.h>
#include "fileutility.h"
#include "utility.h"
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>
#include <stdlib.h>

/*
 获取所有的App信息
 path（In）：app根路径
 isroot（In）：用于释放内部生成的路径资源，默认传True，传入False会引发Free动作。
 findcallback（Out）：回调函数
 isStop（In/Out）：外部中止条件
 */
void trv_all_app(char *path, Bool isroot, findapplicationcallback findcallback, Bool *isStop) {
    if (path == NULL ) {
        return;
    }
    struct stat info;
    stat(path, &info);
    if (!(S_ISDIR(info.st_mode))) {
        return;
    }
    
    DIR *directory_pointer;
    struct dirent *entry;
    if ((directory_pointer = opendir(path)) == NULL) {
        printf("Error opening %s\n", path);
    } else{
        while ((entry = readdir(directory_pointer)) != NULL) {
            if (*isStop == True) {
                break;
            }
            if (strcmp(entry->d_name, ".")==0 ||
                strcmp(entry->d_name, "..")==0 ||
                endwith(entry->d_name, ".DS_Store") ||
                starwith(entry->d_name, ".")) {
                continue;
            }
            
            if (entry->d_type & DT_DIR) {
                char *ext = extensions(entry->d_name, TYPES_DIR);
                if (ext != NULL) {
                    if (strcmp(ext, "app") == 0) {
                        size_t len = strlen(path) + strlen(entry->d_name) + 2;
                        char* newpath = combine_strings((int)len, "%s/%s",path,entry->d_name);
                        if (findcallback != NULL) {
                            findcallback(newpath, True);
                        }
                        free(newpath);
                    }
                } else {
                    size_t len = strlen(path) + strlen(entry->d_name) + 2;
                    char* newpath = combine_strings((int)len, "%s/%s",path,entry->d_name);
                    if (findcallback != NULL) {
                        findcallback(newpath, False);
                    }
                    trv_all_app(newpath, False, findcallback, isStop);
                }
            }
        }
        closedir(directory_pointer);
    }
    if (isroot == False) {
        free(path);
    }
}

/*
 获取指定目录下的App信息
 path（In）：指定目录的路径
 findcallback（Out）：回调函数
 isStop（In/Out）：外部中止条件
 */
void trv_sub_app(char *path, findapplicationcallback findcallback, Bool *isStop) {
    if (path == NULL ) {
        return;
    }
    struct stat info;
    stat(path, &info);
    if (!(S_ISDIR(info.st_mode))) {
        return;
    }
    
    DIR *directory_pointer;
    struct dirent *entry;
    if ((directory_pointer = opendir(path)) == NULL) {
        printf("Error opening %s\n", path);
    } else{
        while ((entry = readdir(directory_pointer)) != NULL) {
            if (*isStop == True) {
                break;
            }
            if (strcmp(entry->d_name, ".")==0 ||
                strcmp(entry->d_name, "..")==0 ||
                endwith(entry->d_name, ".DS_Store") ||
                starwith(entry->d_name, ".")) {
                continue;
            }
            
            if (entry->d_type & DT_DIR) {
                char *ext = extensions(entry->d_name, TYPES_DIR);
                if (ext != NULL) {
                    if (strcmp(ext, "app") == 0) {
                        size_t len = strlen(path) + strlen(entry->d_name) + 2;
                        char* newpath = combine_strings((int)len, "%s/%s",path,entry->d_name);
                        if (findcallback != NULL) {
                            findcallback(newpath, True);
                        }
                        free(newpath);
                    }
                }
            }
        }
        closedir(directory_pointer);
    }
}

/*
 获取浏览器配置下载目录的下载文件文件（支持Safari、FirFox、Chrome、Opera浏览器）
 path（In）：下载的目录路径
 findcallback（Out）：回调函数
 isStop（In/Out）：外部中止条件
 */
void trv_sub_download(char *path, finddownloadcallback findcallback, Bool *isStop) {
    if (path == NULL ) {
        return;
    }
    struct stat info;
    stat(path, &info);
    if (!(S_ISDIR(info.st_mode))) {
        return;
    }
    
    DIR *directory_pointer;
    struct dirent *entry;
    if ((directory_pointer = opendir(path)) == NULL) {
        printf("Error opening %s\n", path);
    } else{
        while ((entry = readdir(directory_pointer)) != NULL) {
            if (*isStop == True) {
                break;
            }
            if (strcmp(entry->d_name, ".")==0 ||
                strcmp(entry->d_name, "..")==0 ||
                endwith(entry->d_name, ".DS_Store") ||
                starwith(entry->d_name, ".")) {
                continue;
            }
            
            printf("%s\r\n", entry->d_name);
            
            if (entry->d_type & DT_DIR) {
                char *ext = extensions(entry->d_name, TYPES_DIR);
                if (ext != NULL) {
                    if (strcmp(ext, "download") == 0 || strcmp(ext, "crdownload") == 0 || strcmp(ext, "part") == 0 || strcmp(ext, "opdownload") == 0) {
                        size_t len = strlen(path) + strlen(entry->d_name) + 2;
                        char* newpath = combine_strings((int)len, "%s/%s",path,entry->d_name);
                        if (findcallback != NULL) {
                            findcallback(newpath);
                        }
                        free(newpath);
                    }
                }
            } else if (entry->d_type & DT_REG) {
                char *ext = extensions(entry->d_name, TYPES_REG);
                if (ext != NULL) {
                    if (strcmp(ext, "download") == 0 || strcmp(ext, "crdownload") == 0 || strcmp(ext, "part") == 0 || strcmp(ext, "opdownload") == 0) {
                        size_t len = strlen(path) + strlen(entry->d_name) + 2;
                        char* newpath = combine_strings((int)len, "%s/%s",path,entry->d_name);
                        if (findcallback != NULL) {
                            findcallback(newpath);
                        }
                        free(newpath);
                    }
                }
            }
        }
        closedir(directory_pointer);
    }
}