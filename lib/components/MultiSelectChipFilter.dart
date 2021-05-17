import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/models/tag_model.dart';

class MultiSelectChipFilter extends StatefulWidget {
  MultiSelectChipFilter({
    this.list,
    this.selectedChoices,
    this.onSelectionChanged,
    this.selectLimit,
  });
  final selectedChoices;
  final List<TagModel> list;
  final Function(List, int) onSelectionChanged;
  final selectLimit;
  @override
  _MultiSelectChipFilterState createState() => _MultiSelectChipFilterState();
}

class _MultiSelectChipFilterState extends State<MultiSelectChipFilter> {
  int maxCounter = 0;
  // this function will build and return the choice list
  _buildChoiceList() {
    List<Widget> choices = [];
    widget.list.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: Text(item.name),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Wrap(
        children: _buildChoiceList(),
      ),
    );
  }
}
