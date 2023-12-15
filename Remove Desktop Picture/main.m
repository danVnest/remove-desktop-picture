//
//  main.m
//  Remove Desktop Picture
//
//  Created by Daniel Vogelnest on 2/03/13.
//  Copyright (c) 2013 Daniel Vogelnest. All rights reserved.
//

#define TEST

//#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[]) {
//    CFPreferencesAppSynchronize(CFSTR("com.apple.dock"));
//    CFPreferencesAppSynchronize(CFSTR("com.apple.spaces"));
//    CFPreferencesAppSynchronize(CFSTR("com.apple.desktop"));
//    
//    NSUserDefaults *userDefaults = [NSUserDefaults resetStandardUserDefaults];
//    NSMutableDictionary   *dockDict = [[defaults persistentDomainForName:@"com.apple.dock"] mutableCopy];
//    
//    [dockDict setValue:[NSNumber numberWithBool:YES] forKey:@"mcx-expose-disabled"]; 
//    
//    [defaults setPersistentDomain:dockDict forName:@"com.apple.dock"];
//
//    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.apple.desktop" object:@"BackgroundChanged"];
    
    NSDictionary *spacesPLIST = (__bridge NSDictionary *)(CFPreferencesCopyAppValue(CFSTR("SpacesConfiguration"), CFSTR("com.apple.spaces")));
    NSDictionary *desktopPLIST = (__bridge NSDictionary *)(CFPreferencesCopyAppValue(CFSTR("Background"), CFSTR("com.apple.desktop")));
    
    NSArray *monitors = [spacesPLIST valueForKeyPath:@"Management Data.Monitors"];
    NSInteger monitorIndex = 0;
    if ([monitors count] > 1) {
        //search for main (or ask user to select)
        for (NSDictionary *monitor in monitors) {
            NSLog(@"More than 1 monitor");
        }
        exit(EXIT_FAILURE);
    }
    NSDictionary *monitor = [monitors objectAtIndex:monitorIndex];
    NSDictionary *spaces = [desktopPLIST valueForKey:@"spaces"];
    NSString *currentSpaceUUID = [monitor valueForKeyPath:@"Current Space.uuid"];
    NSDictionary *currentSpace = [spaces valueForKey:currentSpaceUUID]; //check for error
    NSURL *desktopPicturesDirectory = [NSURL fileURLWithPath:[currentSpace valueForKeyPath:@"default.ChangePath"]
                                                 isDirectory:true];
    NSString *desktopPictureName = [currentSpace valueForKeyPath:@"default.LastName"];
    NSURL *desktopPictureURL = [NSURL URLWithString:desktopPictureName relativeToURL:desktopPicturesDirectory];
    
#ifdef TEST
    [[NSWorkspace sharedWorkspace] selectFile:[desktopPictureURL path] inFileViewerRootedAtPath:@""];
#else
    NSURL *trashURL;
    NSError *error = nil;
    [[NSFileManager defaultManager] trashItemAtURL:desktopPictureURL resultingItemURL:&trashURL error:&error];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:[NSArray arrayWithObject:trashURL]];
    // update current desktop picture
#endif
    exit(EXIT_SUCCESS);
}
