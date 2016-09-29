//ZOOM SCROLL
//WORK IN PROGRESS

private float zoom = 100;
private final float zoomMin = 10;
private final float zoomMax = 2000;

//private boolean userZoomed = false;
private Point scrollLocation = new Point();
private float zoomTransX = 0, zoomTransY = 0;
private float zoomDelta = 0;
private float lastZoomDelta = 0;

void mouseWheel(MouseEvent event) {
  scrollLocation = new Point(mouseX, mouseY);
  // userZoomed = true;  //boolean if the user scrollled or not
  float e = event.getCount();


  float screenWHalf = width/2.0;
  float screenHHalf = height/2.0;

  float stepSize = 1.5;  //initial zoom step size
  zoomDelta = e * stepSize * (zoom/100.0);
  if (zoom <= zoomMin && zoomDelta>0) zoomDelta = 0;    //limit the zooms
  if (zoom >= zoomMax && zoomDelta<0) zoomDelta = 0;    //limit the zooms
  zoom -= zoomDelta;                      //increment or decrement the zoom
  zoomTransX +=  ((mouseX - screenWHalf)) * zoomDelta/100;
  zoomTransY +=  ((mouseY - screenHHalf)) * zoomDelta/100;
  lastZoomDelta += zoomDelta;              //zoom delta for decay
  if (zoom <= zoomMin) zoom = zoomMin;    //limit the zooms
  if (zoom >= zoomMax) zoom = zoomMax;    //limit the zooms
}

public void translateZoomScroll() {
  float screenWHalf = width/2.0;
  float screenHHalf = height/2.0;

  lastZoomDelta *= 0.60;    //DECAY THE DELTA
  if (abs(lastZoomDelta) <= 0.005) lastZoomDelta = 0;  //TO GET RID OF THE "TAIL"
  zoom -= (lastZoomDelta);      //increment zoom by the decayed "momentum" value
  if (zoom <= zoomMin) zoom = zoomMin;  //limit zoom by bounds
  if (zoom >= zoomMax) zoom = zoomMax;
  zoomTransX += (scrollLocation.x - screenWHalf)  * (lastZoomDelta/ 100.0);
  zoomTransY +=  (scrollLocation.y - screenHHalf)  * (lastZoomDelta/ 100.0);

  translate(zoomTransX + panXY.x, zoomTransY + panXY.y);  //ZOOM INTO CURSOR
  scale(zoom/100.0);    //matrix SCALE/ZOOM
}