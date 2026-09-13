import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import 'ingestService.dart';
import '../../models/book.dart';
import '../../models/chunk.dart';

// Only file that knows the request format and response shape.
// Endpoint URL comes from AppConfig, not passed in — it's static,
// so callers shouldn't have to supply it every time.
// Sends the PDF as multipart/form-data (raw bytes, not base64) since this
// is talking to our own backend, not an AI API directly.
class HttpIngestService implements IngestService {
  static const _requestTimeout = Duration(minutes: 10);

  @override
  Future<Book> ingest(Uint8List pdfBytes) async {
    debugPrint('POST ${AppConfig.runBookEndpoint} (${pdfBytes.length} bytes)');
    final request = http.MultipartRequest('POST', AppConfig.runBookEndpoint)
      ..files.add(
        http.MultipartFile.fromBytes('file', pdfBytes, filename: 'upload.pdf'),
      );

    final streamed = await request.send().timeout(_requestTimeout);
    final response = await http.Response.fromStream(
      streamed,
    ).timeout(_requestTimeout);
    debugPrint('Ingest response: ${response.statusCode}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Ingest failed: ${response.statusCode} ${response.body}');
    }

    final json = jsonDecode(response.body);
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Backend returned a non-object response');
    }
    if (json['ok'] != true) {
      throw Exception(json['error'] ?? 'Backend rejected the upload');
    }

    return _bookFromResult(json['result']);
  }

  Book _bookFromResult(dynamic result) {
    final resultMap = result is Map
        ? Map<String, dynamic>.from(result)
        : <String, dynamic>{};
    final book = resultMap['book'];
    final source = book is Map ? Map<String, dynamic>.from(book) : resultMap;
    final chunks = _chunksFrom(source.isEmpty ? result : source);
    if (chunks.isEmpty) {
      throw const FormatException(
        'Backend returned no readable chapter pieces',
      );
    }

    return Book(
      id:
          source['id']?.toString() ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title:
          source['title']?.toString() ??
          source['book_title']?.toString() ??
          'Uploaded book',
      chunks: chunks,
    );
  }

  List<Chunk> _chunksFrom(dynamic value, {String? chapterTitle}) {
    if (value is String && value.trim().isNotEmpty) {
      return [Chunk(title: chapterTitle ?? 'Untitled chapter', content: value)];
    }
    if (value is List) {
      return value
          .expand((item) => _chunksFrom(item, chapterTitle: chapterTitle))
          .toList();
    }
    if (value is! Map) return const [];

    final map = Map<String, dynamic>.from(value);
    for (final key in const [
      'chunks',
      'pieces',
      'reader_pieces',
      'chapters',
      'processed_chapters',
      'sections',
    ]) {
      final nested = map[key];
      if (nested is List) {
        final chunks = nested
            .expand(
              (item) => _chunksFrom(
                item,
                chapterTitle:
                    map['title']?.toString() ??
                    map['chapter_title']?.toString() ??
                    chapterTitle,
              ),
            )
            .toList();
        if (chunks.isNotEmpty) return chunks;
      }
    }

    final content =
        map['content'] ?? map['text'] ?? map['markdown'] ?? map['piece'];
    if (content != null && content.toString().trim().isNotEmpty) {
      // Extract possible AI explanation key variants from backend payload
      final explanation =
          map['aiExplanation'] ??
          map['ai_explanation'] ??
          map['explanation'] ??
          map['ai_summary'];

      return [
        Chunk(
          title:
              map['title']?.toString() ??
              map['chapter_title']?.toString() ??
              chapterTitle ??
              'Untitled chapter',
          content: content.toString(),
          aiExplanation: explanation?.toString(),
        ),
      ];
    }
    return const [];
  }
}
