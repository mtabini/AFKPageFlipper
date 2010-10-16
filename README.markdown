AFKPageFlipper
==============

AFKPageFlipper is a UIView subclass that can be used to display multiple views using a 3-D page flipping mechanism similar to flipping pages in a book. The class supports both direct (by setting a property) and touch-based view transitions in both directions. The touch-based interface supports tap-to-flip on either side of the screen, and pan-to-flip in either direction from anywhere on the screen. The pan functionality is inertial, which means that the user can also swipe to flip between pages.

Each subview that needs to be shown by the subview can contain any arbitrary content (including animated subviews, UI controls, and so on, although those are frozen while switching between pages for performance reasons). Subviews are requested using a just-in-time algorithm to conserve resources (especially memory). In addition, AFKPageFlipper supports less-than-fullscreen rendering—in fact, you can have multiple instances displayed on the same screen (although, to be honest, I can't imagine why you'd need them).

AFKPageFlipper has no external dependencies, with the exception of Quartz Core. The flipping functionality can be added to your project by simply importing two files: AFKPageFlipper.h and AFKPageFlipper.m.

You can see AFKPageFlipper in action [here](http://screencast.com/t/0vo8rdGZ). Please note that the poor frame rate is due to the recording software, and not to the performance of the class. On either the actual simulator or a physical iPad or iPhone, the class is capable of performing full-screen transitions in both landscape and portrait at 60fps without any problems that I've been able to detect.


Usage
-----

Using AFKPageFlipper is extremely simple. Generally speaking, you will need to perform these steps:

* Include AFKPageFlipper.h and AFKPageFlipper.m in your project. These are the only classes you will need.
* Import the Quartz Core framework into your project
* Create an instance of AFKPageFlipper (either programmatically or through Interface Builder) and add it to your window (or to an existing view)
* Provide the instance with a data source
* Optionally, switch programmatically to a specific page

That's it! In most cases, AFKPageFlipper will only require ten lines of actual code or less in order to be added to your project. It's actually easier to use than a UIScrollView, because all the memory management is already handled for you.


Providing a data source
-----------------------

AFKPageFlipper needs a data source from which it can (a) determine how many subviews needs visualizing and (b) fetch the individual subviews as it needs them. It's the developer's job to provide an object that can perform these operations.

The data source (which can be set by changing the dataSource property of an AFKPageFlipper instance) must implement the AFKPageFlipperDataSource formal protocol, which requires it to implement two methods:

* -numberOfPagesForPageFlipper: returns the number of pages to be displayed. Note that zero is not a valid page count (you should hide the view instead).
* -viewForPage:inFlipper: returns the particular view to be displayed in the flipper for a given page number. **Note that page numbers start at 1 and not 0,** and that it's up to you set the frame of the view properly (the flipper passes a pointer to itself to the method call so that you can determine its bounds and use them in your calculations).


Changing pages programmatically
-------------------------------

There are two ways to change the current page programmatically. The first is to set the currentPage property of an AFKPageFlipper instance; this results in a cross-fade from the current page (if any) to the new page. Please note that the class only makes basic data integrity checks: passing a page number that's higher than the maximum number of pages or less than one may result in undefined behaviour.

If you prefer to use the flip transition when changing pages programmatically, you can use the -setCurrentPage:animated: method instead. Passing YES as the value of *animated* will result in the page change to occur through a flip transition. Passing NO will result in the new view simply appearing in place without any transition.


A note on orientation
---------------------

AFKPageFlipper is orientation aware—but only in the sense that, upon sensing a change in its frame property, it will re-request the number of pages to be displayed from the data source. This is to give you an opportunity to refresh your pages in the event that a different number of views can be displayed in either orientation (for example, a simple book reader like the one implemented as a test for this project could display two pages at a time in landscape, but only one in portrait, which would mean that there are roughly twice as many pages in the latter orientation than in the former).


The sample project
------------------

AFKPageFlipper comes as part of a sample project that implements a simplistic PDF viewer. Most of the code is there as scaffolding to make the PDF rendering possible; if you want to see how AFKPageFlipper is used in practice, you can take a look at MainController.m, where you'll find both the data source implementation and the view-loading mechanism (all of eight lines of code!).