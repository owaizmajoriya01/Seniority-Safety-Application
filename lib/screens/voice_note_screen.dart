import 'dart:async';
import 'dart:io';

import 'package:elderly_care/models/my_user.dart';
import 'package:elderly_care/my_theme.dart';
import 'package:elderly_care/provider/audio_note_provider.dart';
import 'package:elderly_care/provider/caretaker_provider.dart';
import 'package:elderly_care/utils/date_utils.dart';
import 'package:elderly_care/utils/shared_pref_helper.dart';
import 'package:elderly_care/utils/validators.dart';
import 'package:elderly_care/widgets/appbar.dart';
import 'package:elderly_care/widgets/buttons.dart';
import 'package:elderly_care/widgets/dropdown.dart';
import 'package:elderly_care/widgets/ripple_effect_widget.dart';
import 'package:elderly_care/widgets/textfield_v2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:collection/collection.dart';

import '../models/my_audio_notes.dart';
import '../provider/elder_provider.dart';
import '../utils/dialog.dart';
import '../widgets/dialogs.dart';

class VoiceNoteScreen extends StatefulWidget {
  const VoiceNoteScreen({Key? key}) : super(key: key);

  @override
  State<VoiceNoteScreen> createState() => _VoiceNoteScreenState();
}

class _VoiceNoteScreenState extends State<VoiceNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _additionalNote = TextEditingController();

  var _recorderState = RecorderState.none;
  String? _filePath;

  MyUser? _selectedUser;

  @override
  void dispose() {
    _additionalNote.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(
          title: 'Send Voice notes',
          centerTitle: true,
        ),
        body: SizedBox.expand(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text("Send Voice Note"),
                TitleWrapper(
                  title: 'Send to',
                  child: Builder(builder: (context) {
                    var role = AppPreferenceUtil.getString(SharedPreferencesKey.userType);
                    if (role == UserRoleEnum.elder.name) {
                      return Consumer<ElderProvider>(
                        builder: (context, provider, child) {
                          return MyDropdownV2(
                            items: provider.assignedCaretakers.map((e) => e.name ?? "-").toList(),
                            validator: (value) => MyValidator.defaultValidator(value),
                            onChanged: (value) {
                              var selectedUser =
                                  provider.assignedCaretakers.firstWhereOrNull((element) => element.name == value);

                              if (selectedUser != null) {
                                _selectedUser = selectedUser;
                              }
                            },
                          );
                        },
                      );
                    } else {
                      return Consumer<CaretakerProvider>(
                        builder: (context, provider, child) {
                          return MyDropdownV2(
                            items: provider.assignedUsers.map((e) => e.name ?? "-").toList(),
                            validator: (value) => MyValidator.defaultValidator(value),
                            onChanged: (value) {
                              var selectedUser =
                                  provider.assignedUsers.firstWhereOrNull((element) => element.name == value);

                              if (selectedUser != null) {
                                _selectedUser = selectedUser;
                              }
                            },
                          );
                        },
                      );
                    }
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TitleWrapper(
                    title: "Note",
                    child: MyTextFieldV2(
                        prefix: const Icon(Icons.edit_note_rounded),
                        hintText: "Additional Notes about reminder",
                        controller: _additionalNote,
                        minLines: 3,
                        validator: (value) => MyValidator.defaultValidator(
                              value,
                            )),
                  ),
                ),
                if (_recorderState == RecorderState.stopped)
                  AudioPlayerWidget(
                      filePath: _filePath,
                      onDelete: () {
                        _onRecorderStateChange(RecorderState.none);
                        _filePath = null;
                        setState(() {});
                      })
                else
                  AudioRecorderWidget(
                    onRecorderStateChange: _onRecorderStateChange,
                    onRecorderStopped: _onRecorderStopped,
                  ),
                PrimaryButton.expanded(
                    enable: _recorderState != RecorderState.none,
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        _onCreateAudioNote();
                      }
                    },
                    text: "Send Invoice")
              ],
            ),
          ),
        ));
  }

  void _onRecorderStateChange(RecorderState state) {
    _recorderState = state;
    setState(() {});
  }

  void _onRecorderStopped(String? filePath) {
    _filePath = filePath;
    _onRecorderStateChange(RecorderState.stopped);
  }

  void _onCreateAudioNote() {
    String uid = AppPreferenceUtil.getString(SharedPreferencesKey.userId);
    String name = AppPreferenceUtil.getString(SharedPreferencesKey.userName);
    final audioNote = MyAudioNotes(
      senderName: name,
      from: uid,
      to: _selectedUser!.uid!,
      receiverName: _selectedUser!.name!,
      timeStamp: DateTime.now().millisecondsSinceEpoch,
      additionalNote: _additionalNote.text,
      url: '',
    );

    MyLoadingDialog.show(context, "Creating reminder...");
    context.read<AudioNoteProvider>().createAudioNote(audioNote, _filePath).then((value) {
      MyLoadingDialog.close(context);
      if (value.success) {
        showDialog(
            context: context,
            builder: (_) => SuccessDialog(
                  header: "Success",
                  message: "Audio note Uploaded Successfully",
                  onNeutralTap: () {
                    Navigator.pop(_);
                    Navigator.pop(context);
                  },
                ));
      } else {
        showDialog(
            context: context,
            builder: (_) => ErrorDialog(
                  message: value.errorMessage,
                ));
      }
    });
  }
}

