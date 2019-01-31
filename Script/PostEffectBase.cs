using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ImageEffectAllowedInSceneView]
[ExecuteInEditMode]
//屏幕后处理特效一般需要绑定在摄像机上
[RequireComponent(typeof(Camera))] 

public class PostEffectBase : MonoBehaviour
{

    protected void CheckResourse()
    {
        //如果显卡检测 返回false
        bool isSupported = CheckSupport();
        if (isSupported == false)
        {
            //NotSupported()方法，即不显示
            NotSupported();
        }

    }

    //检查显卡是否支持
    protected bool CheckSupport()
    {
        if (SystemInfo.supportsImageEffects == false || SystemInfo.supportsRenderTextures == false)
        {//返回false
            Debug.LogWarning("平台不支持后期特效处理");
            return false;
        }
        //如果支持图像后处理，返回true
        return true;
    }

    protected void NotSupported()
    {//图像不显示
        enabled = false;
    }

    protected void Start()
    {
        CheckResourse();
    }

    //CheckShaderAndCreateMaterial函数接受两个参数，第一个参数指定了改特效需要使用的Shader
    //第二个参数则是用于后期处理的材质。该函数首先检查Shader的可用性，检查通过后就返回一个使
    //用了该shader的材质，否则返回null.
    protected Material CheckShaderAndCreateMaterial(Shader shader, Material material) {
        //如果shader为空
        if (shader == null) {
            return null;
        }
        //shader.isSupported：能在终端用户的图形卡上运行这个着色器&& 并且存在material 他的shader是我们输入的shader
        if (shader.isSupported && material && material.shader == shader)
            return material;
        if (!shader.isSupported)
        {
            return null;
        }
        //上面都不满足的话，重新创建新的材质球
        else
        {
            material = new Material(shader);
            //hideFlags：控制对象销毁的位掩码
            //HideFlags.DontSave对象不会保存到场景中。加载新场景时不会被破坏。
            material.hideFlags = HideFlags.DontSave;
            if (material)
                return material;
            else
                return null;
        }


        
    }
}





