import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'appservice/product.dart';
import 'appservice/cart_event.dart';
import 'cart/presentation/cart_storage_service.dart';
import 'appservice/cart_bloc.dart';
import 'startscreen/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ProductAdapter());

  await Hive.openBox('cartBox');

  final cartStorage = CartStorageService();

  final savedCart = cartStorage.loadCart();

  runApp(
    BlocProvider(
      create: (_) => CartBloc(cartStorage)..add(LoadCart(savedCart)),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(),
    );
  }
}
