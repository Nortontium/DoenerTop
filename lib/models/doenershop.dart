import 'dart:core';

class DoenerShop {
  String name;
  String imagePath;
  String adress;

  DoenerShop({
    required this.name,
    required this.imagePath,
    required this.adress,
  });
}

List<DoenerShop> getShops() {
  List<DoenerShop> shops = [];

  shops.add(
    DoenerShop(
      name: "Anadolu Döner",
      imagePath: "assets/images/anadoludoener.jpg",
      adress: "Drei-Kronen-Gasse 6",
    ),
  );

  shops.add(
    DoenerShop(
      name: "Exil",
      imagePath: "assets/images/exil.jpg",
      adress: "Weißgerbergraben 14",
    ),
  );

  shops.add(
    DoenerShop(
      name: "Stern Kebab",
      imagePath: "assets/images/sternkebab.jpg",
      adress: "Maximilianstraße 18",
    ),
  );

  return shops;
}