//
//  WZZCardScrollView.m
//  ScrollDemo
//
//  Created by 王泽众 on 2017/8/29.
//  Copyright © 2017年 王泽众. All rights reserved.
//

#import "WZZCardScrollView.h"
#import "WZZCardCell.h"

#define SHOWCARDNUM 5
#define CELLENDBORDER 100

@interface WZZCardScrollView ()<UIScrollViewDelegate>
{
    UIScrollView * mainScrollView;
    CGFloat cellHeight;
    CGFloat cellOtherHeight;
    NSMutableArray <WZZCardCell *>* allViewsArray;
}

@end

@implementation WZZCardScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mainScrollView = [[UIScrollView alloc] initWithFrame:frame];
        [self addSubview:mainScrollView];
        mainScrollView.delegate = self;
        allViewsArray = [NSMutableArray array];
    }
    return self;
}

- (void)reloadData {
    [[mainScrollView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [allViewsArray removeAllObjects];
    NSInteger rowsNum = 0;
    if ([self.delegate respondsToSelector:@selector(wzzCardRows)]) {
        rowsNum = [self.delegate wzzCardRows];
    }
    if ([self.delegate respondsToSelector:@selector(wzzCardHeight)]) {
        cellHeight = [self.delegate wzzCardHeight];
    }
    
    cellOtherHeight = (self.frame.size.height-cellHeight)/(SHOWCARDNUM-1);
    
    CGFloat endFrame = 0;
    
    for (int i = 0 ; i < rowsNum; i++) {
        UIView * view = nil;
        
        CGFloat x = 0;
        CGFloat y = i*cellOtherHeight;//一个大cell一堆小cell
        CGFloat width = self.frame.size.width;
        CGFloat height = cellHeight;
        
        
        //获取view代理方法
        if ([self.delegate respondsToSelector:@selector(wzzCardCellForRow:size:)]) {
            view = [self.delegate wzzCardCellForRow:i size:CGSizeMake(width, height)];
        }
        
        [view setFrame:CGRectMake(x, y, width, height)];
        
        WZZCardCell * bkView = [[WZZCardCell alloc]  initWithFrame:view.frame];
        view.frame = view.bounds;
        [bkView addSubview:view];
        bkView.cellIndex = i;
        bkView.lastView = [allViewsArray lastObject];
        [(WZZCardCell *)[allViewsArray lastObject] setNextView:bkView];
        bkView.subView = view;
        [mainScrollView addSubview:bkView];
        [allViewsArray addObject:bkView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        [bkView setGestureRecognizers:@[tap]];
        
        endFrame = bkView.frame.size.height+bkView.frame.origin.y;
    }
    [mainScrollView setContentSize:CGSizeMake(0, endFrame)];
}

#pragma mark - view点击
- (void)viewClick:(UITapGestureRecognizer *)tap {
    WZZCardCell * cell = (WZZCardCell *)tap.view;
    CGFloat cellBorder = (((SHOWCARDNUM-1)/2)*cellOtherHeight);
    [mainScrollView setContentOffset:CGPointMake(0, CGRectGetMinY(cell.frame)-cellBorder) animated:YES];
}

#pragma mark - scrollview代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentOffset.y;//scrollview位置
    CGFloat cellBorder = (((SHOWCARDNUM-1)/2)*cellOtherHeight);//除了正中间显示的cell，两边的border/2
    
    //设置动画
    [allViewsArray enumerateObjectsUsingBlock:^(WZZCardCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //向上滑动
        CGFloat cellOffsetY = CGRectGetMinY(obj.frame);
        CGFloat cellJianViewOffsetY = cellOffsetY-contentOffsetY;
        
        //向下滑动
        CGFloat cellOffsetY2 = CGRectGetMaxY(obj.frame);
        CGFloat cellJianViewOffsetY2 = -(cellOffsetY2-(contentOffsetY+self.frame.size.height));
        
        if (cellJianViewOffsetY >= 0 && cellJianViewOffsetY <= cellBorder) {
            CGFloat cellCenterHeightPix = 1-cellJianViewOffsetY/cellBorder;
            if (cellCenterHeightPix > 1) {
                cellCenterHeightPix = 1;
            }
            if (cellCenterHeightPix < 0) {
                cellCenterHeightPix = 0;
            }
            CGFloat cellChangeWidth = (CELLENDBORDER*cellCenterHeightPix)/2;
            
            [obj setFrame:CGRectMake(cellChangeWidth, obj.frame.origin.y, self.frame.size.width-cellChangeWidth*2, obj.frame.size.height)];
            obj.subView.frame = obj.bounds;
            [obj setHidden:NO];
        } else if (cellJianViewOffsetY2 >= 0 && cellJianViewOffsetY2 <= cellBorder) {
            CGFloat cellCenterHeightPix = 1-cellJianViewOffsetY2/cellBorder;
            if (cellCenterHeightPix > 1) {
                cellCenterHeightPix = 1;
            }
            if (cellCenterHeightPix < 0) {
                cellCenterHeightPix = 0;
            }
            CGFloat cellChangeWidth = (CELLENDBORDER*cellCenterHeightPix)/2;
            
            [obj setFrame:CGRectMake(cellChangeWidth, obj.frame.origin.y, self.frame.size.width-cellChangeWidth*2, obj.frame.size.height)];
            obj.subView.frame = obj.bounds;
            [obj setHidden:NO];
        } else {
            [obj setHidden:YES];
        }
        
        //排层次
        if (obj.lastView) {
            if (obj.frame.size.width < obj.lastView.frame.size.width) {
                //如果我下一个view比我宽，我下一个放我上边
                [mainScrollView insertSubview:obj belowSubview:obj.lastView];
            } else {
                [mainScrollView insertSubview:obj aboveSubview:obj.lastView];
            }
        }
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentOffset.y;//scrollview位置
    int cellNum = (int)(contentOffsetY/cellOtherHeight)+2;
    if (cellNum < allViewsArray.count) {
        CGFloat cellBorder = (((SHOWCARDNUM-1)/2)*cellOtherHeight);
        [mainScrollView setContentOffset:CGPointMake(0, CGRectGetMinY(allViewsArray[cellNum].frame)-cellBorder) animated:YES];
    }
}

@end
