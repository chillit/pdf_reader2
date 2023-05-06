import 'package:http/http.dart' as http;

Future<String> convertPdfToText(String url, String apiKey) async {
  var response = await http.post(
    Uri.parse('https://api.cloudmersive.com/convert/pdf/to/text'),
    headers: {
      'Content-Type': 'application/json',
      'Apikey': apiKey,
    },
    body: '{"InputUrl": "$url"}',
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to convert PDF to text');
  }
}