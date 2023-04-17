# RnD Mobile Assignment - City Search

## Project Overview

This project focuses on optimizing the search functionality for a large dataset, a JSON file containing over 200,000 city entities. The key optimization technique implemented is binary search, which significantly enhances search performance.

## View Controllers

The project consists of two primary view controllers: **CitiesViewController** and **MapViewController**.

### CitiesViewController

The **CitiesViewController** incorporates a _SearchController_ for carrying out searches and a _TableView_ for displaying search results. It utilizes a segue to transition to the **MapViewController** in order to display the selected city's map. The data for this controller is sourced from **CitiesController**.

### MapViewController

A standard _ViewController_ that features an MKMapView. The city information is passed as a parameter from **CitiesViewController**. In this view, a pin is displayed on the map to represent the selected city's location.

## Data Controllers

The project contains one data controller, named _CitiesController_.

### CitiesController

_CitiesController_ employs a _shared_ instance due to the need for initialization.

Originally, the intention was for the controller to return an array of results to _CitiesViewController_. However, considering the performance optimization requirements for handling over 200,000 items, all cities are maintained in the _cityList_ array, while the range of search results is stored in _searchResultsIndex_.

Initially, filtering the _cityList_ array was slow. To enhance performance, the code was modified to keep all cities in the _cityList_ array and utilize _searchResultsIndex_ for maintaining the indexes of the first and last valid search elements. This improved performance.

### Implementing Binary Search

Searching items sequentially is slow and inefficient, especially since the _cityList_ array is already sorted. Consequently, binary search was implemented, resulting in a performance boost. This improvement significantly enhances the user experience by displaying **results instantly as the user types**.

## Data models

Two data models are included in the project: **City** and **Coordinates**:

-   **City** is a _Codable_ struct containing the essential fields for the project. It also has the _formattedString_ property, which returns the required format for table cells, and _searchValue_, a lowercased version of _formattedString_. Since it is read multiple times during sorting and slowed down the app's loading time, its value is set by `CitiesController.parseSearchValues()` after loading all cities from the JSON file.
-   **Coordinates** is a struct containing a city's latitude and longitude. The **City** class includes a `coordinate` property that uses the _lat_ and _lon_ values to return a proper `CLLocationCoordinate2D` object.

## Unit Tests

The project features tests for the _CitiesController_ class, including searches that cover valid results and those that return no results.
