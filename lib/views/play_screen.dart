import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:music_app_2/assets.dart';
import 'package:music_app_2/fake_datas.dart';
import 'package:music_app_2/models/audio_asset_player.dart';
import 'package:music_app_2/widgets/side_menu.dart';
import 'dart:async';
import '../models/song.dart';

class PlayScreen extends StatefulWidget {
  int index;
  AudioAssetPlayer player;

  PlayScreen({required this.index,required this.player});

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
    widget.player=AudioAssetPlayer(songs[widget.index].source, widget.player.timePlayed);
    widget.player.init();
    _updateTimeProgress();
    super.initState();
  }

  void _updateTimeProgress() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (timer) {
      setState(() {
        if (!isPlay) {
          widget.player.pause();
          timer.cancel();
        } else {
          // widget.player.timePlayed++;
          widget.player.play();
          _progressValue=widget.player.timePlayed/widget.player.audioDurationMS;
          if(widget.player.timePlayed==widget.player.audioDurationMS){
            if(repeatIconTapCount==1){
              widget.player.timePlayed=0;
            }else{
              if(repeatIconTapCount==2&&!isShuffle){
                if(widget.index>=songs.length-1){
                  isPlay=false;
                }else{
                  widget.index++;
                  widget.player.timePlayed=0;
                }
              }else{
                if(!isShuffle){
                  widget.index=(widget.index+1)%songs.length;
                  widget.player.timePlayed=0;
                }else{
                  widget.index=Random().nextInt(songs.length-1);
                  widget.player.timePlayed=0;
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
        right: ScreenUtil().setWidth(40),
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
            style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setWidth(60)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(50)),
            child: Text(
              songs[widget.index].singer,
              style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setWidth(30)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setHeight(120),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      songs[widget.index].favorite = !songs[widget.index].favorite;
                    });
                  },
                  child: SizedBox(
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setHeight(100),
                    child: Icon(
                      songs[widget.index].favorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.pink,
                      size: ScreenUtil().setHeight(100),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setHeight(100),
                    child: Icon(
                      Icons.download,
                      color: Colors.white,
                      size: ScreenUtil().setHeight(120),

                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setHeight(100),
                    child: Icon(
                      Icons.comment,
                      color: Colors.white,
                      size: ScreenUtil().setHeight(120),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setHeight(100),
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: ScreenUtil().setHeight(120),
                    ),
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
                Expanded(
                  child: Center(
                    child: Text(
                      widget.player.timePlayed % 60 < 10
                          ? '0${widget.player.timePlayed ~/ 60}:0${widget.player.timePlayed % 60}'
                          : '0${widget.player.timePlayed ~/ 60}:${widget.player.timePlayed % 60}',
                      style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setWidth(40)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: LinearProgressIndicator(
                    value: _progressValue,
                    color: Colors.purpleAccent,
                    backgroundColor: Colors.purple,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.player.audioDurationMS==1?'- - : - -':widget.player.audioDurationMS % 60 < 10
                          ? '0${widget.player.audioDurationMS ~/ 60}:0${widget.player.audioDurationMS % 60}'
                          : '0${widget.player.audioDurationMS ~/ 60}:${widget.player.audioDurationMS % 60}',
                      style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setWidth(40)),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setWidth(120),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isShuffle = !isShuffle;
                    });
                  },
                  child: SizedBox(
                    width: ScreenUtil().setWidth(120),
                    height: ScreenUtil().setHeight(120),
                    child: Icon(
                      isShuffle
                          ? MdiIcons.shuffleVariant
                          : MdiIcons.shuffleDisabled,
                      color: Colors.white,
                      size: ScreenUtil().setHeight(100),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: ScreenUtil().setWidth(120),
                    height: ScreenUtil().setHeight(120),
                    child: Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: ScreenUtil().setHeight(100),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    isPlay = !isPlay;
                    _updateTimeProgress();
                  },
                  child: SizedBox(
                    width: ScreenUtil().setWidth(120),
                    height: ScreenUtil().setHeight(120),
                    child: Icon(
                      isPlay ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: ScreenUtil().setHeight(100),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isShuffle
                          ? widget.index = Random().nextInt(songs.length - 1)
                          : widget.index=(widget.index+1)%songs.length;
                      widget.player.stop();
                      widget.player=AudioAssetPlayer(songs[widget.index].source, 0);
                      widget.player.init();
                    });
                  },
                  child: SizedBox(
                    width: ScreenUtil().setWidth(120),
                    height: ScreenUtil().setHeight(120),
                    child: Icon(
                      Icons.skip_next,
                      color: Colors.white,
                      size: ScreenUtil().setHeight(100),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      repeatIconTapCount = (repeatIconTapCount + 1) % 3;
                    });
                  },
                  child: SizedBox(
                    width: ScreenUtil().setWidth(120),
                    height: ScreenUtil().setHeight(120),
                    child: Icon(
                      repeat[repeatIconTapCount],
                      color: Colors.white,
                      size: ScreenUtil().setHeight(100),
                    ),
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
              index: widget.index,
              isPlaying: isPlay,
              player: widget.player,
            ),
          ],
        ),
      ),
    );
  }
}
