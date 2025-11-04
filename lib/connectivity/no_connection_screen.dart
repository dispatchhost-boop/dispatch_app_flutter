import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../const/app_strings.dart';
import 'internet_controller.dart';

class NoInternetConnection extends ConsumerWidget {
  const NoInternetConnection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(internetProvider);
    if (provider.hasConnection) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 70),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Material(
          color: Colors.red[600],
          borderRadius: BorderRadius.circular(8),
          elevation: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Row(
              children: const [
                Icon(Icons.wifi_off, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(AppStrings.noInternetConnection,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
