import 'dart:ffi';
import 'package:ffi/ffi.dart';

export 'dart:ffi' show nullptr;
export 'package:ffi/ffi.dart' show StringUtf8Pointer;

typedef WebviewLib = DynamicLibrary;
typedef WindowHandle = Pointer<Void>;

// Native Functions
typedef NativeCreateFunction = WindowHandle Function(Int32, WindowHandle);
typedef NativeDestroyFunction = Void Function(WindowHandle);
typedef NativeRunFunction = Void Function(WindowHandle);
typedef NativeTerminateFunction = Void Function(WindowHandle);
typedef NativeSetTitleFunction = Void Function(WindowHandle, Pointer<Utf8>);
typedef NativeSetSizeFunction = Void Function(
    WindowHandle, Int32, Int32, Int32);
typedef NativeNavigateFunction = Void Function(WindowHandle, Pointer<Utf8>);
typedef NativeInitFunction = Void Function(WindowHandle, Pointer<Utf8>);
typedef NativeEvalFunction = Void Function(WindowHandle, Pointer<Utf8>);

// darty functions
typedef CreateFunction = WindowHandle Function(int, WindowHandle);
typedef DestroyFunction = void Function(WindowHandle);
typedef RunFunction = void Function(WindowHandle);
typedef TerminateFunction = void Function(WindowHandle);
typedef SetTitleFunction = void Function(WindowHandle, Pointer<Utf8>);
typedef SetSizeFunction = void Function(WindowHandle, int, int, int);
typedef NavigateFunction = void Function(WindowHandle, Pointer<Utf8>);
typedef InitFunction = void Function(WindowHandle, Pointer<Utf8>);
typedef EvalFunction = void Function(WindowHandle, Pointer<Utf8>);

DynamicLibrary? _library;

// lookups
WebviewLib loadLibrary(String path) {
  try {
    _library ??= DynamicLibrary.open(path);
  } catch (e) {
    rethrow;
  }
  return _library!;
}

CreateFunction webviewCreate(DynamicLibrary webview) {
  return webview
      .lookupFunction<NativeCreateFunction, CreateFunction>("webview_create");
}

DestroyFunction webviewDestroy(DynamicLibrary webview) {
  return webview.lookupFunction<NativeDestroyFunction, DestroyFunction>(
      "webview_destroy");
}

RunFunction webviewRun(DynamicLibrary webview) {
  return webview.lookupFunction<NativeRunFunction, RunFunction>("webview_run");
}

TerminateFunction webviewTerminate(DynamicLibrary webview) {
  return webview.lookupFunction<NativeTerminateFunction, TerminateFunction>(
      "webview_terminate");
}

SetTitleFunction webviewSetTitle(DynamicLibrary webview) {
  return webview.lookupFunction<NativeSetTitleFunction, SetTitleFunction>(
      "webview_set_title");
}

SetSizeFunction webviewSetSize(DynamicLibrary webview) {
  return webview.lookupFunction<NativeSetSizeFunction, SetSizeFunction>(
      "webview_set_size");
}

NavigateFunction webviewNavigate(DynamicLibrary webview) {
  return webview.lookupFunction<NativeNavigateFunction, NavigateFunction>(
      "webview_navigate");
}

InitFunction webviewInit(DynamicLibrary webview) {
  return webview
      .lookupFunction<NativeInitFunction, InitFunction>("webview_init");
}

EvalFunction webviewEval(DynamicLibrary webview) {
  return webview
      .lookupFunction<NativeEvalFunction, EvalFunction>("webview_eval");
}