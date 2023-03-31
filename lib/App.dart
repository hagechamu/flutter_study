import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_study_tiger/home_view.dart';
import 'package:flutter_study_tiger/order_inquiry.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

final counterProvider = StateProvider<int>((ref) => 0);
final isLoadingProvider = StateProvider<bool>((ref) => false);

class MyApp extends HookConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _selectedIndex = useState(0);

    final List<Widget> _widgetOptions = <Widget>[
      HomeView(),
      OrderInquiry(),
    ];

    void _onItemTapped(int index) {
      _selectedIndex.value = index;
    }

    Future<void> _initCounter() async {
      final counterStr = await storage.read(key: 'count');
      print(counterStr);
      ref.read(counterProvider.notifier).state = int.tryParse(counterStr ?? '0') ?? 0;
      print(ref.read(counterProvider.notifier).toString());
    }

    useEffect(() {
      _initCounter();
    }, []);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sample App'),
        ),
        body: _widgetOptions.elementAt(_selectedIndex.value),
        bottomNavigationBar: BottomNavigationBar(
          items: const<BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted),
              label: '注文照会',
            ),
          ],
          currentIndex: _selectedIndex.value,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}