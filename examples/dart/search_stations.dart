import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final uri = Uri.https('ladepreis.app', '/api/v1/stations', {
    'city': 'Hamm',
    'only_available': 'true',
    'min_power_kw': '50',
    'limit': '10',
  });
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 15);

  try {
    final request = await client.getUrl(uri);
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');
    request.headers.set(
      HttpHeaders.userAgentHeader,
      'ladepreis-api-example/1.0',
    );
    final response = await request.close().timeout(const Duration(seconds: 15));
    final body = await utf8.decoder.bind(response).join();

    if (response.statusCode != HttpStatus.ok) {
      final retryAfter = response.headers.value('retry-after');
      throw HttpException(
        'HTTP ${response.statusCode}'
        '${retryAfter == null ? '' : '; retry after ${retryAfter}s'}',
        uri: uri,
      );
    }

    final data = jsonDecode(body) as Map<String, dynamic>;
    for (final station in data['items'] as List<dynamic>) {
      final item = station as Map<String, dynamic>;
      final address = item['address'] as Map<String, dynamic>;
      stdout.writeln(
        '${item['name']} — ${address['postal_code']} ${address['city']}',
      );
    }
  } finally {
    client.close(force: true);
  }
}
