import 'dart:convert';

import 'package:finmind/features/products/domain/entities/product_import_row.dart';

class CsvImportUtils {
  static const _headers = <String>[
    'name',
    'sellingPrice',
    'costPrice',
    'openingQty',
    'minimumStockQty',
    'unitOfMeasure',
    'sku',
  ];

  static List<ProductImportRow> parseCsv(String csvContent) {
    var content = csvContent.trim();
    if (content.isEmpty) return <ProductImportRow>[];

    if (content.codeUnitAt(0) == 0xFEFF) {
      content = content.substring(1);
    }

    final lines = const LineSplitter().convert(content);
    if (lines.isEmpty) return <ProductImportRow>[];

    final headerLine = lines.first.replaceAll('\r', '');
    final headers = headerLine.split(',').map((h) => h.trim()).toList();

    final rows = <ProductImportRow>[];
    for (var i = 1; i < lines.length; i++) {
      final line = lines[i].replaceAll('\r', '');
      if (line.trim().isEmpty) continue;

      final values = _splitCsvLine(line);
      final row = _mapValuesToRow(headers, values);
      if (row != null) {
        rows.add(row);
      }
    }
    return rows;
  }

  static String generateCsv(List<ProductImportRow> rows) {
    final buffer = StringBuffer();
    buffer.writeln(_headers.join(','));

    for (final row in rows) {
      final values = <String>[
        _escapeCsvValue(row.name),
        _escapeCsvValue(row.sellingPrice),
        _escapeCsvValue(row.costPrice),
        _escapeCsvValue(row.openingQty),
        _escapeCsvValue(row.minimumStockQty),
        _escapeCsvValue(row.unitOfMeasure),
        _escapeCsvValue(row.sku),
      ];
      buffer.writeln(values.join(','));
    }

    return buffer.toString();
  }

  static List<String> _splitCsvLine(String line) {
    final values = <String>[];
    final buffer = StringBuffer();
    bool inQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          buffer.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        values.add(buffer.toString().trim());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }
    values.add(buffer.toString().trim());
    return values;
  }

  static String _escapeCsvValue(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  static ProductImportRow? _mapValuesToRow(List<String> headers, List<String> values) {
    if (headers.isEmpty) return null;

    final map = <String, String>{};
    for (var i = 0; i < headers.length; i++) {
      final value = i < values.length ? values[i] : '';
      map[headers[i]] = value;
    }

    return ProductImportRow(
      name: map['name'] ?? '',
      sellingPrice: map['sellingPrice'] ?? '',
      costPrice: map['costPrice'] ?? '',
      openingQty: map['openingQty'] ?? '',
      minimumStockQty: map['minimumStockQty'] ?? '',
      unitOfMeasure: map['unitOfMeasure'] ?? 'piece',
      sku: map['sku'] ?? '',
    );
  }
}
