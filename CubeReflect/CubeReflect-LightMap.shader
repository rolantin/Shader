// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:33419,y:32675,varname:node_4013,prsc:2|diff-500-OUT,spec-452-OUT,amspl-8189-OUT;n:type:ShaderForge.SFN_Color,id:1304,x:31944,y:32606,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_1304,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Cubemap,id:4766,x:32173,y:32975,ptovrint:False,ptlb:SPL,ptin:_SPL,varname:node_4766,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,pvfc:0|DIR-2232-OUT,MIP-8929-OUT;n:type:ShaderForge.SFN_Slider,id:8929,x:31788,y:33156,ptovrint:False,ptlb:Gloss,ptin:_Gloss,varname:node_8929,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_ViewReflectionVector,id:2232,x:31866,y:32873,varname:node_2232,prsc:2;n:type:ShaderForge.SFN_Slider,id:2172,x:32462,y:33407,ptovrint:False,ptlb:SPL Intensinty,ptin:_SPLIntensinty,varname:_SPLPower_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:3;n:type:ShaderForge.SFN_Tex2d,id:6676,x:31992,y:32401,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_6676,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:1871,x:32260,y:32415,varname:node_1871,prsc:2|A-6676-RGB,B-1304-RGB;n:type:ShaderForge.SFN_Slider,id:452,x:32919,y:33042,ptovrint:False,ptlb:node_452,ptin:_node_452,varname:node_452,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Tex2d,id:6917,x:32081,y:33267,ptovrint:False,ptlb:LightMap,ptin:_LightMap,varname:node_6917,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:8783,x:32688,y:33087,varname:node_8783,prsc:2|A-4766-RGB,B-2172-OUT;n:type:ShaderForge.SFN_Lerp,id:3966,x:32600,y:32663,varname:node_3966,prsc:2|A-1871-OUT,B-4766-RGB,T-8189-OUT;n:type:ShaderForge.SFN_Multiply,id:8189,x:32613,y:32882,varname:node_8189,prsc:2|A-4766-RGB,B-6917-A,C-2172-OUT;n:type:ShaderForge.SFN_Multiply,id:500,x:32940,y:32520,varname:node_500,prsc:2|A-2558-OUT,B-3966-OUT;n:type:ShaderForge.SFN_Multiply,id:2558,x:32418,y:33237,varname:node_2558,prsc:2|A-6917-RGB,B-8197-OUT;n:type:ShaderForge.SFN_Slider,id:8197,x:32170,y:33483,ptovrint:False,ptlb:LightMap Intensity,ptin:_LightMapIntensity,varname:node_8197,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:3;proporder:1304-4766-8929-2172-6676-452-6917-8197;pass:END;sub:END;*/

Shader "Rolan/CubeReflect-LightMap" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _SPL ("SPL", Cube) = "_Skybox" {}
        _Gloss ("Gloss", Range(0, 10)) = 0
        _SPLIntensinty ("SPL Intensinty", Range(0, 3)) = 0
        _MainTex ("MainTex", 2D) = "white" {}
      //  _node_452 ("node_452", Range(0, 1)) = 0
        _LightMap ("LightMap", 2D) = "white" {}
        _LightMapIntensity ("LightMap Intensity", Range(0, 3)) = 0
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
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
          //  #pragma only_renderers d3d9 d3d11 glcore gles gles3 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _Color;
            uniform samplerCUBE _SPL;
            uniform float _Gloss;
            uniform float _SPLIntensinty;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
           // uniform float _node_452;
            uniform sampler2D _LightMap; uniform float4 _LightMap_ST;
            uniform float _LightMapIntensity;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                 float2 texcoord1 : TEXCOORD1;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD6; 
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
                UNITY_FOG_COORDS(5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
///////// Gloss:
              //  float gloss = 0.5;
              //  float specPow = exp2( gloss * 10.0 + 1.0 );
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float4 _SPL_var = texCUBElod(_SPL,float4(viewReflectDirection,_Gloss));
                float4 _LightMap_var = tex2D(_LightMap,TRANSFORM_TEX(i.uv1, _LightMap));
                
               // float3 specularColor = float3(_node_452,_node_452,_node_452);
                //float3 directSpecular = attenColor * pow(max(0,dot(halfDirection,normalDirection)),specPow)*specularColor;
              //  float3 indirectSpecular = (0 + node_8189)*specularColor;
               // float3 specular = (directSpecular + indirectSpecular);
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 node_8189 = (_SPL_var.rgb*_MainTex_var.a*_SPLIntensinty);
                float3 diffuseColor = ((_LightMap_var.rgb*_LightMapIntensity)*lerp((_MainTex_var.rgb*_Color.rgb),_SPL_var.rgb,node_8189));
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse + node_8189;
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
