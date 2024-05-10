import 'package:badges/badges.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import 'cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        centerTitle: true,
        actions: [
          Center(
            child: badges.Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(value.getCounter().toString(),
                      style: const TextStyle(color: Colors.white));
                },
              ),
              animationDuration: const Duration(milliseconds: 300),
              animationType: BadgeAnimationType.slide,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(width: 20.0)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Image(
                              image: AssetImage('images/empty_cart.png'),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text('Your cart is empty 😌',
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                                'Explore products and shop your\nfavourite items',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall)
                          ],
                        ),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Image(
                                            height: 100,
                                            width: 100,
                                            image: NetworkImage(snapshot
                                                .data![index]['image']
                                                .toString()),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot.data![index]
                                                              ['productName']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          bool exist = cart
                                                              .listOfLists
                                                              .any((map) =>
                                                                  map['productName'] ==
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                          [
                                                                          'productName']
                                                                      .toString());

                                                          print(exist);
                                                          if (exist == true) {
                                                            cart.removeTotalPrice(
                                                                double.parse(snapshot
                                                                    .data![
                                                                        index][
                                                                        'productPrice']
                                                                    .toString()));
                                                            cart.removerCounter();
                                                            cart.removemap(snapshot
                                                                .data![index][
                                                                    'productName']
                                                                .toString());
                                                            print('"removed');
                                                            print(cart
                                                                .listOfLists);
                                                          }
                                                        },
                                                        child: const Icon(
                                                            Icons.delete))
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  snapshot.data![index]
                                                              ['unitTag']
                                                          .toString() +
                                                      " " +
                                                      r"$" +
                                                      snapshot.data![index]
                                                              ['productPrice']
                                                          .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      height: 35,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            InkWell(
                                                                onTap: () {
                                                                  int quantity =
                                                                      snapshot.data![
                                                                              index]
                                                                          [
                                                                          'quantity']!;
                                                                  int price = snapshot
                                                                              .data![
                                                                          index]
                                                                      [
                                                                      'initialPrice']!;
                                                                  quantity--;
                                                                  int?
                                                                      newPrice =
                                                                      price *
                                                                          quantity;

                                                                  if (quantity >
                                                                      0) {
                                                                    cart.listOfLists[index]
                                                                            [
                                                                            'productPrice'] =
                                                                        newPrice;
                                                                    cart.listOfLists[index]
                                                                            [
                                                                            'quantity'] =
                                                                        quantity;

                                                                    newPrice =
                                                                        0;
                                                                    quantity =
                                                                        0;
                                                                    cart.removeTotalPrice(double.parse(snapshot
                                                                        .data![
                                                                            index]
                                                                            [
                                                                            'initialPrice']!
                                                                        .toString()));
                                                                  }
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons.remove,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                            Text(
                                                                snapshot.data![
                                                                        index][
                                                                        'quantity']
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            InkWell(
                                                                onTap: () {
                                                                  int quantity =
                                                                      snapshot.data![
                                                                              index]
                                                                          [
                                                                          'quantity']!;
                                                                  int price = snapshot
                                                                              .data![
                                                                          index]
                                                                      [
                                                                      'initialPrice']!;
                                                                  quantity++;
                                                                  int?
                                                                      newPrice =
                                                                      price *
                                                                          quantity;

                                                                  cart.listOfLists[
                                                                              index]
                                                                          [
                                                                          'productPrice'] =
                                                                      newPrice;
                                                                  cart.listOfLists[
                                                                              index]
                                                                          [
                                                                          'quantity'] =
                                                                      quantity;
                                                                  cart.addTotalPrice(double.parse(snapshot
                                                                      .data![
                                                                          index]
                                                                          [
                                                                          'initialPrice']!
                                                                      .toString()));
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                  }
                  return const Text('');
                }),
            Consumer<CartProvider>(builder: (context, value, child) {
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) == "0.00"
                    ? false
                    : true,
                child: Column(
                  children: [
                    ReusableWidget(
                      title: 'Sub Total',
                      value: r'$' + value.getTotalPrice().toStringAsFixed(2),
                    ),
                    const ReusableWidget(
                      title: 'Discout 5%',
                      value: r'$' '0',
                    ),
                    ReusableWidget(
                      title: 'Total',
                      value: r'$' + value.getTotalPrice().toStringAsFixed(2),
                    )
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.titleSmall,
          )
        ],
      ),
    );
  }
}
