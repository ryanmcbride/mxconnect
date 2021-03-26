import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'accounts.dart';

import 'dart:io';
import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'network.dart';

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  double currentPage = 0;
  CarouselController buttonCarouselController = CarouselController();
  String _deviceID;
  String _name;
  String _mxid;

  @override
  void initState() {
    super.initState();
    _setID();
  }

  void _setID() async {
    var id = await _getId();
    var response = await Network.getUserInfo(id);
    print(response.body);
    var obj = json.decode(response.body);
    _name = obj["name"];
    _mxid = obj["mxid"];
    setState(() {
      _deviceID = id;
    });
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
          ),
          CarouselSlider(
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height / 2,
              enableInfiniteScroll: false,
              pauseAutoPlayInFiniteScroll: true,
              //autoPlay: true,
              //autoPlayInterval: Duration(seconds: 3),
              //autoPlayAnimationDuration: Duration(milliseconds: 800),
              //autoPlayCurve: Curves.fastOutSlowIn,
              //enlargeCenterPage: true,
              onPageChanged: _carouselCallback,
            ),
            items: [1, 2, 3, 4].map((i) {
              return panelBuilder(i);
            }).toList(),
          ),
          currentPage == 3
              ? Container(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(new PageRouteBuilder(
                            settings: RouteSettings(name: "accounts"),
                            pageBuilder: (BuildContext context, _, __) {
                              return new AccountsPage(_mxid, _deviceID);
                            },
                            transitionsBuilder: (_, Animation<double> animation,
                                __, Widget child) {
                              return new FadeTransition(
                                  opacity: animation, child: child);
                            }));
                      },
                      child: Text(
                        "Get Started!",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      color: Theme.of(context).primaryColor,
                      minWidth: 350,
                    ),
                  ),
                )
              : buildNextButton(context),
        ],
      ),
    );
  }

  Container buildNextButton(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlatButton(
            onPressed: null,
            child: Container(
              width: 75,
            ),
          ),
          Container(
            child: DotsIndicator(
              dotsCount: 4,
              position: currentPage,
              decorator: DotsDecorator(
                color: Colors.grey, // Inactive color
                activeColor: Theme.of(context).primaryColor,
              ),
            ),
            height: 100,
          ),
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              ),
            ),
            minWidth: 5,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              buttonCarouselController.nextPage(
                  duration: Duration(milliseconds: 300), curve: Curves.linear);
            },
            child: Container(
              height: 60,
              width: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget panelBuilder(int i) {
    String text = "";
    switch (i) {
      case 1:
        text =
            'Hey team, this is just little something to get us going.  I have built this app and a server that can be run as localhost.  It has not been tested very much and may just crash on startup.';
        break;
      case 2:
        text =
            'This app doesn\'t store any information.  No login is required.  It uses the unique device ID.  We will obviously change that later.';
        break;
      case 3:
        text =
            'This is just a quick agg with a webview.  After we get these right, we can do more later.';
        break;
      case 4:
        text =
            'This is going to be fun building out all of these different apps and servers.';
        break;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 5.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        color: Colors.white,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  void _carouselCallback(int page, CarouselPageChangedReason reason) {
    setState(() {
      currentPage = page.toDouble();
    });
  }
}
