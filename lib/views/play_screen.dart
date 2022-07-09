import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:music_app_2/assets.dart';
import 'package:music_app_2/fake_datas.dart';
import 'package:music_app_2/widgets/side_menu.dart';
import 'dart:async';
import '../models/song.dart';

class PlayScreen extends StatefulWidget {
  int time;
  int index;

  PlayScreen({required this.time, required this.index});

  @override
  State<StatefulWidget> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with TickerProviderStateMixin {
  bool isShowMenu = true;
  String currentTab = Assets.pauseIcon;
  bool isShuffle = false;
  List<IconData> repeat = [Icons.repeat, Icons.repeat_one, MdiIcons.repeatOff];
  int repeatIconTapCount = 0;
  bool isPlay = true;
  double _progressValue=0;

  @override
  initState() {
    isPlay = true;
    widget.time = widget.time;
    _updateTimeProgress();
    super.initState();
  }

  void _updateTimeProgress() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (timer) {
      setState(() {
        if (!isPlay) {
          timer.cancel();
        } else {
          widget.time++;
          _progressValue=widget.time/songs[widget.index].time;
          if(widget.time==songs[widget.index].time){
            if(repeatIconTapCount==1){
              widget.time=0;
            }else{
              if(repeatIconTapCount==2&&!isShuffle){
                if(widget.index>=songs.length-1){
                  isPlay=false;
                }else{
                  widget.index++;
                  widget.time=0;
                }
              }else{
                if(!isShuffle){
                  widget.index=(widget.index+1)%songs.length;
                  widget.time=0;
                }else{
                  widget.index=Random().nextInt(songs.length-1);
                  widget.time=0;
                }
              }
            }
          }
        }
      });
    });
  }

  Widget _buildPlayMain() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(isShowMenu ? 220 : 40),
        right: ScreenUtil().setWidth(20),
        top: ScreenUtil().setHeight(20),
        bottom: ScreenUtil().setHeight(50),
      ),
      color: Colors.black.withOpacity(0.9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(40),
                bottom: ScreenUtil().setHeight(40)),
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setHeight(800),
            child: CircleAvatar(
              backgroundImage: NetworkImage(songs[widget.index].imageURL),
            ),
          ),
          Text(
            songs[widget.index].name,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(50)),
            child: Text(
              songs[widget.index].singer,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setHeight(120),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      songs[widget.index].favorite = !songs[widget.index].favorite;
                    });
                  },
                  icon: Icon(
                    songs[widget.index].favorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.pink,
                    size: ScreenUtil().setHeight(100),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.download,
                    color: Colors.white,
                    size: ScreenUtil().setHeight(100),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.comment,
                    color: Colors.white,
                    size: ScreenUtil().setHeight(100),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: ScreenUtil().setHeight(100),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setWidth(120),
            child: Row(
              children: [
                SizedBox(
                  width: ScreenUtil().setWidth(120),
                  child: Text(
                    widget.time % 60 < 10
                        ? '0${widget.time ~/ 60}:0${widget.time % 60}'
                        : '0${widget.time ~/ 60}:${widget.time % 60}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: _progressValue,
                    color: Colors.purpleAccent,
                    backgroundColor: Colors.purple,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  width: ScreenUtil().setWidth(120),
                  child: Text(
                    songs[widget.index].time % 60 < 10
                        ? '0${songs[widget.index].time ~/ 60}:0${songs[widget.index].time % 60}'
                        : '0${songs[widget.index].time ~/ 60}:${songs[widget.index].time % 60}',
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setWidth(120),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isShuffle = !isShuffle;
                    });
                  },
                  icon: Icon(
                    isShuffle
                        ? MdiIcons.shuffleVariant
                        : MdiIcons.shuffleDisabled,
                    color: Colors.white,
                    size: ScreenUtil().setHeight(100),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: ScreenUtil().setHeight(100),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    isPlay = !isPlay;
                    _updateTimeProgress();
                  },
                  icon: Icon(
                    isPlay ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: ScreenUtil().setHeight(100),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isShuffle
                          ? widget.index = Random().nextInt(songs.length - 1)
                          : widget.index=(widget.index+1)%songs.length;
                      widget.time=0;
                    });
                  },
                  icon: Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: ScreenUtil().setHeight(100),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      repeatIconTapCount = (repeatIconTapCount + 1) % 3;
                    });
                  },
                  icon: Icon(
                    repeat[repeatIconTapCount],
                    color: Colors.white,
                    size: ScreenUtil().setHeight(100),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(300),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            setState(() {
              isShowMenu = !isShowMenu;
            });
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        title: const Text('Play Screen'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
        backgroundColor: Colors.purple,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _buildPlayMain(),
            SideMenu(
              isShowMenu: isShowMenu,
              currentTab: currentTab,
              currentTabCallback: (tab) {
                currentTab = tab;
              },
              time: widget.time,
              index: widget.index,
              isPlaying: isPlay,
            )
          ],
        ),
      ),
    );
  }
}
