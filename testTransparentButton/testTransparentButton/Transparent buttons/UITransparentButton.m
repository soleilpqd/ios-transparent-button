//
//  UITransparentButton.m
//
//  Created by Phạm Quang Dương on 9/20/14.
//  Copyright (c) 2014 GMO RunSystem. All rights reserved.
//

#import "UITransparentButton.h"
#import "CMTransparentImage.h"
#import "ARC.h"

@interface UITransparentButton()

@property ( nonatomic, ARC_STRONG_OR_RETAIN ) CMTransparentImage *alphaMap;

@end

@implementation UITransparentButton

-( BOOL )pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ( event.type == UIEventTypeTouches && self.alphaMap )
        return [ self.alphaMap testPoint:point ];
    return [ super pointInside:point withEvent:event ];
}

#pragma mark - Private

-( void )resetAlphaMap {
    self.alphaMap = nil;
    if ( self.buttonType == UIButtonTypeCustom ) {
        UIImage *image = [ self backgroundImageForState:UIControlStateNormal ];
        if ( image ) {
            self.alphaMap = [[ CMTransparentImage alloc ] initWithImage:image
                                                        containerBounds:self.bounds
                                                            displayRect:self.bounds // UIButton always scallToFit background image
                                                          disableRetina:NO ];
        }
    }
}


-( void )setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    [ super setBackgroundImage:image forState:state ];
    if ( state == UIControlStateNormal )
        [ self resetAlphaMap ];
}

-( void )setFrame:(CGRect)frame {
    [ super setFrame:frame ];
    [ self resetAlphaMap ];
}

-( void )setBounds:(CGRect)bounds {
    [ super setBounds:bounds ];
    [ self resetAlphaMap ];
}

-( void )setBackgroundColor:(UIColor *)backgroundColor {
    [ super setBackgroundColor:backgroundColor ];
    [ self resetAlphaMap ];
}

-( void )setContentMode:(UIViewContentMode)contentMode {
    if ( self.contentMode != contentMode ) {
        [ super setContentMode:contentMode ];
        [ self resetAlphaMap ];
    }
}

#pragma mark - Life cycle

-( void )awakeFromNib {
    [ super awakeFromNib ];
    if ( self.alphaMap == nil )
        [ self resetAlphaMap ];
}

-( void )dealloc {
    self.alphaMap = nil;
#if !ARC_ENABLED
    [ super dealloc ];
#endif
}

@end
