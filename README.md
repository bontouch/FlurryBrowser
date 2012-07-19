Flurry Browser
==============

Flurry Browser is an demo application created to show how flurry can be used.

Configuration
-------------

* Signup to [Flurry](http://www.flurry.com/dev/signup.html) and then login.
* Create a [new application](https://dev.flurry.com/createProjectSelectPlatform.do) within flurry.
* This should have given you a key to use with flurry.
* Create a file called `FlurryBrowser/FlurryBrowser/FlurryKey.h` and add the following line, replacing the key with your own flurry key:


    \#define FLURRY_KEY @"XXXXXXXXXXXXXXXX"

Usage
-----

Install the application on your device, and use it. Make sure you close and reopen the application a couple of times, this makes sure all the data is sent to flurry. Within 5-6 hours the first data should be arriving. [Watch your data!](https://dev.flurry.com/viewProjects.do)

License
-------

This project is distributed under apache license 2.0. For more information checkout the `LICENSE.txt`.
