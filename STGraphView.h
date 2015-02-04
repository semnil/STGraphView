//
//  STGraphView.h
//  STGraphView
//
//  Created by Shinone Tetsuya on 2013/02/24.
//  Copyright (c) 2013 Shinone Tetsuya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    STGraphViewTypeLine,
    STGraphViewTypeBar,
    STGraphViewTypePie
} STGraphViewType;

typedef enum {
    STGraphViewModeNormal,
    STGraphViewModeCumulative,      // value level cumulation
    STGraphViewModeCumulativeAll    // source level cumulation
} STGraphViewMode;

@protocol STGraphViewDelegate
@required
- (long)numberOfSource;
- (long)numberOfValueWithSource:(long)source;
- (float)valueOfIndex:(long)index withSource:(long)source;
- (UIColor *)lineColorOfValueWithSource:(long)source;
- (UIColor *)fillColorOfValueWithSource:(long)source;
@optional
@end

@interface STGraphView : UIView
{
    id _delegate;
    int _graphType;
    int _graphMode;
    float _borderWidth;
    // Line graph parameters
    float _lineWidth;
    float _labelWidth;
    
    float _paddingLeft;
    float _paddingRight;
    float _paddingTop;
    float _paddingBottom;
    
    bool _showAverage;
    
    float _labelTextSize;
    NSString *_labelTextFontName;
    
    NSString *_unitSring;
}

@property (assign, nonatomic) id <STGraphViewDelegate>delegate;
@property (assign, nonatomic) int graphType;
@property (assign, nonatomic) int graphMode;
@property (assign, nonatomic) float paddingLeft;
@property (assign, nonatomic) float paddingRight;
@property (assign, nonatomic) float paddingTop;
@property (assign, nonatomic) float paddingBottom;
@property (assign, nonatomic) bool showAverage;
@property (retain, nonatomic) NSString *labelTextFontName;
@property (retain, nonatomic) NSString *unitSring;

- (void)setPaddingWithWidth:(float)width height:(float)height;

@end
