import 'package:flutter/material.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Represents Homepage for Navigation
class pdfviewer extends StatefulWidget {
  String title, url;

  pdfviewer(this.title, this.url);

  @override
  _pdfviewer createState() => _pdfviewer();
}

class _pdfviewer extends State<pdfviewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(COLOR_BACKGROUND),
        title: Text(widget.title),
      ),
      //TODO
      body: SfPdfViewer.network(
       widget.url,
        key: _pdfViewerKey,
        enableDoubleTapZooming: true,
      ),
    );
  }
}
