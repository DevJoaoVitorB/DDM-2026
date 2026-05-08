import 'package:flutter/material.dart';

import '../models/cep_model.dart';
import '../services/via_cep_service.dart';
import '../widgets/footer_bar.dart';
import '../widgets/header_section.dart';
import '../widgets/result_dashboard.dart';
import '../widgets/search_card.dart';
import '../widgets/state_panel.dart';

enum CepViewState { empty, loading, error, result }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cepController = TextEditingController();
  final ViaCepService _service = ViaCepService();
  CepViewState _state = CepViewState.empty;
  String _errorMessage = '';
  CepModel? _cepData;
  String _typedValue = '';
  bool _isTypedValid = false;
  bool _isRequestInFlight = false;

  @override
  void dispose() {
    _cepController.dispose();
    super.dispose();
  }

  Future<void> _onSearch() async {
    // Prevents multiple API requests while loading.
    if (_isRequestInFlight) {
      return;
    }

    FocusScope.of(context).unfocus();
    final String cep = _sanitizeCep(_cepController.text);
    if (!_isCepValid(cep)) {
      _setErrorState('Digite um CEP valido para buscar.');
      _showSnackBar('Informe um CEP com 8 digitos.');
      return;
    }

    setState(() {
      // Event chaining: loading -> request -> dashboard update.
      _state = CepViewState.loading;
      _errorMessage = '';
      _cepData = null;
      _isRequestInFlight = true;
    });

    try {
      final CepModel result = await _service.fetchCep(cep);
      setState(() {
        _state = CepViewState.result;
        _cepData = result;
      });
      // Displays feedback after successful request.
      _showSnackBar('CEP encontrado com sucesso.');
    } catch (error) {
      _setErrorState(error.toString().replaceFirst('Exception: ', ''));
      _showSnackBar(_errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          _isRequestInFlight = false;
        });
      }
    }
  }

  void _onClear() {
    _cepController.clear();
    _resetContent();
    _showSnackBar('Campos limpos.');
  }

  void _onSearchInvalid() {
    _setErrorState('Digite um CEP valido para buscar.');
  }

  void _onCepChanged(String value) {
    final String sanitized = _sanitizeCep(value);
    final bool isValid = _isCepValid(sanitized);

    setState(() {
      _typedValue = sanitized;
      _isTypedValid = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        // LayoutBuilder keeps responsiveness tied to the available width.
        child: LayoutBuilder(
          builder: (context, constraints) {
            return _buildLayout(constraints);
          },
        ),
      ),
    );
  }

  Widget _buildLayout(BoxConstraints constraints) {
    final ThemeData theme = Theme.of(context);
    // Adjusts layout width for larger screens.
    final double maxWidth = constraints.maxWidth >= 720
        ? 600
        : constraints.maxWidth;
    final bool hasTypedValue = _typedValue.isNotEmpty;
    final Color indicatorColor = !hasTypedValue
        ? theme.colorScheme.outlineVariant
        : _isTypedValid
        ? theme.colorScheme.secondary
        : theme.colorScheme.error;
    final bool canSearch = _isTypedValid && !_isRequestInFlight;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF3F4F6), Color(0xFFF9FAFB)],
        ),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            children: <Widget>[
              const HeaderSection(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Column(
                    children: <Widget>[
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: indicatorColor),
                        ),
                        child: SearchCard(
                          controller: _cepController,
                          onChanged: _onCepChanged,
                          onSearch: canSearch ? _onSearch : _onSearchInvalid,
                          onClear: _onClear,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          Icon(
                            _isTypedValid ? Icons.check_circle : Icons.info,
                            color: indicatorColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              hasTypedValue
                                  ? 'Digitado: $_typedValue'
                                  : 'Digite um CEP com 8 digitos.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: indicatorColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _isRequestInFlight ? null : _onClear,
                          child: const Text('Limpar'),
                        ),
                      ),
                      if (_state == CepViewState.loading) ...<Widget>[
                        const SizedBox(height: 12),
                        const LinearProgressIndicator(),
                      ],
                      const SizedBox(height: 20),
                      _buildContent(),
                    ],
                  ),
                ),
              ),
              const FooterBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_state) {
      case CepViewState.empty:
        return const StatePanel(
          icon: Icons.search,
          title: 'Digite o CEP para iniciar',
          subtitle: 'Os dados de endereco aparecerao aqui.',
        );
      case CepViewState.loading:
        return const StatePanel.loading(
          title: 'Buscando CEP...',
          subtitle: 'Aguarde enquanto consultamos o endereco.',
        );
      case CepViewState.error:
        return StatePanel.error(title: 'CEP invalido', subtitle: _errorMessage);
      case CepViewState.result:
        final CepModel? cep = _cepData;
        if (cep == null) {
          return const StatePanel.error(
            title: 'Nada para exibir',
            subtitle: 'Busque um CEP para ver os detalhes.',
          );
        }
        if (_isCepInfoEmpty(cep)) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                // Dashboard feedback when data is empty.
                _showSnackBar('Informacoes nao encontradas.');
              },
              onLongPress: () {
                _showEmptyInfoDialog();
              },
              child: const StatePanel.error(
                title: 'Informacoes nao encontradas',
                subtitle: 'Nao foi possivel localizar dados para este CEP.',
              ),
            ),
          );
        }
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              _showSnackBar('Dashboard tocado.');
            },
            onLongPress: () {
              _showDashboardDialog(cep);
            },
            child: ResultDashboard(
              logradouro: cep.logradouro,
              bairro: cep.bairro,
              cidade: cep.localidade,
              estado: cep.uf,
              cep: cep.cep,
            ),
          ),
        );
    }
  }

  bool _isCepInfoEmpty(CepModel cep) {
    return cep.logradouro.isEmpty &&
        cep.bairro.isEmpty &&
        cep.localidade.isEmpty &&
        cep.uf.isEmpty &&
        cep.cep.isEmpty;
  }

  bool _isCepValid(String cep) => cep.length == 8;

  String _sanitizeCep(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }

  void _resetContent() {
    setState(() {
      _state = CepViewState.empty;
      _errorMessage = '';
      _cepData = null;
      _typedValue = '';
      _isTypedValid = false;
    });
  }

  void _setErrorState(String message) {
    setState(() {
      _state = CepViewState.error;
      _errorMessage = message;
      _cepData = null;
    });
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }

    // Centralizes user feedback in one place.
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showDashboardDialog(CepModel cep) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detalhes do CEP'),
          content: Text(
            'CEP: ${cep.cep}\nCidade: ${cep.localidade}\nEstado: ${cep.uf}',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEmptyInfoDialog() {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Informacoes nao encontradas'),
          content: const Text(
            'Nao foi possivel localizar dados para este CEP.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
