import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/models/tag_model.dart';

class MultiChipForPostMiniTags extends StatefulWidget {
  MultiChipForPostMiniTags({
    this.list,
  });

  final List<TagModel> list;
  @override
  _MultiChipForPostMiniTagsState createState() =>
      _MultiChipForPostMiniTagsState();
}

class _MultiChipForPostMiniTagsState extends State<MultiChipForPostMiniTags> {
  // this function will build and return the choice list
  _buildChoiceList() {
    List<Widget> choices = [];
    widget.list.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          margin: const EdgeInsets.all(1.0),
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color:
                item.tagTypeId == 4.0 ? Colors.yellowAccent : Colors.grey[300],
            border: Border.all(color: Colors.grey[300]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(item.name),
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
