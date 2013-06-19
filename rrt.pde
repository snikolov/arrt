import processing.pdf.*;
import megamu.mesh.*;

void setup() {
  size(3500, 3500);
  strokeJoin(MITER);
  stroke(0);
  fill(0);
  background(255);
  smooth();

  float scl = 0.975;
  float eps = 0.8;
  
  boolean showTree = false;
  boolean showPoints = true;
  boolean showVoronoiBoundaries = true;
  boolean showVoronoiRegions = false;

  int N = 5000;
  float[][] points = new float[N][2];

  translate(width / 2, height / 2);

  for (int i = 0; i < N; i += 1) {

    float pxRand = random(width * scl) - width * scl / 2.0;
    float pyRand = random(height * scl) - height * scl / 2.0;

    // boolean acceptSample = acceptSampleCircle(px, py, 0.5 * width * scl);
    // boolean acceptSample = acceptSampleRect(px, py, width * scl, 0.5 * width * scl);
    boolean acceptSample = true;
  
    if (!acceptSample) {
      i -= 1;
      continue;
    }

    strokeWeight(width / 1500.0);

    float px, py;
    
    if (i > 0) {
      float[] pClosest = findClosest(points, i, pxRand, pyRand);
      px = pClosest[0] + eps * (pxRand - pClosest[0]);
      py = pClosest[1] + eps * (pyRand - pClosest[1]);
      // println("proposal: " + pxRand + "," + pyRand);
      // println("closest: " + pClosest[0] + "," + pClosest[1]);
      // println("new: " + px + "," + py);
      if (showTree) {
        line(px, py, pClosest[0], pClosest[1]);
      }
    } else {
      px = pxRand;
      py = pyRand;
    }
    
    points[i][0] = px;
    points[i][1] = py;
    
    if (showPoints) {
      float opacity = 125 - 75 * exp(- 2 * i / 2500.0);
      // fill(random(255), 0, random(255), opacity);
      fill(100 + random(155), 100 + random(155), 100 + random(155), opacity);
      // fill(0, opacity);
      float psize = (20 * width / 800.0) * exp(- 2 * i / 2500.0);
      ellipse(px, py, psize, psize);
      fill(0);
      ellipse(px, py, 1.5, 1.5);
    }

    /*
    if (i % 25 == 0) {
     float[][] pointsSoFar = new float[i+1][2];
     for (int j = 0; j <= i; j++) {
     pointsSoFar[j][0] = points[j][0];
     pointsSoFar[j][1] = points[j][1];
     }
     
     Voronoi myVoronoi = new Voronoi(pointsSoFar);
     
     float[][] vEdges = myVoronoi.getEdges();
     MPolygon[] myRegions = myVoronoi.getRegions();
     
     // Regions
     if (showVoronoiRegions) {
     
     for(int j=0; j<myRegions.length; j++)
     {
     fill(random(255), 0, random(255), 30);
     myRegions[j].draw(this); // draw this shape
     }
     }
     
     // Boundaries
     stroke(255 - 255 * (float) i / N);
     
     if (showVoronoiBoundaries) {
     for (int j=0; j < vEdges.length; j++) {
     float startX = vEdges[j][0];
     float startY = vEdges[j][1];
     float endX = vEdges[j][2];
     float endY = vEdges[j][3];
     // Prune edges
     if (pow(startX, 2) + pow(startY, 2) > pow(0.5 * width * scl, 2)) {
     continue;
     }
     if (pow(endX, 2) + pow(endY, 2) > pow(0.5 * width * scl, 2)) {
     continue;
     }
     line(startX, startY, endX, endY);
     }
     }
     }
     */
  }

  
  int perturbIterations = 1;
   float rand = 50;
   for (int j = 0; j < perturbIterations; j++) {
   for (int k = 0; k < points.length; k++) {
   fill(0,150);
   /*
   if (showPoints) {
   ellipse(points[k][0], points[k][1], 20, 20);
   }
   */
   
   /*
   points[k][0] += 2 * random(rand) - rand;
   points[k][1] += 2 * random(rand) - rand;
   */
   }
  
   
   stroke(0);
   // stroke(255 * (float) j / perturbIterations);
   // strokeWeight(0.5 + 1 * (float) j / perturbIterations);
   //strokeWeight(0);
   
   Delaunay myVoronoi = new Delaunay(points);
   // Voronoi myVoronoi = new Voronoi(points);
   if (showVoronoiBoundaries) {
   float[][] vEdges = myVoronoi.getEdges();
   for (int i = 0; i < vEdges.length; i++) {
   float startX = vEdges[i][0];
   float startY = vEdges[i][1];
   float endX = vEdges[i][2];
   float endY = vEdges[i][3];
   // Prune edges
   // if (!(acceptSampleRect(startX, startY, width * scl, 0.5 * width * scl) &&
   //    acceptSampleRect(endX, endY, width * scl, 0.5 * width * scl))) {
   //  continue;
   // }
   line(startX, startY, endX, endY);
   }
   }
   
   /*
   MPolygon[] myRegions = myVoronoi.getRegions();

   // Regions
   if (showVoronoiRegions) {

   for(int k=0; k<myRegions.length; k++)
   {
   fill(random(255), 200);
   myRegions[k].draw(this); // draw this shape
   }
   }
   */
   } 

  save("rrt.png");
}

boolean acceptSampleCircle(float px, float py, float radius) {
  return (pow(px, 2) + pow(py, 2) < pow(radius, 2));
}

boolean acceptSampleRect(float px, float py, float w, float h) {
  return abs(px) < w / 2 && abs(py) < h / 2;
}

float[] findClosest(float[][] points, int stopIndex, float px, float py) {
  float[] closest = new float[2];
  float minDist = 999999;
  int minIndex = -1;
  for (int i = 0; i < min(points.length, stopIndex); i += 1) {
    float dist0 = sqrt(pow((px - points[i][0]), 2) + pow((py - points[i][1]), 2));
    if (dist0 < minDist && dist0 != 0) {
      minDist = dist0;
      minIndex = i;
    }
  }
  closest[0] = points[minIndex][0];
  closest[1] = points[minIndex][1];
  return closest;
}

