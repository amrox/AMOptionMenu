//
//  AMOptionPopUpButton.h
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AMOptionMenuController;

@interface AMOptionPopUpButton : NSPopUpButton
{
	BOOL _smartTitleTruncation;
}

@property (nonatomic, retain) AMOptionMenuController* optionMenuController;

@property (nonatomic, assign) BOOL smartTitleTruncation;


@end
