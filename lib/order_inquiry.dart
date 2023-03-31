import 'package:flutter/material.dart';
import 'package:flutter_study_tiger/App.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderInquiry extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('riverpod を体感する'),
          Text('${ref.watch(counterProvider)}')
        ],
      )
    );
  }
}