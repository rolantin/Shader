// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:False,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:False,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:2865,x:33894,y:32678,varname:node_2865,prsc:2|normal-1640-RGB,clip-4581-OUT,rich5 out-6554-OUT;n:type:ShaderForge.SFN_Multiply,id:6031,x:31310,y:32140,varname:node_6031,prsc:2|A-5127-RGB,B-4681-RGB,C-4169-OUT;n:type:ShaderForge.SFN_Color,id:4681,x:31080,y:32327,ptovrint:False,ptlb:Color,ptin:_Color,varname:_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,taginstsco:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:1640,x:33005,y:32371,ptovrint:True,ptlb:Normal Map,ptin:_BumpMap,varname:_BumpMap,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,taginstsco:False,ntxv:3,isnm:True;n:type:ShaderForge.SFN_Tex2d,id:8867,x:31949,y:32758,ptovrint:False,ptlb:Metallic,ptin:_Metallic,varname:node_6358,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,taginstsco:False,ntxv:2,isnm:False;n:type:ShaderForge.SFN_Cubemap,id:6955,x:31943,y:33285,ptovrint:False,ptlb:SpecIBL,ptin:_SpecIBL,varname:_CubeMap_copy_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,taginstsco:False,pvfc:0;n:type:ShaderForge.SFN_Slider,id:958,x:32461,y:33342,ptovrint:False,ptlb:SpecIBL Power,ptin:_SpecIBLPower,varname:_CubeDiff_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,taginstsco:False,min:0,cur:1,max:10;n:type:ShaderForge.SFN_Multiply,id:2743,x:32962,y:33277,varname:node_2743,prsc:2|A-6955-RGB,B-958-OUT,C-8867-RGB;n:type:ShaderForge.SFN_Tex2d,id:8910,x:32397,y:32022,ptovrint:False,ptlb:Emssion Map,ptin:_EmssionMap,varname:node_3401,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,taginstsco:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:9125,x:32748,y:32232,varname:node_9125,prsc:2|A-8910-RGB,B-1350-RGB;n:type:ShaderForge.SFN_Color,id:1350,x:32370,y:32281,ptovrint:False,ptlb:Emssion Color,ptin:_EmssionColor,varname:node_657,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,taginstsco:False,c1:0,c2:0,c3:0,c4:1;n:type:ShaderForge.SFN_PBR,id:4864,x:33223,y:32706,varname:node_4864,prsc:2|MainTex-2201-OUT,Metallic-8867-RGB,Metallic_alpha-8867-A,Metallic_red-8867-R,DiffCubemap-7433-OUT,SpecCubemap-4494-OUT;n:type:ShaderForge.SFN_Tex2d,id:5127,x:31076,y:32019,ptovrint:False,ptlb:Albedo,ptin:_Albedo,varname:node_5127,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,taginstsco:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Add,id:5497,x:33362,y:33056,varname:node_5497,prsc:2|A-9125-OUT,B-4864-OUT;n:type:ShaderForge.SFN_RichShadow,id:6554,x:33698,y:33197,varname:node_6554,prsc:2|IN-5497-OUT;n:type:ShaderForge.SFN_FragmentPosition,id:2003,x:30775,y:32902,varname:node_2003,prsc:2;n:type:ShaderForge.SFN_Transform,id:9545,x:30969,y:33008,varname:node_9545,prsc:2,tffrom:0,tfto:1|IN-2003-XYZ;n:type:ShaderForge.SFN_ComponentMask,id:7416,x:31201,y:33041,varname:node_7416,prsc:2,cc1:1,cc2:-1,cc3:-1,cc4:-1|IN-9545-XYZ;n:type:ShaderForge.SFN_Smoothstep,id:1154,x:31263,y:32826,varname:node_1154,prsc:2|A-9878-OUT,B-1183-OUT,V-7416-OUT;n:type:ShaderForge.SFN_ValueProperty,id:9878,x:31052,y:32743,ptovrint:False,ptlb:Min,ptin:_Min,varname:node_9878,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,taginstsco:False,v1:0;n:type:ShaderForge.SFN_Lerp,id:5382,x:31599,y:32702,varname:node_5382,prsc:2|A-7149-RGB,B-1154-OUT,T-7149-A;n:type:ShaderForge.SFN_Multiply,id:2201,x:31953,y:32383,varname:node_2201,prsc:2|A-7779-OUT,B-5382-OUT;n:type:ShaderForge.SFN_OneMinus,id:5658,x:31697,y:32533,varname:node_5658,prsc:2|IN-5382-OUT;n:type:ShaderForge.SFN_Color,id:7149,x:31239,y:32531,ptovrint:False,ptlb:shaodowColor,ptin:_shaodowColor,varname:node_7149,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,taginstsco:False,c1:1,c2:1,c3:1,c4:0.37;n:type:ShaderForge.SFN_ValueProperty,id:1183,x:30951,y:32686,ptovrint:False,ptlb:Max,ptin:_Max,varname:node_1183,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,taginstsco:False,v1:8;n:type:ShaderForge.SFN_Enviment,id:3208,x:32443,y:32500,varname:node_3208,prsc:2;n:type:ShaderForge.SFN_Multiply,id:4494,x:33165,y:33142,varname:node_4494,prsc:2|A-2743-OUT,B-8904-OUT;n:type:ShaderForge.SFN_Vector1,id:8904,x:33220,y:32961,varname:node_8904,prsc:2,v1:2;n:type:ShaderForge.SFN_Divide,id:7779,x:31614,y:32002,varname:node_7779,prsc:2|A-6031-OUT,B-7487-OUT;n:type:ShaderForge.SFN_Slider,id:7487,x:31381,y:32294,ptovrint:False,ptlb:To Linrar,ptin:_ToLinrar,varname:node_7487,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,taginstsco:False,min:-1,cur:1,max:2.2;n:type:ShaderForge.SFN_Multiply,id:4581,x:31979,y:31948,varname:node_4581,prsc:2|A-5127-A,B-4801-OUT;n:type:ShaderForge.SFN_Slider,id:4801,x:31649,y:31864,ptovrint:False,ptlb:Alpha,ptin:_Alpha,varname:node_4801,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,taginstsco:False,min:-1,cur:0,max:2;n:type:ShaderForge.SFN_Lerp,id:4169,x:31508,y:31552,varname:node_4169,prsc:2|A-8338-RGB,B-9139-OUT,T-1046-OUT;n:type:ShaderForge.SFN_Vector3,id:9139,x:31117,y:31626,varname:node_9139,prsc:2,v1:1,v2:1,v3:1;n:type:ShaderForge.SFN_Slider,id:1046,x:30691,y:31520,ptovrint:False,ptlb:AO Power,ptin:_AOPower,varname:node_6571,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,taginstsco:False,min:0,cur:1,max:1;n:type:ShaderForge.SFN_Tex2d,id:8338,x:31185,y:31431,ptovrint:False,ptlb:AO,ptin:_AO,varname:node_8338,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,taginstsco:False,ntxv:0,isnm:False|UVIN-620-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:620,x:30902,y:31334,varname:node_620,prsc:2,uv:1,uaff:False;n:type:ShaderForge.SFN_Multiply,id:7433,x:32751,y:32378,varname:node_7433,prsc:2|A-4169-OUT,B-3208-OUT;proporder:4681-5127-8910-1350-1640-8867-6955-958-9878-7149-1183-7487-4801-1046-8338;pass:END;sub:END;*/

