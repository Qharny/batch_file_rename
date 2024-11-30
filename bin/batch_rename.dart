import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:args/args.dart';

class BatchFileRenamer {
  /// Renames files based on specified criteria
  Future<void> renameFiles({
    required Directory directory,
    String? prefix,
    String? suffix,
    String? replace,
    String? replaceWith,
    bool recursive = false,
    bool dryRun = false,
    bool verbose = false,
  }) async {
    try {
      // Validate input directory
      if (!await directory.exists()) {
        throw ArgumentError('Directory does not exist: ${directory.path}');
      }

      // Track rename operations
      final renameLog = <Map<String, String>>[];
      int filesProcessed = 0;
      int filesRenamed = 0;

      // File listing function with optional recursion
      Stream<FileSystemEntity> listFiles() {
        return directory.list(recursive: recursive)
          .where((entity) => entity is File);
      }

      // Process each file
      await for (var file in listFiles()) {
        filesProcessed++;
        
        try {
          final oldPath = file.path;
          final fileName = path.basename(oldPath);
          String newFileName = fileName;

          // Apply prefix if specified
          if (prefix != null) {
            newFileName = '$prefix$newFileName';
          }

          // Apply suffix if specified
          if (suffix != null) {
            final ext = path.extension(fileName);
            final nameWithoutExt = path.basenameWithoutExtension(fileName);
            newFileName = '$nameWithoutExt$suffix$ext';
          }

          // Replace text if specified
          if (replace != null && replaceWith != null) {
            newFileName = newFileName.replaceAll(replace, replaceWith);
          }

          // Construct new file path
          final newPath = path.join(path.dirname(oldPath), newFileName);

          // Perform rename (or simulate)
          if (dryRun) {
            renameLog.add({
              'old': oldPath,
              'new': newPath,
              'status': 'SIMULATED'
            });
            if (verbose) print('Would rename: $oldPath → $newPath');
          } else {
            await File(oldPath).rename(newPath);
            renameLog.add({
              'old': oldPath,
              'new': newPath,
              'status': 'RENAMED'
            });
            filesRenamed++;
            if (verbose) print('Renamed: $oldPath → $newPath');
          }
        } catch (e) {
          renameLog.add({
            'old': file.path,
            'new': '',
            'status': 'ERROR: ${e.toString()}'
          });
          if (verbose) print('Error processing ${file.path}: $e');
        }
      }

      // Print summary
      print('\n--- Batch Rename Summary ---');
      print('Total files processed: $filesProcessed');
      print('Files renamed: $filesRenamed');
      
      // Optional: Save rename log
      if (!dryRun) {
        await _saveRenameLog(renameLog);
      }
    } catch (e) {
      stderr.writeln('Critical error: $e');
      exit(1);
    }
  }

  /// Saves a log of rename operations
  Future<void> _saveRenameLog(List<Map<String, String>> renameLog) async {
    final logFile = File('rename_log_${DateTime.now().toIso8601String()}.json');
    await logFile.writeAsString(JsonEncoder.withIndent('  ').convert(renameLog));
    print('Rename log saved to: ${logFile.path}');
  }

  /// Validates and parses command-line arguments
  ArgParser _setupArgumentParser() {
    final parser = ArgParser()
      ..addOption('directory', 
        abbr: 'd', 
        defaultsTo: '.',
        help: 'Directory to rename files in')
      ..addOption('prefix', 
        abbr: 'p', 
        help: 'Prefix to add to filenames')
      ..addOption('suffix', 
        abbr: 's', 
        help: 'Suffix to add to filenames')
      ..addOption('replace', 
        abbr: 'r', 
        help: 'Text to replace in filenames')
      ..addOption('replace-with', 
        abbr: 'w', 
        help: 'Replacement text')
      ..addFlag('recursive', 
        abbr: 'R', 
        defaultsTo: false,
        help: 'Recursively rename files in subdirectories')
      ..addFlag('dry-run', 
        defaultsTo: false,
        help: 'Simulate rename without actually changing files')
      ..addFlag('verbose', 
        abbr: 'v', 
        defaultsTo: false,
        help: 'Print detailed information')
      ..addFlag('help', 
        abbr: 'h', 
        defaultsTo: false,
        help: 'Show this help message');
    return parser;
  }

  /// Main CLI entry point
  void run(List<String> arguments) {
    final parser = _setupArgumentParser();
    
    try {
      final results = parser.parse(arguments);

      // Show help
      if (results['help']) {
        print('Batch File Renamer');
        print('Usage: dart batch_renamer.dart [options]');
        print('\nOptions:');
        print(parser.usage);
        exit(0);
      }

      // Validate exclusive replacement options
      if ((results['replace'] != null) != (results['replace-with'] != null)) {
        throw ArgumentError('Both --replace and --replace-with must be specified together');
      }

      // Execute rename
      renameFiles(
        directory: Directory(results['directory']),
        prefix: results['prefix'],
        suffix: results['suffix'],
        replace: results['replace'],
        replaceWith: results['replace-with'],
        recursive: results['recursive'],
        dryRun: results['dry-run'],
        verbose: results['verbose']
      );
    } on ArgParserException catch (e) {
      stderr.writeln('Error parsing arguments: ${e.message}');
      print('\nUsage:');
      print(parser.usage);
      exit(1);
    } catch (e) {
      stderr.writeln('Error: $e');
      exit(1);
    }
  }
}

void main(List<String> arguments) {
  final renamer = BatchFileRenamer();
  renamer.run(arguments);
}