using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[ExecuteInEditMode]
public class EffectBase : PostEffectBase
{
    private void OnEnable()
    {
        this.hideFlags = HideFlags.HideInInspector;
    }
}
