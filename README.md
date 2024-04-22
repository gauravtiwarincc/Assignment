# Assignment
Features

    Displays images in a 3-column square grid layout.
    Asynchronously loads images from a remote API URL.
    Supports lazy loading to ensure smooth scrolling and efficient use of resources.
    Implements caching mechanisms to store images in both memory and disk cache for quick retrieval.
    Handles network errors and image loading failures gracefully.
    Provides informative error messages for troubleshooting.
    Ensures no lag while scrolling the image grid.

Implementation Details

    Language: Swift
    Architecture: MVVM (Model-View-ViewModel)
    Dependency Management: No third-party libraries used for image loading and caching.
    Image Loading: Implemented using URLSession data tasks.
    Caching: Memory and disk caching implemented using NSCache and FileManager.
    Error Handling: Network errors and image loading failures are handled and logged.
    Optimization: Collection view layout optimized for smooth scrolling with a 3-column square grid.

How to Run

To run the project:

    Clone this repository to your local machine.
    Open the project in Xcode.
    Build and run the project on a simulator or device.
