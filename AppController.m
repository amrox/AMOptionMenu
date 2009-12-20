//
//  AppController.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"

#import "AMOptionMenuController.h"

#import "AMOptionPopUpButton.h"
#import "AMOptionPopUpButtonCell.h"

@implementation AppController

@synthesize popUpButton;

- (void) awakeFromNib
{	
	optionMenuController = [[AMOptionMenuController alloc] init];
	
	// -- uncomment the following to add separators between sections
	//optionMenuController.shouldSeparateSections = YES;

	// -- add some options in code
	NSArray* colorAlternatives = [NSArray arrayWithObjects:
								  [AMOptionMenuItem itemWithIdentifier:@"Red" title:@"Red"],
								  [AMOptionMenuItem itemWithIdentifier:@"Green" title:@"Green"],
								  [AMOptionMenuItem itemWithIdentifier:@"Blue" title:@"Blue"],
								  nil];	
	[optionMenuController insertOptionWithIdentifier:@"Color" title:@"Color" atIndex:0];
	[optionMenuController setAlternatives:colorAlternatives forOptionWithIdentifier:@"Color"];
	
	
	// -- add some options form a resource file
	NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"DinosaurOptions" ofType:@"plist"];
	[optionMenuController insertOptionsFromPropertyListWithURL:[NSURL fileURLWithPath:plistPath] atIndex:1];
	
	// -- configure a popp button in a nib
	[popUpButton setOptionMenuController:optionMenuController];
	popUpButton.smartTitleTruncation = YES;
		
	// -- create a menu 
	NSMenu* thingsMenu = [[NSMenu alloc] initWithTitle:@"Things"];
	[optionMenuController insertItemsInMenu:thingsMenu atIndex:0];
	[testMenu setSubmenu:thingsMenu];
	[thingsMenu release];

	// -- create a popup button programmatically
	NSRect myFrame = NSMakeRect( 10, 10, 300, 30);
	AMOptionPopUpButton* myPopupButton = [[AMOptionPopUpButton alloc] initWithFrame:myFrame pullsDown:YES];
	[myPopupButton setOptionMenuController:optionMenuController];
	[[window contentView] addSubview:myPopupButton];
}


- (IBAction) setBlue:(id)sender
{
	[optionMenuController setValue:@"Blue" forKeyPath:@"Color"];
}


- (IBAction) setReallyAwesome:(id)sender
{
	[optionMenuController setValue:[NSNumber numberWithBool:YES] forKeyPath:@"Dinosaurs.isReallyAwesome"];
}



@end
