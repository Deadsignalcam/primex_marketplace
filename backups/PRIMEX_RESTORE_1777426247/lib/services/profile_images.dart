class ProfileImages {
  static String avatar(String name) {
    final n = name.toLowerCase();
    if (n.contains("sarah")) return "https://i.pravatar.cc/150?img=47";
    if (n.contains("mike")) return "https://i.pravatar.cc/150?img=12";
    if (n.contains("jessica")) return "https://i.pravatar.cc/150?img=32";
    if (n.contains("tools")) return "https://i.pravatar.cc/150?img=15";
    if (n.contains("auto")) return "https://i.pravatar.cc/150?img=8";
    if (n.contains("jobs")) return "https://i.pravatar.cc/150?img=20";
    if (n.contains("primex")) return "https://i.pravatar.cc/150?img=3";
    return "https://i.pravatar.cc/150?img=11";
  }
}
