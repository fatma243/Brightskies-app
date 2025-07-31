import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../appservice/cart_bloc.dart';
import '../../../appservice/cart_event.dart';
import '../../../appservice/cart_state.dart';
import '../../../appservice/product.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final cartItems = state.items;
            double totalPrice = 0;
            cartItems.forEach((product, quantity) {
              totalPrice += product.price * quantity;
            });

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(10),
                            child: const SizedBox(
                              width: 20,
                              height: 20,
                              child: Icon(Icons.arrow_back_ios,size:20, color: Color(0xFF0019FF)),

                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            "Your bag",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (cartItems.isEmpty)
                  const Expanded(
                    child: Center(child: Text("Your bag is empty.")),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: cartItems.length,
                      separatorBuilder: (_, __) => const Divider(height: 24),
                      itemBuilder: (context, index) {
                        final product = cartItems.keys.elementAt(index);
                        final quantity = cartItems[product]!;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: product.images.isNotEmpty
                                      ? Image.network(
                                    product.images[0],
                                    width: 90,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                      : Container(
                                    width: 90,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, size: 30),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.title,
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${product.selectedColorName ?? 'Color'} / ${product.selectedSize ?? 'Size'}",
                                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            _qtyButton(
                                              icon: Icons.remove,
                                              onPressed: () {
                                                if (quantity == 1) {
                                                  context.read<CartBloc>().add(RemoveFromCart(product));
                                                } else {
                                                  context.read<CartBloc>().add(DecrementQuantity(product));
                                                }
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Text('$quantity',
                                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                            _qtyButton(
                                              icon: Icons.add,
                                              onPressed: () {
                                                context.read<CartBloc>().add(IncrementQuantity(product));
                                              },
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text("€ ${product.price.toStringAsFixed(2)}",
                                            style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ],
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          Text("€ ${totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0019FF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: cartItems.isEmpty
                              ? null
                              : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Proceeding to checkout...")),
                            );
                          },
                          child: const Text("Checkout",
                              style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: const Color(0xFFE5E8FF),
          borderRadius: BorderRadius.circular(26),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 16, color: const Color(0xFF0019FF)),
      ),
    );
  }
}
