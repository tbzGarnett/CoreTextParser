//
//  TBZFrameParserConfig.h
//  CoreTextDemo
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//用于配置绘制的参数 配置类
@interface TBZFrameParserConfig : NSObject
//配置属性
@property (nonatomic ,assign) CGFloat width;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, strong) UIColor *textColor;
@end

NS_ASSUME_NONNULL_END
