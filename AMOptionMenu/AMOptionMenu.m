//
//  AMOptionMenu.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AMOptionMenu.h"


NSString* const kAMOptionPopUpButtonTitle = @"kAMOptionPopUpButtonTitle";


@implementation AMOptionMenuItem

@synthesize identifier = _identifier;
@synthesize title = _title;
@synthesize shortTitle = _shortTitle;


+ (AMOptionMenuItem*) optionMenuSectionWithIdentifier:(NSString*)identifier title:(NSString*)title shortTitle:(NSString*)shortTitle
{
	AMOptionMenuItem* optionMenuSection = [[[AMOptionMenuItem alloc] init] autorelease];
	[optionMenuSection setIdentifier:identifier];
	[optionMenuSection setTitle:title];
	[optionMenuSection setShortTitle:shortTitle];
	return optionMenuSection;
}


+ (AMOptionMenuItem*) itemWithIdentifier:(NSString*)identifier title:(NSString*)title
{
	return [self optionMenuSectionWithIdentifier:identifier title:title shortTitle:nil];
}


- (void) dealloc
{
	[_identifier release];
	[_title release];
	[_shortTitle release];
	[super dealloc];
}

@end

#pragma mark -

@interface AMOptionMenuDataSource ()
- (NSMenuItem*) menuItemForSection:(AMOptionMenuItem*)section;
- (NSMenuItem*) menuItemForOption:(AMOptionMenuItem*)option inSection:(AMOptionMenuItem*)section;
@end

@implementation AMOptionMenuDataSource


- (id) init
{
	self = [super init];
	if (self != nil)
	{
		_sectionsDict = [[NSMutableDictionary alloc] init];
		_optionsDict = [[NSMutableDictionary alloc] init];
		_stateDict = [[NSMutableDictionary alloc] init];
	}
	return self;
}


- (NSArray*) sections
{
	return [_sectionsDict allValues];
}


- (void) setSections:(NSArray*)sections
{
	for( AMOptionMenuItem* item in sections )
	{
		[_sectionsDict setObject:item forKey:[item identifier]];
	}
}


- (NSArray*) optionsForSectionWithIdentifier:(NSString*)identifier
{
	return [_optionsDict objectForKey:identifier];
}


- (void) setOptions:(NSArray*)options forSectionWithIdentifier:(NSString*)identifier
{
	[_optionsDict setObject:options forKey:identifier];
	if( ![_stateDict objectForKey:identifier] && [options count] )
		[_stateDict setObject:[[options objectAtIndex:0] identifier] forKey:identifier];
}


- (NSMenu*) createMenuWithTitle:(NSString*)title
{
	NSMenu* menu = [[NSMenu alloc] initWithTitle:title];
	[menu setAutoenablesItems:NO];
	[menu setDelegate:self];
	
//	for( AMOptionMenuItem* section in [self sections] )
//	{
//		[menu addItem:[self menuItemForSection:section]];
//		
//		for( AMOptionMenuItem* option in [self optionsForSectionWithIdentifier:[section identifier]] )
//		{
//			[menu addItem:[self menuItemForOption:option inSection:section]];
//		}
//	}
	
	return [menu autorelease];
}


- (NSMenuItem*) menuItemForSection:(AMOptionMenuItem*)section
{
	NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:[section title] action:nil keyEquivalent:@""];
	[menuItem setEnabled:NO];
	return [menuItem autorelease];
}


- (NSMenuItem*) menuItemForOption:(AMOptionMenuItem*)option inSection:(AMOptionMenuItem*)section
{
	//NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:[option title] action:@selector(optionChosen:) keyEquivalent:@""];
	NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:[option title] action:nil keyEquivalent:@""];

	[menuItem setIndentationLevel:1];
	[menuItem setTarget:self];
	[menuItem setEnabled:YES];
	
	NSString* keypath = [NSString stringWithFormat:@"%@.%@", [section identifier], [option identifier]];
	[menuItem setRepresentedObject:keypath];

	NSDictionary* bindingOptions = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithBool:YES], NSAllowsEditingMultipleValuesSelectionBindingOption,
									nil];
	
	[menuItem bind:@"value"
		  toObject:self
	   withKeyPath:keypath
		   options:bindingOptions];

	return [menuItem autorelease];
}


