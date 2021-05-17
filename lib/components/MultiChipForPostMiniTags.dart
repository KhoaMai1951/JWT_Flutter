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
    widget.list.forEach((item) {
      return Text(item.name);
    });
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
