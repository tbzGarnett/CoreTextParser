//
//  ViewController.m
//  CoreTextDemo
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ViewController.h"
#import "TBZShowViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTablev;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.mainTablev];
}

- (UITableView *)mainTablev{
    if (!_mainTablev) {
        _mainTablev = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _mainTablev.delegate = self;
        _mainTablev.dataSource = self;
    }
    return _mainTablev;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    switch (indexPath.row) {
        case 0:
            {
                cell.textLabel.text = @"基本展示文本";
            }
            break;
        case 1:
        {
            cell.textLabel.text = @"文本展示一";
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"读取json文本展示二";
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"图文混排";
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TBZShowViewController *showVC = [[TBZShowViewController alloc] init];
    showVC.type = indexPath.row;
    [self.navigationController pushViewController:showVC animated:YES];
}


@end
