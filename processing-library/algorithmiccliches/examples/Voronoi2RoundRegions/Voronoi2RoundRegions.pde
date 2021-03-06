import de.hfkbremen.algorithmiccliches.*; 
import de.hfkbremen.algorithmiccliches.agents.*; 
import de.hfkbremen.algorithmiccliches.cellularautomata.*; 
import de.hfkbremen.algorithmiccliches.convexhull.*; 
import de.hfkbremen.algorithmiccliches.delaunaytriangulation2.*; 
import de.hfkbremen.algorithmiccliches.delaunaytriangulation2.VoronoiDiagram.Region; 
import de.hfkbremen.algorithmiccliches.exporting.*; 
import de.hfkbremen.algorithmiccliches.fluiddynamics.*; 
import de.hfkbremen.algorithmiccliches.isosurface.marchingcubes.*; 
import de.hfkbremen.algorithmiccliches.isosurface.marchingsquares.*; 
import de.hfkbremen.algorithmiccliches.laserline.*; 
import de.hfkbremen.algorithmiccliches.lindenmayersystems.*; 
import de.hfkbremen.algorithmiccliches.octree.*; 
import de.hfkbremen.algorithmiccliches.util.*; 
import de.hfkbremen.algorithmiccliches.util.ArcBall; 
import de.hfkbremen.algorithmiccliches.voronoidiagram.*; 
import oscP5.*; 
import netP5.*; 
import teilchen.*; 
import teilchen.constraint.*; 
import teilchen.force.*; 
import teilchen.behavior.*; 
import teilchen.cubicle.*; 
import teilchen.util.*; 
import teilchen.util.Vector3i; 
import teilchen.util.Util; 
import teilchen.util.Packing; 
import teilchen.util.Packing.PackingEntity; 
import de.hfkbremen.mesh.*; 
import java.util.*; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import quickhull3d.*; 
import javax.swing.*; 


final Qvoronoi mQvoronoi = new Qvoronoi();
final Vector<PVector> mPoints = new Vector<PVector>();
PVector[][] mRegions;
int mCurrentRegion;
void settings() {
    size(1024, 768, P3D);
}
void setup() {
    smooth();
    final int NUMBER_OF_POINTS_ON_CIRLCE = 20;
    for (int i = 0; i < NUMBER_OF_POINTS_ON_CIRLCE; i++) {
        final float r = (float) i / NUMBER_OF_POINTS_ON_CIRLCE * TWO_PI;
        final float x = sin(r) * 50 + width / 2;
        final float y = cos(r) * 50 + height / 2;
        addPoint(x, y);
    }
    for (int i = 0; i < NUMBER_OF_POINTS_ON_CIRLCE; i++) {
        final float r = (float) i / NUMBER_OF_POINTS_ON_CIRLCE * TWO_PI + 0.3f;
        final float x = sin(r) * 100 + width / 2;
        final float y = cos(r) * 100 + height / 2;
        addPoint(x, y);
    }
    for (int i = 0; i < NUMBER_OF_POINTS_ON_CIRLCE; i++) {
        final float r = (float) i / NUMBER_OF_POINTS_ON_CIRLCE * TWO_PI + 1.1f;
        final float x = sin(r) * 150 + width / 2;
        final float y = cos(r) * 150 + height / 2;
        addPoint(x, y);
    }
    addPoint(width / 2, height / 2);
}
void addPoint(float x, float y) {
    mCurrentRegion = 0;
    mPoints.add(new PVector(x, y));
}
void draw() {
    PVector[] mGridPointsArray = new PVector[mPoints.size()];
    mPoints.toArray(mGridPointsArray);
    mRegions = mQvoronoi.calculate2(mGridPointsArray);
    mPoints.lastElement().set(mouseX, mouseY);
    if (mousePressed) {
        addPoint(mouseX, mouseY);
    }
    /* setup scene */
    background(255);
    /* draw regions */
    if (mRegions != null) {
        for (PVector[] mRegion : mRegions) {
            stroke(255, 223, 192);
            noFill();
            drawRegion(mRegion);
        }
        /* draw selected region */
        if (mRegions.length > 0) {
            noStroke();
            fill(255, 127, 0);
            drawRegion(mRegions[mCurrentRegion]);
        }
    }
    /* draw points */
    stroke(255, 0, 0, 127);
    for (int i = 0; i < mPoints.size(); i++) {
        PVector v = mPoints.get(i);
        drawCross(v);
    }
}
void drawCross(PVector v) {
    final float o = 2.0f;
    line(v.x - o, v.y, v.z, v.x + o, v.y, v.z);
    line(v.x, v.y - o, v.z, v.x, v.y + o, v.z);
    line(v.x, v.y, v.z - o, v.x, v.y, v.z + o);
}
void drawRegion(PVector[] pVertex) {
    Vector<PVector> mRegion = new Vector<PVector>(Arrays.asList(pVertex));
    final Vector<PVector> mRoundRegion = BSpline.curve(BSpline.closeCurve(mRegion), 10);
    beginShape();
    for (PVector v : mRoundRegion) {
        vertex(v.x, v.y, v.z);
    }
    endShape(CLOSE);
}
void keyPressed() {
    mCurrentRegion++;
    mCurrentRegion %= mRegions.length;
}
void mousePressed() {
    addPoint(mouseX, mouseY);
}
