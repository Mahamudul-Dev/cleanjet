import 'package:args/args.dart';
import 'package:cleanjet/initializer.dart';
import 'package:cleanjet/feature_creator.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addCommand('init')
    ..addCommand('create-feature');

  final argResults = parser.parse(arguments);

  switch (argResults.command?.name) {
    case 'init':
      initializeProject();
      break;
    case 'create-feature':
      createFeature();
      break;
    default:
      print('Usage: cleanjet <command>\n\nCommands:');
      print(parser.usage);
      break;
  }
}
