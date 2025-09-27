bool isWhite(index) {
  int x = index ~/ 8;
  int y = index % 8;

  if ((x + y) % 2 == 0) {
    return true;
  } else {
    return false;
  }
}
