import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MultiSelectChipFilter extends StatefulWidget {
  MultiSelectChipFilter({
    this.list,
    this.selectedChoices,
    this.onSelectionChanged,
    this.selectLimit,
  });
  final selectedChoices;
  final List list;
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
        child: ChoiceChip(
          label: Text(item['name']),
          labelStyle: TextStyle(color: Colors.black),
          selected: widget.selectedChoices.contains(item),
          selectedColor: Colors.lightGreen,
          onSelected: (selected) {
            setState(() {
              // if array of choices < 3 parameters, then allow add more or delete already existing ones
              if (widget.selectedChoices.length < widget.selectLimit) {
                widget.selectedChoices.contains(item)
                    ? widget.selectedChoices.remove(item)
                    : widget.selectedChoices.add(item);
                maxCounter = widget.selectedChoices.length;
                widget.onSelectionChanged(widget.selectedChoices, maxCounter);
              }
              // if array of choices >= 3 parameters, then allow only delete already existing ones
              else {
                if (widget.selectedChoices.contains(item)) {
                  widget.selectedChoices.remove(item);
                  maxCounter = widget.selectedChoices.length;
                  widget.onSelectionChanged(widget.selectedChoices, maxCounter);
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
