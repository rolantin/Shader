using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
//using Sirenix.OdinInspector;

public  class BrightnessSaturationAndContrastComponent : EffectBase
{
   // BrightnessSaturationAndContrast bsc = new BrightnessSaturationAndContrast();
    private Shader briSatConShader;
    private Material briSatConMaterial;

    public Material material {
        get {
            briSatConShader = Shader.Find("RolanImageEffect/BrightnessSaturationAndContrast");
            briSatConMaterial = CheckShaderAndCreateMaterial(briSatConShader, briSatConMaterial);
            return briSatConMaterial;
        }
    }
   // [Range(0.0f, 3.0f)]
   public  float brightness = 1.0f;

  //  [Range(0.0f, 3.0f)]
    public float saturation = 1.0f;

   //[ Range(0.0f, 3.0f)]
    public float contrast = 1.0f;
    //定义OnRenderImage函数来进特效处理
    //当OnRenderImage函数被调用的时候，他会检查材质球是否可用。如果可用，就把参数传递给材质，
    //再调用Graphics.Blit进行处理；否则，直接把原图像显示到屏幕上，不做任何处理。

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
       // Debug.Log(" bsc.brightness = " + bsc.brightness);
        if (material != null)
        {
            material.SetFloat("_Brightness", brightness);
            material.SetFloat("_Saturation", saturation);
            material.SetFloat("_Contrast", contrast);

            Graphics.Blit(src, dest, material);
        }
        else {
            //不做处理
            Graphics.Blit(src, dest);
        }
    }
}




//知识点：
//public static void Blit(Texture source, RenderTexture dest);
//public static void Blit(Texture source, RenderTexture dest, Material mat, int pass = -1);
//public static void Blit(Texture source, Material mat, int pass = -1);

//src： 原纹理 ，当前屏幕的文理，也是传给材质球的_MainTex的图

//dest :目标文理，经过shader返回的图 。如果他的值为null就会直接将结果显示在屏幕上

//met：材质球

//pass：默认为-1，表示将依次调用shader内的pass。否则只会调用给定索引的Pass

//lerp函数（a，b，w）：很多人都觉得w为0到1范围，然后返回值是a到b之间 其实并不仅仅是这些

//    float3 lerp(float3 a, float3 b, float w)
//{
//    return a + w * (b - a);
//}