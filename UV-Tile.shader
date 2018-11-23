// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:True,hqlp:False,rprd:True,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:2865,x:32786,y:32815,varname:node_2865,prsc:2|diff-9799-RGB,gloss-1813-OUT,normal-5964-RGB,custl-9799-RGB;n:type:ShaderForge.SFN_Tex2d,id:5964,x:32359,y:32994,ptovrint:True,ptlb:Normal Map,ptin:_BumpMap,varname:_BumpMap,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:True;n:type:ShaderForge.SFN_Slider,id:1813,x:32252,y:32880,ptovrint:False,ptlb:Gloss,ptin:_Gloss,varname:_Metallic_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;n:type:ShaderForge.SFN_UVTile,id:6738,x:32172,y:33416,varname:node_6738,prsc:2|UVIN-3137-UVOUT,WDT-561-OUT,HGT-6387-OUT,TILE-4333-OUT;n:type:ShaderForge.SFN_Tex2d,id:9799,x:32426,y:33522,varname:node_9799,prsc:2,ntxv:0,isnm:False|UVIN-6738-UVOUT,TEX-6708-TEX;n:type:ShaderForge.SFN_Tex2dAsset,id:6708,x:32170,y:33691,ptovrint:False,ptlb:TileMap,ptin:_TileMap,varname:node_6708,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_TexCoord,id:3137,x:31865,y:33366,varname:node_3137,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_ValueProperty,id:6387,x:31865,y:33665,ptovrint:False,ptlb:V,ptin:_V,varname:node_6387,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:2;n:type:ShaderForge.SFN_ValueProperty,id:4333,x:31855,y:33761,ptovrint:False,ptlb:ID,ptin:_ID,varname:_node_6387_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:3;n:type:ShaderForge.SFN_ValueProperty,id:561,x:31865,y:33571,ptovrint:False,ptlb:U,ptin:_U,varname:_node_6387_copy_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:4;n:type:ShaderForge.SFN_Tex2d,id:9412,x:31663,y:32204,ptovrint:False,ptlb:1,ptin:_1,varname:node_9412,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:5315,x:31663,y:32406,ptovrint:False,ptlb:2,ptin:_2,varname:_2,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:5008,x:31677,y:32602,ptovrint:False,ptlb:3,ptin:_3,varname:_3,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:5161,x:31677,y:32793,ptovrint:False,ptlb:4,ptin:_4,varname:_4,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:2698,x:31677,y:32994,ptovrint:False,ptlb:5,ptin:_5,varname:_5,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Lerp,id:8605,x:32103,y:32330,varname:node_8605,prsc:2|A-9412-RGB,B-5315-RGB;n:type:ShaderForge.SFN_ValueProperty,id:7176,x:31883,y:32307,ptovrint:False,ptlb:node_7176,ptin:_node_7176,varname:node_7176,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;proporder:5964-1813-6708-561-6387-4333;pass:END;sub:END;*/

Shader "Shader Forge/UV-Tile" {
    Properties {
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _Gloss ("Gloss", Range(0, 1)) = 1
        _TileMap ("TileMap", 2D) = "white" {}
        _U ("U", Float ) = 4
        _V ("V", Float ) = 2
        _ID ("ID", Float ) = 3
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 
            #pragma target 3.0
            uniform sampler2D _BumpMap; uniform float4 _BumpMap_ST;
            uniform float _Gloss;
            uniform sampler2D _TileMap; uniform float4 _TileMap_ST;
            uniform float _V;
            uniform float _ID;
            uniform float _U;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                float3 tangentDir : TEXCOORD2;
                float3 bitangentDir : TEXCOORD3;
                UNITY_FOG_COORDS(4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 _BumpMap_var = UnpackNormal(tex2D(_BumpMap,TRANSFORM_TEX(i.uv0, _BumpMap)));
                float3 normalLocal = _BumpMap_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
////// Lighting:
                float2 node_6738_tc_rcp = float2(1.0,1.0)/float2( _U, _V );
                float node_6738_ty = floor(_ID * node_6738_tc_rcp.x);
                float node_6738_tx = _ID - _U * node_6738_ty;
                float2 node_6738 = (i.uv0 + float2(node_6738_tx, node_6738_ty)) * node_6738_tc_rcp;
                float4 node_9799 = tex2D(_TileMap,TRANSFORM_TEX(node_6738, _TileMap));
                float3 finalColor = node_9799.rgb;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
