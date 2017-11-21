//
//  XBHorizontalMenuView.m
//  TBJPro
//
//  Created by Loxe on 17/7/18.
//  Copyright © 2017年 TBJ. All rights reserved.
//

#import "XBHorizontalMenuView.h"
const int maskViewTag = 9999;
@interface XBHorizontalMenuView()


@property(nonatomic, strong) UIScrollView *bodyScrollView;
//显示普通状态的图层
@property(nonatomic, strong) UIView *backgroundLayer;
//显示遮罩状态的图层
@property(nonatomic, strong) UIView *maskLayer;
@property(nonatomic, strong) UIView *maskView;
//点击事件按钮的图层
@property(nonatomic, strong) UIView *btnLayer;

@property(nonatomic, strong) UIView *moreView;
@property(nonatomic, strong) NSMutableArray *titlesWidth;
@property(nonatomic, strong) NSMutableArray *titlesRealWidth;
@property(nonatomic, strong) NSMutableArray *titlesX;
@property(nonatomic, strong) UIView *lineView;


@end
@implementation XBHorizontalMenuView
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles space:(CGFloat)space font:(UIFont *)font normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor lineColor:(UIColor *)lineColor lineShowRealWidth:(BOOL)showRealWidth showMaxCount:(NSUInteger)showMaxCount avgWidth:(BOOL)avg
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.showMaxCount = showMaxCount;
        self.showRealWidth = showRealWidth;
        self.space = space;
        self.hasAvg = avg;
        self.normalColor = normalColor;
        self.font = font;
        self.selectedColor = selectedColor;
        self.lineColor = lineColor;
        self.titles = titles;
        if (self.titlesX.count > 0 && (self.titlesWidth.count > 0)) {
            [self updateUIWithFrom:0 to:1 percent:0];
        }
        [self addSubview:self.lineView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame normalTitlesAttr:(NSArray *)titles selectedTitlesAttr:(NSArray *)selectedTitles space:(CGFloat)space lineColor:(UIColor *)lineColor lineShowRealWidth:(BOOL)showRealWidth showMaxCount:(NSUInteger)showMaxCount avgWidth:(BOOL)avg
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.showMaxCount = showMaxCount;
        self.showRealWidth = showRealWidth;
        self.space = space;
        self.hasAvg = avg;
        self.lineColor = lineColor;
        self.titlesAttr = titles;
        self.selectedTitlesAttr = selectedTitles;
        if (self.titlesX.count > 0 && (self.titlesWidth.count > 0)) {
            [self updateUIWithFrom:0 to:1 percent:0];
        }
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (object == self.bodyScrollView) {
        if ([keyPath isEqualToString:@"contentOffset"]) {
            CGFloat endX = self.bodyScrollView.contentSize.width - self.frame.size.width;
            self.moreView.hidden = (self.bodyScrollView.contentOffset.x >= endX);
        }
    } else {
        [self updateUIWithContentOffset:object];
    }
}

