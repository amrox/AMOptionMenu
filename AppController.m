//
//  AppController.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"

#import "AMOptionMenu.h"

#import "AMOptionPopUpButton.h"

@implementation AppController



- (void) awakeFromNib
{
	
	ds = [[AMOptionMenuDataSource alloc] init];
	
	NSArray* sections = [NSArray arrayWithObjects:
						 [AMOptionMenuItem itemWithIdentifier:@"Color" title:@"Color"],
						 [AMOptionMenuItem itemWithIdentifier:@"Dinosaurs" title:@"Dinosaurs"],
						 nil];
	[ds setSections:sections];
	
	NSArray* colorOptions = [NSArray arrayWithObjects:
							 [AMOptionMenuItem itemWithIdentifier:@"Red" title:@"Red"],
							 [AMOptionMenuItem itemWithIdentifier:@"Green" title:@"Green"],
							 [AMOptionMenuItem itemWithIdentifier:@"Blue" title:@"Blue"],
							 nil];
	[ds setOptions:colorOptions forSectionWithIdentifier:@"Color"];
	
	NSArray* dinosaurOptions = [NSArray arrayWithObjects:
								[AMOptionMenuItem itemWithIdentifier:@"Awesome" title:@"Awesome"],
								[AMOptionMenuItem itemWithIdentifier:@"ReallyAwesome" title:@"Really Awesome"],
								nil];
	[ds setOptions:dinosaurOptions forSectionWithIdentifier:@"Dinosaurs"];
	
//	NSMenu* newMenu1 = [ds createMenuWithTitle:@"Stuff"];
	
	
	[[popUpButton cell] setDataSource:ds];
	
//	NSMenuItem *summaryItem = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
//	[summaryItem bind:@"title" toObject:ds withKeyPath:@"summaryString" options:nil];
//	[newMenu1 insertItem:summaryItem atIndex:0];
//	[summaryItem release];
//
//	[popUpButton setMenu:newMenu1];
//	[popUpButton setAutoenablesItems:NO];
//	[popUpButton setPullsDown:YES];
//	[popUpButton setAlignment:NSCenterTextAlignment];
//	
//	[[popUpButton cell] setArrowPosition:NSPopUpArrowAtBottom];
//	
//	[[popUpButton cell] setAltersStateOfSelectedItem:YES];
		
//	[[popUpButton cell] setControlSize:NSSmallControlSize];
//	[[popUpButton cell] setFont:[NSFont labelFontOfSize:kScanOptionsLabelSize]];
	
	
	[testMenu setSubmenu:[ds createMenuWithTitle:@"Things"]];
	

	NSRect myFrame = NSMakeRect( 10, 10, 300, 30);
	
	AMOptionPopUpButton* myPopupButton = [[AMOptionPopUpButton alloc] initWithFrame:myFrame];
	[myPopupButton setDataSource:ds];
	
	[[window contentView] addSubview:myPopupButton];
}


- (IBAction) setBlue:(id)sender
{
	[ds setValue:@"Blue" forKeyPath:@"Color"];
}


- (IBAction) setReallyAwesome:(id)sender
{
	[ds setValue:@"ReallyAwesome" forKeyPath:@"Dinosaurs"];
}



@end
