import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_study_tiger/App.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

// StatelessWidgetの代わりに `HookConsumerWidget` を継承します。
class HomeView extends HookConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _selectedIndex = useState(0);

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

    void _persist() async {
      await storage.write(key: 'count', value: ref.read(counterProvider.notifier).state.toString());
    }

    void _incrementCounterWithAwait() async {
      _setIsLoading(true);
      await Future.delayed(Duration(seconds: 1)); // 1秒間待機する
      _incrementCounter();
      _persist();
      _setIsLoading(false);
    }

    void _decrementCounterWithAwait() async {
      _setIsLoading(true);
      await Future.delayed(Duration(seconds: 1)); // 1秒間待機する
      _decrementCounter();
      _persist();
      _setIsLoading(false);
    }

    void _resetCounterWithAwait() async {
      _setIsLoading(true);
      await Future.delayed(Duration(seconds: 1)); // 1秒間待機する
      _resetCounter();
      _persist();
      _setIsLoading(false);
    }

    return MaterialApp(
      home: Scaffold(
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