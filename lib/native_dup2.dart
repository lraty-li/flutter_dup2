import 'dart:ffi'; // For FFI
import 'dart:io'; // For Platform.isX
import 'package:ffi/src/utf8.dart';

// android only
final DynamicLibrary dylib = Platform.isAndroid
    ? DynamicLibrary.open("librunDup2.so")
    : DynamicLibrary.process();

// C function: int runDup2(char *str,int length)
typedef redirectNative = Int32 Function(Pointer<Utf8> str, Int32 length);
typedef redirect = int Function(Pointer<Utf8> str, int length);
final nativeRunDup2 = dylib.lookupFunction<redirectNative, redirect>('runDup2');


// final int Function() nativeredirect = nativeAddLib
//     .lookup<NativeFunction<Int32 Function()>>("native_redirect")
//     .asFunction();