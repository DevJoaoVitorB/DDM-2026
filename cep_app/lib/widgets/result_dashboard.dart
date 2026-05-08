import 'package:flutter/material.dart';

import 'result_row.dart';

class ResultDashboard extends StatelessWidget {
  const ResultDashboard({
    super.key,
    required this.logradouro,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.cep,
  });

  final String logradouro;
  final String bairro;
  final String cidade;
  final String estado;
  final String cep;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Informacoes do CEP',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ResultRow(
              icon: Icons.route,
              label: 'Logradouro',
              value: logradouro,
            ),
            ResultRow(
              icon: Icons.location_city,
              label: 'Bairro',
              value: bairro,
            ),
            ResultRow(icon: Icons.apartment, label: 'Cidade', value: cidade),
            ResultRow(icon: Icons.map, label: 'Estado', value: estado),
            ResultRow(icon: Icons.markunread_mailbox, label: 'CEP', value: cep),
          ],
        ),
      ),
    );
  }
}
