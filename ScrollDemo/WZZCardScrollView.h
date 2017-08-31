//
//  WZZCardScrollView.h
//  ScrollDemo
//
//  Created by 王泽众 on 2017/8/29.
//  Copyright © 2017年 王泽众. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WZZCardScrollViewDelegate <NSObject>

@required

/**
 多少行
 */
- (NSInteger)wzzCardRows;

/**
 复用cell(暂时不用复用，直接创建即可)
 */
- (UIView *)wzzCardCellForRow:(NSInteger)row size:(CGSize)size;

/**
 当前选中cell最大高度
 */
- (CGFloat)wzzCardHeight;

@optional

@end

@interface WZZCardScrollView : UIView

@property (nonatomic, weak) id<WZZCardScrollViewDelegate> delegate;

/**
 刷新数据
 */
- (void)reloadData;

@end
