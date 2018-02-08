//
//  fileutility.h
//  
//
//  Created by Pallas on 11/2/15.
//
//

#ifndef ____fileutility__
#define ____fileutility__

#include "common.h"

/*
 查找App进度的回调函数
 path（Out）：查找到的App路径
 is_app（Out）：是否是一个App程序
 */
typedef void(* findapplicationcallback)(char *path, Bool is_app);

/*
 查找下载的浏览器下载文件
 path（Out）：找到的下载文件地址
 */
typedef void(* finddownloadcallback)(char *path);

/*
 获取所有的App信息
 path（In）：app根路径
 isroot（In）：用于释放内部生成的路径资源，默认传True，传入False会引发Free动作。
 findcallback（Out）：回调函数
 isStop（In/Out）：外部中止条件
 */
EXTERN void trv_all_app(char *path, Bool isroot, findapplicationcallback findcallback, Bool *isStop);

/*
 获取指定目录下的App信息
 path（In）：指定目录的路径
 findcallback（Out）：回调函数
 isStop（In/Out）：外部中止条件
 */
EXTERN void trv_sub_app(char *path, findapplicationcallback findcallback, Bool *isStop);

/*
 获取浏览器配置下载目录的下载文件文件（支持Safari、FirFox、Chrome、Opera浏览器）
 path（In）：下载的目录路径
 findcallback（Out）：回调函数
 isStop（In/Out）：外部中止条件
 */
EXTERN void trv_sub_download(char *path, finddownloadcallback findcallback, Bool *isStop);

#endif /* defined(____fileutility__) */
