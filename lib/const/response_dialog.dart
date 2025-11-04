import 'package:flutter/material.dart';

class ResponseDialog extends StatelessWidget {
  final String title;
  final String msg;
  final String buttonText;
  final String? buttonText2;
  final int popTimes;
  final String? refreshKey;
  final Color? dlgClr;
  final VoidCallback? onPressed1;

  const ResponseDialog({
    super.key,
    required this.title,
    required this.msg,
    required this.buttonText,
    this.buttonText2,
    required this.popTimes,
    this.refreshKey,
    this.dlgClr,
    this.onPressed1,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      actionsPadding: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: dlgClr ?? Colors.blue,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: mq.height * 0.02,
              color: Colors.white,
            ),
          ),
        ),
      ),
      content: Text(
        msg,
        style: TextStyle(fontSize: mq.height * 0.018),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: buttonText2 != null
              ? MainAxisAlignment.spaceEvenly
              : MainAxisAlignment.center,
          children: [
            if (buttonText2 != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: dlgClr ?? Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: onPressed1,
                child: Text(
                  buttonText2!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: mq.height * 0.02,
                  ),
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: dlgClr ?? Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                for (int i = 0; i < popTimes; i++) {
                  Navigator.pop(context, refreshKey ?? '');
                }
              },
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: mq.height * 0.02,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
