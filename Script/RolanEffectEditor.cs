#if UNITY_EDITOR
namespace Sirenix.OdinInspector
{
    using System;
    using UnityEngine;
    [AddComponentMenu("Bloom/Bloom")]
    [RequireComponent(typeof(BrightnessSaturationAndContrastComponent))]
    public class RolanEffectEditor : MonoBehaviour
    {
        // Simple Toggle Group
        [ToggleGroup("MyToggle")]
        public bool MyToggle;

        [ToggleGroup("MyToggle")]
        public float A;

        [ToggleGroup("MyToggle")]
        [HideLabel, Multiline]
        public string B;

        // Toggle for custom data.
        [ToggleGroup("EnableGroupOne", "$GroupOneTitle")]
        public bool EnableGroupOne;

        [ToggleGroup("EnableGroupOne")]
        public string GroupOneTitle = "One";

        [ToggleGroup("EnableGroupOne")]
        public float GroupOneA;

        [ToggleGroup("EnableGroupOne")]
        public float GroupOneB;

        // Toggle for individual objects.
        [Toggle("Enabled")]
        public BrightnessSaturationAndContrastComponentInspector BrightnessSaturationAndContrast = new BrightnessSaturationAndContrastComponentInspector() ;

        [Toggle("Enabled")]
        public MyToggleA Four = new MyToggleA();

        [Toggle("Enabled")]
        public MyToggleB Five = new MyToggleB();

        public MyToggleC[] ToggleList;

        //private void TestFunc()
        //{
        //    BrightnessSaturationAndContrast.Brightness = 0f;
        //}
    }

    [Serializable]
    public partial class BrightnessSaturationAndContrastComponentInspector
    {
        BrightnessSaturationAndContrastComponent BSC;
        public bool Enabled;
        [HideInInspector]
        public string Title;

       [PropertyRange(0, 30)]
       // public float Brightness
       // {
       //     get { return BSC.brightness; }
       //     set { BSC.brightness = value; }
       // }


       // public float Saturation
       // {
       //     get { return BSC.saturation; }
       //     set { BSC.saturation = value; }
       // }

       // public float Contrast
       // {
       //     get { return BSC.contrast; }
       //     set { BSC.contrast = value; }
       // }

       // [Range(0.0f, 3.0f)]
       // public float brightness = 1.0f;

       // [Range(0.0f, 3.0f)]
       //public float saturation = 1.0f;

      [Range(0.0f, 3.0f)]
       public float contrast = 1.0f;

        public int A;
        public int B;
    }

    [Serializable]
    public class MyToggleA : BrightnessSaturationAndContrastComponentInspector
    {
        public float C;
        public float D;
        public float F;
    }

    [Serializable]
    public class MyToggleB : BrightnessSaturationAndContrastComponentInspector
    {
        public string Text;
    }

    [Serializable]
    public class MyToggleC
    {
        [ToggleGroup("Enabled", "$Label")]
        public bool Enabled;

       // public string Label { get { return this.Test.ToString(); } }

        [ToggleGroup("Enabled")]
        public float Test;
    }
}
#endif
