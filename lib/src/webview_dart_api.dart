import 'dart:convert';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'bindings.dart';

enum SizeHint { none, min, max, fixed }

/// Creates a new webview instance. If debug true - developer tools will
/// be enabled (if the platform supports them).
/// Depending on the platform, a GtkWindow, NSWindow or HWND is used
class Webview {
  static final WebviewLib _lib = loadLibrary(
    Directory(
      Directory.current.path +
          "/webview.${Platform.isWindows ? 'dll' : Platform.isLinux ? 'so' : 'dylib'}",
    ).absolute.path.replaceAll("\\", "/"),
  );
  static final CreateFunction _create = webviewCreate(_lib);
  static final DestroyFunction _destroy = webviewDestroy(_lib);
  static final RunFunction _run = webviewRun(_lib);
  static final TerminateFunction _terminate = webviewTerminate(_lib);
  static final SetTitleFunction _setTitle = webviewSetTitle(_lib);
  static final SetSizeFunction _setSize = webviewSetSize(_lib);
  static final NavigateFunction _navigate = webviewNavigate(_lib);
  static final InitFunction _init = webviewInit(_lib);
  static final EvalFunction _eval = webviewEval(_lib);
  static final BindFunction _bind = webviewBind(_lib);

  late final WindowHandle _handle;

  static final Map<String, void Function(List<dynamic>)> _bindings = {};

  /// Creates a new webview instance. If debug true - developer tools will
  /// be enabled (if the platform supports them).
  /// Depending on the platform, a GtkWindow, NSWindow or HWND is used
  Webview([bool debug = false]) {
    _handle = _create(debug ? 1 : 0, nullptr);
  }

  /// Stops the main loop.
  void terminate() {
    _terminate(_handle);
  }

  /// Updates the title of the native window.
  Webview setTitle(String title) {
    final cTitle = title.toNativeUtf8();
    _setTitle(_handle, cTitle);
    malloc.free(cTitle);
    return this;
  }

  /// Updates native window size.
  Webview setSize(final int width, final int height,
      [SizeHint sizeHint = SizeHint.none]) {
    _setSize(_handle, width, height, sizeHint.index);
    return this;
  }

  /// Navigates webview to the given URL. URL may be a data URI, i.e.
  /// "data:text/text,<html>...</html>". It is often ok not to url-encode it
  /// properly, webview will re-encode it for you.
  Webview navigate(String url) {
    final cUrl = url.toNativeUtf8();
    _navigate(_handle, cUrl);
    malloc.free(cUrl);
    return this;
  }

  /// Injects JavaScript code at the initialization of the new page. Every time
  /// the webview will open a the new page - this initialization code will be
  /// executed. It is guaranteed that code is executed before window.onload.
  Webview init(String js) {
    final cJs = js.toNativeUtf8();
    _init(_handle, cJs);
    malloc.free(cJs);
    return this;
  }

  /// Evaluates arbitrary JavaScript code. Evaluation happens asynchronously, also
  /// the result of the expression is ignored.
  Webview eval(String js) {
    final cJs = js.toNativeUtf8();
    print("evaluating: ${cJs.toDartString()}");
    _eval(_handle, cJs);
    malloc.free(cJs);
    return this;
  }

  /// Runs the main loop until it's terminated. After this function exits - you
  /// must destroy the webview if autoDestroy is set to false
  void run([bool autoDestroy = true]) {
    _run(_handle);
    if (autoDestroy) destroy();
  }

  static void _cb(Pointer<Utf8> seq, Pointer<Utf8> req, Pointer<Void> arg) {
    final request = req.toDartString();
    List<dynamic> data = jsonDecode(request);
    final binding = data[0] as String;
    final List<dynamic> args = data.sublist(1);
    if (_bindings.containsKey(binding)) {
      _bindings[binding]!.call(args);
    }
  }

  /// Binds a native callback so that it will appear under the given name as a
  /// global JavaScript function. Internally it uses webview_init(). Callback
  /// receives a list of all the arguments passed to the JavaScript
  /// function.
  Webview bind(String name, void Function(List<dynamic>) callback) {
    final cName = name.toNativeUtf8();
    _bindings[name] = callback;
    _bind(_handle, cName, Pointer.fromFunction(_cb), nullptr);
    malloc.free(cName);
    return this;
  }

  /// Destroys a webview and closes the native window.
  void destroy() {
    _destroy(_handle);
  }
}
