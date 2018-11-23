// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:33387,y:32973,varname:node_3138,prsc:2|emission-5643-OUT;n:type:ShaderForge.SFN_Tex2d,id:6742,x:31809,y:32395,ptovrint:False,ptlb:1,ptin:_1,varname:node_6742,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:9200,x:31809,y:32635,ptovrint:False,ptlb:2,ptin:_2,varname:_node_6742_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:4653,x:31719,y:32949,ptovrint:False,ptlb:3,ptin:_3,varname:_node_6742_copy_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:1130,x:31702,y:33164,ptovrint:False,ptlb:4,ptin:_4,varname:_node_6742_copy_copy_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:2423,x:31737,y:33400,ptovrint:False,ptlb:5,ptin:_5,varname:_node_6742_copy_copy_copy_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Lerp,id:5,x:32291,y:32617,varname:node_5,prsc:2|A-6742-RGB,B-9200-RGB,T-1947-OUT;n:type:ShaderForge.SFN_Lerp,id:1369,x:32559,y:32850,varname:node_1369,prsc:2|A-5-OUT,B-4653-RGB,T-1947-OUT;n:type:ShaderForge.SFN_Lerp,id:7202,x:32773,y:33025,varname:node_7202,prsc:2|A-1369-OUT,B-1130-RGB,T-1947-OUT;n:type:ShaderForge.SFN_Lerp,id:5643,x:32989,y:33279,varname:node_5643,prsc:2|A-7202-OUT,B-2423-RGB,T-1947-OUT;n:type:ShaderForge.SFN_Vector1,id:1947,x:32027,y:32821,varname:node_1947,prsc:2,v1:0;proporder:6742-9200-4653-1130-2423;pass:END;sub:END;*/

Shader "Rolan/Effect-BillBoard" {
    Properties {
        _1 ("1", 2D) = "white" {}
        _2 ("2", 2D) = "white" {}
        _3 ("3", 2D) = "white" {}
        _4 ("4", 2D) = "white" {}
        _5 ("5", 2D) = "white" {}
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
            #pragma multi_compile_fwdbase_fullshadows
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 
            #pragma target 3.0
            uniform sampler2D _1; uniform float4 _1_ST;
            uniform sampler2D _2; uniform float4 _2_ST;
            uniform sampler2D _3; uniform float4 _3_ST;
            uniform sampler2D _4; uniform float4 _4_ST;
            uniform sampler2D _5; uniform float4 _5_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                float4 _1_var = tex2D(_1,TRANSFORM_TEX(i.uv0, _1));
                float4 _2_var = tex2D(_2,TRANSFORM_TEX(i.uv0, _2));
                float node_1947 = 0.0;
                float4 _3_var = tex2D(_3,TRANSFORM_TEX(i.uv0, _3));
                float4 _4_var = tex2D(_4,TRANSFORM_TEX(i.uv0, _4));
                float4 _5_var = tex2D(_5,TRANSFORM_TEX(i.uv0, _5));
                float3 emissive = lerp(lerp(lerp(lerp(_1_var.rgb,_2_var.rgb,node_1947),_3_var.rgb,node_1947),_4_var.rgb,node_1947),_5_var.rgb,node_1947);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
