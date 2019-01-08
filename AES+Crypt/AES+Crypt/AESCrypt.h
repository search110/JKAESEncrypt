//
//  AESCrypt.h
//  AES+Crypt
//
//  Created by caoyong on 2019/1/4.
//  Copyright © 2019 caoyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 * AES 加密
 AES是分组加密 将明文分为一组一组的进行加密处理 每一组的长度都是相等的、加密是一组一组的进行加密
 AES的每个分组只能是128位的长度 也就是每个分组是16个字节(因为每个字节为8位)
 AES的密钥长度可以是128位、192位、256位、一般密钥的长度不同加密的轮数也就不一样
 AES的结构如下:
 AES类型|密钥长度|分组长度|加密轮数
 AES-128|4|4|10
 AES-192|6|4|12
 AES-256|8|4|14
 加密轮数的意思:运行加密函数的明文+密钥执行多少次 一般前面的几次都一样 只有最后一次不一样
 AES处理的单位是字节 128位分为了16个字节 16个字节以P为例就是：P0 ~P15 的矩形阵列排列成为状态矩列 然后经过AES算法加密处理
 AES加密的主要函数：
 CCCryptorStatus CCCrypt(
 CCOperation op,      用来代表加密或者解密，kCCEncrypt = 加密，kCCDecrypt = 解密
 CCAlgorithm alg,     用来代表加密算法，有kCCAlgorithmAES128..
 CCOptions options,   iOS中只提供了kCCOptionPKCS7Padding和kCCOptionECBMode两种，这个在于后台和安卓交互时要注意一点
 const void *key,            密钥长度，一般使用char keyPtr[kCCKeySizeAES256+1];
 size_t keyLength,
 const void *iv,
 const void *dataIn,         加密信息的比特数
 size_t dataInLength,        加密信息的长度
 void *dataOut,              用来输出加密结果
 size_t dataOutAvailable,    输出的大小
 size_t *dataOutMoved)
 __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_2_0);
 */

@interface AESCrypt : NSObject
/*!
 * NSData+普通的AES加密 && NSData+普通的AES解密
 */
+(nullable NSData*)GeneralPurposeAES256EncryptWithKey:(nonnull NSString*)key withEncryptParamDatas:(nonnull NSData*)data withEncryptParamIV:(nullable NSString*)iv;

+(nullable NSData*)GeneralPurposeAES256DecryptWithKey:(nonnull NSString*)key withDecryptParamDatas:(nonnull NSData*)data withDecryptParamIV:(nullable NSString*)iv;
/*!
 * NSString+普通的AES加密 && NSString+普通的AES解密
 * 此方法的解密适合没有中文的字符串(含有中文会出现nil)
 * 加密之后最好来个base64，加密后的数据中会可能出现'\0' 导致解密的时候会出现特殊的字符串
 *  此方法的加密适合没有中文的字符串(含有中文会出现nil)
 */
+(nullable NSString*)ordinaryAES256ParmStringEncryptWithKey:(nullable NSString*)key encryptWithParm:(nullable NSString*)encryptString withEncryptParamIv:(nullable NSString*)iv;

+(nullable NSString*)ordinaryAES256ParmStringdDecryptWithKey:(nullable NSString*)key dncryptWithParm:(nullable NSString*)decryptString withDecryptParamIv:(nullable NSString*)iv;
/*!
 * AES添加base64方式加密(追加系统base64)&&AES添加base64方式解密
 */
+(nullable NSString*)additionAESParmEncryptWithKey:(nullable NSString*)key encryptParm:(nullable NSString*)encryptString withEncryptParamIv:(nullable NSString*)iv;

+(nullable NSString*)additionAESParmdDecryptWithKey:(nullable NSString*)key decryptParm:(nullable NSString*)decryptString withDecryptParamIv:(nullable NSString*)iv;
/*！
 * AES加密字符串并且添加Base64加密&&解密处理(推荐使用改方法进行数据加密解密处理)
 */
+(nullable NSString*)additionAES256EncryptParamWithKey:(nullable NSString*)key encryptParam:(id)paramDict withEncryptParamIV:(nullable NSString*)iv;

+(id)additionAES256DecryptParamWithKey:(nullable NSString*)key decryptParam:(nullable NSString*)paramBase64String withDecryptParamIV:(nullable NSString*)iv;

@end

NS_ASSUME_NONNULL_END
