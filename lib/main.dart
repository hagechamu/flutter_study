import 'dart:html';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp (
    ProviderScope(
      child: MyApp(),
    ),
  );
}

final storage = new FlutterSecureStorage();

// The await expression can only be used in an async function.
// final countStr = await storage.read(key: 'count');

final counterProvider = StateProvider<int>((ref) => 0);
final isLoadingProvider = StateProvider<bool>((ref) => false);

// StatelessWidgetの代わりに `HookConsumerWidget` を継承します。
class MyApp extends HookConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void _incrementCounter() {
      ref.read(counterProvider.notifier).state++;
    }

    void _decrementCounter() {
      ref.read(counterProvider.notifier).state--;
    }

    void _resetCounter() {
      ref.read(counterProvider.notifier).state = 0;
    }

    void _setIsLoading(bool isLoadind) {
      ref.read(isLoadingProvider.notifier).state = isLoadind;
    }

    void _incrementCounterWithAwait() async {
      _setIsLoading(true);
      await Future.delayed(Duration(seconds: 1)); // 1秒間待機する
      await storage.write(key: 'count', value: ref.read(counterProvider.notifier).toString());
      _incrementCounter();
      _setIsLoading(false);
    }

    void _decrementCounterWithAwait() async {
      _setIsLoading(true);
      await Future.delayed(Duration(seconds: 1)); // 1秒間待機する
      _decrementCounter();
      _setIsLoading(false);
    }

    void _resetCounterWithAwait() async {
      _setIsLoading(true);
      await Future.delayed(Duration(seconds: 1)); // 1秒間待機する
      _resetCounter();
      _setIsLoading(false);
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('ボタンを押した回数'),
                  ref.watch(isLoadingProvider) ? CircularProgressIndicator() :
                  Text(
                    '${ref.watch(counterProvider)}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _incrementCounterWithAwait,
                child: Text("plus"),
              ),
              ElevatedButton(
                onPressed: _decrementCounterWithAwait,
                child: Text("minus"),
              ),
              ElevatedButton(
                onPressed: _resetCounterWithAwait,
                child: Text("reset"),
              )
            ],
          )
        ),
      ),
    );
  }
}