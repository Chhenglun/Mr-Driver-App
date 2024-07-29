class Document {
  String docTitle;
  String docUrl;
  String docDate;
  String pageNum;

  Document({
    required this.docTitle,
    required this.docUrl,
    required this.docDate,
    required this.pageNum,
  });

  static List<Document> docList = [
    Document(
      docTitle: 'Document 1',
      docUrl: 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
      docDate: '2022-10-10',
      pageNum: '10',
    ),
    Document(
      docTitle: 'Document 2',
      docUrl: 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
      docDate: '2022-10-10',
      pageNum: '10',
    ),
    Document(
      docTitle: 'Document 3',
      docUrl: 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
      docDate: '2022-10-10',
      pageNum: '10',
    ),
    Document(
      docTitle: 'Document 4',
      docUrl: 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
      docDate: '2022-10-10',
      pageNum: '10',
    ),
    Document(
      docTitle: 'Document 5',
      docUrl: 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
      docDate: '2022-10-10',
      pageNum: '10',
    ),
    Document(
      docTitle: 'Document 6',
      docUrl: 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
      docDate: '2022-10-10',
      pageNum: '10',
    ),
  ];
}
