String fileSize(String url) {
  final exp = RegExp(r'[0-9]+(\.[0-9])?(GB|MB|gb|mb)');
  var match = exp.stringMatch(Uri.decodeComponent(url));
  return (match == null) ? 'Unknown Size' : match;
}
