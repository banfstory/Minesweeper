import java.util.*; //<>// //<>// //<>// //<>//
final int numOfMines = 40;
final int numOfBoxesX = 16;
final int numOfBoxesY = 16;
final int totalBoxes = numOfBoxesX * numOfBoxesY;
final int winState = totalBoxes - numOfMines;
final int boardPosX = 60;
final int boardPosY = 60;
final int size = 30;
int completedBox = 0;
Box[][] board = new Box[numOfBoxesX][numOfBoxesY];
boolean end = false;

void setup() {
  size(600, 600);
  background(211, 211, 211);
  SetupBoard();
  PrintBoard(false, -1, -1);
}

void draw() {
  if (!end) {
    background(211, 211, 211);
    PrintBoard(false, -1, -1);
  }
}

void mouseClicked() {
  if (!end) {  
    int x = (mouseX-boardPosX)/size;
    int y = (mouseY-boardPosY)/size;
    if (x < numOfBoxesX && x >= 0 && y < numOfBoxesY && y >= 0) {
      if (board[x][y].state=='M') {
        end = true;
        push();
        fill(255, 0, 0);
        text("Game Over", 280, 20);
        text("Press 'r' to start over!", 250, 40);
        pop();
        PrintBoard(true, x, y);
        return;
      }
      if (board[x][y].state=='B') {
        return;
      }
      Queue<int[]> queue = new ArrayDeque();  
      queue.add(new int[]{x, y});
      while (queue.size()!=0) {
        completedBox++;
        int[] temp = queue.remove();
        Queue<int[]> subqueue = new ArrayDeque();  
        int mines = countMines(temp[0], temp[1], subqueue);
        if (mines>0) {
          board[temp[0]][temp[1]].state = str(mines).charAt(0);
          board[temp[0]][temp[1]].disable = true;
        } else {
          board[temp[0]][temp[1]].state = 'B';
          board[temp[0]][temp[1]].disable = true;
          while (subqueue.size()!=0) {       
            int[] coord = subqueue.remove();
            if (board[coord[0]][coord[1]].state=='E') {
              board[coord[0]][coord[1]].state = 'B';
              queue.add(coord);
            }
          }
        }
      }
    }
    PrintBoard(false, -1, -1);
    if (completedBox==winState) {
      text("You win!", 280, 20);
      end = true;
    }
  }
}

private int countMines(int x, int y, Queue<int[]> queue) {
  int mines = 0;
  for (int i=-1; i<=1; i++) {
    for (int j=-1; j<=1; j++) {
      if ((i==0 && j==0) || x+i<0 || x+i>=board.length || y+j<0 || y+j>=board[0].length) continue;
      if (board[x+i][y+j].state=='M') {
        mines++;
      } else {
        queue.add(new int[]{x+i, y+j});
      }
    }
  }
  return mines;
}

private void PrintBoard(boolean showMines, int highlightX, int highlightY) {
  for (int i=0; i<board.length; i++) {
    for (int j=0; j<board[i].length; j++) {
      float x = board[i][j].X;
      float y = board[i][j].Y;
      if (!board[i][j].disable) {
        push();
        stroke(0);
        strokeWeight(3);
        if (showMines && i==highlightX && j==highlightY) {
          fill(255, 0, 0);
          square(x, y, size);
        }
        square(x, y, size);
        pop();
      } else {
        push();
        stroke(0);
        strokeWeight(1);
        square(x, y, size);
        pop();
      }
      if (showMines && board[i][j].state == 'M') {
        push();
        fill(0);
        text(board[i][j].state, x+(size/2-4), y+(size/2+4));
        pop();
      }
      if (Character.isDigit(board[i][j].state)) {
        NumColorCode(board[i][j].state, i, j, x, y);
      }
    }
  }
}

void keyPressed() {
  if (end) {
    if (key==114) {
      reset();
    }
  }
}

private void reset() {
  SetupBoard();
  PrintBoard(false, -1, -1);
  completedBox = 0;
  end = false;
}

private void SetupBoard() {
  for (int i=0; i<board.length; i++) {
    for (int j=0; j<board[i].length; j++) {
      board[i][j] = new Box(i*size+boardPosX, j*size+boardPosY);
    }
  }
  HashMap<Integer, HashSet<Integer>> mines = new HashMap<Integer, HashSet<Integer>>();
  int count = 0; 
  while (count < numOfMines) {
    Integer x = (int)random(0, numOfBoxesX-1);
    Integer y = (int)random(0, numOfBoxesY-1);
    if (!(mines.containsKey(x) && mines.get(x).contains(y))) {
      if (!mines.containsKey(x)) {
        mines.put(x, new HashSet<Integer>());
      }
      mines.get(x).add(y);
      board[x][y].state='M';
      count++;
    }
  }
}

private void NumColorCode(char c, int i, int j, float x, float y) {
  switch(c) {
  case '1':
    push();
    fill(0, 0, 255);
    text(board[i][j].state, x+(size/2-3), y+(size/2+4));
    pop();
    break;
  case '2':
    push();
    fill(9, 89, 9);
    text(board[i][j].state, x+(size/2-3), y+(size/2+4));
    pop();
    break;
  case '3':
    push();
    fill(255, 0, 0);
    text(board[i][j].state, x+(size/2-3), y+(size/2+4));
    pop();
    break;
  default:
    push();
    fill(3, 18, 43);
    text(board[i][j].state, x+(size/2-3), y+(size/2+4));
    pop();
    break;
  }
}