class AudioNoteItem extends StatelessWidget {
  const AudioNoteItem({Key? key, required this.audioNote}) : super(key: key);

  final MyAudioNotes audioNote;

  //late AnimationController _animationController;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16,12,16,12),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(audioNote.senderName,style : const TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: MyTheme.primaryColor)),
                SizedBox(
                  width: size.width * 0.80,
                  child: AudioPlayerWidgetV2(
                    filePath: null,
                    audioUrl: audioNote.url,
                  ),
                ),
                Text(MyDateUtils.parseTimeStamp(audioNote.timeStamp),style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MyRecorder {
  final recorder = Record();

  Future<String> getTempPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return "${appDocDir.path}/audio";
  }

  Future<void> startRecording(String path) async {
    if (await recorder.hasPermission()) {
      try {
        await recorder.start(
          path: path,
          encoder: AudioEncoder.wav,
          bitRate: 128000,
        );
      } on Exception catch (_, e) {
        debugPrint('Debug MyRecorder.startRecording :${e.toString()} ');
        debugPrint('Debug MyRecorder.startRecording :${_.toString()} ');
      }
    }
  }

  Future<String?> stopRecording() async {
    final isRecording = await recorder.isRecording();
    if (isRecording) {
      return await recorder.stop();
    } else {
      return null;
    }
  }

  Future<void> pauseRecording() async {
    final isRecording = await recorder.isRecording();
    if (isRecording) {
      await recorder.pause();
    }
  }
}

enum RecorderState { none, recording, paused, stopped }

class AudioRecorderWidget extends StatefulWidget {
  const AudioRecorderWidget({Key? key, this.onRecorderStateChange, this.onRecorderStopped}) : super(key: key);

  final void Function(RecorderState)? onRecorderStateChange;
  final void Function(String? filePath)? onRecorderStopped;

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  RecorderState _recorderState = RecorderState.none;
  String? _filePath;

  RecorderState get recorderState => _recorderState;
  final _audioRecorderService = MyRecorder();

  set recorderState(RecorderState value) {
    _recorderState = value;
    widget.onRecorderStateChange?.call(value);
  }

  @override
  void initState() {
    super.initState();
    _setFilePath();
  }

  Future<void> _setFilePath() async {
    _filePath = await _getFilePath();
    setState(() {});
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationSupportDirectory();
    return '${directory.path}\\audio_recording_${DateTime.now().millisecond}.m4a';
  }

  Future<void> _startRecording() async {
    if (_filePath == null) {
      return;
    }

    try {
      await _audioRecorderService.startRecording(_filePath!);
      setState(() {
        _recorderState = RecorderState.recording;
      });
    } catch (e) {
      debugPrint('Debug _AudioRecorderWidgetState._startRecording :  $e');
    }
  }

