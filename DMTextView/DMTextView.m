/**
 The MIT License (MIT)
 
 Copyright (c) 2015 DreamCao
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import "DMTextView.h"

@interface DMTextView ()

@property (nonatomic, strong) UILabel *m_placeholderLabel;

@property (nonatomic, strong) NSArray *m_observingKeyArray;

@end

@implementation DMTextView

#pragma mark - setter / getter

- (UILabel *)m_placeholderLabel
{
    if (nil == _m_placeholderLabel)
    {
        //以下设置self.text，是为了获取出self.font字体大小
        NSAttributedString *originalText = self.attributedText;
        self.text = @" ";
        self.attributedText = originalText;
        
        UILabel *label = [[UILabel alloc] init];
        _m_placeholderLabel = label;
        
        label.textColor = [UIColor lightGrayColor];
        label.numberOfLines = 0;
        label.userInteractionEnabled = NO;
        label.font = self.font; //获取当前font
        
        [self observeCreate];
    }
    
    return _m_placeholderLabel;
}

- (NSArray *)m_observingKeyArray
{
    if (nil == _m_observingKeyArray)
    {
        _m_observingKeyArray = @[@"attributedText",
                                 @"bounds",
                                 @"font",
                                 @"frame",
                                 @"text",
                                 @"textAlignment",
                                 @"textContainerInset"];
    }
    
    return _m_observingKeyArray;
}

- (NSString *)placeholder
{
    return self.m_placeholderLabel.text;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.m_placeholderLabel.text = placeholder;
    [self updatePlaceholderLabel];
}


- (UIColor *)placeholderColor
{
    return self.m_placeholderLabel.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.m_placeholderLabel.textColor = placeholderColor;
}


#pragma mark - observe
- (void)observeRemove
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (nil != self.m_placeholderLabel)
    {
        [self.m_observingKeyArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:self forKeyPath:obj];
        }];
    }
}

- (void)observeCreate
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePlaceholderLabel)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
    if (nil != self.m_placeholderLabel)
    {
        [self.m_observingKeyArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            [self addObserver:self forKeyPath:obj options:NSKeyValueObservingOptionNew context:nil];
        }];
    }
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    [self updatePlaceholderLabel];
}


#pragma mark - Update Label
- (void)updatePlaceholderLabel
{
    if (self.text.length)
    {
        [self.m_placeholderLabel removeFromSuperview];
        return;
    }
    
    [self insertSubview:self.m_placeholderLabel atIndex:0];
    
    self.m_placeholderLabel.font = self.font;
    self.m_placeholderLabel.textAlignment = self.textAlignment;
    
    // `NSTextContainer` is available since iOS 7
    CGFloat lineFragmentPadding;
    UIEdgeInsets textContainerInset;

    lineFragmentPadding = self.textContainer.lineFragmentPadding;
    textContainerInset = self.textContainerInset;
    
    CGFloat x = lineFragmentPadding + textContainerInset.left;
    CGFloat y = textContainerInset.top;
    CGFloat width = CGRectGetWidth(self.bounds) - x - lineFragmentPadding - textContainerInset.right;
    CGFloat height = [self.m_placeholderLabel sizeThatFits:CGSizeMake(width, 0)].height;
    self.m_placeholderLabel.frame = CGRectMake(x, y, width, height);
}


@end
