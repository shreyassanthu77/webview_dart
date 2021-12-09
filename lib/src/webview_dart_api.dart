import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:ffi/src/utf8.dart';

import 'bindings.dart';

enum SIzeHint { none, min, max, fixed }

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

  Webview([bool debug = false]) {
    _handle = _create(debug ? 1 : 0, nullptr);
  }

  void terminate() {
    _terminate(_handle);
  }

  Webview setTitle(String title) {
    final cTitle = title.toNativeUtf8();
    _setTitle(_handle, cTitle);
    malloc.free(cTitle);
    return this;
  }

  Webview setSize(final int width, final int height,
      [SIzeHint sIzeHint = SIzeHint.none]) {
    _setSize(_handle, width, height, sIzeHint.index);
    return this;
  }

  Webview navigate(String url) {
    final cUrl = url.toNativeUtf8();
    _navigate(_handle, cUrl);
    malloc.free(cUrl);
    return this;
  }

  Webview init(String js) {
    final cJs = js.toNativeUtf8();
    _init(_handle, cJs);
    malloc.free(cJs);
    return this;
  }

  Webview eval(String js) {
    final cJs = js.toNativeUtf8();
    print("evaluating: ${cJs.toDartString()}");
    _eval(_handle, cJs);
    malloc.free(cJs);
    return this;
  }

  void run([bool autoDestroy = true]) {
    _run(_handle);
    if (autoDestroy) destroy();
  }

  void destroy() {
    _destroy(_handle);
  }
}
