import 'dart:async';
import 'dart:io';
import 'package:doenertop/views/profile.dart';
import 'package:doenertop/components/responsive_text.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'add_shop.dart';
import 'navigation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = "";

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
  void initState() {
    super.initState();
    BrowseController.stream.listen((bool _) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    uid = _auth.currentUser!.uid;
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
        centerTitle: true,
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
      body: ListView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Favorites",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 250,
              child: Favourites(),
            ),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Browse",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              child: Browse(),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const AddShopButton(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ResponsiveText(
                textAlign: TextAlign.center,
                text: "Made with ♥ by Carl Czarnetzki",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class Browse extends StatefulWidget {
  const Browse({super.key});

  @override
  State<Browse> createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  final Stream<QuerySnapshot> _shopsStream =
      FirebaseFirestore.instance.collection('doenershops').snapshots();
  bool rebuilt = false;

  void listenToDoenershops() async {
    _shopsStream.listen((QuerySnapshot<Object?> snapshot) {
      for (var change in snapshot.docChanges) {
        // Handle the changes (added, modified, removed documents)
        if (change.type == DocumentChangeType.added) {
          setState(() {});
        } else if (change.type == DocumentChangeType.modified) {
          setState(() {});
        } else if (change.type == DocumentChangeType.removed) {
          setState(() {});
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    BrowseController.stream.listen((bool _) {
      setState(() {});
    });
    listenToDoenershops();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _shopsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                height: 200,
                width: MediaQuery.of(context).size.width * 0.95,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 200,
                width: MediaQuery.of(context).size.width * 0.95,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                return ShopCard(key: ValueKey(document.id), cardData: document);
              })
              .toList()
              .cast(),
        );
      },
    );
  }
}

class Favourites extends StatefulWidget {
  const Favourites({super.key});
  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    FavoritesController.stream.listen((bool _) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('doenershops')
            .where('favorites', arrayContains: _auth.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              margin: const EdgeInsets.all(10),
              height: 200,
              width: MediaQuery.of(context).size.width * 0.80,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              if (snapshot.data!.size == 0) {
                //TODO: schönes ui
                return Container(
                  margin: const EdgeInsets.all(10),
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.80,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Click the heart icon to \nadd to favorites.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 18,
                      ),
                    ),
                  ),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.size,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot<Object?> cardData =
                      snapshot.data!.docs[index];
                  return FavCard(
                      key: ValueKey(cardData.id),
                      cardData: cardData.data() as Map<String, dynamic>);
                },
              );
            } else {
              //TODO: schönes ui
              return Container(
                margin: const EdgeInsets.all(10),
                height: 200,
                width: MediaQuery.of(context).size.width * 0.80,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'Click the heart icon to \nadd to favorites.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 18,
                    ),
                  ),
                ),
              );
            }
          }
          return const Text("Something went wrong.");
        });
  }
}

class FavCard extends StatefulWidget {
  final Map<String, dynamic> cardData;

  const FavCard({super.key, required this.cardData});

  @override
  State<FavCard> createState() => _FavCardState();
}

class _FavCardState extends State<FavCard> {
  final storageRef = FirebaseStorage.instance.ref();
  File? _file;
  bool loading = true;

