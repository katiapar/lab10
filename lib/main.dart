import 'package:flutter/material.dart';

void main() {
  runApp(const TextPreviewApp());
}

class TextPreviewApp extends StatelessWidget {
  const TextPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF62518F);
    const background = Color(0xFFFFF7FF);

    return MaterialApp(
      title: 'Text previewer',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: purple,
          primary: purple,
          surface: background,
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFCDB4F4),
          foregroundColor: Colors.black,
          centerTitle: true,
        ),
      ),
      home: const InputScreen(),
    );
  }
}

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController textController = TextEditingController();

  double fontSize = 75;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> openPreview() async {
    FocusScope.of(context).unfocus();

    // true — OK, false — Cancel, null — повернення назад.
    final bool? result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          text: textController.text,
          fontSize: fontSize,
        ),
      ),
    );

    if (!mounted) return;

    final String message;

    if (result == true) {
      message = 'Cool!';
    } else if (result == false) {
      message = 'Let’s try something else';
    } else {
      message = "Don't know what to say";
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Image.network(
              'https://emojiisland.com/cdn/shop/products/'
                  'Robot_Emoji_Icon_abe1111a-1293-4668-bdf9-9ceb05cff58e'
                  '_large.png?v=1571606090',
              width: 48,
              height: 48,
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  '🤖',
                  style: TextStyle(fontSize: 36),
                );
              },
            ),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text previewer'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Text',
                  helperText: 'Enter some text',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text('Font size: ${fontSize.round()}'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Slider(
                      value: fontSize,
                      min: 10,
                      max: 100,
                      divisions: 90,
                      onChanged: (value) {
                        setState(() {
                          fontSize = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: openPreview,
                child: const Text('Preview'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PreviewScreen extends StatelessWidget {
  final String text;
  final double fontSize;

  const PreviewScreen({
    super.key,
    required this.text,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: fontSize),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('OK'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}