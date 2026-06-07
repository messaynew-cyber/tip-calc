import 'package:flutter/material.dart';

void main() => runApp(const TipCalcApp());

class TipCalcApp extends StatelessWidget {
  const TipCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const TipCalculator(),
    );
  }
}

class TipCalculator extends StatefulWidget {
  const TipCalculator({super.key});

  @override
  State<TipCalculator> createState() => _TipCalculatorState();
}

class _TipCalculatorState extends State<TipCalculator> {
  final _controller = TextEditingController();
  double _tipPercent = 0.15;
  bool _hasInput = false;

  double get _billAmount => double.tryParse(_controller.text) ?? 0;
  double get _tipAmount => _billAmount * _tipPercent;
  double get _total => _billAmount + _tipAmount;

  void _setTip(double percent) => setState(() => _tipPercent = percent);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = _billAmount > 0;
    if (hasValue != _hasInput) {
      _hasInput = hasValue;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Tip Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Bill Amount',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 28),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 32),
            Text('Tip Percentage',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [0.10, 0.15, 0.20].map((pct) {
                final isSelected = _tipPercent == pct;
                return FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceVariant,
                    foregroundColor: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () => _setTip(pct),
                  child: Text('${(pct * 100).toInt()}%'),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildRow('Tip', _tipAmount),
                    const Divider(height: 24),
                    _buildRow('Total', _total, isTotal: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: isTotal ? 24 : 18,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            )),
        Text('\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 24 : 18,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            )),
      ],
    );
  }
}
