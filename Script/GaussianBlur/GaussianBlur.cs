using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GaussianBlur : PostEffectBase {

    private Shader GaussianBlurShader;
    private Material GaussianBlurMaterial;
    
    public Material material {
        get {
            GaussianBlurShader = Shader.Find("Rolan/ImageEffect/Gaussian Blur");
            GaussianBlurMaterial = CheckShaderAndCreateMaterial(GaussianBlurShader, GaussianBlurMaterial);
            return GaussianBlurMaterial;
        }
    }
    [Range(0, 4)]
    public int iterations = 3;

    //blur spread for each iteration - larger value means more blur
    [Range(0.2f,3.0f)]
    public float blurSpread = 0.6f;

    [Range(1, 8)]
    public int downSample = 2;

    public enum FxaaPreset {
        low,
        mid,
        high
    }

    //定义OnRenderImage函数来进特效处理
    //当OnRenderImage函数被调用的时候，他会检查材质球是否可用。如果可用，就把参数传递给材质，
    //再调用Graphics.Blit进行处理；否则，直接把原图像显示到屏幕上，不做任何处理。


    //1st edition:just apply blur
    void OnRenderImageHigh(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {
            int rtW = src.width;
            int rtH = src.height;
            RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH);
            //render the vertical pass
            Graphics.Blit(src, buffer0, material, 0);
            //render the horizontal pass
            Graphics.Blit(src, buffer0, material, 1);
            RenderTexture.ReleaseTemporary(buffer0);
            Graphics.Blit(src, dest, material);
        }
        else
        {
            //不做处理
            Graphics.Blit(src, dest);
        }
    }
     //2st edition : scale the render texture
    void OnRenderImageLow(RenderTexture src, RenderTexture dest)
        {
            if (material != null)
            {
                int rtW = src.width / downSample;
                int rtH = src.height / downSample;
                RenderTexture buffer = RenderTexture.GetTemporary(rtW, rtH);
                buffer.filterMode = FilterMode.Bilinear;

                //render the vertical pass
                Graphics.Blit(src, buffer, material, 0);
                //render the horizontal pass
                Graphics.Blit(src, buffer, material, 1);
                RenderTexture.ReleaseTemporary(buffer);
            }
            else
            {
                //不做处理
                Graphics.Blit(src, dest);
            }
        }

    //3st edition : use iterations for large blur
    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {
            int rtW = src.width / downSample;
            int rtH = src.height / downSample;
            RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH);
            buffer0.filterMode = FilterMode.Bilinear;

            Graphics.Blit(src, buffer0);

            for (int i = 0; i < iterations; i++) {
                material.SetFloat("_BlurSize", 1.0f + i * blurSpread);
                RenderTexture buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);
                Graphics.Blit(buffer0, buffer1, material, 0);
                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
                buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);
                Graphics.Blit(buffer0, buffer1, material, 1);
                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
            }
            //render the horizontal pass
            Graphics.Blit(buffer0, dest);
            RenderTexture.ReleaseTemporary(buffer0);
        }
        else
        {
            //不做处理
            Graphics.Blit(src, dest);
        }
    }
    }