import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app_2/views/play_screen.dart';
import 'package:music_app_2/widgets/side_menu.dart';

import '../assets.dart';
import '../fake_datas.dart';
import '../models/song.dart';

class HomeScreen extends StatefulWidget {
  int time;
  int index;
  bool isPlaying;

  HomeScreen([this.time = 0, this.index = 0,this.isPlaying=false]);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isShowMenu = false;
  String currentTab = Assets.homeIcon;
  bool isVertical = true;

  @override
  initState() {
    if(widget.isPlaying){
      _updatePlayedTime();
    }
    super.initState();
  }

  void _updatePlayedTime() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        widget.time++;
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
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none),
                      style: TextStyle(color: Colors.white),
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
      height: ScreenUtil().setHeight(700),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ScreenUtil().setWidth(1000),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Trending',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
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
                    icon: const Icon(
                      Icons.business,
                      color: Colors.white,
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
                                    widget.time = 0;
                                    widget.index = index;
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PlayScreen(
                                                time: widget.time,
                                                index: widget.index,
                                              )));
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
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      songs[index].singer,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
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
                    : Container(
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
                                height: ScreenUtil().setHeight(550),
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
                                            widget.time = 0;
                                            widget.index = index;
                                          }
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlayScreen(
                                                        time: widget.time,
                                                        index: widget.index,
                                                      )));
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
                                          horizontal: ScreenUtil().setWidth(20),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              songs[index].name,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              songs[index].singer,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
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
          const Text(
            'Từ khóa',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
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
                        style: const TextStyle(color: Colors.white),
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
          padding: const EdgeInsets.only(bottom: 10),
          child: const Text(
            'Recently',
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
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
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              songs[index].singer,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
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
                            widget.time = 0;
                            widget.index = index;
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlayScreen(
                                        time: widget.time,
                                        index: widget.index,
                                      )));
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
          icon: Icon(isShowMenu ? Icons.chevron_left : Icons.menu),
        ),
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
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
              time: widget.time,
              index: widget.index,
              isPlaying: widget.isPlaying,
            ),
          ],
        ),
      ),
    );
  }
}
