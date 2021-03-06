import org.gicentre.geomap.*;
import java.util.*;
GeoMap geoMap = new GeoMap(650,20,500,350,this);

int TIME, line_TIME, pie_TIME, map_TIME;
String PARTY, STATE, STATE_MAP;
HashMap<String, Integer> time_to_int;
Parser p;
Map map;
Pie pie_chart;
Line_Chart lc;
Candidate can;
boolean loop, selected_mode;
int count; //for the loop rate
int can_hover;

void setup(){
  frameRate(10);
  size(1200,800);
  TIME = 8;
  PARTY = "ALL_PARTY";
  STATE = "ALL_STATE";
  p = new Parser("./data.csv");
  map = new Map(geoMap);
  pie_chart = new Pie(p);
  lc = new Line_Chart(p);
  can = null;
  loop = false;
  selected_mode = false;
  count = 0;
}

void draw(){
  fill(50);
  noStroke();
  rect(0, 0, width, height);
  map.draw();
  pie_chart.draw();
  lc.draw();
  fill(50);
  noStroke();
  rect(1100,740,80,30);
  fill(200);
  text("see the trend",1100,750);
  if (loop == true) {
    PARTY = "ALL_PARTY";
    STATE = "ALL_STATE";
    STATE_MAP = "";
    can = null;
    selected_mode = false;
    lc.reset();
    if (count <= 80) {
      TIME = count/10;
      count++;
    } else {
      count = 0;
      loop = false;
    }
  }
  can_hover = lc.hover_button();
  can_hover = can_hover == -1 ? pie_chart.hover() : can_hover;
}


void mouseClicked(){
  if(mouseButton == LEFT){
    can = pie_chart.clicked();
    selected_mode = lc.clicked();
    if (selected_mode) can = null;
    TIME = lc.click_time();
    if(can != null){
      PARTY = can.party;
      STATE = can.state;
      STATE_MAP = "";
    }
    else if (mouseX >= 1100 && mouseX <= 1180 && mouseY >= 740 && mouseY <= 770) {
      loop = true;
      TIME = 0;
      line_TIME = 8;
      PARTY = "ALL_PARTY";
      STATE = "ALL_STATE";
      STATE_MAP = "";
      can = null;
      selected_mode = false;
      lc.reset();
    }
    //get the clicked candidate from pie chart
    else if (map.clicked() != null){
      selected_mode = false;
      lc.reset();
      STATE = map.clicked();
      STATE_MAP = map.clicked();
      PARTY = "ALL_PARTY";
    }
    else if (map.clicked() == null){
      //selected_mode = false;
      STATE = "ALL_STATE";
      PARTY = "ALL_PARTY";
      STATE_MAP = "";
      //lc.reset();
    }
  }else if (mouseButton == RIGHT){
    reset();
  }
}

void reset(){
  PARTY = "ALL_PARTY";
  STATE = "ALL_STATE";
  STATE_MAP = "";
  can = null;
  TIME = 8;
  count = 0;
  loop = false;
  selected_mode = false;
  lc.reset();
}