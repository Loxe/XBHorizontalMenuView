# TBJHorizontalMenuView

# 支持一下四种模式显示 

支持String、NSAttributedString菜单名的初始化

````
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles space:(CGFloat)space font:(UIFont *)font normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor lineColor:(UIColor *)lineColor lineShowRealWidth:(BOOL)showRealWidth showMaxCount:(NSUInteger)showMaxCount avgWidth:(BOOL)avg;

- (instancetype)initWithFrame:(CGRect)frame normalTitlesAttr:(NSArray *)titles selectedTitlesAttr:(NSArray *)selectedTitles space:(CGFloat)space lineColor:(UIColor *)lineColor lineShowRealWidth:(BOOL)showRealWidth showMaxCount:(NSUInteger)showMaxCount avgWidth:(BOOL)avg;
````
支持 stringattrib
 
 
## 模式1
````
lineShowRealWidth = NO && avgWidth = NO
````
会根据设置的showMaxCount 计算横线的宽度
在item超过maxCount的时候 会在右侧出现阴影
 ![image](https://github.com/Loxe/TBJHorizontalMenuView/raw/master/gif/1.gif)
 
## 模式2
````
lineShowRealWidth = YES && avgWidth = NO
````
会根据设置的showMaxCount计算item的【最小宽度宽度】若是真实宽度大于此宽度会按照【真实宽度为准】 
但是横线的宽度会按照当前item中文字的真实宽度显示
在item超过maxCount的时候 会在右侧出现阴影
 ![image](https://github.com/Loxe/TBJHorizontalMenuView/raw/master/gif/2.gif)

## 模式3
````
lineShowRealWidth = YES && avgWidth = YES
````
会根据设置的showMaxCount计算item宽度 但是横线的宽度会按照当前item中文字的真实宽度显示
在item超过maxCount的时候 会在右侧出现阴影
 ![image](https://github.com/Loxe/TBJHorizontalMenuView/raw/master/gif/3.gif)

## 模式4
````
lineShowRealWidth = NO && avgWidth = YES
````
会根据设置的showMaxCount计算item宽度 
但是横线的宽度会按照当前item宽度显示 
在item超过maxCount的时候 会在右侧出现阴影
 ![image](https://github.com/Loxe/TBJHorizontalMenuView/raw/master/gif/4.gif)
 
# 其他说明

如果有另外一个scrollView滚动的时候 menuView需要跟着一起滚动 那么我们不需要自己计算可以设置如下代码
## 自动计算
````
[_bodyScroll addObserver:_menuView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
````

## 手动更新
如果你期望自己去跟新menuview的位置 你可以调用menuview的如下方法
````
- (void)updateUIWithContentOffset:(UIScrollView *)scrollView;
````
