int size = 10;
boolean[][] data = new boolean[size][size];
String[] data_text = new String[size];
boolean[][] userData = new boolean[size][size];
boolean edit_mode = true;

void setup() {
   size(800, 500);
   background(200);
   for(int i = 0; i < size; i++) for(int j = 0; j < size; j++){
      data[i][j] = false;
      userData[i][j] = false;
   }
   for(int i = 0; i < size; i++) for (int j = 0; j < size; j++) if (i<=j) data[i][j] = true;
   // for(int i = 0; i < size; i++) data[i][i] = true; // fillData()

      setupData();
}

void setupData() {
   for(int i = 0; i < size; i++) {
      data_text[i] = "";
      boolean flag = false;
      int acc = 0;
      for (int j = 0; j < size; j++) {
         if (data[j][i]) {
            if (flag) {
               acc++;
            } else {
               flag = true;
               acc++;
            }
         } else if (flag) {
            flag = false;
            if (data_text[i].length() != 0) data_text[i]+='-';
            data_text[i]+=Integer.toString(acc);
            acc = 0;
         }
      }
      if (flag) {
         if (data_text[i].length() != 0) data_text[i]+='-';
         data_text[i]+=Integer.toString(acc);
      }
      if (data_text[i].equals("")) data_text[i] += "0";
   }
}
// 75% width is box, 25% is data
// 90% height is box, 10% is data


void draw() {
   //background(100);

   drawPanel();
   if (edit_mode) {
      fill(50, 255, 0);
      rect(0.01*width, 0.01*height, 0.23*width, 0.075*height);
      textAlign(CENTER, TOP);
      textSize(height*0.06);
      fill(0);
      text("Play!", 0.01*width, 0.01*height, 0.23*width, 0.075*height); //<>// //<>//
   } else {
      fill(255, 255, 0);
      rect(0.01*width, 0.01*height, 0.23*width, 0.075*height);
      textAlign(CENTER, TOP);
      textSize(height*0.06);
      fill(0);
      text("Edit", 0.01*width, 0.01*height, 0.23*width, 0.075*height);
   }

   fill(255);
   stroke(255, 155, 0);
   rect(0.25*width, 0.1*height, 0.75*width, 0.9*height);
   drawGrid();

   noLoop();
}

void drawPanel(){
   //these are the config for data rect
   float x_off = 0.01*width;
   float y_off = 0.1*height;
   float h = (0.9*height)/size;
   float w = (0.23*width);

   stroke(255, 255, 255);
   textAlign(CENTER, CENTER);
   textSize(h*0.75); //TODO: make ths scale according to width or height
   for (int i = 0; i < size; i++) {
      if (!edit_mode && checkHorizontal(i)) fill(0, 255, 0);
      else fill(50, 150, 250);
      rect(x_off, y_off+(h*i), w, h);
      fill(0);
      text(data_text[i], 0, y_off+(h*i), w, h);
   }

   //the vertical check rects
   x_off = 0.25*width;
   y_off = 0.01*height;
   h = 0.075*height;
   w = (0.75*width)/size;
   for (int i = 0; i < size; i++) {
      if (!edit_mode && checkVertical(i)) fill(0, 255, 0);
      else fill(50, 150, 250);
      rect(x_off+(w*i), y_off, w, h);
   }
}

void drawGrid() {
   //vertical lines:
   float x_off = 0.25*width;
   float w = (0.75*width)/size;
   float y_off = 0.1*height;
   float h = 0.9*height;

   for (int i = 1; i < size; i++) {
      x_off += w;
      line(x_off, y_off, x_off, y_off+h);
   }

   //horizontal lines:
   x_off = 0.25*width;
   h = (0.9*height)/size;
   y_off = 0.1*height;
   w = 0.75*width;
   for (int i = 1; i < size; i++) {
      y_off += h;
      line(x_off, y_off, x_off+w, y_off);
   }

   x_off = 0.25*width;
   w = (0.75*width)/size;
   y_off = 0.1*height;
   h = (0.9*height)/size;

   fill(0);
   for(int i = 0; i < size; i++) for (int j = 0; j < size; j++) {
      // if (edit_mode) if (data[i][j]) {
      //    rect(x_off+(w*i), y_off+(h*j), w, h);
      // } else if (userData[i][j]) {
      //    rect(x_off+(w*i), y_off+(h*j), w, h);
      // }
      if(edit_mode && data[i][j]) rect(x_off+(w*i), y_off+(h*j), w, h);
      if(!edit_mode && userData[i][j]) rect(x_off+(w*i), y_off+(h*j), w, h);
   }
}

void mousePressed(){
   if (mouseX < 0.25*width && mouseY < 0.1*height) {
      toggleEdit();
   } else {
      float x = mouseX-0.25*width;
      float y = mouseY-0.1*height;

      if (x >= 0 && y >= 0) {
         float max_x = 0.75*width;
         float max_y = 0.9*height;

         x/=max_x;
         y/=max_y;

         if (edit_mode) {
            data[(int)Math.floor(x*size)][(int)Math.floor(y*size)] = !data[(int)Math.floor(y*size)][(int)Math.floor(y*size)];
            setupData();
         }
         else userData[(int)Math.floor(x*size)][(int)Math.floor(y*size)] = !userData[(int)Math.floor(y*size)][(int)Math.floor(y*size)];
      }
   }
   loop();
}

void toggleEdit() {
   if(edit_mode) {
      setupData();
      edit_mode = false;
      for(int i = 0; i < size; i++) for(int j = 0; j < size; j++) userData[i][j] = false;
   } else edit_mode = true;
}

boolean checkHorizontal(int line) {
   for (int i = 0; i < size; i++) {
      if (userData[i][line] != data[i][line]) return false;
   }
   return true;
}

boolean checkVertical(int line) {
   for (int i = 0; i < size; i++) {
      if (userData[line][i] != data[line][i]) return false;
   }
   return true;
}
//