- (void)dealloc
{
    [self.bodyScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)createUI:(NSArray *)titles withAttrib:(BOOL)isattrib
{
    [self.bodyScrollView addSubview:self.backgroundLayer];
    [self.bodyScrollView addSubview:self.maskLayer];
    [self.bodyScrollView addSubview:self.btnLayer];
    [self addSubview:self.bodyScrollView];
    [self addSubview:self.moreView];
    [self.titlesWidth removeAllObjects];
    [self.titlesX removeAllObjects];
    [self.backgroundLayer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.maskLayer.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj class] == [UILabel class]) {
            [obj removeFromSuperview];
        }
    }];
    [self.btnLayer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat itemH = self.frame.size.height;
    
    for (int i = 0; i < titles.count; i ++) {
        id title = titles[i];
        CGFloat itemW = 0;
        if (self.hasAvg) {
            self.showMaxCount = self.showMaxCount == 0 ? 4 : self.showMaxCount;
            itemW = self.frame.size.width / self.showMaxCount - [self offsetX] / self.showMaxCount;
        } else {
            if (self.showMaxCount == 0) {
                if (isattrib) {
                    itemW = [((NSAttributedString *)title) boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size.width + 16 + self.space * 2;
                } else {
                    itemW = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil]].width + 16 + self.space * 2;
                }
                if (itemW < 64) {
                    itemW = 64;
                }
            } else {
                itemW = self.frame.size.width/ self.showMaxCount;
            }
        }
        CGFloat subWdith = [[self.titlesWidth valueForKeyPath:@"@sum.floatValue"] floatValue];
        UILabel *normalLbl = [[UILabel alloc] initWithFrame:CGRectMake(subWdith, 0, itemW, itemH)];
        normalLbl.textColor = self.normalColor;
        normalLbl.font = self.font;
        normalLbl.textAlignment = NSTextAlignmentCenter;
        normalLbl.numberOfLines = 0;
        if (self.hasAvg) {
            normalLbl.minimumScaleFactor = 0.1f;
            normalLbl.adjustsFontSizeToFitWidth = YES;
        }
        if (isattrib) {
            normalLbl.attributedText = title;
        } else {
            normalLbl.text = title;
        }

        
        

        UILabel *selectedLbl = [[UILabel alloc] initWithFrame:CGRectMake(subWdith, 0, itemW, itemH)];
        selectedLbl.textColor = self.selectedColor;
        selectedLbl.font = self.font;
        selectedLbl.textAlignment = NSTextAlignmentCenter;
        selectedLbl.numberOfLines = 0;
        if (self.hasAvg) {
            selectedLbl.minimumScaleFactor = 0.1f;
            selectedLbl.adjustsFontSizeToFitWidth = YES;
        }
        if (isattrib) {
            title = (self.selectedTitlesAttr.count > i && self.selectedTitlesAttr[i]) ? self.selectedTitlesAttr[i] : title;
            selectedLbl.attributedText = title;
        } else {
            selectedLbl.text = title;
        }

        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(subWdith, 0, itemW, itemH);
        selectBtn.backgroundColor = [UIColor clearColor];
        selectBtn.tag = i;
        [selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.backgroundLayer addSubview:normalLbl];
        [self.maskLayer addSubview:selectedLbl];
        [self.btnLayer addSubview:selectBtn];
        [self.titlesWidth addObject:@(itemW)];
        if (isattrib) {
            [self.titlesRealWidth addObject:@([((NSAttributedString *)title) boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size.width + 16 + self.space * 2)];
        } else {
            [self.titlesRealWidth addObject:@([title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil]].width + 16 + self.space * 2)];
        }
        [self.titlesX addObject:@(subWdith)];
    }
    CGFloat subWdith = [[self.titlesWidth valueForKeyPath:@"@sum.floatValue"] floatValue];
    
    self.moreView.hidden = !(subWdith > self.frame.size.width);
    self.bodyScrollView.contentSize = CGSizeMake(subWdith + [self offsetX], self.frame.size.height);
    self.backgroundLayer.frame = self.maskLayer.frame = self.btnLayer.frame = CGRectMake([self offsetX]/2, 0, subWdith, self.frame.size.height);
    self.maskLayer.layer.mask = self.maskView.layer;
    [self bringSubviewToFront:self.lineView];
}

- (void)updateUIWithContentOffset:(UIScrollView *)scrollView
{
    CGFloat pageIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    CGFloat percent = pageIndex - (int)pageIndex;
    //从第几页到
    NSInteger fromeIdx = floor(pageIndex);
    //到第几页
    NSInteger gotoIdx = ceilf(pageIndex);

    [self updateUIWithFrom:fromeIdx to:gotoIdx percent:percent];
}

- (void)updateUIWithFrom:(NSInteger)from to:(NSInteger)to percent:(CGFloat)percent
{
    if (self.titles.count == 0 && self.titlesAttr.count == 0) {
        return;
    }
    BOOL isattrib = (self.titlesAttr.count > 0);
    //    CGFloat endX = scrollView.contentSize.width - scrollView.frame.size.width;
    //从第几页到
    NSInteger fromeIdx = from;
    //到第几页
    NSInteger gotoIdx = to;
    //若是最右边不进行任何变化
    NSArray *tmpTitles = nil;
    if (isattrib) {
        tmpTitles = self.titlesAttr;
    } else {
        tmpTitles = self.titles;
    }
    if (fromeIdx == (tmpTitles.count - 1) && (gotoIdx > tmpTitles.count -1)) {
        return;
    }
    //若是最左边也不进行任何变化
    if (gotoIdx == 0 && fromeIdx < 0) {
        return;
    }
    if (gotoIdx == fromeIdx ) {
        percent = 1;
    }
    
    CGFloat fromeWidth;
    CGFloat gotoWidth;
    CGFloat fromeX;
    CGFloat gotoX;
    if (self.showRealWidth) {
        fromeWidth = [self.titlesRealWidth[fromeIdx] floatValue] - self.space;
        gotoWidth  = [self.titlesRealWidth[gotoIdx] floatValue] - self.space;
        fromeX = [self.titlesX[fromeIdx] floatValue] + ([self.titlesWidth[fromeIdx] floatValue] -   [self.titlesRealWidth[fromeIdx] floatValue])/2 + self.space/2;
        gotoX = [self.titlesX[gotoIdx] floatValue] + ([self.titlesWidth[gotoIdx] floatValue] -   [self.titlesRealWidth[gotoIdx] floatValue])/2 + self.space/2;
    } else {
        fromeWidth = [self.titlesWidth[fromeIdx] floatValue] - self.space;
        gotoWidth  = [self.titlesWidth[gotoIdx] floatValue] - self.space;
        fromeX = [self.titlesX[fromeIdx] floatValue] + self.space/2;
        gotoX = [self.titlesX[gotoIdx] floatValue] + self.space/2;
    }
    
    
    self.maskView.frame = CGRectMake(fromeX + (gotoX - fromeX) * percent, self.maskView.frame.origin.y, fromeWidth + (gotoWidth - fromeWidth) * percent, self.maskView.frame.size.height);
    
    CGFloat endX = self.bodyScrollView.contentSize.width - self.frame.size.width;
    endX = endX < 0 ? 0 : endX;
    CGFloat offsetX = self.maskView.frame.origin.x;
    offsetX -= (self.frame.size.width/2-gotoWidth/2);
    if (offsetX > endX) {
        offsetX = endX;
    } else if (offsetX < 0) {
        offsetX = 0;
    }
    [self.bodyScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];

}

