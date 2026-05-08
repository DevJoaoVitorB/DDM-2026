import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSearch,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextInputFormatter cepMaskFormatter = CepMaskFormatter();

    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.primary.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            // Validates CEP as the user types.
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              maxLength: 9,
              inputFormatters: <TextInputFormatter>[
                cepMaskFormatter,
              ],
              onChanged: onChanged,
              decoration: InputDecoration(
                labelText: 'Digite o CEP',
                prefixIcon: const Icon(Icons.search),
                counterText: '',
                suffixIcon: controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: onClear,
                      ),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onSearch,
                icon: const Icon(Icons.search),
                label: const Text('Buscar CEP'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CepMaskFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < digitsOnly.length && i < 8; i++) {
      if (i == 5) {
        buffer.write('-');
      }
      buffer.write(digitsOnly[i]);
    }

    final String masked = buffer.toString();
    return TextEditingValue(
      text: masked,
      selection: TextSelection.collapsed(offset: masked.length),
    );
  }
}
