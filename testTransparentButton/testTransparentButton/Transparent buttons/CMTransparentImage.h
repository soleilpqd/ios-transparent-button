//
//  CMTransparentImage.h
//
//  Created by Phạm Quang Dương on 9/20/14.
//  Copyright (c) 2014 GMO RunSystem. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Store alpha map of image pixels */
@interface CMTransparentImage : NSObject

/**
 *  Calculate frame to draw image depending on receiver content mode
 *
 *  @param imageSize   Size of image to display
 *  @param viewSize    Size of view displaying image
 *  @param contentMode Content mode of displayer
 *
 *  @return Rect to render image
 */
+( CGRect )displayFrameForImageSize:( CGSize )imageSize inViewSize:( CGSize )viewSize forContentMode:( UIViewContentMode )contentMode;

/**
 *  Create new alpha map object from an image.
 *
 *  @param image    Image to extract alpha map
 *  @param noRetina YES to ignore Retina scale, render map as non Retina (take less memory but less exact)
 *
 *  @return Alpha map object
 */
-( id )initWithImage:( UIImage* )image
       disableRetina:( BOOL )noRetina;

/**
 *  This method makes an new image by render the given image in area having specified size, using the specifed frame to draw the image.
 *  Finally, use the new image to make alpha map object.
 *  Use this method to create alpha map object for a view which has background image frame not fit with view bounds.
 *
 *  @param image           Image to extract alpha map
 *  @param bounds          Size (bounds) of view displaying image
 *  @param imageFrame      Frame of image on view
 *  @param backgroundColor Background color of view, can be nil
 *  @param noRetina        YES to ignore Retina scale, render map as non Retina (take less memory but less exact)
 *
 *  @return Alpha map object
 */
-( id )initWithImage:( UIImage* )image
     containerBounds:( CGRect )bounds
         displayRect:( CGRect )imageFrame
     backgroundColor:( UIColor* )backgroundColor
       disableRetina:( BOOL )noRetina;

/**
 *  Check point is transparent or opaque. Threshld is 0.
 *
 *  @param point Coordinates of pixel to test transparent (with non-Rentina image)
 *
 *  @return YES if point inside map and opaque
 */
-( BOOL )testPoint:( CGPoint )point;
/**
 *  Check point is transparent
 *
 *  @param point Coordinates of pixel to test transparent (with non-Rentina image)
 *  @param alphaThreshold Threshold to check. Pixel which has alpha value greater than threshold is opaque
 *
 *  @return YES if point inside map and opaque
 */
-( BOOL )testPoint:( CGPoint )point withThreshold:( unsigned int )alphaThreshold;

/**
 *  Make an image of map, can be use to make clips mask
 *
 *  @return Image from alpha map
 */
-( CGImageRef )CGImage;

@end
