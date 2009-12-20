//
//  AppController.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/8/09.
//
//  Copyright (c) 2009 Andy Mroczkowski
//  
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
