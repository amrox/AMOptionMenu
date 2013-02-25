//
//  AMOptionMenu.m
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

#import "AMOptionMenuController.h"


@interface AMOptionMenuItem ()
@property (nonatomic, readwrite) BOOL bindValue;
@end

NSString* const kAMOptionPopUpButtonTitle = @"kAMOptionPopUpButtonTitle";


@implementation AMOptionMenuItem


+ (AMOptionMenuItem*) itemWithIdentifier:(NSString*)identifier title:(NSString*)title shortTitle:(NSString*)shortTitle bindValue:(BOOL)bindValue
{
	AMOptionMenuItem* item = [[AMOptionMenuItem alloc] init];
	[item setIdentifier:identifier];
	[item setTitle:title];
	[item setShortTitle:shortTitle];
    [item setBindValue:bindValue];
    
	return item;
}


+ (AMOptionMenuItem*) itemWithIdentifier:(NSString*)identifier title:(NSString*)title bindValue:(BOOL)bindValue
{
	return [self itemWithIdentifier:identifier title:title shortTitle:nil bindValue:bindValue];
}

- (NSString*) titleForSummary
{
	if( [self shortTitle] )
		return [self shortTitle];
	return [self title];
}

@end

#pragma mark -

NSString* const kAMOptionMenuContentWillChange = @"kAMOptionMenuDataWillChange";
NSString* const kAMOptionMenuContentDidChange = @"kAMOptionMenuDataDidChange";


@interface AMOptionMenuController ()
{
    NSMutableArray* _options;
	NSMutableDictionary* _valuesDict;
	NSMutableDictionary* _stateDict;
}

- (NSArray*) createMenuItems;
- (NSArray*) optionValuesForGroupWithIdentifier:(NSString*)identifier;
- (NSMenuItem*) menuItemForGroup:(AMOptionMenuItem*)group;
- (NSMenuItem*) menuItemForOption:(AMOptionMenuItem*)option inGroup:(AMOptionMenuItem*)group;
- (void) choseOptionWithKeyPath:(NSString*)keypath;

@end

@implementation AMOptionMenuController

@synthesize options = _options;
@synthesize valuesDict = _valuesDict;

- (id) init
{
	self = [super init];
	if (self != nil)
	{
		_options = [[NSMutableArray alloc] init];
		_valuesDict = [[NSMutableDictionary alloc] init];
		_stateDict = [[NSMutableDictionary alloc] init];
		_maxValuesInSummary = NSUIntegerMax;
    }
	return self;
}

- (NSArray*) optionValuesForGroupWithIdentifier:(NSString*)identifier
{
	return [_valuesDict objectForKey:identifier];
}


- (NSArray*) createMenuItems
{
	NSMutableArray* array = [NSMutableArray array];
	for( AMOptionMenuItem* option in [self options] )
	{
		[array addObject:[self menuItemForGroup:option]];

		for( AMOptionMenuItem* value in [self optionValuesForGroupWithIdentifier:[option identifier]] )
		{
			[array addObject:[self menuItemForOption:value inGroup:option]];
		}

		// -- don't add the separator for the last item. Might be more efficient way to do, but it's a small data set.
		if( [self shouldSeparateSections] && [[self options] lastObject] != option )
		{
			[array addObject:[NSMenuItem separatorItem]];
		}

	}
	return array;
}


- (void) insertItemsInMenu:(NSMenu*)menu atIndex:(NSInteger)insertIndex
{
	for( NSMenuItem* item in [self createMenuItems] )
	{
		[menu insertItem:item atIndex:insertIndex++];
	}
}


- (NSMenuItem*) menuItemForGroup:(AMOptionMenuItem*)group
{
	NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:[group title] action:nil keyEquivalent:@""];
	[menuItem setEnabled:NO];
	return menuItem;
}


- (NSMenuItem*) menuItemForOption:(AMOptionMenuItem*)option inGroup:(AMOptionMenuItem*)group
{
	NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:[option title] action:@selector(optionChosen:) keyEquivalent:@""];

	[menuItem setIndentationLevel:1];
	[menuItem setTarget:self];
	[menuItem setEnabled:YES];

	NSString* keypath = [NSString stringWithFormat:@"%@.%@", [group identifier], [option identifier]];
	[menuItem setRepresentedObject:keypath];

	NSDictionary *bindingOptions = nil;
    
    if (option.bindValue)
        [menuItem bind:@"value" toObject:self withKeyPath:keypath options:bindingOptions];

	return menuItem;
}


- (void) optionChosen:(id)sender
{
	// ???: the visual check next to the selected item did not update correctly without deferring to the next run loop
	//[self choseOptionWithKeyPath:[sender representedObject]];

	[self performSelector:@selector(choseOptionWithKeyPath:) withObject:[sender representedObject] afterDelay:0.0];
}


- (void) choseOptionWithKeyPath:(NSString*)keypath
{
	NSLog( @"--------- choseOptionWithKeyPath: %@ ---------", keypath );
	[self setValue:[NSNumber numberWithBool:YES] forKeyPath:keypath];
    
    NSArray *keypathComponents = [keypath componentsSeparatedByString:@"."];
    assert(keypathComponents.count == 2);
    [_delegate didChooseOption:keypathComponents[1] forSection:keypathComponents[0]];
}


