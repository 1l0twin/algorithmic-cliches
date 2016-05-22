package de.hfkbremen.algorithmiccliches.exporting;

import de.hfkbremen.algorithmiccliches.additional.exporting.SketchRenderWithSunflow;
import hipstersinc.P5Sunflow;
import hipstersinc.sunflow.SunflowCamera;
import processing.core.PApplet;
import processing.core.PGraphics;

import java.awt.Frame;
import java.lang.reflect.Method;

public class SunflowRenderer
        extends Frame {

    private final SunflowRenderer mThis;

    private Method mMethod;

    private final PApplet mParent;

    private static int FRAME_COUNTER = 0;

    private final int mFrameNumber;

    private final SunflowRendererApplet mApplet;

    public static SunflowRenderer render(PApplet pApplet, String pDrawMethodName) {
        return new SunflowRenderer(pApplet, pDrawMethodName);
    }

    public SunflowRenderer(PApplet pParent, String pMethodName) {
        mParent = pParent;
        mFrameNumber = FRAME_COUNTER++;

        System.err.println("### SunflowerRenderer is broken in Processing 3.0");
        System.exit(-1);

        final Class mClass = SketchRenderWithSunflow.class;
        try {
            mMethod = mClass.getMethod(pMethodName, new Class[]{PGraphics.class});
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        setBounds(0, 0, pParent.width, pParent.height);
        mApplet = new SunflowRendererApplet(this);

        // causes problems in processing 3.0 @fix
//        add(mApplet);
//        mApplet.init();
//        setVisible(true);
        mThis = this;

    }

    public void setup(P5Sunflow pSunflow) {
        pSunflow.camera.setType(SunflowCamera.PINHOLE);
        pSunflow.scene.setAaSamples(1);
    }

    public class SunflowRendererApplet
            extends PApplet {

        private final SunflowRenderer mInnerParent;

        public SunflowRendererApplet(SunflowRenderer pParent) {
            mInnerParent = pParent;
        }

        public void setup() {
            size(mParent.width, mParent.height, hipstersinc.P5Sunflow.class.getName());
            noLoop();
            background(255);
        }

        public void draw() {
            /* TODO only works with up to Processing 1.5 as of now */
//            final P5Sunflow mSunflow = (P5Sunflow) g;
//            mInnerParent.setup(mSunflow);
//
//            try {
//                mMethod.invoke(mParent, new Object[]{mSunflow});
//            } catch (Exception ex) {
//                ex.printStackTrace();
//            }

            saveFrame("export-" + nf(mFrameNumber, 4) + ".png");

            setVisible(false);
            mThis.dispose();
        }
    }
}