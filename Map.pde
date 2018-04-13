class Map{
  HashMap<String, Integer> stateid;
  HashMap<Integer, Float> statefunding;
  GeoMap geoMap;
  Map(GeoMap geoMap){
    stateid = new HashMap<String, Integer>();
    this.geoMap = geoMap; 
    geoMap.readFile("usContinental");   // Read shapefile.
    for (int id = 1; id < 52; id++) {
      stateid.put(geoMap.getAttributeTable().findRow(str(id),0).getString("Abbrev"), id);
    }
  }
  
  void arrange(int month){
    statefunding = new HashMap<Integer, Float>();
    for (int i = 0; i < p.candidates.length; i++){
      for (int j = 0; j <= month; j++) {
        int stateid = this.stateid.get(p.candidates[i].state);
        if (statefunding.containsKey(stateid)) 
          statefunding.put(stateid,statefunding.get(stateid) + p.candidates[i].funding[j]);
        else statefunding.put(stateid, p.candidates[i].funding[j]);
      }
    }
  }

  void draw(){
    stroke(200);               // Boundary colour
    arrange(TIME); // init the statefunding based on the parameter "month"
    // draw the states that appear in the data in specific color based on the amount of funding
    for (int i = 1; i < 52; i++) {
        if (statefunding.containsKey(i)) fill(select_color(statefunding.get(i)));
        else fill(210);
        strokeWeight(1);
        geoMap.draw(i);
      }
    
    if (can_hover != -1){
      int sid = stateid.get(p.candidates[can_hover].state);
      stroke(#6a95f2);
      strokeWeight(2);
      geoMap.draw(sid);
      strokeWeight(1);
    }
    
    if (can != null){
      Set<Integer> states = new HashSet<Integer>();
      for (int i = 0; i < p.candidates.length; i++) {
        if (p.candidates[i].party.equals(PARTY)) states.add(stateid.get(p.candidates[i].state));
      }
      for (Integer state: states){
        fill(select_color(statefunding.get(state)));
        stroke(#6a95f2);
        strokeWeight(2);
        geoMap.draw(state);
        strokeWeight(1);
      }
    }
    
    //for selected state in the map
    if (!STATE.equals("ALL_STATE")) {
      for (int i = 1; i < 52; i++) {
        if (!statefunding.containsKey(i)) {
          stroke(200);
          fill(210);
          strokeWeight(1);
          geoMap.draw(i);
        }
        else {
          if (!geoMap.getAttributeTable().findRow(str(i),0).getString("Abbrev").equals(STATE)) {
            fill(select_color(statefunding.get(i)));
            stroke(200);
            strokeWeight(1);
            geoMap.draw(i);
          }
          else {
            fill(select_color(statefunding.get(i)));
            stroke(#6a95f2);
            strokeWeight(2);
            geoMap.draw(i);
          }
        }
      }
    }
    //Find the country at mouse position and draw in different colour.
    int id = geoMap.getID(mouseX, mouseY);
    if (id != -1) {
      if (statefunding.containsKey(id)) {
        strokeWeight(5);
        stroke(select_color(statefunding.get(id)));
        fill(select_color(statefunding.get(id)));
      }
      else fill(220);
      geoMap.draw(id);
      strokeWeight(1);
      // get the state name using id.
      String name = geoMap.getAttributeTable().findRow(str(id),0).getString("Abbrev"); 
      fill(255);
      textSize(12);
      text(name, mouseX+5, mouseY-5);
      if (statefunding.containsKey(id)){
        Float funding = statefunding.get(id)/1000000;
        text("$"+funding+"M", mouseX+5, mouseY+10);
      }
    }
  }
  
  color select_color(float funding){
    color c = color(255,int(255-funding/3770000),int(255-funding/1800000));
    return c;
  }
  String clicked(){
    int id = geoMap.getID(mouseX, mouseY);
    if (id != -1 && statefunding.containsKey(id)){
      return geoMap.getAttributeTable().findRow(str(id),0).getString("Abbrev");
    }
    else return null;
  }
}
 