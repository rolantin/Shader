

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
//gui layout 需要使用 UNITY_EDITOR
//#if UNITY_EDITOR
using UnityEditor;
//#endif

[ExecuteInEditMode]
//[TypeInfoBox("You can apply attributes on type definitions instead of on individual attributes.")]
//public class AttributesOnClassesExample : SerializedMonoBehaviour
//{
//    public MyClass<int> A;
//    public MyClass<string> B;
//    public MyClass<GameObject> C;
//}

//[Required]
//[LabelWidth(70)]
//[Toggle("IsEnabled")]
//[HideReferenceObjectPicker]
//public class MyClass<T>
//{
//    public bool IsEnabled;
//    public T Brightness, Saturation, Contrast;
//}


public class EffectController : MonoBehaviour
{
    [HideInInspector]
    public BrightnessSaturationAndContrastComponent bsc = new BrightnessSaturationAndContrastComponent();
    [HideInInspector]
    public Effect2 e2;
    [OnValueChanged("BrightnessSaturationAndContrastComponent")]
    public bool BrightnessSaturationAndContrast;
    [ShowIf("BrightnessSaturationAndContrast")]
    [Range(0.0f, 3.0f)]
    public float Brightness=1;
    [ShowIf("BrightnessSaturationAndContrast")]
    [Range(0.0f, 3.0f)]
    public float Saturation=1;
    [ShowIf("BrightnessSaturationAndContrast")]
    [Range(0.0f, 3.0f)]
    public float Contrast=1;
    [OnValueChanged("Effect2")]
    public bool effect2;
    [ShowIf("effect2")]
    public int effect2_t;

    //[CustomValueDrawer("SliderBar")]
    //public float CustomDrawerStatic;
    //[CustomValueDrawer("SliderBar")]
    //public float CustomDrawerInstance;


    //#if UNITY_EDITOR
    //    float From = 0, To = 3;
    //    private static float SliderBar(float value, GUIContent label){
    //        return EditorGUILayout.Slider(label, value, 0f, 3f);
    //    }
    //    //private float MyStaticCustomDrawerInstance(float value, GUIContent label){
    //    //    return EditorGUILayout.Slider(label, value, this.From, this.To);
    //    //}
    //    //private float MyStaticCustomDrawerArray(float value, GUIContent label){
    //    //    return EditorGUILayout.Slider(value, this.From, this.To);
    //    //}
    //#endif


    void BrightnessSaturationAndContrastComponent()
    {
        if (BrightnessSaturationAndContrast)
        {
            if (bsc == null)
            {
                bsc = gameObject.AddComponent<BrightnessSaturationAndContrastComponent>();
            }
            else
            {
                bsc.enabled = true;
            }
        }
        else
        {
            bsc.enabled = false;
        }
    }

    void Effect2()
    {
        if (effect2)
        {
            if (e2 == null)
            {
                e2 = gameObject.AddComponent<Effect2>();
            }
            else
            {
                e2.enabled = true;
            }
        }
        else
        {
            e2.enabled = false;
        }
    }

    private void OnEnable()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.update += Update;
#endif
    }

    void Update()
    {
       
        if (BrightnessSaturationAndContrast)
        {
            bsc.brightness = Brightness;
            bsc.saturation = Saturation;
            bsc.contrast = Contrast;
        }

        if (effect2)
        {
            e2.t = effect2_t;
        }
    }

    private void OnDisable()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.update -= Update;
#endif
    }
}

//public class BSC<T>{
//    public bool IsEnabled;
//    public T Brightness, Saturation, Contrast;
//}


