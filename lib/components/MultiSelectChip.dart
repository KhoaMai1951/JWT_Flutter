import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MultiSelectChip extends StatefulWidget {
  // constructor
  //MultiSelectChip({this.reportList, this.onSelectionChanged});
  MultiSelectChip({this.list, this.onSelectionChanged, this.selectLimit});
  final List list;
  final Function(List, int) onSelectionChanged;
  final selectLimit;
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List selectedChoices = [];
  int maxCounter = 0;
  Color _color = Colors.grey;
  // this function will build and return the choice list
  _buildChoiceList() {
    List<Widget> choices = [];
    widget.list.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item['name']),
          labelStyle: TextStyle(color: Colors.black),
          selected: selectedChoices.contains(item),
          selectedColor: Colors.lightGreen,
          onSelected: (selected) {
            setState(() {
              _color = selected ? Colors.lightGreen : Colors.grey;
              // if array of choices < 3 parameters, then allow add more or delete already existing ones
              if (selectedChoices.length < widget.selectLimit) {
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
