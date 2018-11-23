Shader "Unlit/Tree"
{
	Properties
	{
		_color ("color" , Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_NormalMap ("NormalMap", 2D) = "Grey" {}
		_AlphaClip("AlphaClip ", Range(0,1)) = 1
		_backlightIntensity("backlightIntensity ", Range(0,1)) = 1
		_backColor("_backColor" , Color) = (1,1,1,1)
		emssisonIntensity("emssisonIntensity",Range(0,3) ) = 0.5
		_Gama("_gama",Range(-3,3) ) = 1
		_mask  ("_mask", 2D) = "white" {}

	}
	SubShader
	{
		Tags { "RenderType"="TransparentCutout" "Queue"="Transparent" "IgnoreProjector"="True"}
		LOD 100
		Cull Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			#include "../CGIncludes/RolantinCG.cginc"

			struct vertexin
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				     float4 tangent : TANGENT;
				
			};

			struct vertexout
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float3 normalDir : TEXCOORD2 ;
				float3 pos : TEXCOORD3 ;
				     float3 tangentDir : TEXCOORD4;
                float3 bitangentDir : TEXCOORD5;

			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _AlphaClip;
			fixed _backlightIntensity;
			float4 _backColor;
			float emssisonIntensity;
			sampler2D _NormalMap;	float4 _NormalMap_ST;
			float4	 _color;
			sampler2D _mask;
			
			vertexout vert (vertexin v)
			{
				vertexout o = (vertexout)0;
				o.pos = mul (unity_ObjectToWorld,(v.vertex)); 

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normalDir =  UnityObjectToWorldNormal(v.normal);
				  o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (vertexout i) : SV_Target
			{

			   float3 _BumpMap_var = UnpackNormal(tex2D(_NormalMap,TRANSFORM_TEX(i.uv, _NormalMap)));
			    float3 mask = (tex2D(_mask,i.uv));
			   float3 view = _WorldSpaceCameraPos - i.pos;
			   float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
			   float3 normalDirection = normalize(mul( _BumpMap_var, tangentTransform )); 

				float3 Light =  DirectionalLight(normalDirection)[0];
				float3 backlight =  DirectionalLight( - normalDirection)[0];


				float3 viewDir  = saturate(dot(view,backlight));
				// sample the texture
				fixed4 diff = tex2D(_MainTex, i.uv);
				fixed4 col = ColorSpace(diff);

				clip(col.a -0.5* _AlphaClip);
				// apply fog
				fixed3 finaldiff = col * ( Light  + (backlight * _backlightIntensity * _backColor *(1- mask) ))  + col * emssisonIntensity  ;  

			
				UNITY_APPLY_FOG(i.fogCoord, col);
				return fixed4 (finaldiff * _color,1);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
