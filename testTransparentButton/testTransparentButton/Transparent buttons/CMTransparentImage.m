//
//  CMTransparentImage.m
//
//  Created by Phạm Quang Dương on 9/20/14.
//  Copyright (c) 2014 GMO RunSystem. All rights reserved.
//

#import "CMTransparentImage.h"
#import "ARC.h"

@interface CMTransparentImage() {
    CGFloat _scale;
    Byte *_bitmapData;
    CGRect _bounds;
}

@end

@implementation CMTransparentImage

+( CGRect )displayFrameForImageSize:(CGSize)imageSize inViewSize:(CGSize)viewSize forContentMode:(UIViewContentMode)contentMode {
    CGRect frame = CGRectZero;
    frame.size = imageSize;
    switch ( contentMode ) {
        case UIViewContentModeBottom:
            frame.origin.x = ( viewSize.width - frame.size.width ) / 2;
            frame.origin.y = viewSize.height - frame.size.height;
            break;
        case UIViewContentModeBottomLeft:
            frame.origin.x = 0;
            frame.origin.y = viewSize.height - frame.size.height;
            break;
        case UIViewContentModeBottomRight:
            frame.origin.x = viewSize.width - frame.size.width;
            frame.origin.y = viewSize.height - frame.size.height;
            break;
        case UIViewContentModeCenter:
            frame.origin.x = ( viewSize.width - frame.size.width ) / 2;
            frame.origin.y = ( viewSize.height - frame.size.height ) / 2;
            break;
        case UIViewContentModeLeft:
            frame.origin.x = 0;
            frame.origin.y = ( viewSize.height - frame.size.height ) / 2;
            break;
        case UIViewContentModeRight:
            frame.origin.x = viewSize.width - frame.size.width;
            frame.origin.y = ( viewSize.height - frame.size.height ) / 2;
            break;
        case UIViewContentModeScaleAspectFill:
            if ( frame.size.width > viewSize.width && frame.size.height > viewSize.height ) {
                CGFloat newWidth = frame.size.width * viewSize.height / frame.size.height;
                if ( newWidth >= viewSize.width ) {
                    frame.size.width = newWidth;
                    frame.size.height = viewSize.height;
                }
                CGFloat newHeight = frame.size.height * viewSize.width / frame.size.width;
                if ( newHeight >= viewSize.height ) {
                    frame.size.height = newHeight;
                    frame.size.width = viewSize.width;
                }
            }
            if ( frame.size.width < viewSize.width ) {
                CGFloat newHeight = frame.size.height * viewSize.width / frame.size.width;
                if ( newHeight >= viewSize.height ) {
                    frame.size.height = newHeight;
                    frame.size.width = viewSize.width;
                }
            }
            if ( frame.size.height < viewSize.height ) {
                CGFloat newWidth = frame.size.width * viewSize.height / frame.size.height;
                if ( newWidth >= viewSize.width ) {
                    frame.size.width = newWidth;
                    frame.size.height = viewSize.height;
                }
            }
            frame.origin.x = ( viewSize.width - frame.size.width ) / 2;
            frame.origin.y = ( viewSize.height - frame.size.height ) / 2;
            break;
        case UIViewContentModeScaleAspectFit:
            if ( frame.size.width > viewSize.width ) {
                CGFloat newHeight = frame.size.height * viewSize.width / frame.size.width;
                if ( newHeight <= viewSize.height ) {
                    frame.size.height = newHeight;
                    frame.size.width = viewSize.width;
                }
            }
            if ( frame.size.height > viewSize.height ) {
                CGFloat newWidth = frame.size.width * viewSize.height / frame.size.height;
                if ( newWidth <= viewSize.width ) {
                    frame.size.width = newWidth;
                    frame.size.height = viewSize.height;
                }
            }
            if ( frame.size.width < viewSize.width && frame.size.height < viewSize.height ) {
                CGFloat newWidth = frame.size.width * viewSize.height / frame.size.height;
                if ( newWidth <= viewSize.width ) {
                    frame.size.width = newWidth;
                    frame.size.height = viewSize.height;
                }
                CGFloat newHeight = frame.size.height * viewSize.width / frame.size.width;
                if ( newHeight <= viewSize.height ) {
                    frame.size.height = newHeight;
                    frame.size.width = viewSize.width;
                }
            }
            frame.origin.x = ( viewSize.width - frame.size.width ) / 2;
            frame.origin.y = ( viewSize.height - frame.size.height ) / 2;
            break;
        case UIViewContentModeScaleToFill:
            frame.size = viewSize;
            break;
        case UIViewContentModeTop:
            frame.origin.x = ( viewSize.width - frame.size.width ) / 2;
            frame.origin.y = 0;
            break;
        case UIViewContentModeTopLeft:
        case UIViewContentModeRedraw:
            frame.origin.x =
            frame.origin.y = 0;
            break;
        case UIViewContentModeTopRight:
            frame.origin.x = viewSize.width - frame.size.width;
            frame.origin.y = 0;
            break;
        default:
            break;
    }
    return frame;
}

