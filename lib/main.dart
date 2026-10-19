import 'package:flutter/material.dart';

void main() {
  runApp(const CounterApp());
}

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабораторна робота №1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final TextEditingController _controller = TextEditingController();

  int _counter = 0;
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _processInput() {
    final String input = _controller.text.trim();

    if (input == 'Avada Kedavra') {
      setState(() {
        _counter = 0;
        _errorMessage = null;
        _controller.clear();
      });

      _showMessage('Лічильник скинуто до нуля.');
      return;
    }

    final int? number = int.tryParse(input);

    if (number == null) {
      setState(() {
        _errorMessage = 'Введіть ціле число або команду Avada Kedavra.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Некоректне введення. Лічильник не змінено.'),
        ),
      );
      return;
    }

    setState(() {
      _counter += number;
      _errorMessage = null;
      _controller.clear();
    });

    _showMessage('До лічильника додано $number.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторна робота №1'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.calculate_outlined, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Інтерактивний лічильник',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Введіть ціле число, щоб змінити значення.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 28),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Text('Поточне значення'),
                          const SizedBox(height: 8),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              '$_counter',
                              key: ValueKey<int>(_counter),
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Число або команда',
                      hintText: 'Наприклад, 10 або -5',
                      prefixIcon: const Icon(Icons.edit),
                      border: const OutlineInputBorder(),
                      errorText: _errorMessage,
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _processInput(),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _processInput,
                    icon: const Icon(Icons.add),
                    label: const Text('Застосувати'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _counter = 0;
                        _errorMessage = null;
                        _controller.clear();
                      });
                    },
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Скинути лічильник'),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Команда скидання: Avada Kedavra',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
