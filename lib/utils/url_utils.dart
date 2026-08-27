String? sanitizeAvatarUrl(String? url) {
  if (url == null) return null;
  if (url.startsWith('http') && !url.contains('/home/') && !url.contains('/storage/')) {
    return url; // ✅ нормальный URL
  }
  return null; // ❌ битый — сбрасываем
}