- (id) valueForUndefinedKey:(NSString*)key
{
	if( [_sectionsDict objectForKey:key] )
		return [_stateDict objectForKey:key];
	
	return [super valueForUndefinedKey:key];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	if( [_sectionsDict objectForKey:key] )
	{
		//NSLog( @"settingValue:%@ forKey:%@", value, key );
		[self willChangeValueForKey:@"summaryString"];
		[_stateDict setObject:value forKey:key];
		[self didChangeValueForKey:@"summaryString"];
		return;
	}
	[super setValue:value forUndefinedKey:key];
}


- (id) valueForKeyPath:(NSString*)keyPath
{
	NSArray* keyPathComponents = [keyPath componentsSeparatedByString:@"."];
	
	if( [keyPathComponents count] == 2 )
	{
		NSString* sectionKey = [keyPathComponents objectAtIndex:0];
		NSString* optionKey = [keyPathComponents objectAtIndex:1];

		if( [_sectionsDict objectForKey:sectionKey] )
		{
			if( [[_stateDict objectForKey:sectionKey] isEqual:optionKey] )
			{
				//NSLog( @"valueForKeyPath:%@ is YES", keyPath );
				return [NSNumber numberWithBool:YES];
			}
			else
			{
				//NSLog( @"valueForKeyPath:%@ is NO", keyPath );
				return [NSNumber numberWithBool:NO];				
			}
		}
	}
	return [super valueForKeyPath:keyPath];
}


- (void)setValue:(id)value forKeyPath:(NSString*)keyPath
{
	NSArray* keyPathComponents = [keyPath componentsSeparatedByString:@"."];
	if( [keyPathComponents count] == 2 )
	{
		NSString* sectionKey = [keyPathComponents objectAtIndex:0];
		NSString* optionKey = [keyPathComponents objectAtIndex:1];		
		
		if( [_sectionsDict objectForKey:sectionKey] )
		{
			if( [value boolValue] )
			{
				[self setValue:optionKey forKey:sectionKey];
			}
			return;
		}
	}
	[super setValue:value forKeyPath:keyPath];
}


//- (void) optionChosen:(id)sender
//{
//	NSString* keyPath = [sender representedObject];
//	[self performSelector:@selector(chooseOptionWithKeyPath:) withObject:keyPath afterDelay:0.0];
//	
	// NOTE: using performSelector:afterDelay was necessary for the PopupButton UI to update

	
	// correctly.  I don't fully understand why.
//	
//	if( [sender state] == NSOnState )
//		[sender setState:NSOffState];
//	else
//		[sender setState:NSOnState];
//		
//	
//}

//
//- (void) chooseOptionWithKeyPath:(NSString*)keyPath
//{
//	[self setValue:[NSNumber numberWithBool:YES] forKeyPath:keyPath];	
//}


- (NSString*) summaryString
{
	NSMutableString* string = [NSMutableString string];
	for( NSString* sectionId in [_sectionsDict allKeys] )
	{
		if( [string length] )
			[string appendString:@" | "];
		
		// TODO: make nicer		
		NSString* optionId = [self valueForKey:sectionId];		
		[string appendFormat:@"%@", optionId];
	}
	return [NSString stringWithString:string];
}


#pragma mark NSMenu Delegate Methods


