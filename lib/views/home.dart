import 'package:doenertop/components/responsive_text.dart';
import 'package:doenertop/views/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/doenershop.dart';
import 'navigation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DoenerShop> shops = [];

  void _getShops() {
    shops = getShops();
  }

  @override
  void initState() {
    _getShops();
  }

  void _pushNavigation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Navigation(),
      ),
    );
  }

  void _pushProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Profile(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _getShops();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[40],
        elevation: 0.0,
        title: ResponsiveText(
          text: "DönerTop",
          style: const TextStyle(
            fontSize: 36,
            color: Colors.green,
            fontFamily: "DelaGothicOne",
          ),
        ),
        leading: GestureDetector(
          onTap: _pushNavigation,
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 30,
            height: 30,
            child: SvgPicture.asset(
              "assets/icons/list.svg",
              width: 20,
              height: 20,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _pushProfile,
            child: Container(
              margin: const EdgeInsets.all(10),
              width: 37,
              height: 37,
              child: SvgPicture.asset(
                "assets/icons/person.svg",
                width: 20,
                height: 20,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Trending",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: shops.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    height: 200,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Image.asset(
                          shops[index].imagePath,
                          fit: BoxFit.cover,
                          width: 300,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 150,
                            width: 300,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.grey.withOpacity(0.9),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  shops[index].name,
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 22,
                                  ),
                                ),
                                Text(
                                  shops[index].adress,
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
