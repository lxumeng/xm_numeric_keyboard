import 'package:flutter/material.dart';
import 'package:xm_numeric_keyboard/xm_numeric_keyboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XM Numeric Keyboard Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const KeyboardExample(),
    );
  }
}

class KeyboardExample extends StatefulWidget {
  const KeyboardExample({super.key});

  @override
  State<KeyboardExample> createState() => _KeyboardExampleState();
}

class _KeyboardExampleState extends State<KeyboardExample> {
  String _input = '';
  bool _keyboardVisible = true;

  void _toggleKeyboard() {
    setState(() {
      _keyboardVisible = !_keyboardVisible;
    });
  }

  void _onKeyboardTap(String text) {
    setState(() {
      if (text == 'delete') {
        _input =
            _input.isNotEmpty ? _input.substring(0, _input.length - 1) : '';
      } else if (text == '确定') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('输入内容: $_input')),
        );
      } else {
        _input += text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XM数字键盘示例'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _input.isEmpty ? '请输入数字' : _input,
                    style: const TextStyle(fontSize: 36),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _toggleKeyboard,
                    child: Text(_keyboardVisible ? '隐藏键盘' : '显示键盘'),
                  ),
                ],
              ),
            ),
          ),
          XMNumericKeyboard(
            onKeyboardTap: _onKeyboardTap,
            textColor: Colors.black,
            showConfirm: true,
            confirmButtonText: '确定',
            buttonColor: Colors.grey[100]!,
            buttonRadius: 12,
            isVisible: _keyboardVisible,
          ),
        ],
      ),
    );
  }
}