  Future<void> _pauseRecording() async {
    try {
      await _audioRecorderService.pauseRecording();
      _recorderState = RecorderState.paused;
      setState(() {});
    } catch (e) {
      debugPrint('Debug _AudioRecorderWidgetState._pauseRecording : ');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorderService.stopRecording();
      _recorderState = RecorderState.stopped;
      widget.onRecorderStopped?.call(path);
      setState(() {});
    } catch (e) {
      debugPrint('Debug _AudioRecorderWidgetState._stopRecording : ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              children: [
                StopwatchTimer(start: _isRecording, reset: _isNotInitiated),
                Visibility(visible: !_isNotInitiated, child: Text(_isRecording ? "Recording" : "Paused"))
              ],
            ),
            const Spacer(),
            MyRippleEffectWidget(
                onTap: _toggleState,
                child: AnimatedCrossFade(
                    firstChild: const IconWithLabel(
                      icon: IconBackground(
                          color: MyTheme.accentColor,
                          child: Icon(
                            Icons.mic,
                            color: Colors.white,
                          )),
                      label: "Record",
                    ),
                    secondChild: const IconWithLabel(
                      icon: IconBackground(color: MyTheme.accentColor, child: Icon(Icons.pause, color: Colors.white)),
                      label: "Pause",
                    ),
                    crossFadeState: _isRecording ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 500))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AnimatedScale(
                  scale: _isNotInitiated ? 0 : 1,
                  duration: const Duration(milliseconds: 500),
                  child: MyRippleEffectWidget(
                      onTap: _stopRecording,
                      child: const IconWithLabel(
                          icon: IconBackground(
                              color: MyTheme.black_85,
                              child: Icon(
                                Icons.square,
                                color: Colors.white,
                              )),
                          label: "Stop"))),
            ),
            AnimatedScale(
                scale: _isNotInitiated ? 0 : 1,
                duration: const Duration(milliseconds: 500),
                child: MyRippleEffectWidget(
                    onTap: _resetRecorder,
                    child: const IconWithLabel(
                        icon: IconBackground(color: Colors.redAccent, child: Icon(Icons.delete, color: Colors.white)),
                        label: "Delete")))
          ],
        ),
      ],
    );
  }

  bool get _isRecording => _recorderState == RecorderState.recording;

  bool get _isNotInitiated => _recorderState == RecorderState.none;

  Future<void> _resetRecorder() async {
    recorderState = RecorderState.none;
    await _audioRecorderService.stopRecording();
    _filePath = "";
    _setFilePath();
  }

  void _toggleState() {
    if (_recorderState == RecorderState.recording) {
      _pauseRecording();
    } else {
      _startRecording();
    }
  }
}

class IconBackground extends StatelessWidget {
  const IconBackground(
      {Key? key,
      required this.child,
      this.color,
      this.borderRadius = 6,
      this.padding = const EdgeInsets.all(4),
      this.margin = EdgeInsets.zero})
      : super(key: key);

