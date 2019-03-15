//
//  TBZCoreImageData.h
//  CoreTextDemo
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBZCoreImageData : NSObject
//图片资源名称
@property (nonatomic,copy) NSString *name;
//图片位置的起始点
@property (nonatomic,assign) CGFloat position;
//图片的尺寸
@property (nonatomic,assign) CGRect imagePostion;
@end

NS_ASSUME_NONNULL_END