- (id) valueForUndefinedKey:(NSString*)key
{
	if( [_valuesDict objectForKey:key] )
	{
		id val = [_stateDict objectForKey:key];
		NSLog( @"valueForUndefinedKey: %@ = %@", key, val );
		return val;
	}

	return [super valueForUndefinedKey:key];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	if( [self allowUnkownOptions] || [_valuesDict objectForKey:key] )
	{
		NSLog( @"settingValue:%@ forKey:%@", value, key );
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
		NSString* groupKey = [keyPathComponents objectAtIndex:0];
		NSString* optionKey = [keyPathComponents objectAtIndex:1];

		if( [_valuesDict objectForKey:groupKey] )
		{
			if( [[_stateDict objectForKey:groupKey] isEqual:optionKey] )
			{
				NSLog( @"valueForKeyPath:%@ is YES", keyPath );
				return [NSNumber numberWithBool:YES];
			}
			else
			{
				NSLog( @"valueForKeyPath:%@ is NO", keyPath );
				return [NSNumber numberWithBool:NO];
			}
		}
	}
	return [super valueForKeyPath:keyPath];
}


- (void)setValue:(id)value forKeyPath:(NSString*)keyPath
{
	NSLog( @"setting value:%@ forKeyPath:%@", value, keyPath );
	NSArray* keyPathComponents = [keyPath componentsSeparatedByString:@"."];
	if( [keyPathComponents count] == 2 )
	{
		NSString* sectionKey = [keyPathComponents objectAtIndex:0];
		NSString* optionKey = [keyPathComponents objectAtIndex:1];

        NSString* option = optionKey;

        if( [_valuesDict objectForKey:sectionKey] )
        {
            if( [value boolValue] )
            {
                [self setValue:option forKey:sectionKey];
            }
            return;
        }
	}
	[super setValue:value forKeyPath:keyPath];
}


- (NSString*) summaryString
{
	NSMutableString* string = [NSMutableString string];
	NSUInteger count = 0;
	for( AMOptionMenuItem* group in [self options] )
	{
		if( count++ == [self maxValuesInSummary] )
			break;

		if( [string length] )
			[string appendString:@" | "];

		// TODO: make nicer
		NSString* optionId = [self valueForKey:[group identifier]];

		NSString* title = nil;
		for( AMOptionMenuItem* menuItem in [_valuesDict objectForKey:[group identifier]] )
		{
			if( [[menuItem identifier] isEqualToString:optionId] )
			{
				title = [menuItem titleForSummary];
				break;
			}
		}
		[string appendFormat:@"%@", title];
	}
	return [NSString stringWithString:string];
}


- (void) initializeStateForOptionWithIdentifier:(NSString*)optionId
{
	if( ![_stateDict objectForKey:optionId] )
	{
		NSString* valueId = [[[[self valuesDict] objectForKey:optionId] objectAtIndex:0] identifier];
		[_stateDict setObject:valueId forKey:optionId];
	}
}


- (NSDictionary*) state
{
	return [_stateDict copy];
}


- (void) setAlternatives:(NSArray*)values forOptionWithIdentifier:(NSString*)optionId;
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kAMOptionMenuContentWillChange object:self];
	[_valuesDict setObject:values forKey:optionId];
	[self initializeStateForOptionWithIdentifier:optionId];
	[[NSNotificationCenter defaultCenter] postNotificationName:kAMOptionMenuContentDidChange object:self];

}


- (void) insertOptionWithIdentifier:(NSString*)identifier title:(NSString*)title atIndex:(NSInteger)index
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kAMOptionMenuContentWillChange object:self];
	AMOptionMenuItem* option = [AMOptionMenuItem itemWithIdentifier:identifier title:title bindValue:YES];
	[_options insertObject:option atIndex:index];
	[[NSNotificationCenter defaultCenter] postNotificationName:kAMOptionMenuContentDidChange object:self];

}


- (void) insertOption:(AMOptionMenuItem*)option atIndex:(NSInteger)insertIndex withAternatives:(NSArray*)alternatives
{
	[_options insertObject:option atIndex:insertIndex];
	[self setAlternatives:alternatives forOptionWithIdentifier:[option identifier]];
}


- (BOOL) insertOptionsFromPropertyListWithURL:(NSURL*)url atIndex:(NSInteger)insertIndex
{
	NSArray* options = [NSArray arrayWithContentsOfURL:url];
	if( !options )
		return NO;

	for( NSDictionary* option in options )
	{
		NSString* optionIdentifier = [option objectForKey:@"identifier"];
		NSString* optionTitle = [option objectForKey:@"title"];
		[self insertOptionWithIdentifier:optionIdentifier title:optionTitle atIndex:insertIndex];

		NSArray* alternatives = [option objectForKey:@"alternatives"];
		NSMutableArray* valueItems = [NSMutableArray arrayWithCapacity:[alternatives count]];
		for( NSDictionary* value in alternatives )
		{
			NSString* valueIdentifer = [value objectForKey:@"identifier"];
			NSString* valueTitle = [value objectForKey:@"title"];
			NSString* valueShortTitle = [value objectForKey:@"shortTitle"];

			AMOptionMenuItem* valueItem = [AMOptionMenuItem itemWithIdentifier:valueIdentifer
																		 title:valueTitle
																	shortTitle:valueShortTitle
                                                                     bindValue:YES];
			[valueItems addObject:valueItem];
		}
		[self setAlternatives:valueItems forOptionWithIdentifier:optionIdentifier];
	}
	return YES;
}

@end

