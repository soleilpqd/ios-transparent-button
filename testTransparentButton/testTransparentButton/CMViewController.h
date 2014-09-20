//
//  CMViewController.h
//  testTransparentButton
//
//  Created by Phạm Quang Dương on 9/18/14.
//  Copyright (c) 2014 GMO RunSystem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMViewController : UIViewController {
    IBOutlet UIButton *_btnLeft;
    IBOutlet UIButton *_btnRight;
    IBOutlet UIButton *_btnBottom;
    IBOutlet UIButton *_btnCenter;
    
    IBOutlet UILabel *_lblText;
}

-( IBAction )btnDemo_onTap:(id)sender;

@end
