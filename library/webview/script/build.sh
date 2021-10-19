echo Build Started...
echo g++ webview.cc -shared -fPIC pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0 -o ../../out/linux/webview.so
g++ webview.cc -shared -fPIC `pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0` -o ../../out/linux/webview.so
echo "Build Successful -> written to out folder in the project root"