  final Widget child;
  final Color? color;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(borderRadius)),
      padding: padding,
      margin: margin,
      child: child,
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({Key? key, required this.filePath, this.onDelete, this.audioUrl}) : super(key: key);

  final String? filePath;
  final String? audioUrl;
  final VoidCallback? onDelete;

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _audioPlayerService = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;

  Future<void> _setFilePath() async {
    if (widget.filePath?.isNotEmpty == true) {
      _audioPlayerService.setFilePath(widget.filePath!);
    } else if (widget.audioUrl?.isNotEmpty == true) {
      _audioPlayerService.setUrl(widget.filePath!);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _setFilePath();

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _audioPlayerService.playerStateStream.listen((event) {
      _isPlaying = event.playing;
      debugPrint('Debug _AudioPlayerWidgetState.initState : ${event.processingState.name} ');

      if (_isPlaying && _isCurrentDurationMoreThanDuration()) {
        debugPrint('Debug _AudioPlayerWidgetState.initState : stop ');
        _audioPlayerService.stop();
      } else if (event.processingState == ProcessingState.completed) {
        //_animationController.forward();
        // _animationController.forward();
        debugPrint('Debug _AudioPlayerWidgetState.initState : $_isPlaying ');
      }

      setState(() {});
    }, onDone: () {
      debugPrint('Debug _AudioPlayerWidgetState.initState  Done: ');
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _isCurrentDurationMoreThanDuration() {
    return _audioPlayerService.position.inMilliseconds >= (_audioPlayerService.duration?.inMilliseconds ?? 0);
  }

  _load() async {
    debugPrint('Debug _AudioPlayerWidgetState._load : ${_audioPlayerService.processingState}');
    if (_audioPlayerService.processingState != ProcessingState.loading) {
      debugPrint('Debug _AudioPlayerWidgetState._load : loading ');
      await _audioPlayerService.load();
    }
  }

  void _updateStatus(bool isPlaying) {
    if (isPlaying) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _isPlaying = isPlaying;
    setState(() {});
  }

  Future<void> _seek() async {
    if (_audioPlayerService.position.inMilliseconds >= (_audioPlayerService.duration?.inMilliseconds ?? 0)) {
      await _audioPlayerService.seek(Duration.zero);
    } else {
      //await _audioPlayerService.seek(_duration);
    }
  }

  Future<void> _seekTo(Duration duration) async {
    await _audioPlayerService.seek(duration);
  }

  Future<void> _startPlayback() async {
    if (widget.filePath != null) {
      try {
        debugPrint('Debug _AudioPlayerWidgetState._startPlayback : ${_duration.toString()} ');
        _updateStatus(true);
        //await _load();
        await _seek();
        await _audioPlayerService.play();
        _updateStatus(false);
      } catch (e) {
        debugPrint('Debug _AudioPlayerWidgetState._pausePlayback : $e ');
      }
    } else {
      debugPrint('Debug _AudioPlayerWidgetState._startPlayback : file is null ');
    }
  }

  Future<void> _pausePlayback() async {
    try {
      await _audioPlayerService.pause();
      _updateStatus(false);
    } catch (e) {
      debugPrint('Debug _AudioPlayerWidgetState._pausePlayback : $e ');
    }
  }

  Future<void> _togglePlayback() async {
    debugPrint('Debug _AudioPlayerWidgetState._togglePlayback : $_isPlaying ');
    if (_isPlaying) {
      await _pausePlayback();
    } else {
      await _startPlayback();
    }
  }

  String _printDuration(Duration? duration) {
    if (duration == null) return "-";
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MyRippleEffectWidget(
            onTap: _togglePlayback,
            decoration: const BoxDecoration(color: MyTheme.primaryColor, shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedIcon(icon: AnimatedIcons.play_pause, color: Colors.white, progress: _animationController),
            )),
        Expanded(
          child: StreamBuilder<Duration?>(
              stream: _audioPlayerService.positionStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var currentDuration = snapshot.data?.inMilliseconds ?? 1;
                  var totalDuration = _audioPlayerService.duration?.inMilliseconds ?? 1;

                  return Column(
                    children: [
                      Slider(
                        value: currentDuration.toDouble(),
                        min: 0.0,
                        max: totalDuration + 10,
                        onChanged: (_) {
                          _duration = Duration(milliseconds: (_).toInt());
                          _seekTo(_duration);
                          //setState(() {});
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_printDuration(snapshot.data)),
                            Text(_printDuration(_audioPlayerService.duration))
                          ],
                        ),
                      )
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
        ),
        MyIconButton(
          icon: const Icon(Icons.delete, color: Colors.white),
          color: Colors.redAccent,
          onTap: widget.onDelete?.call,
        )
      ],
    );
  }
}

class AudioPlayerWidgetV2 extends StatefulWidget {
  const AudioPlayerWidgetV2({Key? key, this.filePath, this.audioUrl}) : super(key: key);

  final String? filePath;
  final String? audioUrl;

  @override
  State<AudioPlayerWidgetV2> createState() => _AudioPlayerWidgetV2State();
}

class _AudioPlayerWidgetV2State extends State<AudioPlayerWidgetV2> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _audioPlayerService = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  var _playerState = ProcessingState.idle;

  Future<void> _setFilePath() async {
    if (widget.filePath != null && widget.filePath!.isNotEmpty) {
      _audioPlayerService.setFilePath(widget.filePath!);
    } else if (widget.audioUrl != null && widget.audioUrl?.isNotEmpty == true) {
      _audioPlayerService.setAudioSource(AudioSource.uri(Uri.parse(widget.audioUrl!)), preload: true);
      //_audioPlayerService.load();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _setFilePath();

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _audioPlayerService.playerStateStream.listen((event) {
      _isPlaying = event.playing;
      _playerState = event.processingState;

      if (_isPlaying && _isCurrentDurationMoreThanDuration()) {
        _audioPlayerService.stop();
      } else if (event.processingState == ProcessingState.completed) {}

      setState(() {});
    }, onDone: () {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _isCurrentDurationMoreThanDuration() {
    return _audioPlayerService.position.inMilliseconds >= (_audioPlayerService.duration?.inMilliseconds ?? 0);
  }

  void _updateStatus(bool isPlaying) {
    if (isPlaying) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _isPlaying = isPlaying;
    setState(() {});
  }

  Future<void> _seek() async {
    if (_audioPlayerService.position.inMilliseconds >= (_audioPlayerService.duration?.inMilliseconds ?? 0)) {
      await _audioPlayerService.seek(Duration.zero);
    } else {}
  }

  Future<void> _seekTo(Duration duration) async {
    await _audioPlayerService.seek(duration);
  }

  Future<void> _startPlayback() async {
    if (widget.filePath != null || widget.audioUrl != null) {
      try {
        _updateStatus(true);
        await _seek();
        await _audioPlayerService.play();
        _updateStatus(false);
      } catch (_) {}
    } else {}
  }

  Future<void> _pausePlayback() async {
    try {
      await _audioPlayerService.pause();
      _updateStatus(false);
    } catch (_) {}
  }

  Future<void> _togglePlayback() async {
    debugPrint('Debug _AudioPlayerWidgetV2State._togglePlayback :  $_isPlaying ');
    if (_isPlaying) {
      await _pausePlayback();
    } else {
      await _startPlayback();
    }
  }

  String _printDuration(Duration? duration) {
    if (duration == null) return "-";
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MyRippleEffectWidget(
            onTap: _togglePlayback,
            decoration: const BoxDecoration(color: MyTheme.primaryColor, shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedIcon(icon: AnimatedIcons.play_pause, color: Colors.white, progress: _animationController),
            )),
        if (_playerState == ProcessingState.loading)
          const Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 16),
            child: LinearProgressIndicator(),
          ))
        else
          Expanded(
            child: StreamBuilder<Duration?>(
                stream: _audioPlayerService.positionStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var currentDuration = snapshot.data?.inMilliseconds ?? 1;
                    var totalDuration = _audioPlayerService.duration?.inMilliseconds ?? 1;

                    return Column(
                      children: [
                        Slider(
                          value: currentDuration.toDouble(),
                          min: 0.0,
                          max: totalDuration + 10,
                          onChanged: (_) {
                            _duration = Duration(milliseconds: (_).toInt());
                            _seekTo(_duration);
                            //setState(() {});
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_printDuration(snapshot.data)),
                              Text(_printDuration(_audioPlayerService.duration))
                            ],
                          ),
                        )
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
          ),
      ],
    );
  }
}

class IconWithLabel extends StatelessWidget {
  const IconWithLabel({Key? key, required this.icon, required this.label}) : super(key: key);

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon,
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}

class StopwatchTimer extends StatefulWidget {
  final bool start;
  final bool reset;

  const StopwatchTimer({Key? key, required this.start, required this.reset}) : super(key: key);

  @override
  State<StopwatchTimer> createState() => _StopwatchTimerState();
}

class _StopwatchTimerState extends State<StopwatchTimer> {
  Timer? _timer;
  int _milliseconds = 0;
  String _formattedTime = '00:00.00';

  @override
  void initState() {
    super.initState();
    if (widget.start) {
      startTimer();
    }
  }

  @override
  void didUpdateWidget(StopwatchTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.start != oldWidget.start || widget.reset != oldWidget.reset) {
      if (widget.reset) {
        resetTimer();
      } else if (widget.start) {
        startTimer();
      } else {
        stopTimer();
      }
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _milliseconds += 100;
        _formattedTime = formatMilliseconds(_milliseconds);
      });
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    setState(() {
      _milliseconds = 0;
      _formattedTime = '00:00.00';
      stopTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formattedTime,
      style: const TextStyle(fontSize: 24),
    );
  }

  String formatMilliseconds(int milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds);
    String minutesStr = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String secondsStr = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String centisecondsStr = (duration.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr.$centisecondsStr';
  }

  @override
  void dispose() {
    if (_timer?.isActive == true) {
      _timer?.cancel();
    }
    super.dispose();
  }
}
