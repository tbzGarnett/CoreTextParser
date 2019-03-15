//
//  TBZFrameParserConfig.m
//  CoreTextDemo
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TBZFrameParserConfig.h"

@implementation TBZFrameParserConfig

- (instancetype)init{
    if ([super init]) {
        _width = 200.f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = [UIColor colorWithRed:108/255 green:108/255 blue:108/255 alpha:0];
    }
    return self;
}

@end
