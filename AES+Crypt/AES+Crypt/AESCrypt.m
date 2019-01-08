//
//  AESCrypt.m
//  AES+Crypt
//
//  Created by caoyong on 2019/1/4.
//  Copyright © 2019 caoyong. All rights reserved.
//

#import "AESCrypt.h"
//MARK:扩展类
#import "NSString+Empty.h"
#import "NSString+Base64.h"
#import "NSData+Base64.h"
//MARK:添加AES加密框架
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

//MARK:密钥长度：AES-256
size_t const KKEYSIZE = kCCKeySizeAES256;

@implementation AESCrypt

#pragma mark --- 根据Key和数据data使用AES256加密数据并返回加密后的Data数据

+(nullable NSData*)GeneralPurposeAES256EncryptWithKey:(nonnull NSString*)key withEncryptParamDatas:(nonnull NSData*)data withEncryptParamIV:(nullable NSString*)iv
{
    CCCryptorStatus cyyptStatus = kCCSuccess;
    // 定义一个字符数组keyPtr，元素个数是kCCKeySizeAES256+1
    // AES256加密，密钥应该是32位的
    char keyPtr[KKEYSIZE+1];
    // sizeof(keyPtr) 数组keyPtr所占空间的大小，即多少个个字节
    // bzero的作用是字符数组keyPtr的前sizeof(keyPtr)个字节为零且包括‘\0’。就是前32位为0，最后一位是\0
    bzero(keyPtr,sizeof(keyPtr));
    // NSString转换成C风格字符串
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    //MARK:数据大小
    NSUInteger dataLenth = [data length];
    //MARK: buffer缓冲，缓冲区
    //MARK:对于块加密算法：输出的大小<= 输入的大小 +  一个块的大小
    size_t bufferSize = dataLenth + kCCBlockSizeAES128;
    //MARK: malloc()函数其实就在内存中找一片指定大小的空间
    void*buffer = malloc(bufferSize);
    //MARK:size_t的全称应该是size type，就是说“一种用来记录大小的数据类型”。通常我们用sizeof(XXX)操作，这个操作所得到的结果就是size_t类型。
    //MARK:英文翻译：num 数量 Byte字节  encrypt解密
    size_t numBytesEncrypted = 0;
    //MARK:iv 向量参数
    if (![NSString isEmptyWithStr:iv]) {
        char ivPtr[KKEYSIZE + 1];
        memset(ivPtr,0,sizeof(ivPtr));
        [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
        //MARK:主要加密方法
        cyyptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding|kCCOptionECBMode, keyPtr, kCCKeySizeAES256, ivPtr, [data bytes], dataLenth, buffer, bufferSize, &numBytesEncrypted);
    }else{
         cyyptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding|kCCOptionECBMode, keyPtr, kCCKeySizeAES256, NULL, [data bytes], dataLenth, buffer, bufferSize, &numBytesEncrypted);
    }
    //MARK:加密结果
    if (cyyptStatus==kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

#pragma mark --- 使用AES256加密方式和Key将加加密的字符串数据解密并返回原来Data数据

+(nullable NSData*)GeneralPurposeAES256DecryptWithKey:(nonnull NSString*)key withDecryptParamDatas:(nonnull NSData*)data withDecryptParamIV:(nullable NSString*)iv
{
    CCCryptorStatus decryptStatus = kCCSuccess;
    char keyPtr[KKEYSIZE +1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    if (![NSString isEmptyWithStr:iv]) {
        char ivPtr[KKEYSIZE + 1];
        memset(ivPtr,0,sizeof(ivPtr));
        [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
        //MARK:主要解密方法
        decryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding|kCCOptionECBMode, keyPtr, kCCKeySizeAES256, ivPtr, [data bytes], dataLength, buffer, bufferSize, &numBytesDecrypted);
    }else{
        decryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding|kCCOptionECBMode, keyPtr, kCCKeySizeAES256, NULL, [data bytes], dataLength, buffer, bufferSize, &numBytesDecrypted);
    }
    //MARK:解密结果
    if (decryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

#pragma mark --- 字符串AES256加密处理返回加密后的字符串文本

+(nullable NSString*)ordinaryAES256ParmStringEncryptWithKey:(NSString *)key encryptWithParm:(NSString *)encryptString withEncryptParamIv:(nullable NSString *)iv
{
    //转化为C字符串
    const char * cstr = [encryptString cStringUsingEncoding:NSUTF8StringEncoding];
    //二进制数据
    NSData * data = [NSData dataWithBytes:cstr length:encryptString.length];
    //对NSData使用Data的数据加密方法进行数据的加密处理
    NSData * encryptData = [self GeneralPurposeAES256EncryptWithKey:key withEncryptParamDatas:data withEncryptParamIV:iv];
    //MARK:转化为二进制
    if (encryptData && encryptData.length>0){
        
        Byte * datasByte =(Byte*)[encryptData bytes];
        NSMutableString * encryptString = [NSMutableString stringWithCapacity:encryptData.length * 2];
        for (int i=0; i<encryptData.length; i++) {
            [encryptString appendFormat:@"%02x",datasByte[i]];
        }
        return encryptString;
    }
    return nil;
}

#pragma mark --- 字符串AES256解密处理返回原内容文本

+(nullable NSString*)ordinaryAES256ParmStringdDecryptWithKey:(NSString *)key dncryptWithParm:(NSString *)decryptString withDecryptParamIv:(nullable NSString *)iv
{
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:decryptString.length/2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [decryptString length]/2; i++) {
        byte_chars[0] = [decryptString characterAtIndex:i*2];
        byte_chars[1] = [decryptString characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    //对数据进行解密
    NSData* result = [self GeneralPurposeAES256DecryptWithKey:key withDecryptParamDatas:data withDecryptParamIV:iv];
    if (result && result.length > 0) {
        //加密之后最好来个base64，加密后的数据中会可能出现'\0' 导致解密的时候会出现特殊的字符串
        NSString * resultString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        return resultString;
    }
    return nil;
}


#pragma mark --- 追加系统的Base64加密处理

+(nullable NSString*)additionAESParmEncryptWithKey:(NSString *)key encryptParm:(NSString *)encryptString withEncryptParamIv:(nullable NSString *)iv
{
    //MARK:将数据转化为二进制数据
    NSData * data = [encryptString dataUsingEncoding:NSUTF8StringEncoding];
    NSData * encryptDatas = [self GeneralPurposeAES256EncryptWithKey:key withEncryptParamDatas:data withEncryptParamIV:iv];
    if (encryptDatas && encryptDatas.length > 0) {
        return [encryptDatas base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    return nil;
}

#pragma mark --- 追加系统的Base64解密处理

+(nullable NSString*)additionAESParmdDecryptWithKey:(NSString *)key decryptParm:(NSString *)decryptString withDecryptParamIv:(nullable NSString *)iv
{
    //把base64String转换成Data
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:decryptString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData * decryptDatas = [self GeneralPurposeAES256DecryptWithKey:key withDecryptParamDatas:contentData withDecryptParamIV:iv];
    if (decryptDatas && decryptDatas.length>0) {
        return [[NSString alloc] initWithData:decryptDatas encoding:NSUTF8StringEncoding];
    }
    return nil;
}

#pragma mark --- 字符串&&字典数据转化为字符串进行数据加密处理并返回Base64追加加密后的字符串

+(nullable NSString*)additionAES256EncryptParamWithKey:(NSString *)key encryptParam:(id)paramDict withEncryptParamIV:(nullable NSString *)iv
{
    NSString * jsonString = nil;
    if ([paramDict isKindOfClass:[NSDictionary class]]) {
         jsonString = [NSString dictionaryTranfromToJson:paramDict];
    }else if ([paramDict isKindOfClass:[NSString class]]){
        jsonString = paramDict;
    }
    if ([NSString isEmptyWithStr:jsonString]) {
        return nil;
    }
    NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSData * encryptDatas = [self GeneralPurposeAES256EncryptWithKey:key withEncryptParamDatas:data withEncryptParamIV:iv];
    if (encryptDatas && encryptDatas.length > 0) {
        NSString * base64DataString = [NSString base64StringFromData:encryptDatas length:[encryptDatas length]];
        return base64DataString;
    }
    return nil;
}

#pragma mark --- 使用Base64加密后字符串进行数据解密处理并根据解密后数据是否是字典或者字符串区别

+(id)additionAES256DecryptParamWithKey:(NSString *)key decryptParam:(nullable NSString *)paramBase64String withDecryptParamIV:(nullable NSString *)iv
{
    NSData *contentData = [NSData base64DataFromString:paramBase64String];
    NSData * decryptDatas = [self GeneralPurposeAES256DecryptWithKey:key withDecryptParamDatas:contentData withDecryptParamIV:iv];
    if (decryptDatas && decryptDatas.length>0) {
        NSString * dataString = [[NSString alloc] initWithData:decryptDatas encoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSString jsonStringTranFromToDict:dataString];
        if (dict!=nil) {
            return dict;
        }
        return dataString;
    }
    return nil;
}

@end
