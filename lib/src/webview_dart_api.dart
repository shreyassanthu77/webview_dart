import 'dart:io';

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

  late final WindowHandle _handle;

  Webview([bool debug = false]) {
    _handle = _create(debug ? 1 : 0, nullptr);
  }

  void terminate() {
    _terminate(_handle);
  }

  Webview setTitle(String title) {
    _setTitle(_handle, title.toNativeUtf8());
    return this;
  }

  Webview setSize(final int width, final int height,
      [SIzeHint sIzeHint = SIzeHint.none]) {
    _setSize(_handle, width, height, sIzeHint.index);
    return this;
  }

  Webview navigate(String url) {
    _navigate(_handle, url.toNativeUtf8());
    return this;
  }

  Webview init(String js) {
    _init(_handle, js.toNativeUtf8());
    return this;
  }

  Webview eval(String js) {
    _eval(_handle, js.toNativeUtf8());
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
