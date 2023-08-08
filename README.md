# ImageCollection

ImageCollection is a robust iOS application developed in Swift, leveraging the UIKit framework for its user interface. The application provides a platform for users to search and view images sourced from the Unsplash API.

## Core Features

- **Image Search:** The application allows users to search for images using the Unsplash API.
- **Image Display:** Images are displayed in a collection view, providing a visually appealing and organized layout.
- **Dynamic Cell Sizing:** The application is designed to adjust the cell size dynamically based on the device's orientation and screen size.
- **Testing:** The application includes both unit and UI tests to ensure its functionality and reliability.

## Getting Started

The following instructions will guide you on how to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Ensure that you have the following software installed on your system:

- Xcode 12.0 or later
- iOS 14.0 or later
- Swift 5.0 or later

### Installation

To install the application, you need to clone the repository and open the project in Xcode. After that, you can build and run the project on your preferred simulator or physical device.

## Project Structure

The project is structured into several directories, each serving a specific purpose:

- `App`: This directory contains AppDelegate and SceneDelegate.
- `Models`: This directory houses the data models used in the application.
- `Services`: This directory contains the service for interacting with the Unsplash API.
- `ViewModels`: This directory contains the view models that provide data for the views.
- `Views`: This directory contains the views and their related files.
- `Tests`: This directory contains unit tests for the application.

## Usage

The application presents a collection view of images. Users can search for images using the search bar at the top of the screen. The size of the cells in the collection view dynamically adjusts based on the device's orientation and screen size.

## Testing

The project includes both unit tests. To run the tests, select the desired test suite in Xcode and execute the 'Run' command.

## Contributing

For details on our code of conduct and the process for submitting pull requests, please read the [CONTRIBUTING.md](CONTRIBUTING.md) file.

## License

This project is licensed under the MIT License. For more details, please refer to the [LICENSE.md](LICENSE.md) file.

## Acknowledgments

We would like to express our gratitude to the Unsplash API for providing the images used in this application.

## Contact

For any questions or suggestions, feel free to open an issue on this repository.

---

**Note:** This README assumes the existence of CONTRIBUTING.md and LICENSE.md files in the repository. If these files do not exist, you may want to create them, or adjust the links accordingly.
