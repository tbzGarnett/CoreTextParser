//
//  ViewController.m
//  CoreTextDemo
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ViewController.h"
#import "TBZDisplayView.h"
#import "TBZEncapsulationView.h"
#import "TBZFrameParserConfig.h"
#import "TBZFrameParser.h"
#import "TBZCoreTextData.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //显示内容
//    TBZDisplayView *dispaleView = [[TBZDisplayView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
//    dispaleView.center = self.view.center;
//    dispaleView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:dispaleView];
    
    
    CGFloat viewWidth = 300;
    
    TBZFrameParserConfig *config = [[TBZFrameParserConfig alloc] init];
    config.fontSize = 16.0f;
    config.width = viewWidth;
    config.lineSpace = 3.0f;
    config.textColor = [UIColor whiteColor];
    
    NSString *content = @"凯文·加内特（Kevin Garnett），1976年5月19日出生在美国南卡罗来纳，前美国职业篮球运动员，司职大前锋/中锋，绰号狼王（森林狼时期）、KG（名字缩写）、The BIG TICKET、Da Kid。"
    "1995年NBA选秀，凯文·加内特首轮第五顺位被明尼苏达森林狼队选中，2003-04赛季获得常规赛MVP。2007年夏季转会至波士顿凯尔特人，和雷·阿伦和保罗·皮尔斯一起形成了“凯尔特人三巨头”，2008年的总决赛中击败湖人队，获得NBA总冠军。2013年，加内特被交易至布鲁克林篮网队。2015年重回明尼苏达森林狼队。";
    
//    TBZCoreTextData *data = [TBZFrameParser parserContent:content config:config];
    NSDictionary *attr = [TBZFrameParser attributesWithConfig:config];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributeString addAttributes:attr range:NSMakeRange(0, [content length])];
    //这里注意NSForegroundColorAttributeName和kCTForegroundColorAttributeName 当要设置几个字是不同颜色时，必须都设置为同一个key，否则会有问题
    [attributeString addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor redColor].CGColor range:NSMakeRange(0, 21)];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:26] range:NSMakeRange(0, 21)];
    
    TBZCoreTextData *data = [TBZFrameParser parserAttributeString:attributeString config:config];
    
    TBZEncapsulationView *view = [[TBZEncapsulationView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, data.height)];
    view.center = self.view.center;
    view.textData = data;
    view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view];
}


@end
