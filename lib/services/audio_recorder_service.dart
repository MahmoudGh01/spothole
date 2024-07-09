import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorderService {
late FlutterSoundRecorder _recorder;
bool _isRecording = false;
late String _filePath;

bool _isInitialized = false;

Future<void> init() async {
  _recorder = FlutterSoundRecorder();
  await _recorder.openAudioSession();
  _isRecording = false;

  final directory = await getTemporaryDirectory();
  _filePath = '${directory.path}/interview_recording.wav';
  _isInitialized = true;
}

Future<void> startRecording() async {
await _recorder.startRecorder(toFile: _filePath);
_isRecording = true;
}

Future<PlatformFile> stopRecording() async {
  if (_isRecording) {
    await _recorder.stopRecorder();
    _isRecording = false;
  }
  final file = File(_filePath);
  final bytes = await file.readAsBytes();
  return PlatformFile(
    name: file.path.split('/').last,
    path: file.path,
    size: bytes.length,
    bytes: bytes,
  );
}

Future<void> dispose() async {
await _recorder.closeAudioSession();
_isInitialized = false;
}

bool get isRecording => _isRecording;
}