Shader "DAFUHAO_Editor/Building-High-Art-Alpha" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _Albedo ("Albedo", 2D) = "white" {}
        _EmssionMap ("Emssion Map", 2D) = "white" {}
        _EmssionColor ("Emssion Color", Color) = (0,0,0,1)
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _Metallic ("Metallic", 2D) = "black" {}
        _SpecIBL ("SpecIBL", Cube) = "_Skybox" {}
        _SpecIBLPower ("SpecIBL Power", Range(0, 10)) = 1
        _Min ("Min", Float ) = 0
        _shaodowColor ("shaodowColor", Color) = (1,1,1,0.37)
        _Max ("Max", Float ) = 8
        _ToLinrar ("To Linrar", Range(-1, 2.2)) = 1
        _Alpha ("Alpha", Range(-1, 2)) = 0
        _AOPower ("AO Power", Range(0, 1)) = 1
        _AO ("AO", 2D) = "white" {}
        [HideInInspector]_SrcBlend("", Float) = 1
        [HideInInspector]_DstBlend("", Float) = 0
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend [_SrcBlend][_DstBlend]
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile __ AlphaBlendOn UseUnityShadow
            #pragma multi_compile_instancing
            #include "AutoLight.cginc"
            #include "../CGIncludes/DiffuseInfo.cginc"
            
            
            INSTANCING_START
            INSTANCING_PROP_UVST
            INSTANCING_END
            
            
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers gles3 
            #pragma target 3.0
            uniform float4 _Color;
            uniform sampler2D _BumpMap; uniform float4 _BumpMap_ST;
            uniform sampler2D _Metallic; uniform float4 _Metallic_ST;
            uniform samplerCUBE _SpecIBL;
            uniform float _SpecIBLPower;
            uniform sampler2D _EmssionMap; uniform float4 _EmssionMap_ST;
            uniform float4 _EmssionColor;
            uniform sampler2D _Albedo; uniform float4 _Albedo_ST;
            uniform float _Min;
            uniform float4 _shaodowColor;
            uniform float _Max;
            uniform float _ToLinrar;
            uniform float _Alpha;
            uniform float _AOPower;
            uniform sampler2D _AO; uniform float4 _AO_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
            UNITY_VERTEX_INPUT_INSTANCE_ID
            
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float4 posWorld : TEXCOORD2;
                float4 viewPos : TEXCOORD3;
                float4 worldPos_2_Camera : TEXCOORD4;
                float3 normalDir : TEXCOORD5;
                float3 tangentDir : TEXCOORD6;
                float3 bitangentDir : TEXCOORD7;
                UNITY_FOG_COORDS(8)
            UNITY_VERTEX_INPUT_INSTANCE_ID
            
            #ifdef UseUnityShadow
            LIGHTING_COORDS(10, 11)
            #endif
            };
            #include "../CGIncludes/shadow.cginc"
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                UNITY_INITIALIZE_OUTPUT(VertexOutput, o);
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                
                #ifdef UseUnityShadow
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                #endif
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                GET_CAMERA_POS_NORMAL(o.posWorld, o.viewPos, o.worldPos_2_Camera, o.normalDir);
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
            UNITY_SETUP_INSTANCE_ID(i);
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _BumpMap_var = UnpackNormal(tex2D(_BumpMap,TRANSFORM_TEX(i.uv0, _BumpMap)));
                float3 normalLocal = _BumpMap_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float4 _Albedo_var = tex2D(_Albedo,TRANSFORM_TEX(i.uv0, _Albedo));
                clip((_Albedo_var.a*_Alpha) - 0.5);
