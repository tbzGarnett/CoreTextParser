//
//  TBZShowViewController.m
//  CoreTextDemo
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TBZShowViewController.h"
#import "TBZDisplayView.h"
#import "TBZEncapsulationView.h"
#import "TBZFrameParserConfig.h"
#import "TBZFrameParser.h"
#import "TBZCoreTextData.h"
#import "TBZMixedFrameParser.h"
#import "TBZMixedView.h"
#import "TBZUrlFrameParser.h"
#import "TBZUrlMixedView.h"

@interface TBZShowViewController ()

@end

@implementation TBZShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    
    TBZFrameParserConfig *config = [[TBZFrameParserConfig alloc] init];
    config.fontSize = 16.0f;
    config.width = viewWidth;
    config.lineSpace = 3.0f;
    config.textColor = [UIColor whiteColor];
    
    NSString *content = @"凯文·加内特（Kevin Garnett），1976年5月19日出生在美国南卡罗来纳，前美国职业篮球运动员，司职大前锋/中锋，绰号狼王（森林狼时期）、KG（名字缩写）、The BIG TICKET、Da Kid。"
    "1995年NBA选秀，凯文·加内特首轮第五顺位被明尼苏达森林狼队选中，2003-04赛季获得常规赛MVP。2007年夏季转会至波士顿凯尔特人，和雷·阿伦和保罗·皮尔斯一起形成了“凯尔特人三巨头”，2008年的总决赛中击败湖人队，获得NBA总冠军。2013年，加内特被交易至布鲁克林篮网队。2015年重回明尼苏达森林狼队。";
    
    switch (self.type) {
        case 0:
            {
                self.title = @"基本展示";
                TBZDisplayView *dispaleView = [[TBZDisplayView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
                dispaleView.center = self.view.center;
                dispaleView.backgroundColor = [UIColor whiteColor];
                [self.view addSubview:dispaleView];
            }
            break;
        case 1:
        {
            self.title = @"文本展示一";
            
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
            break;
        case 2:
        {
            self.title = @"文本展示二";
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"File" ofType:@"json"];
            TBZCoreTextData *data = [TBZFrameParser parserPath:path config:config];
            
            TBZEncapsulationView *view = [[TBZEncapsulationView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, data.height)];
            view.center = self.view.center;
            view.textData = data;
            view.backgroundColor = [UIColor grayColor];
            [self.view addSubview:view];
        }
            break;
        case 3:
        {
            self.title = @"图文混排";
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"File1" ofType:@"json"];
            TBZCoreTextData *data = [TBZMixedFrameParser parseTemplateFile:path config:config];
            
            TBZMixedView *view = [[TBZMixedView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, data.height)];
            view.center = self.view.center;
            view.textData = data;
            view.backgroundColor = [UIColor grayColor];
            [self.view addSubview:view];
        }
            break;
        case 4:
        {
            self.title = @"URL链接";
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"File2" ofType:@"json"];
            TBZCoreTextData *data = [TBZUrlFrameParser parseTemplateFile:path config:config];
            
            TBZUrlMixedView *view = [[TBZUrlMixedView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, data.height)];
            view.center = self.view.center;
            view.textData = data;
            view.backgroundColor = [UIColor grayColor];
            [self.view addSubview:view];
        }
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
