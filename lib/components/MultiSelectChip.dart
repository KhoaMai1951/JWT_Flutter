import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/models/TagModel.dart';

class MultiSelectChip extends StatefulWidget {
  // constructor
  //MultiSelectChip({this.reportList, this.onSelectionChanged});
  MultiSelectChip({this.list, this.onSelectionChanged});
  final List<TagModel> list;
  final Function(List<TagModel>, int) onSelectionChanged;
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<TagModel> selectedChoices = [];
  int maxCounter = 0;
  // this function will build and return the choice list
  _buildChoiceList() {
    List<Widget> choices = [];
    widget.list.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item.tagName),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              // if array of choices < 3 parameters, then allow add more or delete already existing ones
              if (selectedChoices.length < 3) {
                selectedChoices.contains(item)
                    ? selectedChoices.remove(item)
                    : selectedChoices.add(item);
                maxCounter = selectedChoices.length;
                widget.onSelectionChanged(selectedChoices, maxCounter);
              }
              // if array of choices >= 3 parameters, then allow only delete already existing ones
              else {
                if (selectedChoices.contains(item)) {
                  selectedChoices.remove(item);
                  maxCounter = selectedChoices.length;
                  widget.onSelectionChanged(selectedChoices, maxCounter);
                }
              }
            });
          },
        ),
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
