//
//  TBZMixedFrameParser.h
//  CoreTextDemo
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TBZCoreTextData;
@class TBZFrameParserConfig;

NS_ASSUME_NONNULL_BEGIN

@interface TBZMixedFrameParser : NSObject

/**
 *  配置信息格式化
 *
 *  @param config 配置信息
 */
+(NSDictionary *)attributesWithConfig:(TBZFrameParserConfig *)config;


/**
 *  给内容设置配置信息
 *
 *  @param content 内容
 *  @param config  配置信息
 */
+(TBZCoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(TBZFrameParserConfig *)config;

/**
 *  给内容设置配置信息
 *
 *  @param path   模板文件路径
 *  @param config 配置信息
 */
+(TBZCoreTextData *)parseTemplateFile:(NSString *)path config:(TBZFrameParserConfig *)config;

@end

NS_ASSUME_NONNULL_END
