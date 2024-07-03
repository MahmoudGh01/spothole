import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:job_seeker/services/FileManager.dart';
import 'package:job_seeker/services/audio_recorder_service.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/constants.dart';

class InterviewMeetingPage extends StatefulWidget {
  @override
  _InterviewMeetingPageState createState() => _InterviewMeetingPageState();
}

class _InterviewMeetingPageState extends State<InterviewMeetingPage> {
  late AudioRecorderService _audioRecorderService;
  bool _isRecordingAudio = false;
  VideoPlayerController? _controller;
  int _currentVideoIndex = 0;

  final List<String> _videoUrls = [
    '${Constants.uri}/getVideoRh?job_id=123456&video_number=1',
    '${Constants.uri}/getVideoRh?job_id=123456&video_number=2',
    '${Constants.uri}/getVideoRh?job_id=123456&video_number=3',
  ];

  @override
  void initState() {
    super.initState();
    _audioRecorderService = AudioRecorderService();
    _audioRecorderService.init(); // Initialize the recorder
    _initializeVideoPlayer(_videoUrls[_currentVideoIndex]);
  }

  void _initializeVideoPlayer(String url) {
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {});
        _controller?.play();
      });
  }

  @override
  void dispose() {
    _audioRecorderService.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void _onRecordButtonPressed() async {
    if (_isRecordingAudio) {
      try {
        // Stop audio recording and get the file
        PlatformFile audioFile = await _audioRecorderService.stopRecording();

        // Upload the audio file
        String audioUploadUrl = '${Constants.uri}/speechtts';
        // FileManager.uploadFile(audioUploadUrl, audioFile);

        // Update the UI state
        setState(() {
          _isRecordingAudio = false;
        });

        // Play the next video if available
        if (_currentVideoIndex < _videoUrls.length - 1) {
          _currentVideoIndex++;
          _initializeVideoPlayer(_videoUrls[_currentVideoIndex]);
        } else {
          // Interview finished
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Interview completed!')),
          );
        }
      } catch (e) {
        // Handle errors
        print('Error during recording or file upload: $e');
        setState(() {
          _isRecordingAudio = false;
        });
      }
    } else {
      try {
        // Start audio recording
        await _audioRecorderService.startRecording();

        // Update the UI state
        setState(() {
          _isRecordingAudio = true;
        });
      } catch (e) {
        // Handle possible errors during preparation or starting the recording
        print('Error starting recording: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Interview Meeting')),
      body: Stack(
        children: [
          // Video Background with Aspect Ratio to fit the screen
          Positioned.fill(
            child: _controller?.value.isInitialized ?? false
                ? Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            )
                : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: _onRecordButtonPressed,
            child: Icon(_isRecordingAudio ? Icons.call_end : Icons.mic),
            backgroundColor: _isRecordingAudio ? Colors.red : Colors.green,
          ),
        ],
      ),
    );
  }
}
