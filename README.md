
# Dart Webview
Dart bindings for [webview](https://github.com/webview/webview), 
A tiny cross-platform webview library to build modern cross-platform GUIs


## Installation

create a new project
```bash
    dart create myapp
```

Run this command from the project directory
```bash
    dart pub add webview_dart
```
or add this to pubspec.yaml
```yaml
    dependencies: 
        webview_dart: ^1.0.0
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
        .setSize(1280, 800, SizeHint.none)
        .navigate(url)
        .run();
    }
```

  
## Running

### To run your project
- change the directory to out
- and run the dart file as shown

```bash
  cd out
  dart run ../bin/myapp.dart
```

  
## API Reference

#### Create Window
Creates a new webview instance. If debug true - developer tools will
be enabled (if the platform supports them).
Depending on the platform, a GtkWindow, NSWindow or HWND is used

```dart
  final webview = new Webview(true)
```

| Parameter | Type     | Description                                                                        |
| :-------- | :------- | :----------------------------------------------------------------------------------|
| `debug`   | `bool`   | **Optional**. Sets if dev tool can be accessed from the app on supported platforms |

#### Navigate to a url
Navigates webview to the given URL. URL may be a data URI, i.e.
"data:text/text,\<html>...<\/html>". It is often ok not to url-encode it
properly, webview will re-encode it for you

```dart
  webview.navigate("Your url")
```

| Parameter | Type     | Description                                                                    |
| :-------- | :------- | :----------------------------------------------------------------------------- |
| `url`     | `String` | **Required**. Navigates to the given url as soon as the `run` method is called |

#### Run the app
starts the app with given settings

```dart
  webview.run()
```

| Parameter        | Type     | Description                                                     |
| :--------        | :------- | :-------------------------------------------------------------- |
| `autoDestroy`   | `String` | **Optional**. Destroys the window as soon as the execution ends |

#### Change Title
Used to change the title of the window

```dart
  webview.setTitle("New Title")
```

| Parameter | Type     | Description                                   |
| :-------- | :------- | :-------------------------------------------- |
| `title`   | `String` | **Required**. Changes the title of the window |

#### Change Size
Updates native window size.

```dart
  webview.setSize(400, 600, SizeHint.none)
```

| Parameter | Type       | Description                                    |
| :-------- | :--------- | :--------------------------------------------- |
| `width`   | `int`      | **Required**. Sets the Width of the window     |
| `height`  | `int`      | **Required**. Sets the height of the window    |
| `sizeHint`| `SizeHint` | **Optional**. Sets the Size Hint of the window |
  

#### Size Hint
Sets the window resize behaviour

##### SizeHint has the following values

    - SizeHint.none

    - SizeHint.min

    - SizeHint.max

    - SizeHint.fixed


| Value     | Description                                    |
| :-------- | :--------------------------------------------- |
| `none`    | **Default**. Width and height are default size |
| `min`     | Width and height are minimum bounds            |
| `max`     | Width and height are maximum bounds            |
| `fixed`   | Window size can not be changed by a user       |


#### Evaluate js
Evaluates arbitrary JavaScript code. Evaluation happens asynchronously, also
the result of the expression is ignored.

```dart
  webview.eval("A valid string of Js")
```

| Parameter | Type       | Description                                    |
| :-------- | :--------- | :--------------------------------------------- |
| `js`      | `String`      | **Required**. The JavaScript to run         |
  
#### Initialization logic
Injects JavaScript code at the initialization of the new page. Every time
the webview will open a the new page - this initialization code will be
executed. It is guaranteed that code is executed before window.onload.

```dart
  webview.init("A valid string of Js")
```

| Parameter | Type       | Description                                    |
| :-------- | :--------- | :--------------------------------------------- |
| `js`      | `String`      | **Required**. The JavaScript to run         |
  
#### Binding Native functions
Binds a native callback so that it will appear under the given name as a
global JavaScript function. Internally it uses webview_init(). Callback
receives a list of all the arguments passed to the JavaScript
function.

```dart
  webview.bind("jsName", (List<dynamic> args) {
      // some code
  })
```

| Parameter  | Type                                     | Description                                                  |
| :--------- | :--------------------------------------- | :----------------------------------------------------------- |
| `name`     | `String`                                 | **Required**. The name of the function to be exposed to js   |
| `function` | `void Function(List<dynamic args>)`      | **Required**. The function to be exposed to js the args param is the list of parameters that are passed from js               |
  
  
#### Destroying the Window
Destroys the webview and closes the native window.

```dart
  webview.destroy()
```
  
#### Terminating the Main loop
Stops the main loop.

```dart
  webview.terminate()
```
  
