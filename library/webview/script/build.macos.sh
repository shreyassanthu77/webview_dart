FLAGS="-DWEBVIEW_COCOA -std=c++11 -Wall -Wextra -pedantic -framework WebKit"

g++ webview.cc $FLAGS -shared -o ../../out/linux/webview.dylib