  Future<void> loadImage() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDocDir.absolute.path}/${widget.cardData['image']}";
    _file = File(filePath);

    final downloadTask =
        storageRef.child(widget.cardData['image']).writeToFile(_file!);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          //print("Download is $progress% complete.");
          break;
        case TaskState.paused:
          print("Download is paused.");
          break;
        case TaskState.canceled:
          print("Download was canceled");
          break;
        case TaskState.error:
          print("Download error");
          break;
        case TaskState.success:
          setState(() {
            loading = false;
          });
          break;
      }

      setState(() {
        loading = false;
      });
    });

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    loading = true;
    super.initState();

    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        margin: const EdgeInsets.all(10),
        height: 200,
        width: MediaQuery.of(context).size.width * 0.80,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.all(10),
      height: 200,
      width: MediaQuery.of(context).size.width * 0.80,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Image.file(
            _file!,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width * 0.80,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.80,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.grey[800]!.withOpacity(0.9),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.cardData['name'],
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.cardData['address'],
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: "Roboto",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShopCard extends StatefulWidget {
  final DocumentSnapshot<Object?> cardData;
  const ShopCard({super.key, required this.cardData});

  @override
  State<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _fav = false;
  Map<String, dynamic> data = {};
  final storageRef = FirebaseStorage.instance.ref();
  File? _file;
  bool loading = true;

  Future<void> loadImage() async {
    if (widget.cardData['image'] == null) {
      FavoritesController.notifyFavoritesChanged();
      setState(() {
        loading = true;
      });
    }

    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDocDir.absolute.path}/${widget.cardData['image']}";
    _file = File(filePath);

    final downloadTask =
        storageRef.child(widget.cardData['image']).writeToFile(_file!);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          //print("Download is $progress% complete.");
          break;
        case TaskState.paused:
          print("Download is paused.");
          break;
        case TaskState.canceled:
          print("Download was canceled");
          break;
        case TaskState.error:
          print("Download error");
          break;
        case TaskState.success:
          setState(() {
            loading = false;
          });
          break;
      }
    });
  }

  @override
  void initState() {
    data = widget.cardData.data() as Map<String, dynamic>;
    if (_auth.currentUser != null &&
        data['favorites'].contains(_auth.currentUser?.uid)) {
      _fav = true;
    } else {
      _fav = false;
    }
    loadImage();
  }

  void setFavorite(bool isFavorite) async {
    final docRef = _firestore.collection("doenershops").doc(widget.cardData.id);
    if (isFavorite) {
      // Add current user's ID to the favorites array
      docRef.set({
        'favorites': FieldValue.arrayUnion([_auth.currentUser?.uid])
      }, SetOptions(merge: true));
    } else {
      // Remove current user's ID from the favorites array
      docRef.update({
        'favorites': FieldValue.arrayRemove([_auth.currentUser?.uid])
      });
    }

    FavoritesController.notifyFavoritesChanged();

    setState(() {
      _fav = isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        margin: const EdgeInsets.all(10),
        height: 200,
        width: MediaQuery.of(context).size.width * 0.95,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.all(10),
      height: 200,
      width: MediaQuery.of(context).size.width * 0.95,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Image.file(
            _file!,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width * 0.95,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.95,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.grey[800]!.withOpacity(0.9),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'],
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    data['address'],
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: "Roboto",
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            height: 150,
            width: MediaQuery.of(context).size.width * 0.95,
            child: Align(
              alignment: Alignment.topRight,
              child: FavoriteButton(
                isFavorite: _fav,
                valueChanged: (isFavorite) {
                  setState(() {
                    setFavorite(isFavorite);
                  });
                },
                iconDisabledColor: Colors.white,
                iconSize: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesController {
  static final StreamController<bool> _controller =
      StreamController<bool>.broadcast();

  static Stream<bool> get stream => _controller.stream;

  static void notifyFavoritesChanged() {
    _controller.add(true);
  }
}

class BrowseController {
  static final StreamController<bool> _controller =
      StreamController<bool>.broadcast();

  static Stream<bool> get stream => _controller.stream;

  static void notifyBrowseChanged() {
    _controller.add(true);
  }
}

class AddShopButton extends StatefulWidget {
  const AddShopButton({super.key});

  @override
  State<AddShopButton> createState() => _AddShopButtonState();
}

class _AddShopButtonState extends State<AddShopButton> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    checkAdmin();
  }

  void checkAdmin() async {
    try {
      var currentUser = _auth.currentUser?.uid;
      var docRef = await firestore
          .collection('admin')
          .where('userId', isEqualTo: currentUser)
          .get();
      if (docRef.docs.isNotEmpty) {
        setState(() {
          isAdmin = true;
        });
      } else {
        setState(() {
          isAdmin = false;
        });
      }
    } catch (e) {
      print("Error getting admin id: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isAdmin) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ShopCreate()));
            },
            child: const Text("Add Shop"),
          ),
        ],
      );
    }
    return const SizedBox();
  }
}
