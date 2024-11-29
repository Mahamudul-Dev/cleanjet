import 'dart:io';
import 'package:cleanjet/constants.dart';
import 'package:recase/recase.dart';
import 'package:yaml_edit/yaml_edit.dart';

void initializeProject() {
  stdout.write('Enter project name: ');
  final projectName = stdin.readLineSync()?.trim();
  if (projectName == null || projectName.isEmpty) {
    print('Project name is required.');
    return;
  }

  final pascalCaseAppName = projectName.pascalCase;
  final snakeCaseAppName = projectName.snakeCase;

  stdout.write('Enter initial feature name (optional): ');
  final featureName = stdin.readLineSync()?.trim().snakeCase;

  // Create Flutter project (override)
  print('Initializing Flutter project...');
  Process.runSync('flutter', ['create', '.'], workingDirectory: Directory.current.path);

  // Add dependencies
  addDependencies(Constants.dependencies);
  addDevDependencies(Constants.devDependencies);

  // Create directories
  print('Creating project structure...');
  createDirectories([
    'assets/audios',
    'assets/fonts',
    'assets/icons',
    'assets/images',
    'assets/translations',
    'lib/config/routes',
    'lib/config/theme',
    'lib/src/core/network',
    'lib/src/core/resources',
    'lib/src/core/usecases',
    'lib/src/core/utils',
    'lib/src/features/${featureName ?? ''}/data/data_sources',
    'lib/src/features/${featureName ?? ''}/data/models',
    'lib/src/features/${featureName ?? ''}/data/repository',
    'lib/src/features/${featureName ?? ''}/domain/entities',
    'lib/src/features/${featureName ?? ''}/domain/repository',
    'lib/src/features/${featureName ?? ''}/domain/usecases',
    'lib/src/features/${featureName ?? ''}/presentation/bloc',
    'lib/src/features/${featureName ?? ''}/presentation/pages',
    'lib/src/features/${featureName ?? ''}/presentation/widgets',
  ]);

  updatePubspec();

  // Create initial files
  print('Generating boilerplate code...');
  createFile('lib/main.dart', generateMainDart(snakeCaseAppName));
  createFile('test/widget_test.dart', generateTestDart());
  createFile('lib/src/$snakeCaseAppName.dart', generateAppDart(pascalCaseAppName));
  createFile('lib/config/config.dart', generateConfigDart(pascalCaseAppName));
  createFile('lib/config/routes/app_routes.dart', generateAppRoutesDart());
  createFile('lib/config/routes/app_pages.dart', generateAppPagesDart());
  createFile('lib/src/core/resources/data_state.dart', generateDataStateDart());

  print('Project initialization complete!');
}


void updatePubspec() {
  print('Updating pubspec.yaml...');
  final pubspecFile = File('pubspec.yaml');

  if (!pubspecFile.existsSync()) {
    print('Error: pubspec.yaml not found!');
    return;
  }

  try {
    // Read the original content
    final content = pubspecFile.readAsStringSync();

    // Remove all comments and clean gaps
    final cleanedContent = _removeCommentsAndGaps(content);

    // Parse the cleaned YAML content
    final editor = YamlEditor(cleanedContent);

    // Define the assets configuration
    const flutterConfig = {
      'assets': [
        'assets/images/',
        'assets/icons/',
        'assets/audios/',
        'assets/fonts/',
        'assets/translations/',
      ]
    };

    // Add or update the `flutter` section
    editor.update(['flutter'], flutterConfig);
  
    // Write the updated content back to the file
    pubspecFile.writeAsStringSync(editor.toString());
    print('pubspec.yaml updated successfully!');
  } catch (e) {
    print('Error updating pubspec.yaml: $e');
  }
}

// Helper function to remove comments and extra gaps
String _removeCommentsAndGaps(String yamlContent) {
  final lines = yamlContent.split('\n');

  // Filter out lines with comments and empty spaces
  final cleanedLines = lines.where((line) {
    final trimmed = line.trim();
    return trimmed.isNotEmpty && !trimmed.startsWith('#');
  });

  // Rejoin cleaned lines into a single YAML string
  return cleanedLines.join('\n');
}


void addDependencies(List<String> dependencies) async {
  for (var dependency in dependencies) {
    try {
      print('Adding $dependency...');
      var result = await Process.run('flutter', ['pub', 'add', dependency]);
      if (result.exitCode == 0) {
        print('Successfully added $dependency');
      } else {
        print('Error adding $dependency: ${result.stderr}');
      }
    } catch (e) {
      print('Failed to add $dependency: $e');
    }
  }
}

void addDevDependencies(List<String> devDependencies) async {
  for (var devDependency in devDependencies) {
    try {
      print('Adding $devDependency as a dev dependency...');
      var result = await Process.run('flutter', ['pub', 'add', devDependency, '--dev']);
      if (result.exitCode == 0) {
        print('Successfully added $devDependency');
      } else {
        print('Error adding $devDependency: ${result.stderr}');
      }
    } catch (e) {
      print('Failed to add $devDependency: $e');
    }
  }
}

String generateAppDart(String appName) => '''
import 'package:flutter/material.dart';

import '../config/config.dart';

class ${appName.pascalCase} extends StatelessWidget {
  const ${appName.pascalCase}({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.APP_NAME,
      theme: ThemeData.light(), // Replace with your custom theme if needed
      darkTheme: ThemeData.dark(), // Replace with your custom dark theme if needed
      themeMode: ThemeMode.system, // Use system theme mode
      home: const Placeholder(), // Replace with your app's initial widget
    );
  }
}
''';

String generateConfigDart(String appName) => '''
class Config {
  static const String BASE_URL = "https://api.example.com";
  static const String API_KEY = "your_api_key_here";
  static const String APP_NAME = "${appName.pascalCase}";
}
''';

String generateAppRoutesDart() => '''
part of 'app_pages.dart';

class RouteModel {
  final String name;
  final String path;
  final String? pathParam;
  const RouteModel({required this.name, required this.path, this.pathParam});
}

class AppRoutes {
  // Example: static const RouteModel home = RouteModel(name: 'home', path: '/home');
}
''';

String generateAppPagesDart() => '''
import 'package:go_router/go_router.dart';

part 'app_routes.dart';

class AppPages {
  final GoRouter routes = GoRouter(
    routes: [
      // Example:
      // GoRoute(
      //   path: AppRoutes.home,
      //   builder: (context, state) => const HomePage(),
      // ),
    ],
  );
}
''';


String generateDataStateDart() => '''
import 'package:dio/dio.dart';

abstract class DataState<T> {
  final T? data;
  final DioException? exception;
  const DataState({this.data, this.exception});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(DioException exception) : super(exception: exception);
}
''';


void createDirectories(List<String> paths) {
  for (final path in paths) {
    Directory(path).createSync(recursive: true);
  }
}

void createFile(String path, String content) {
  File(path).writeAsStringSync(content);
}

String generateMainDart(String appName) => '''
import 'package:flutter/material.dart';
import 'src/$appName.dart';

void main() {
  runApp(const ${appName.pascalCase}());
}
''';

String generateTestDart() => '''
void main() {
  // Write your test code here
}
''';


// Add other `generate*` methods for boilerplate code...
