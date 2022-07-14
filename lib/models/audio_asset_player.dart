import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class AudioAssetPlayer {
  final String filename;
  final _progressStreamController = StreamController<double>();

  late final StreamSubscription _progressSubcription;
  late final AudioPlayer _audioPlayer = AudioPlayer();
  int audioDurationMS = 1;

  // late var _source;
  // late var _position;
  int timePlayed;

  Stream<double> get progressStream => _progressStreamController.stream;

  Stream<PlayerState> get stateStream => _audioPlayer.onPlayerStateChanged;

  AudioAssetPlayer(this.filename, this.timePlayed);

  Future<void> init() async {
    // await _audioPlayer.setSource(AssetSource(filename));
    // await play();
    await _audioPlayer
        .play(AssetSource(filename), position: Duration(seconds: timePlayed))
        .catchError((onError) => {});
    // await _audioPlayer.play(AssetSource(filename),
    //     position: Duration(seconds: timePlayed));
    await Future.delayed(const Duration(milliseconds: 200))
        .catchError((onError) => {});

    audioDurationMS =
        (await _audioPlayer.getDuration().catchError((onError) => {}))!
            .inSeconds;

    await _audioPlayer.stop();
    await _audioPlayer.seek(Duration(seconds: timePlayed));
    _progressStreamController.add(timePlayed / audioDurationMS);
    _progressSubcription = _audioPlayer.onPositionChanged.listen((duration) {
      _progressStreamController.add(duration.inSeconds / audioDurationMS);
      timePlayed = duration.inSeconds;
    });
  }

  Future<void> dispose() async {
    Future.wait([
      _audioPlayer.dispose(),
      _progressSubcription.cancel(),
      _progressStreamController.close()
    ]);
  }

  Future<void> play() async {
    await _audioPlayer
        .resume()
        .catchError((onError) => {});
  }

  Future<void> pause() => _audioPlayer.pause().catchError((onError) => {});

  Future<void> start() async {
    _progressStreamController.add(0.0);
    await _audioPlayer.resume().catchError((onError) => {});
  }

  Future<void> stop() => _audioPlayer.stop().catchError((onError) => {});
}
