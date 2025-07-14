import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../appservice/cart_bloc.dart';
import '../../../appservice/cart_event.dart';
import '../../../appservice/cart_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              context.read<CartBloc>().add(ClearCart());
            },
            tooltip: "Clear All",
          )
        ],
      ),

      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final cartItems = state.items;

          if (cartItems.isEmpty) {
            return const Center(child: Text("Your cart is empty."));
          }

          double totalPrice = 0;
          cartItems.forEach((product, quantity) {
            totalPrice += product.price * quantity;
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final product = cartItems.keys.elementAt(index);
                    final quantity = cartItems[product]!;

                    return ListTile(
                      leading: Image.asset(product.imagePath, width: 50),
                      title: Text(product.title),
                      subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: "Remove Item",
                            onPressed: () {
                              context.read<CartBloc>().add(RemoveFromCart(product));
                            },
                          ),


                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    quantity == 1 ? Icons.delete_forever : Icons.remove,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    if (quantity == 1) {
                                      context.read<CartBloc>().add(RemoveFromCart(product));
                                    } else {
                                      context.read<CartBloc>().add(DecrementQuantity(product));
                                    }
                                  },
                                ),
                                Text(
                                  '$quantity',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                                  onPressed: () {
                                    context.read<CartBloc>().add(IncrementQuantity(product));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );


                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("\$${totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Proceeding to checkout...")),
                          );
                        },
                        child: const Text("Checkout", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