////// Lighting:
                float4 _EmssionMap_var = tex2D(_EmssionMap,TRANSFORM_TEX(i.uv0, _EmssionMap));
                float4 _Metallic_var = tex2D(_Metallic,TRANSFORM_TEX(i.uv0, _Metallic));
                float4 _AO_var = tex2D(_AO,TRANSFORM_TEX(i.uv1, _AO));
                float3 node_4169 = lerp(_AO_var.rgb,float3(1,1,1),_AOPower);
                float node_1154 = smoothstep( _Min, _Max, mul( unity_WorldToObject, float4(i.posWorld.rgb,0) ).xyz.rgb.g );
                float3 node_5382 = lerp(_shaodowColor.rgb,float3(node_1154,node_1154,node_1154),_shaodowColor.a);
                float4 finalColor = FINAL_SHADOW_COLOR_SINGLE(((_EmssionMap_var.rgb*_EmssionColor.rgb)+PBRSpecular(normalDirection, 
                                    viewDirection,_Metallic_var.rgb,_Metallic_var.a,_Metallic_var.r,(((_Albedo_var.rgb*_Color.rgb*node_4169)/_ToLinrar)*node_5382),(node_4169*GetEnvirmentColor(normalDirection)),((texCUBE(_SpecIBL,viewReflectDirection).rgb*_SpecIBLPower*_Metallic_var.rgb)*2.0))), i, normalDirection);
                UNITY_APPLY_FOG(i.fogCoord, finalColor.rgb);
                return finalColor;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
