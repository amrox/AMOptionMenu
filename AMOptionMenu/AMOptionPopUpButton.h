//
//  AMOptionPopUpButton.h
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AMOptionMenuDataSource;

@interface AMOptionPopUpButton : NSPopUpButton
{

}

@property (nonatomic, retain) AMOptionMenuDataSource* optionMenuDataSource;

// -- or something
// @property (nonatomic) BOOL smartTitleTruncation


@end
