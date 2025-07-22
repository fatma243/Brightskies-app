import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'appservice/product.dart';
import 'appservice/cart_event.dart';
import 'appservice/cart_bloc.dart';
import 'cart/presentation/cart_storage_service.dart';
import 'injection/injection.dart';
import 'appservice/bottom_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  await Hive.openBox('cartBox');

  await configureDependencies();

  final cartStorage = getIt<CartStorageService>();
  final savedCart = cartStorage.loadCart();

  runApp(
    BlocProvider(
      create: (_) => getIt<CartBloc>()..add(LoadCart(savedCart)),
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
      home: BottomNavigation(),
    );
  }
}
