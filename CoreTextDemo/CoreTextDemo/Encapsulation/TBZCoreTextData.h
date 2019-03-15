//
//  TBZCoreTextData.h
//  CoreTextDemo
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBZCoreTextData : NSObject
@property (nonatomic, assign) CTFrameRef ctFrame;
@property (nonatomic, assign) CGFloat height;

//图文混排
@property (nonatomic, strong) NSArray *imageArray;
//url数组
@property (nonatomic, strong) NSArray *linkArray;
@end

NS_ASSUME_NONNULL_END
