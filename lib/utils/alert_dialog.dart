import 'package:flutter/material.dart';

class GlobalAlertDialog extends StatelessWidget {
  final String imagePath;
  final String title;
  final Color titleColor;
  final String message;
  final String primaryButtonText;
  final VoidCallback primaryButtonAction;
  final String secondaryButtonText;
  final VoidCallback secondaryButtonAction;

  const GlobalAlertDialog({
    required this.imagePath,
    required this.title,
    required this.titleColor,
    required this.message,
    required this.primaryButtonText,
    required this.primaryButtonAction,
    required this.secondaryButtonText,
    required this.secondaryButtonAction,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 56),
          child: Column(
            children: [
              Image.asset(imagePath, height: height / 6, fit: BoxFit.fitHeight),
              SizedBox(height: height / 30),
              Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: titleColor),
              ),
              SizedBox(height: height / 46),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: height / 26),
              InkWell(
                onTap: primaryButtonAction,
                child: Container(
                  height: height / 15,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      primaryButtonText,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height / 56),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: secondaryButtonAction,
                child: Container(
                  height: height / 15,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blue.shade100,
                  ),
                  child: Center(
                    child: Text(
                      secondaryButtonText,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Usage example
void success(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => GlobalAlertDialog(
      imagePath: 'assets/images/applysuccess.png',
      title: 'Congratulations',
      titleColor: Colors.green,
      message: 'Your application has been successfully submitted. You can track the progress of your application through the applications menu.',
      primaryButtonText: 'Go to My Applications',
      primaryButtonAction: () {
        // Navigate to applications
      },
      secondaryButtonText: 'Cancel',
      secondaryButtonAction: () {
        Navigator.pop(context);
      },
    ),
  );
}

void failed(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => GlobalAlertDialog(
      imagePath: 'assets/images/applyfail.png',
      title: 'Oops, Failed!',
      titleColor: Colors.red,
      message: 'Please check your internet connection then try again.',
      primaryButtonText: 'Try Again',
      primaryButtonAction: () {
        // Retry action
      },
      secondaryButtonText: 'Cancel',
      secondaryButtonAction: () {
        Navigator.pop(context);
      },
    ),
  );
}
