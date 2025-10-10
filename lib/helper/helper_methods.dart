bool isWhite(index) {
  int x = index ~/ 8;
  int y = index % 8;

  if ((x + y) % 2 == 0) {
    return true;
  } else {
    return false;
  }
}

bool isInBoard(int row, int col) {
  return row >= 0 && row < 8 && col >= 0 && col < 8;
}

List<String> columnLabels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
List<String> rowLabels = ['8', '7', '6', '5', '4', '3', '2', '1'];