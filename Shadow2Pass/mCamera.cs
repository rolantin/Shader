using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class PlayerShadow : MonoBehaviour
{
    public Camera mCamera;
    public GameObject mLight;
    private List<Material> mMatList = new List<Material>();
    private void Awake()
    {
        SkinnedMeshRenderer[] renderlist = GetComponentsInChildren<SkinnedMeshRenderer>();
        foreach (var render in renderlist)
        {
            if (render == null)
                continue;
            foreach (var mt in render.materials)
            {
                if (mt.shader.name == "Custom/PlayerShadow")
                    mMatList.Add(mt);
            }
        }
    }
    void Start()
    {
        mCamera = Camera.main;
        mLight = GameObject.Find("LightPosition").gameObject;
    }
    void Update()
    {
        UpdateShader();
    }
    private void UpdateShader()
    {
        if (mLight == null)
            return;
        foreach (var mat in mMatList)
        {
            if (mat == null)
                continue;
            mat.SetVector("_WorldPos", transform.position);
            mat.SetVector("_ShadowProjDir", mLight.transform.forward);
            mat.SetVector("_ShadowPlane", new Vector4(0f, 0.4f, 0.0f, 0.0f));
            mat.SetVector("_ShadowFadeParams", new Vector4(1f, 0.9f, 0.8f, 0.7f));
        }
    }
}