//
//  STViewController.h
//  STGraphViewTest
//
//  Created by Shinone Tetsuya on 2013/02/24.
//  Copyright (c) 2013 Shinone Tetsuya. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STGraphView.h"

@interface STViewController : UIViewController<STGraphViewDelegateProtocol>
{
    NSArray *_graphValues;
}

@end
