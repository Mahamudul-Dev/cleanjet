# Cleanjet CLI

**Cleanjet** is a Flutter project initializer and feature generator CLI tool that helps developers quickly scaffold Flutter projects and maintain a clean and consistent project structure.

## Features

- Initialize a new Flutter project with a structured directory layout.
- Add required dependencies and dev dependencies automatically.
- Generate boilerplate code for the main application and configuration files.
- Create new features with a predefined structure.

## Installation

To install **Cleanjet**, run:

```bash
dart pub global activate cleanjet
```

## Usage
Initialize a New Project
To initialize a new Flutter project, run:

```bash
cleanjet init
```


You will be prompted to provide:

- Project Name: The name of the project (e.g., my_app).
- Initial Feature Name: (Optional) The name of the first feature to create.

## Create a New Feature
To generate a new feature within the project, run:

```bash
cleanjet create feature
```

## Project Structure
Cleanjet generates a clean and consistent project structure as follows:
```
|- assets
|-- audios
|-- fonts
|-- icons
|-- images
|-- translations
|- lib
|-- config
|--- routes
|---- app_pages.dart
|---- app_routes.dart
|--- theme
|--- config.dart
|-- src
|--- core
|---- network
|---- resources
|----- data_state.dart
|---- usecases
|---- utils
|--- features
|---- <feature_name>
|----- data
|------ data_sources
|------ models
|------ repository
|----- domain
|------ entities
|------ repository
|------ usecases
|----- presentation
|------ bloc
|------ pages
|------ widgets
|--- <app_name>.dart
|-- main.dart

```


## Dependencies and Dev Dependencies
When you run ```cleanjet init```, the following dependencies will be automatically added to your project:

```
bloc
flutter_bloc
go_router
meta
equatable
get_it
intl
dio
retrofit
logger
json_annotation
flutter_hooks
cached_network_image
google_fonts
```

## Dev Dependencies
```
retrofit_generator
build_runner
json_serializable
```


## About
**Cleanjet** CLI is developed and maintained by Codejet Dev.

Author: Mahamudul Hasan
Website: https://codejet.dev

Feel free to contribute to the project or report issues on the repository!