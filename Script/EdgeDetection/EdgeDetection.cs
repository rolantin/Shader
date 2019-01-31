using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EdgeDetection : PostEffectBase {

    private Shader EdgeDetectShader;
    private Material EdgeDetectMaterial;

    public Material material {
        get {
            EdgeDetectShader = Shader.Find("Rolan/ImageEffect/EdgeDetection");
            EdgeDetectMaterial = CheckShaderAndCreateMaterial(EdgeDetectShader, EdgeDetectMaterial);
            return EdgeDetectMaterial;
        }
    }
    [Range(0.0f, 1.0f)]
    public float edgeOnly = 0.0f;
    public Color edgeColor = Color.black;
    public Color backgroundColor = Color.white;

    //定义OnRenderImage函数来进特效处理
    //当OnRenderImage函数被调用的时候，他会检查材质球是否可用。如果可用，就把参数传递给材质，
    //再调用Graphics.Blit进行处理；否则，直接把原图像显示到屏幕上，不做任何处理。
    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {
            material.SetFloat("_EdgeOnly", edgeOnly);
            material.SetColor("_EdgeColor", edgeColor);
            material.SetColor("_BackgroundColor", backgroundColor);

            Graphics.Blit(src, dest, material);
        }
        else {
            //不做处理
            Graphics.Blit(src, dest);
        }
    }
}

