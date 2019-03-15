//
//  TBZFrameParser.h
//  CoreTextDemo
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TBZCoreTextData;
@class TBZFrameParserConfig;

NS_ASSUME_NONNULL_BEGIN
//解析类
@interface TBZFrameParser : NSObject
/**
 给内容content添加配置信息并返回一个模型对象

 @param content 内容
 @param config 配置config
 @return 模型对象
 */
+ (TBZCoreTextData *)parserContent:(NSString *)content config:(TBZFrameParserConfig *)config;


/**
 给attString添加配置信息并返回一个模型对象

 @param attString attString内容
 @param config 配置config
 @return 模型对象
 */
+ (TBZCoreTextData *)parserAttributeString:(NSAttributedString *)attString config:(TBZFrameParserConfig *)config;


/**
 根据路径获取内容，添加配置信息并返回一个模型对象

 @param path 文件路径
 @param config 配置config
 @return 模型对象
 */
+ (TBZCoreTextData *)parserPath:(NSString *)path config:(TBZFrameParserConfig *)config;

/**
 将配置信息转换成attributeString的attributeDictionary

 @param config 配置信息
 @return attributeDictionary
 */
+ (NSDictionary *)attributesWithConfig:(TBZFrameParserConfig *)config;

@end

NS_ASSUME_NONNULL_END
