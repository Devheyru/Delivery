import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minoo_deleivery/models/destination_address.dart';
import 'package:minoo_deleivery/providers/address/address_providers.dart';

class DestinationDropdown extends ConsumerWidget {
  const DestinationDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final center = ref.watch(selectedCenterProvider);
    final selectedDestination = ref.watch(selectedDestinationProvider);

    if (center == null) {
      return const Text("");
    }

    final destinationsAsync = ref.watch(destinationsProvider(center.id));

    return destinationsAsync.when(
      data:
          (destinations) => DropdownButton<Destination>(
            value: selectedDestination,
            hint: const Text("Select Destination"),
            isExpanded: true,
            items:
                destinations.map((d) {
                  return DropdownMenuItem(value: d, child: Text(d.name));
                }).toList(),
            onChanged: (value) {
              ref.read(selectedDestinationProvider.notifier).state = value;
            },
          ),
      loading: () => const CircularProgressIndicator(),
      error: (err, _) => Text("Error: $err"),
    );
  }
}
