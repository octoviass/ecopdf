import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/pdf_cache_manager.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class PdfEditorScreen extends StatefulWidget {
  final String url;
  const PdfEditorScreen(
      {super.key,
      this.url = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'});

  @override
  PdfEditorScreenState createState() => PdfEditorScreenState();
}

class PdfEditorScreenState extends State<PdfEditorScreen> {
  final PdfViewerController _pdfController = PdfViewerController();
  final TextEditingController _textController = TextEditingController();
  final PdfCacheManager _pdfCacheManager = PdfCacheManager();
  double _fontSize = 16.0;
  Color _fontColor = Colors.black;
  String _fontFamily = 'Roboto';
  List<TextAnnotation> textAnnotations = [];
  bool _isLoading = true;
  late Uint8List _pdfData;

  Future<void> loadPdf() async {
    final cachedPdf = await _pdfCacheManager.loadPdf(widget.url.hashCode.toString());
    if (cachedPdf != null) {
      _pdfData = cachedPdf;
    } else {
      final response = await http.get(Uri.parse(widget.url));
      _pdfData = response.bodyBytes;
      await _pdfCacheManager.savePdf(_pdfData, widget.url.hashCode.toString());
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  List<String> fontFamilies = ['Roboto', 'Arial', 'Times New Roman'];
  Future<void> loadFontFamilies() async {
    final fontLoader = FontLoader(_fontFamily);
    await fontLoader.load();
    setState(() {});
  }

  void addTextAnnotation(String text) {
    setState(() {
      textAnnotations.add(TextAnnotation(
          text: text,
          position: Offset(MediaQuery.of(context).size.width / 2 - 50,
              MediaQuery.of(context).size.height / 2 - 25),
          fontSize: _fontSize,
          fontColor: _fontColor,
          fontFamily: _fontFamily));
      _textController.clear();
    });
  }

  void changeFontSize(double newSize) {
    setState(() {
      _fontSize = newSize;
    });
  }

  void changeFontColor(Color newColor) {
    setState(() {
      _fontColor = newColor;
    });
  }

  void changeFontFamily(String newFont) {
    setState(() {
      _fontFamily = newFont;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[800]!
        : Colors.white;
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Editor'),
        backgroundColor: backgroundColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Container(
        color: backgroundColor,
        child: Stack(
          children: [
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SfPdfViewer.memory(
                    _pdfData,
                    controller: _pdfController,
                    key: UniqueKey(),
                    canShowPaginationDialog: true,
            ),
            ...textAnnotations.map((annotation) {
              return Positioned(
                left: annotation.position.dx,
                top: annotation.position.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      annotation.position += details.delta;
                    });
                  },
                  child: Text(
                    annotation.text,
                    style: TextStyle(
                      fontSize: annotation.fontSize,
                      color: annotation.fontColor,
                      fontFamily: annotation.fontFamily,
                    ),
                  ),
                ),
              );
            }),
            Positioned(
                bottom: 10,
                left: 20,
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(hintText: "Text to add",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(onPressed: () {
                        if(_textController.text.isNotEmpty) {
                          addTextAnnotation(_textController.text);
                        } else {
                          print("Empty text");
                        }

                      }, icon: Icon(Icons.add))) ,
                )),
            Positioned(
              bottom: 10,
              left: 190,
              child: DropdownButton<double>(
                value: _fontSize,
                items: <double>[12, 14, 16, 18, 20, 24]
                    .map<DropdownMenuItem<double>>((double value) {
                  return DropdownMenuItem<double>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (double? newValue) {
                  if (newValue != null) {
                    changeFontSize(newValue);
                  }
                },
              ),
            ),
            Positioned(
                bottom: 10,
                left: 300,
                child: ElevatedButton(
                    onPressed: () {
                      changeFontColor(_fontColor == Colors.red
                          ? Colors.red
                          : Colors.black);
                    },
                    child: Text("Color"))),
            Positioned(
              bottom: 10,
              left: 350,
              child: DropdownButton<String>(
                value: _fontFamily,
                items: fontFamilies
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    changeFontFamily(newValue);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    _textController.dispose();
    super.dispose();
  }
}

class TextAnnotation {
  String text;
  Offset position;
  double fontSize;
  Color fontColor;
  String fontFamily;
  TextAnnotation(
      {required this.text,
      required this.position,
      required this.fontSize,
      required this.fontColor,
      required this.fontFamily});
}
