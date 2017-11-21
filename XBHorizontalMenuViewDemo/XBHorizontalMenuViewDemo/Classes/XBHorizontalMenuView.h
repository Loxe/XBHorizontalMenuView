//
//  XBHorizontalMenuView.h
//  TBJPro
//
//  Created by Loxe on 17/7/18.
//  Copyright © 2017年 TBJ. All rights reserved.
//
//  实例化slideMenu对象后 将需要联动的scrollView的contentOffset KVO设置到slideMenu对象上既可以联动
//  或者自己监听需要联动的scrollView对象 调用updateUIWithContentOffset方法 进行slideMenu的改变

#import <UIKit/UIKit.h>

@protocol XBHorizontalMenuViewDelegate;
@interface XBHorizontalMenuView : UIView
@property(nonatomic, assign) NSUInteger showMaxCount;
@property(nonatomic, assign) BOOL hasAvg;
@property(nonatomic, assign) CGFloat space;
@property(nonatomic, strong) NSArray<NSString *> *titles;
@property(nonatomic, strong) NSArray<NSAttributedString *> *titlesAttr;
@property(nonatomic, strong) NSArray *selectedTitlesAttr;
@property(nonatomic, strong) UIColor *normalColor;
@property(nonatomic, strong) UIFont *font;
@property(nonatomic, strong) UIColor *selectedColor;
@property(nonatomic, strong) UIColor *lineColor;
@property(nonatomic, assign) BOOL showRealWidth;
@property(nonatomic, assign) id<XBHorizontalMenuViewDelegate> delegate;
/** 
 showMaxChout 
    avgWidth为YES:showMaxCount默认等于4 不进行title自动计算
    avgWidth为NO :若是需要自动计算title宽度showMaxCount传0
*/
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles space:(CGFloat)space font:(UIFont *)font normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor lineColor:(UIColor *)lineColor lineShowRealWidth:(BOOL)showRealWidth showMaxCount:(NSUInteger)showMaxCount avgWidth:(BOOL)avg;
- (instancetype)initWithFrame:(CGRect)frame normalTitlesAttr:(NSArray *)titles selectedTitlesAttr:(NSArray *)selectedTitles space:(CGFloat)space lineColor:(UIColor *)lineColor lineShowRealWidth:(BOOL)showRealWidth showMaxCount:(NSUInteger)showMaxCount avgWidth:(BOOL)avg;
- (void)updateUIWithContentOffset:(UIScrollView *)scrollView;
@end

@protocol XBHorizontalMenuViewDelegate <NSObject>
- (void)slideMenuView:(XBHorizontalMenuView *)view selectedIdx:(NSUInteger)idx;
@end
