//
//  WZZCardCell.h
//  ScrollDemo
//
//  Created by 王泽众 on 2017/8/29.
//  Copyright © 2017年 王泽众. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZZCardCell : UIView

@property (nonatomic, assign) NSInteger cellIndex;
@property (nonatomic, weak) WZZCardCell * lastView;
@property (nonatomic, weak) WZZCardCell * nextView;
@property (nonatomic, strong) UIView * subView;

@end