- (void)selectBtnAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(slideMenuView:selectedIdx:)]) {
        [self.delegate slideMenuView:self selectedIdx:sender.tag];
    }
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    [self createUI:titles withAttrib:NO];
}

- (void)setSelectedTitlesAttr:(NSArray *)selectedTitlesAttr
{
    _selectedTitlesAttr = selectedTitlesAttr;
    if (self.titlesAttr) {
        [self createUI:self.titlesAttr withAttrib:YES];
    }
}

- (void)setTitlesAttr:(NSArray *)titlesAttr
{
    _titlesAttr = titlesAttr;
    [self createUI:titlesAttr withAttrib:YES];
}

- (UIColor *)selectedColor
{
    if (!_selectedColor) {
        //434343
        _selectedColor = [UIColor colorWithRed:67.f/255.f green:67.f/255.f blue:67.f/255.f alpha:1];
    }
    return _selectedColor;
}

- (UIColor *)normalColor
{
    if (!_normalColor) {
        //999999
        _normalColor = [UIColor colorWithRed:153.f/255.f green:153.f/255.f blue:153.f/255.f alpha:1];
    }
    return _normalColor;
}

- (UIColor *)lineColor
{
    if (!_lineColor) {
        //F0594E
        _lineColor = [UIColor colorWithRed:240.f/255.f green:89.f/255.f blue:78.f/255.f alpha:1];
    }
    return _lineColor;
}

- (UIScrollView *)bodyScrollView
{
    if (!_bodyScrollView) {
        _bodyScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _bodyScrollView.bounces = NO;
        _bodyScrollView.showsHorizontalScrollIndicator = NO;
        _bodyScrollView.showsVerticalScrollIndicator = NO;
        [_bodyScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _bodyScrollView;
}

- (UIView *)backgroundLayer
{
    if (!_backgroundLayer) {
        _backgroundLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _backgroundLayer.backgroundColor = [UIColor clearColor];
    }
    return _backgroundLayer;
}

- (UIView *)maskLayer
{
    if (!_maskLayer) {
        _maskLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width , self.bounds.size.height)];
        _maskLayer.backgroundColor = [UIColor clearColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 1.5, 10000, 1)];
        lineView.backgroundColor = self.lineColor;
        [_maskLayer addSubview:lineView];
    }
    return _maskLayer;
}

- (UIView *)btnLayer
{
    if (!_btnLayer) {
        _btnLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width , self.bounds.size.height)];
    }
    return _btnLayer;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
        _maskView.backgroundColor = [UIColor blueColor];
        _maskView.tag = maskViewTag;

    }
    return _maskView;
}

- (NSMutableArray *)titlesWidth
{
    if (!_titlesWidth) {
        _titlesWidth = [NSMutableArray new];
    }
    return _titlesWidth;
}

- (NSMutableArray *)titlesRealWidth
{
    if (!_titlesRealWidth) {
        _titlesRealWidth = [NSMutableArray new];
    }
    return _titlesRealWidth;
}

- (NSMutableArray *)titlesX
{
    if (!_titlesX) {
        _titlesX = [NSMutableArray new];
    }
    return _titlesX;
}

- (UIView *)moreView
{
    if (!_moreView) {
        _moreView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 20, 0, 20, self.frame.size.height)];
        UIView *block = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 10, self.frame.size.height)];
        block.backgroundColor = [UIColor whiteColor];
        //999999
        block.layer.shadowColor = [UIColor colorWithRed:153.f/255.f green:153.f/255.f blue:153.f/255.f alpha:1].CGColor;//shadowColor阴影颜色
        block.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        block.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        block.layer.shadowRadius = 3;//阴影半径，默认3

        //设置阴影路径  
        block.layer.shadowPath = [self shadowPath:block].CGPath;
        
        [_moreView addSubview:block];
        _moreView.layer.masksToBounds = YES;
        _moreView.hidden = YES;
    }
    return _moreView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1.f];
    }
    return _lineView;
}

- (UIBezierPath *)shadowPath:(UIView *)view
{
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = view.bounds.size.width;
    float height = view.bounds.size.height;
    float x = view.bounds.origin.x;
    float y = view.bounds.origin.y;
    float addWH = 10;
    
    CGPoint topLeft      = view.bounds.origin;
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    CGPoint topRight     = CGPointMake(x+width,y);
    
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    return path;
}

- (CGFloat)offsetX
{
    return self.space==0?0:self.space/2;
}

@end
