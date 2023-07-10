import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';

String htmlToPlainText(String htmlString) {
  final unescape = HtmlUnescape();
  final text = unescape.convert(htmlString);
  return text;
}

String formatDate(String dateString) {
  final inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
  final outputFormat = DateFormat('d MMMM yyyy', 'it_IT');
  final date = inputFormat.parse(dateString);
  final formattedDate = outputFormat.format(date);
  return formattedDate;
}