#pragma mark - Life cycle

-( id )initWithImage:(UIImage *)image disableRetina:(BOOL)noRetina {
    if ( image == nil ) return nil;
    if ( self = [ super init ]) {
        if ( noRetina )
            _scale = 1.0f;
        else
            _scale = image.scale;
        _bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
        [ self drawBitmapWithImage:image
                          inBounds:image.size
                      displayFrame:_bounds
                   backgroundColor:nil ];
    }
    return self;
}

-( id )initWithImage:(UIImage *)image containerBounds:(CGRect)bounds
         displayRect:(CGRect)imageFrame backgroundColor:(UIColor *)backgroundColor
       disableRetina:(BOOL)noRetina {
    if ( image == nil ) return nil;
    if ( self = [ super init ]) {
        if ( noRetina )
            _scale = 1.0f;
        else
            _scale = image.scale;
        _bounds = CGRectZero;
        _bounds.size = bounds.size;
        [ self drawBitmapWithImage:image
                          inBounds:bounds.size
                      displayFrame:imageFrame
                   backgroundColor:backgroundColor ];
    }
    return self;
}

-( void )dealloc {
    free( _bitmapData );
#if !ARC_ENABLED
    [ super dealloc ];
#endif
}

#pragma mark - Private

-( void )drawBitmapWithImage:( UIImage* )image inBounds:( CGSize )boundsSize displayFrame:( CGRect )imgFrame backgroundColor:( UIColor* )bkgColor {
    // Buffer
    size_t bitmapSize = boundsSize.width * _scale * boundsSize.height * _scale;
    _bitmapData = calloc( bitmapSize, 1 );
    memset( _bitmapData, 0, bitmapSize );
    // Draw to get alpha
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGImageRef backgroundImage = image.CGImage;
    CGContextRef context = CGBitmapContextCreate( _bitmapData,
                                                 ceil( boundsSize.width * _scale ),
                                                 ceil( boundsSize.height * _scale ),
                                                 8,
                                                 ceil( boundsSize.width * _scale ),
                                                 colorSpace,
                                                 ( CGBitmapInfo )kCGImageAlphaOnly );
    
    // Adjust frame for retina
    CGRect bounds = CGRectZero;
    bounds.size = boundsSize;
    if ( _scale > 1 ) {
        imgFrame.origin.x *= _scale;
        imgFrame.origin.y *= _scale;
        imgFrame.size.width *= _scale;
        imgFrame.size.height *= _scale;
        bounds.size.width *= _scale;
        bounds.size.height *= _scale;
    }
    // Draw background
    if ( bkgColor == nil ) bkgColor = [ UIColor clearColor ];
    CGContextClearRect( context, bounds );
    CGContextSetFillColorWithColor( context, bkgColor.CGColor );
    CGContextFillRect( context, bounds );
    // Draw image
    CGContextDrawImage( context, imgFrame, backgroundImage );
    CGContextRelease( context );
    CGColorSpaceRelease( colorSpace );
#if LOG_BITMAP_DATA
    FILE *file = fopen([[ NSString stringWithFormat:@"%@/Documents/%i_%p.txt", NSHomeDirectory(), self.tag, self ] UTF8String ], "w+" );
    for ( unsigned int i = 0; i < self.frame.size.height * scale; i++ ) {
        for ( unsigned int j = 0; j < self.frame.size.width * scale; j++ ) {
            NSUInteger index = i * self.frame.size.width + j;
            fprintf( file, "%02lx ", _bitmapData[ index ]);
        }
        fprintf( file, "\n" );
    }
    fclose( file );
#endif
}

#pragma mark - Public

-( BOOL )testPoint:(CGPoint)point {
    return [ self testPoint:point withThreshold:0 ];
}

-( BOOL )testPoint:(CGPoint)point withThreshold:(unsigned int)alphaThreshold {
    if ( CGRectContainsPoint( _bounds, point )) {
        NSUInteger index =  ceil( point.y * _scale ) * ceil( _bounds.size.width * _scale ) + ceil( point.x * _scale );
        unsigned long picAlpha = _bitmapData[ index ];
        return picAlpha > alphaThreshold;
    }
    return NO;
}

-( CGImageRef )CGImage {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate( _bitmapData,
                                                 ceil( _bounds.size.width * _scale ),
                                                 ceil( _bounds.size.height * _scale ),
                                                 8,
                                                 ceil( _bounds.size.width * _scale ),
                                                 colorSpace,
                                                 ( CGBitmapInfo )kCGImageAlphaOnly );
    CGImageRef image = CGBitmapContextCreateImage( context );
    CGColorSpaceRelease( colorSpace );
    CGContextRelease( context );
    return image;
}

@end
