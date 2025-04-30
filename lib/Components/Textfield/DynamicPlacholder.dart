import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'CustomSearchBar.dart';
import 'CustomTextField.dart';

class DynamicPlaceholderTextField extends StatefulWidget {
  final List<String> searchTerms;
  final Function(String?)? onChanged;
  final bool? searchIcon;
  final TextEditingController? textEditingController;

  const DynamicPlaceholderTextField(
      {required this.searchTerms,
      super.key,
      this.onChanged,
      this.textEditingController,
      this.searchIcon = false});

  @override
  _DynamicPlaceholderTextFieldState createState() =>
      _DynamicPlaceholderTextFieldState();
}

class _DynamicPlaceholderTextFieldState
    extends State<DynamicPlaceholderTextField> {
  int currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startPlaceholderRotation();
  }

  void _startPlaceholderRotation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % widget.searchTerms.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchIcon!
        ? CustomSearchBox(
            placeHolderName: "Search by ${widget.searchTerms[currentIndex]}",
            onTextChanged: widget.onChanged!,textEditingController: widget.textEditingController)
        : CustomTextField(
            name: 'searchField',
            placeHolder: "Search by ${widget.searchTerms[currentIndex]}",
            onChanged: widget.onChanged,
            textEditingController: widget.textEditingController,
          );
  }
}
