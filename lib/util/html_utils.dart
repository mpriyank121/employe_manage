class HtmlUtils {
  // Generates checkbox HTML with checked state
  static String checkbox(String label, {bool checked = false}) {
    return '<label>'
        '<input type="checkbox" ${checked ? "checked" : ""}> $label'
        '</label><br>';
  }

  // Adds an image tag
  static String image(String url, {String alt = 'Image'}) {
    return '<img src="$url" alt="$alt" style="max-width:100%;"><br>';
  }

  // Wrap plain text as HTML paragraph
  static String paragraph(String text) {
    return '<p>$text</p>';
  }

  // Compose full HTML content
  static String buildHtml({
    List<String> elements = const [],
  }) {
    return elements.join('\n');
  }

  // For display: Replace checkboxes with emoji equivalents
  static String prepareForDisplay(String html) {
    return html
        .replaceAllMapped(RegExp(r'<input type="checkbox"(.*?)checked(.*?)>'), (_) => '☑️')
        .replaceAll(RegExp(r'<input type="checkbox"(.*?)>'), '☐');
  }
}
