import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:music_app_2/views/play_screen.dart';
import 'package:music_app_2/widgets/side_menu.dart';

import '../assets.dart';
import '../fake_datas.dart';
import '../models/audio_asset_player.dart';

class HomeScreen extends StatefulWidget {
  int index;
  bool isPlaying;
  AudioAssetPlayer player = AudioAssetPlayer(songs[0].source, 0);

  HomeScreen(this.player, [this.index = 0, this.isPlaying = false]);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isShowMenu = false;
  String currentTab = Assets.homeIcon;
  bool isVertical = false;

  @override
  initState() {
    if (widget.isPlaying) {
      _updatePlayedTime();
    }
    super.initState();
  }

  void _updatePlayedTime() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        widget.player.timePlayed++;
      });
    });
  }

  Widget _buildHomeMain() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(isShowMenu ? 220 : 40),
        right: ScreenUtil().setWidth(20),
        top: ScreenUtil().setHeight(20),
        bottom: ScreenUtil().setHeight(50),
      ),
      color: Colors.purple.withOpacity(0.7),
      alignment: Alignment.topLeft,
      //width: double.infinity,
      // height: double.infinity,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(),
            _buildTrending(),
            _buildCategory(),
            _buildRecently()
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: ScreenUtil().setHeight(150),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black.withOpacity(0.5),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: ScreenUtil().setWidth(150),
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(10),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setWidth(50)),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(20),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(150),
            //height: ScreenUtil().setHeight(150),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/no_image.png',
                width: ScreenUtil().setWidth(150),
                //height: ScreenUtil().setHeight(150),
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTrending() {
    return SizedBox(
      height: ScreenUtil().setHeight(800),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(50)),
            width: ScreenUtil().setWidth(1000),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Trending',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setWidth(75),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(100),
                  width: ScreenUtil().setWidth(100),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isVertical = !isVertical;
                      });
                    },
                    icon: Icon(
                      isVertical ? MdiIcons.viewModule : Icons.list,
                      color: Colors.white,
                      size: ScreenUtil().setWidth(75),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(600),
            width: ScreenUtil().setWidth(1000),
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return isVertical
                    ? Container(
                        width: ScreenUtil().setWidth(800),
                        height: ScreenUtil().setHeight(120),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(20)),
                              child: InkWell(
                                onTap: () {
                                  if (widget.index != index) {
                                    widget.player.timePlayed = 0;
                                    widget.index = index;
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlayScreen(
                                        index: widget.index,
                                        player: widget.player,
                                      ),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  'assets/images/play_button.png',
                                  color: Colors.green,
                                  width: ScreenUtil().setWidth(100),
                                  height: ScreenUtil().setHeight(100),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      songs[index].name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setWidth(50),
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      songs[index].singer,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setWidth(35),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          if (widget.index != index) {
                            widget.player.timePlayed = 0;
                            widget.index = index;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayScreen(
                                index: widget.index,
                                player: widget.player,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(right: 10),
                          // width: ScreenUtil().setHeight(800),
                          // height: ScreenUtil().setHeight(800),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  songs[index].imageURL,
                                  width: ScreenUtil().setWidth(750),
                                  height: ScreenUtil().setHeight(750),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: ScreenUtil().setHeight(30),
                                child: Container(
                                  width: ScreenUtil().setWidth(700),
                                  height: ScreenUtil().setHeight(150),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(20)),
                                        child: InkWell(
                                          onTap: () {
                                            if (widget.index != index) {
                                              widget.player.timePlayed = 0;
                                              widget.index = index;
                                            }
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PlayScreen(
                                                  index: widget.index,
                                                  player: widget.player,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Image.asset(
                                            'assets/images/play_button_circle.png',
                                            color: Colors.green,
                                            width: ScreenUtil().setWidth(150),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                ScreenUtil().setWidth(20),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                songs[index].name,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: ScreenUtil()
                                                        .setWidth(50),
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                songs[index].singer,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      ScreenUtil().setWidth(35),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategory() {
    return Container(
      padding: EdgeInsets.only(
        top: ScreenUtil().setWidth(40),
      ),
      width: ScreenUtil().setWidth(1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Từ khóa',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setWidth(75),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(40),
            ),
            width: ScreenUtil().setWidth(1000),
            height: ScreenUtil().setHeight(300),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 4,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setWidth(40)),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildRecently() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(75)),
          child: Text(
            'Recently',
            style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setWidth(75),
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(1000),
          height: ScreenUtil().setHeight(500),
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: songs.length,
            itemBuilder: (context, index) {
              return Container(
                width: ScreenUtil().setWidth(1000),
                height: ScreenUtil().setHeight(120),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              songs[index].name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setWidth(50),
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              songs[index].singer,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setWidth(35),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                      child: InkWell(
                        onTap: () {
                          if (widget.index != index) {
                            widget.player.timePlayed = 0;
                            widget.index = index;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayScreen(
                                index: widget.index,
                                player: widget.player,
                              ),
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/images/play_button.png',
                          color: Colors.green,
                          width: ScreenUtil().setWidth(100),
                          height: ScreenUtil().setHeight(100),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
      ],
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
          icon: Icon(
            isShowMenu ? Icons.chevron_left : Icons.menu,
            size: ScreenUtil().setWidth(60),
          ),
        ),
        title: Text(
          'Home',
          style: TextStyle(fontSize: ScreenUtil().setWidth(60)),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                size: ScreenUtil().setWidth(60),
              ))
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _buildHomeMain(),
            SideMenu(
              isShowMenu: isShowMenu,
              currentTab: currentTab,
              currentTabCallback: (tab) {
                currentTab = tab;
              },
              index: widget.index,
              isPlaying: widget.isPlaying,
              player: widget.player,
            ),
          ],
        ),
      ),
    );
  }
}
