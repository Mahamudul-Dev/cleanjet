import 'dart:io';
import 'package:recase/recase.dart';

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
  final featureName = stdin.readLineSync()?.trim()?.snakeCase;

  // Create Flutter project (override)
  print('Initializing Flutter project...');
  Process.runSync('flutter', ['create', '.'], workingDirectory: Directory.current.path);

  // Add dependencies
  print('Adding dependencies...');
  Process.runSync('flutter', ['pub', 'add', ...[
    'bloc', 'flutter_bloc', 'go_router', 'meta', 'equatable', 'get_it',
    'intl', 'dio', 'retrofit', 'logger', 'json_annotation',
    'flutter_hooks', 'cached_network_image', 'google_fonts',
  ]]);

  Process.runSync('flutter', ['pub', 'add', ...[
    'retrofit_generator', 'build_runner', 'json_serializable'
  ], '--dev']);

  // Remove comments and update `pubspec.yaml`
  print('Updating pubspec.yaml...');
  final pubspec = File('pubspec.yaml');
  final updatedPubspec = pubspec.readAsStringSync()
      .replaceAll(RegExp(r'#.*'), '') // Remove comments
      .replaceAll('flutter:', '''
flutter:
  assets:
    - images/
    - icons/
    - audios/
''');
  pubspec.writeAsStringSync(updatedPubspec);

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

  // Create initial files
  print('Generating boilerplate code...');
  createFile('lib/main.dart', generateMainDart(snakeCaseAppName));
  createFile('lib/src/$snakeCaseAppName.dart', generateAppDart(pascalCaseAppName));
  createFile('lib/config/config.dart', generateConfigDart(pascalCaseAppName));
  createFile('lib/config/routes/app_routes.dart', generateAppRoutesDart());
  createFile('lib/config/routes/app_pages.dart', generateAppPagesDart());
  createFile('lib/src/core/resources/data_state.dart', generateDataStateDart());

  print('Project initialization complete!');
}

String generateAppDart(String appName) => '''
import 'package:flutter/material.dart';

import '../config/config.dart';
import '../config/theme/theme.dart';

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
  // Example: static const String home = '/home';
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

// Add other `generate*` methods for boilerplate code...
