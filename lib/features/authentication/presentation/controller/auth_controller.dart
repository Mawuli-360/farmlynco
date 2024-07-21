import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedIndex = StateProvider((ref) => 0);
final selectedValue = StateProvider((ref) => "Sell Foodstuff");
final isPasswordSelected = StateProvider((ref) => true);
final selectedRole = StateProvider((ref) => "Farmer");
