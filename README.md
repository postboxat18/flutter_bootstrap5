# Flutter Bootstrap 5

## Overview

This repository provides an easy way to integrate Bootstrap 5 with Flutter to create responsive web applications. By using the `flutter_bootstrap5` package, you can leverage the power of Bootstrap's grid system and components directly within your Flutter projects.

## Integration

To integrate Bootstrap 5 into your Flutter project, add the [`flutter_bootstrap5`](https://pub.dev/packages/flutter_bootstrap5) package to your `pubspec.yaml` file.

## Bootstrap Grid System

Bootstrap 5 uses a powerful mobile-first flexbox grid system to build layouts of all shapes and sizes. The grid system is responsive and uses a series of containers, rows, and columns to layout and align content. It's built with flexbox and is fully responsive. Below are the screen size breakpoints:

- **Extra small (xs)**: `<576px`
- **Small (sm)**: `≥576px`
- **Medium (md)**: `≥768px`
- **Large (lg)**: `≥992px`
- **Extra large (xl)**: `≥1200px`
- **Extra extra large (xxl)**: `≥1400px`

## `FB5Row` and `FB5Col`

- **`FB5Row`**: This widget acts as a container for columns. It is similar to Bootstrap's `.row` class and is used to group `FB5Col` widgets. It ensures that columns are aligned properly and provides a responsive layout.

- **`FB5Col`**: This widget represents a column within a `FB5Row`. It accepts a `sizes` parameter where you can specify how many columns it should span across different screen sizes using Bootstrap's responsive grid classes (e.g., `col-12`, `col-md-6`, `col-lg-4`).
