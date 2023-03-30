import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp (
    ProviderScope(
      child: MyApp(),
    ),
  );
}

final storage = new FlutterSecureStorage();

final counterProvider = StateProvider<int>((ref) => 0);
final isLoadingProvider = StateProvider<bool>((ref) => false);

// StatelessWidgetの代わりに `HookConsumerWidget` を継承します。
class MyApp extends HookConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = useState(0);
    // final counterState = ref.watch(counterProvider);
    // final isLoadingState = ref.watch(isLoadingProvider);

    void _incrementCounter() {
      counter.value++;
    }

    void _decrementCounter() {
      // ref.read(counterProvider.notifier).state--;
      counter.value--;
    }

    void _resetCounter() {
      // ref.read(counterProvider.notifier).state = 0;
      counter.value = 0;
    }

    void _setIsLoading(bool isLoadind) {
      ref.read(isLoadingProvider.notifier).state = isLoadind;
    }

    void _persist() async {
      await storage.write(key: 'count', value: counter.value.toString());
    }

    void _incrementCounterWithAwait() async {
      _setIsLoading(true);
      await Future.delayed(Duration(seconds: 1)); // 1秒間待機する
      _incrementCounter();
      // await storage.write(key: 'count', value: ref.read(counterProvider.notifier).toString());
      _persist();
      _setIsLoading(false);
    }

    void _decrementCounterWithAwait() async {
      _setIsLoading(true);
      await Future.delayed(Duration(seconds: 1)); // 1秒間待機する
      _decrementCounter();
      // await storage.write(key: 'count', value: ref.read(counterProvider.notifier).toString());
      _persist();
      _setIsLoading(false);
    }

    void _resetCounterWithAwait() async {
      _setIsLoading(true);
      await Future.delayed(Duration(seconds: 1)); // 1秒間待機する
      _resetCounter();
      // await storage.write(key: 'count', value: ref.read(counterProvider.notifier).toString());
      _persist();
      _setIsLoading(false);
    }

    Future<void> _initCounter() async {
      final counterStr = await storage.read(key: 'count');
      counter.value = int.tryParse(counterStr ?? '0') ?? 0;
    }

    useEffect(() {
      _initCounter();
    }, []);

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
                    // '${ref.watch(counterProvider)}',
                    '${counter.value}',
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