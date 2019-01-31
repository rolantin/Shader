﻿using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
 //BloomShader = Shader.Find("RimageEffect/Bloom");

public class Bloom : PostEffectBase{

    private Shader BloomShader;
    private Material BloomMaterial;

    public Material material {
        get {
            BloomShader = Shader.Find("Rolan/ImageEffect/Bloom");
             BloomMaterial = CheckShaderAndCreateMaterial(BloomShader, BloomMaterial);
            return BloomMaterial;
        }
    }
    //blur iterations - larger number means more blur
    [Range(0, 4)]
    public int iterations = 3;
    [Range(0.2f, 3.0f)]
    public float blurSpread = 0.6f;
    [Range(1, 8)]
    public int downSample = 2;
    [Range(0.0f, 4.0f)]
    public float luminanceThreshold = 0.6f;

    //绝大多数情况亮度不会超过1，如果开启HDR，硬件会允许我们把颜色存储在一个更高精度范围的缓冲中，
    //此时像素的亮度超过1，因此把luminancethreshold规定在 0 4 中

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {
            material.SetFloat("_LuminanceThreshold", luminanceThreshold);

            int rtW = src.width / downSample;
            int rtH = src.height / downSample;

            //获取临时纹理
            RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH, 0);
            buffer0.filterMode = FilterMode.Bilinear;

            Graphics.Blit(src, buffer0, material, 0);

            for (int i = 0; i < iterations; i++) {
                material.SetFloat("_BlurSize", 1.0f + i * blurSpread);
                RenderTexture buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);
                //render the vertical pass
                Graphics.Blit(buffer0, buffer1, material, 1);
                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
                buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);
                //render the horizonal pass
                Graphics.Blit(buffer0, buffer1, material, 2);
                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
            }

            material.SetTexture("_Bloom", buffer0);
            Graphics.Blit(src, dest, material,3);
            RenderTexture.ReleaseTemporary(buffer0);
        }
        else {
            //不做处理
            Graphics.Blit(src, dest);
        }
    }
}

