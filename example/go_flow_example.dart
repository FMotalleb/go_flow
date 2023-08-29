// ignore_for_file: avoid_print

import 'dart:io';

import 'package:go_flow/go_flow.dart';

Future<void> main() async {
  final testFile = File('example/test.log');
  syncWrite(testFile);
  await asyncWrite(testFile);
}

void syncWrite(File file) => syncGoFlow(
      (defer) {
        final io = file.openSync(mode: FileMode.append);
        defer(
          (result, recover) {
            final err = recover<FileSystemException>();
            if (err != null) {
              print('there was an error in request');
            }
            io.closeSync();
          },
        );
        io.writeStringSync('text');
      },
    );
Future<void> asyncWrite(File file) => asyncGoFlow(
      (defer) async {
        final io = await file.open(mode: FileMode.append);
        defer(
          (result, recover) async {
            final err = recover<FileSystemException>();
            if (err != null) {
              print('there was an error in request');
            }
            await io.close();
          },
        );
        await io.writeString('text');
      },
    );
