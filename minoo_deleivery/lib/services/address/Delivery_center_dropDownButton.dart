import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minoo_deleivery/models/delivery_center_model.dart';
import 'package:minoo_deleivery/providers/address/address_providers.dart';

class DeliveryCenterDropdown extends ConsumerWidget {
  const DeliveryCenterDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final centersAsync = ref.watch(deliveryCentersProvider);
    final selectedCenter = ref.watch(selectedCenterProvider);

    return centersAsync.when(
      data:
          (centers) => DropdownButton<DeliveryCenter>(
            value: selectedCenter,
            hint: const Text("Select Delivery Center"),
            isExpanded: true,
            items:
                centers.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c.name));
                }).toList(),
            onChanged: (value) {
              ref.read(selectedCenterProvider.notifier).state = value;
              // Reset destination when center changes
              ref.read(selectedDestinationProvider.notifier).state = null;
            },
          ),
      loading: () => const CircularProgressIndicator(),
      error: (err, _) => Text("Error: $err"),
    );
  }
}
