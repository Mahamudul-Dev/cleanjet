import 'dart:io';
import 'package:cleanjet/initializer.dart';
import 'package:recase/recase.dart';

void createFeature() {
  stdout.write('Enter feature name: ');
  final featureName = stdin.readLineSync()?.trim()?.snakeCase;
  if (featureName == null || featureName.isEmpty) {
    print('Feature name is required.');
    return;
  }

  print('Creating feature: $featureName...');
  createDirectories([
    'lib/src/features/$featureName/data/data_sources',
    'lib/src/features/$featureName/data/models',
    'lib/src/features/$featureName/data/repository',
    'lib/src/features/$featureName/domain/entities',
    'lib/src/features/$featureName/domain/repository',
    'lib/src/features/$featureName/domain/usecases',
    'lib/src/features/$featureName/presentation/bloc',
    'lib/src/features/$featureName/presentation/pages',
    'lib/src/features/$featureName/presentation/widgets',
  ]);

  print('Feature "$featureName" created successfully.');
}