- (void)menuNeedsUpdate:(NSMenu *)menu
{
	while( [[menu itemArray] count] )
	{
		[menu removeItemAtIndex:0];
	}
	
	//NSInteger offset = 0;
	if( [[menu title] isEqualToString:kAMOptionPopUpButtonTitle] )
	{
		[menu insertItemWithTitle:@"dummy" action:nil keyEquivalent:@"" atIndex:0];
	}
		
	for( AMOptionMenuItem* section in [self sections] )
	{
		[menu addItem:[self menuItemForSection:section]];
		
		for( AMOptionMenuItem* option in [self optionsForSectionWithIdentifier:[section identifier]] )
		{
			[menu addItem:[self menuItemForOption:option inSection:section]];
		}
	}
		
	
//	while( [[menu itemArray] count] - offset) )
//	{
//		[menu removeItemAtIndex:[[menu itemArray] count]-1];
//	}
}

//- (void)menuNeedsUpdate:(NSMenu *)menu
//{
//	while( [[menu itemArray] count] )
//	{
//		[menu removeItemAtIndex:0];
//	}
//	
//	
//	if( [[menu title] isEqualToString:kAMOptionPopUpButtonTitle] )
//	{
//		// insert dummy
//		
//		[menu insertItemWithTitle:@"dummy" action:nil keyEquivalent:@"" atIndex:0];
//		
//		
//		//		offset = 1;
//		
//		
//	}
//	
//	
////	while( ([[menu itemArray] count] - offset) > 0 )
////	{
////		[menu removeItemAtIndex:[[menu itemArray] count]-1];
////	}
//
//	
////	if( [[menu title] isEqualToString:kAMOptionPopUpButtonTitle] )
////	{
////		NSMenuItem *summaryItem = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
////		[summaryItem bind:@"title" toObject:self withKeyPath:@"summaryString" options:nil];
////		[menu insertItem:summaryItem atIndex:0];
////		[summaryItem release];
////	}
//	
//	for( AMOptionMenuItem* section in [self sections] )
//	{
//		[menu addItem:[self menuItemForSection:section]];
//		
//		for( AMOptionMenuItem* option in [self optionsForSectionWithIdentifier:[section identifier]] )
//		{
//			[menu addItem:[self menuItemForOption:option inSection:section]];
//		}
//	}
//}


//- (NSInteger)numberOfItemsInMenu:(NSMenu *)menu
//{
//	//return 5;
//	NSInteger optionsCount = 0;
//	for( id x in [_optionsDict allValues] )
//	{
//		optionsCount += [x count];
//	}
//	
//	if( [[menu title] isEqualToString:kAMOptionPopUpButtonTitle] )
//	{
//		optionsCount += 1;
//	}
//	
//	return [_sectionsDict count] + optionsCount;
//}
//
//
//- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(NSInteger)index shouldCancel:(BOOL)shouldCancel
//{
//	NSInteger indexOffset = 0;
//	if( [[menu title] isEqualToString:kAMOptionPopUpButtonTitle] )
//	{
//		indexOffset = 1;
//		
//		if( index == 0 )
//		{
//			[item bind:@"title" toObject:self withKeyPath:@"summaryString" options:nil];
//		}
//		
//		
//	}
//	
//	
//	
//	
//	return YES;
//}


//- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(NSInteger)index shouldCancel:(BOOL)shouldCancel
//{
//	
//	NSMutableArray* flat = [[NSMutableArray alloc] init];
//	
//	
//	for( AMOptionMenuItem* section in [self sections] )
//	{
//		[flat addObject:[self menuItemForSection:section]];
//		
//		for( AMOptionMenuItem* option in [self optionsForSectionWithIdentifier:[section identifier]] )
//		{
//			[flat addObject:[self menuItemForOption:option inSection:section]];
//		}
//	}
//	
//	
//	if( [[menu title] isEqualToString:kAMOptionPopUpButtonTitle] )
//	{
//		NSLog(@"");
//		
//	}
//	
//	return YES;
//	
//	
//}



// THOUGHT: bind to Dinosaurs.Awesome.isSelected ????

@end

