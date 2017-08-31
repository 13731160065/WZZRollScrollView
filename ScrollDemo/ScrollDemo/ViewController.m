//
//  ViewController.m
//  ScrollDemo
//
//  Created by 王泽众 on 2017/8/29.
//  Copyright © 2017年 王泽众. All rights reserved.
//

#import "ViewController.h"
#import "WZZCardScrollView.h"
#import "WZZAViewCell.h"

@interface ViewController ()<WZZCardScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray * dataArr;
    WZZCardScrollView * mainCardView;
    UITableView * mainTableView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#if 1
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    mainCardView = [[WZZCardScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    [self.view addSubview:mainCardView];
    mainCardView.delegate = self;
#endif
    
#if 0
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300) style:UITableViewStylePlain];
        [self.view addSubview:mainTableView];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [mainTableView registerNib:[UINib nibWithNibName:@"WZZAViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
#endif
    
    dataArr = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        CGFloat red = arc4random()%256/255.0f;
        CGFloat green = arc4random()%256/255.0f;
        CGFloat blue = arc4random()%256/255.0f;
        [dataArr addObject:[UIColor colorWithRed:red green:green blue:blue alpha:1.0f]];
    }
    
    [mainCardView reloadData];
}

- (IBAction)reloadfff:(id)sender {
    dataArr = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        CGFloat red = arc4random()%256/255.0f;
        CGFloat green = arc4random()%256/255.0f;
        CGFloat blue = arc4random()%256/255.0f;
        [dataArr addObject:[UIColor colorWithRed:red green:green blue:blue alpha:1.0f]];
    }
    [mainCardView reloadData];
}

#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WZZAViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setClipsToBounds:YES];
//    cell.backgroundColor = dataArr[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.alabel.backgroundColor = dataArr[indexPath.row];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (UITableViewCell * cell in mainTableView.visibleCells) {
        [(WZZAViewCell *)cell cellOffset];
    }
}

#pragma mark - wzz代理
- (NSInteger)wzzCardRows {
    return dataArr.count;
}

- (UIView *)wzzCardCellForRow:(NSInteger)row size:(CGSize)size {
    CGRect frame;
    frame.size = size;
    UIView * aView = [[UIView alloc] initWithFrame:frame];
    
    UILabel * label = [[UILabel alloc] initWithFrame:aView.bounds];
    [aView addSubview:label];
    [label setTextColor:[UIColor whiteColor]];
    label.text = [NSString stringWithFormat:@"银行卡%ld", row];
    [label setTextAlignment:NSTextAlignmentCenter];
    [aView setBackgroundColor:dataArr[row]];
    [aView.layer setMasksToBounds:YES];
    [aView.layer setCornerRadius:10];
    
    return aView;
}

- (CGFloat)wzzCardHeight {
    return 200;
}

@end
