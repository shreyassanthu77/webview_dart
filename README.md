
# Dart Webview
Dart bindings for [webview](https://github.com/webview/webview), 
A tiny cross-platform webview library to build modern cross-platform GUIs


## Installation

create a new project
```bash
    dart create myapp
```

in pubspec.yaml add
```yaml
    dependencies: 
        webview_dart: ^1.0.0
            git: https://github.com/shreyassanthu77/webview_dart

```

### windows

Download the prebuilt binaries for windows from releases and place them in your root directory under out folder
> Note you need to ship them with the final executable file

your folder structure should now look like this
```
    myapp
      |
      +---- out
      |      |
      |      +--- webview.dll
      |      |
      |      +--- webview2loader.dll
      |
      +--- bin
      |     |
      |     +--- myapp.dart
      |
      +---- all other files

```

### Linux

Download the prebuilt binaries for linux from releases and place them in your root directory under out folder
> Note you need to ship them with the final executable file

your folder structure should now look like this
```
    myapp
      |
      +---- out
      |      |
      |      +--- webview.so
      |
      +--- bin
      |     |
      |     +--- myapp.dart
      |
      +---- all other files

```
    

### Macos
Unfortunately I don't have a mac so please check the build instructions to build the .dylib files
After you build the library prepare the same folder structure as linux and you are good to go
## Documentation

in your `myapp.dart` file
```dart
    import 'package:webview_dart/webview_dart.dart';

    void main() {
    final url = "https://www.google.com";
    Webview(true)
        .setTitle("title")
        .setSize(1280, 800, SIzeHint.none)
        .navigate(url)
        .run();
    }
```

  