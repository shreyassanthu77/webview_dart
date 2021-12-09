import 'package:webview_dart/webview_dart.dart';

void main() async {
  final url = "https://www.google.com";
  Webview(true)
      .setTitle("Google")
      .setSize(1280, 800,
          SizeHint.none /* Sizehint is optional and can be omitted */)
      .navigate(url)
      .run();
}
