import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app_2/assets.dart';
import 'package:music_app_2/models/audio_asset_player.dart';
import 'package:music_app_2/views/home_screen.dart';
import 'package:music_app_2/views/play_screen.dart';

import '../models/song.dart';

class SideMenu extends StatefulWidget {
  bool isShowMenu;
  String currentTab;
  bool micOn = true;
  int index;
  bool isPlaying;
  AudioAssetPlayer player;
  Function(String) currentTabCallback;

  SideMenu(
      {required this.isShowMenu,
      required this.currentTab,
      required this.currentTabCallback,
      required this.index,
      required this.isPlaying,
      required this.player});

  @override
  State<StatefulWidget> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  void updateButton(currentScreen) {
    setState(() {
      widget.currentTab = currentScreen;
      widget.currentTabCallback(currentScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnimatedContainer(
      width: ScreenUtil().setWidth(widget.isShowMenu ? 200 : 0),
      color: Colors.purple,
      duration: const Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
            child: Image.asset(
              'assets/images/spotify.png',
              width: ScreenUtil().setWidth(150),
              height: ScreenUtil().setHeight(150),
              color: Colors.green,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                widget.currentTab == Assets.homeIcon
                    ? Image.asset(
                        Assets.homeIcon,
                        width: ScreenUtil().setWidth(100),
                        height: ScreenUtil().setHeight(100),
                        color: Colors.white,
                      )
                    : InkWell(
                        onTap: () {
                          updateButton(Assets.homeIcon);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (HomeScreen(
                                      widget.player,
                                      widget.index,
                                      widget.isPlaying))));
                        },
                        child: Image.asset(
                          Assets.homeIconOutline,
                          width: ScreenUtil().setWidth(100),
                          height: ScreenUtil().setHeight(100),
                          color: Colors.white,
                        ),
                      ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                widget.currentTab == Assets.cloudIcon
                    ? Image.asset(
                        Assets.cloudIcon,
                        width: ScreenUtil().setWidth(100),
                        height: ScreenUtil().setHeight(100),
                        color: Colors.white,
                      )
                    : InkWell(
                        onTap: () {
                          updateButton(Assets.cloudIcon);
                        },
                        child: Image.asset(
                          Assets.cloudIconOutline,
                          width: ScreenUtil().setWidth(100),
                          height: ScreenUtil().setHeight(100),
                          color: Colors.white,
                        ),
                      ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                widget.currentTab == Assets.pauseIcon
                    ? Image.asset(
                        Assets.pauseIcon,
                        width: ScreenUtil().setWidth(100),
                        height: ScreenUtil().setHeight(100),
                        color: Colors.white,
                      )
                    : InkWell(
                        onTap: () {
                          updateButton(Assets.pauseIcon);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlayScreen(
                                        index: widget.index,
                                        player: widget.player,
                                      )));
                        },
                        child: Image.asset(
                          Assets.playIcon,
                          width: ScreenUtil().setWidth(100),
                          height: ScreenUtil().setHeight(100),
                          color: Colors.white,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
