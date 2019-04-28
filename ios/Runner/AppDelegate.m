#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Add the following line with your API key.
  [GMSServices provideAPIKey:@"AIzaSyCkWs0u3VdobkImHKj0xo8CI4bcqJ7EXHQ"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
