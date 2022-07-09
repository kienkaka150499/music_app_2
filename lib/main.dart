import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app_2/views/home_screen.dart';

import 'fake_datas.dart';
import 'models/song.dart';

void main() {
  runApp(MusicApp());
}

class MusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (BuildContext context, Widget? child) => MaterialApp(
          home: HomeScreen(),
        ));
  }
}
