# Dart Batch File Renamer 🔄📁

## Overview

Batch File Renamer is a powerful and flexible command-line tool written in Dart that allows you to rename multiple files in a directory with ease. Whether you need to add prefixes, suffixes, replace text, or perform recursive renaming, this utility has you covered.

## 🌟 Features

- **Prefix Addition**: Prepend text to filenames
- **Suffix Addition**: Append text to filenames
- **Text Replacement**: Replace specific text in filenames
- **Recursive Processing**: Rename files in subdirectories
- **Dry Run Mode**: Simulate renaming without making actual changes
- **Verbose Logging**: Detailed information about rename operations
- **Error Handling**: Robust processing with individual file error tracking
- **Rename Log**: Generates a JSON log of all rename operations

## 🚀 Installation

### Prerequisites
- Dart SDK (version 2.19 or higher)
- pub (Dart package manager)

### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/qharny/batch-file-renamer.git
   cd batch-file-renamer
   ```

2. Install dependencies:
   ```bash
   dart pub get
   ```

## 💻 Usage

### Basic Usage
```bash
dart batch_renamer.dart [options]
```

### Naming Options

#### Add Prefix
```bash
dart batch_renamer.dart -d /path/to/directory -p "2024_"
```

#### Add Suffix
```bash
dart batch_renamer.dart -d /path/to/directory -s "_backup"
```

#### Replace Text
```bash
dart batch_renamer.dart -d /path/to/directory -r "old" -w "new"
```

### Advanced Options

#### Recursive Renaming
```bash
dart batch_renamer.dart -d /path/to/directory -R
```

#### Dry Run (Simulate Renaming)
```bash
dart batch_renamer.dart -d /path/to/directory --dry-run -v
```

## 🔍 Command-line Options

| Option | Short | Description | Default |
|--------|-------|-------------|---------|
| `--directory` | `-d` | Directory to rename files in | Current directory |
| `--prefix` | `-p` | Prefix to add to filenames | None |
| `--suffix` | `-s` | Suffix to add to filenames | None |
| `--replace` | `-r` | Text to replace in filenames | None |
| `--replace-with` | `-w` | Replacement text | None |
| `--recursive` | `-R` | Recursively rename files | False |
| `--dry-run` | | Simulate renaming without changes | False |
| `--verbose` | `-v` | Print detailed information | False |
| `--help` | `-h` | Show help message | False |

## 📋 Examples

1. Add a timestamp prefix to all files:
   ```bash
   dart batch_renamer.dart -d ./documents -p "$(date +%Y%m%d)_"
   ```

2. Remove spaces from filenames in a music directory:
   ```bash
   dart batch_renamer.dart -d ./music -r " " -w "_"
   ```

3. Backup all text files with a suffix:
   ```bash
   dart batch_renamer.dart -d ./notes -s ".bak" -R
   ```

## 🛡️ Error Handling

- Validates input directory
- Handles individual file rename errors
- Generates comprehensive rename logs
- Provides verbose error reporting

## 🔐 Rename Log

After each successful rename operation (non-dry run), a JSON log is generated with the following details:
- Original filename
- New filename
- Rename status

Logs are saved as `rename_log_[timestamp].json`

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## ⚠️ Warnings

- Always test with `--dry-run` first
- Ensure you have backups of important files
- Be cautious with recursive renaming

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## 🐛 Reporting Issues

Please report any bugs or feature requests by opening an issue in the GitHub repository.

## 🌐 Contact

Your Name - youremail@example.com

Project Link: [https://github.com/yourusername/batch-file-renamer](https://github.com/yourusername/batch-file-renamer)